import 'package:flutter/material.dart';
import 'package:snaptask_app/core/layout/app_shell.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/features/auth/data/boards_api.dart';
import 'package:snaptask_app/features/auth/data/boards_models.dart';

class BoardsPage extends StatefulWidget {
  const BoardsPage({super.key});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  late final BoardsApi _api;
  late Future<List<BoardSummary>> _future;

  @override
  void initState() {
    super.initState();
    _api = BoardsApi(ApiClient(baseUrl: 'http://localhost:8080'));
    _future = _api.getAll();
  }

  void _reload() {
    if (!mounted) return;
    setState(() => _future = _api.getAll());
  }

  Future<void> _reloadAsync() async => _reload();

  Future<void> _openCreateBoardDialog() async {
    final controller = TextEditingController();
    bool? created;

    try {
      created = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool loading = false;

          return StatefulBuilder(
            builder: (dialogContext, setLocalState) {
              Future<void> create() async {
                final name = controller.text.trim();
                if (name.isEmpty || loading) return;

                setLocalState(() => loading = true);
                var popped = false;

                try {
                  await _api.create(CreateBoardRequest(name: name));

                  if (!dialogContext.mounted) return;
                  popped = true;
                  Navigator.of(dialogContext).pop(true);
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Erro ao criar board: $e')),
                  );
                } finally {
                  if (!popped && dialogContext.mounted) {
                    setLocalState(() => loading = false);
                  }
                }
              }

              return AlertDialog(
                title: const Text('Criar novo board'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nome do board'),
                  onSubmitted: (_) => loading ? null : create(),
                ),
                actions: [
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: loading ? null : create,
                    child: loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      controller.dispose();
    }

    if (!mounted) return;
    if (created == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reload();
      });
    }
  }

  Future<void> _openEditBoardDialog(BoardSummary board) async {
    final controller = TextEditingController(text: board.name);
    bool? updated;

    try {
      updated = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool loading = false;

          return StatefulBuilder(
            builder: (dialogContext, setLocalState) {
              Future<void> update() async {
                final name = controller.text.trim();
                if (name.isEmpty || loading) return;

                setLocalState(() => loading = true);
                var popped = false;

                try {
                  await _api.updateName(
                    board.id,
                    UpdateBoardRequest(name: name),
                  );

                  if (!dialogContext.mounted) return;
                  popped = true;
                  Navigator.of(dialogContext).pop(true);
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Erro ao editar board: $e')),
                  );
                } finally {
                  if (!popped && dialogContext.mounted) {
                    setLocalState(() => loading = false);
                  }
                }
              }

              return AlertDialog(
                title: const Text('Editar board'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Nome do board'),
                  onSubmitted: (_) => loading ? null : update(),
                ),
                actions: [
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: loading ? null : update,
                    child: loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      controller.dispose();
    }

    if (!mounted) return;
    if (updated == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reload();
      });
    }
  }

  Future<void> _confirmDelete(BoardSummary board) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir board'),
          content: Text(
            'Tem certeza que deseja excluir "${board.name}"? Essa ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _api.delete(board.id);
      if (!mounted) return;
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir board: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final background = scheme.background;
    final surface = scheme.surface;
    final outline = scheme.outline;

    final textTheme = Theme.of(context).textTheme;
    final muted =
        textTheme.bodySmall?.color ?? scheme.onSurface.withOpacity(0.65);
    final softSurface = scheme.primary.withOpacity(0.04);
    final avatarBg = scheme.primary.withOpacity(0.12);

    return AppShell(
      title: 'SnapTask',
      titleWidget: Image.asset(
        'assets/images/logo_full.png',
        height: 28,
        fit: BoxFit.contain,
        semanticLabel: 'SnapTask',
      ),
      body: Container(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<BoardSummary>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: softSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: outline),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Erro ao carregar boards: ${snapshot.error}'),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: _reload,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final boards = snapshot.data ?? [];

              if (boards.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: softSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: outline),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.dashboard_outlined, size: 48),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum board ainda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Crie seu primeiro board para começar.'),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _openCreateBoardDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Criar board'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                color: accent,
                backgroundColor: surface,
                onRefresh: _reloadAsync,
                child: ListView.separated(
                  itemCount: boards.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Seus boards',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Organize seus projetos em um só lugar.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: _openCreateBoardDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Novo'),
                            ),
                          ],
                        ),
                      );
                    }

                    final b = boards[i - 1];

                    return Card(
                      elevation: 0,
                      color: surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: outline),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: avatarBg,
                          child: Icon(Icons.dashboard, color: scheme.primary),
                        ),
                        title: Text(
                          b.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Criado em ${b.createdAt.toLocal()}',
                          style: TextStyle(color: muted),
                        ),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: 'Editar',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _openEditBoardDialog(b),
                            ),
                            IconButton(
                              tooltip: 'Excluir',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _confirmDelete(b),
                            ),
                          ],
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Abrir board: ${b.name} (placeholder)',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
