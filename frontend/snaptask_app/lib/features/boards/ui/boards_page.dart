import 'package:flutter/material.dart';
import 'package:snaptask_app/app/router/app_routes.dart';
import 'package:snaptask_app/app/shell/app_shell.dart';
import 'package:snaptask_app/core/config/env.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/widgets/app_search.dart';
import 'package:snaptask_app/core/widgets/confirmation_dialog.dart';
import 'package:snaptask_app/features/boards/data/boards_api.dart';
import 'package:snaptask_app/features/boards/data/boards_models.dart';

enum _BoardMenuAction { edit, delete }

class BoardsPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const BoardsPage({super.key, required this.onToggleTheme});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  late final BoardsApi _api;
  late Future<List<BoardSummary>> _future;
  List<BoardSummary>? _cachedBoards;

  @override
  void initState() {
    super.initState();
    _api = BoardsApi(ApiClient(baseUrl: Env.baseUrl));
    _future = _loadBoards();
  }

  void _reload() {
    if (!mounted) return;
    setState(() {
      _future = _loadBoards();
    });
  }

  Future<List<BoardSummary>> _loadBoards() async {
    final boards = await _api.getAll();
    _cachedBoards = boards;
    return boards;
  }

  void _setBoards(List<BoardSummary> boards) {
    _cachedBoards = boards;
    if (!mounted) return;
    setState(() {
      _future = Future.value(boards);
    });
  }

  Future<void> _reloadAsync() async {
    _reload();
    try {
      await _future;
    } catch (_) {}
  }

  String _formatDateShort(DateTime date) {
    final local = date.toLocal();
    const months = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];
    final day = local.day.toString().padLeft(2, '0');
    final month = months[local.month - 1];
    return '$day $month ${local.year}';
  }

  Widget _buildSectionHeader({
    required int total,
    required Color surface,
    required Color outline,
    required Color muted,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Seus boards',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organize seus projetos em um só lugar.',
                  style: TextStyle(fontSize: 13, color: muted),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: outline),
                  ),
                  child: Text(
                    '$total boards',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: _openCreateBoardDialog,
            icon: const Icon(Icons.add),
            label: const Text('Novo'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required String query,
    required Color surface,
    required Color outline,
    required Color muted,
  }) {
    final isFiltered = query.isNotEmpty;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFiltered ? Icons.search_off : Icons.dashboard_outlined,
              size: 48,
              color: muted,
            ),
            const SizedBox(height: 12),
            Text(
              isFiltered ? 'Nenhum resultado' : 'Nenhum board ainda',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Nenhum board encontrado para "$query".'
                  : 'Crie seu primeiro board para começar.',
              style: TextStyle(color: muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _openCreateBoardDialog,
              icon: const Icon(Icons.add),
              label: Text(isFiltered ? 'Novo board' : 'Criar board'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardCard({
    required BoardSummary board,
    required ColorScheme scheme,
    required Color surface,
    required Color outline,
    required Color muted,
  }) {
    return Card(
      elevation: 0,
      color: surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: outline),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 24,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: scheme.primary.withOpacity(0.12),
          child: Icon(Icons.dashboard, size: 16, color: scheme.primary),
        ),
        title: Text(
          board.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Criado em ${_formatDateShort(board.createdAt)}',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        trailing: PopupMenuButton<_BoardMenuAction>(
          tooltip: 'Ações',
          padding: EdgeInsets.zero,
          splashRadius: 20,
          position: PopupMenuPosition.under,
          color: scheme.surface,
          icon: Icon(Icons.more_vert, color: muted),
          onSelected: (value) {
            if (value == _BoardMenuAction.edit) {
              _openEditBoardDialog(board);
            } else if (value == _BoardMenuAction.delete) {
              _confirmDelete(board);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _BoardMenuAction.edit,
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: scheme.onSurface),
                  const SizedBox(width: 8),
                  const Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              value: _BoardMenuAction.delete,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: scheme.error),
                  const SizedBox(width: 8),
                  const Text('Excluir'),
                ],
              ),
            ),
          ],
        ),
        onTap: () async {
          await Navigator.of(
            context,
          ).pushNamed(AppRoutes.boardDetails(board.id));
          if (mounted) _reload();
        },
      ),
    );
  }

  Future<void> _openCreateBoardDialog() async {
    final controller = TextEditingController();
    BoardSummary? createdBoard;

    try {
      createdBoard = await showDialog<BoardSummary>(
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
                  final created = await _api.create(
                    CreateBoardRequest(name: name),
                  );

                  if (!dialogContext.mounted) return;
                  popped = true;
                  Navigator.of(dialogContext).pop(created);
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
                        : () => Navigator.of(dialogContext).pop(),
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
    if (createdBoard != null) {
      if (_cachedBoards != null) {
        final updated = [createdBoard, ..._cachedBoards!];
        _setBoards(updated);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reload();
      });
    }
  }

  Future<void> _openEditBoardDialog(BoardSummary board) async {
    final controller = TextEditingController(text: board.name);
    String? updatedName;

    try {
      updatedName = await showDialog<String>(
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
                  Navigator.of(dialogContext).pop(name);
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
                        : () => Navigator.of(dialogContext).pop(),
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
    if (updatedName != null) {
      if (_cachedBoards == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _reload();
        });
        return;
      }
      final updated = _cachedBoards!
          .map(
            (item) => item.id == board.id
                ? BoardSummary(
                    id: item.id,
                    name: updatedName!,
                    createdAt: item.createdAt,
                  )
                : item,
          )
          .toList();
      _setBoards(updated);
    }
  }

  Future<void> _confirmDelete(BoardSummary board) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return ConfirmDeleteDialog(objectName: board.name);
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _api.delete(board.id);
      if (!mounted) return;
      if (_cachedBoards == null) {
        _reload();
        return;
      }
      final updated = _cachedBoards!
          .where((item) => item.id != board.id)
          .toList();
      _setBoards(updated);
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
    final canvas = scheme.surface;
    final panel = scheme.surfaceVariant;
    final outline = scheme.outline;
    final outlineSoft = scheme.outlineVariant;
    final muted = scheme.onSurface.withOpacity(0.6);
    return AppShell(
      title: 'SnapTask',
      titleWidget: Image.asset(
        'assets/images/logo.png',
        height: 28,
        fit: BoxFit.contain,
        semanticLabel: 'SnapTask',
      ),
      onToggleTheme: widget.onToggleTheme,
      body: FutureBuilder<List<BoardSummary>>(
        future: _future,
        builder: (context, snapshot) {
          final query = AppSearchScope.of(context).query.trim();
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: panel,
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
          final normalized = query.toLowerCase();
          final filtered = normalized.isEmpty
              ? boards
              : boards
                    .where((b) => b.name.toLowerCase().contains(normalized))
                    .toList();

          if (filtered.isEmpty) {
            return _buildEmptyState(
              query: query,
              surface: panel,
              outline: outline,
              muted: muted,
            );
          }

          return RefreshIndicator(
            color: accent,
            backgroundColor: canvas,
            onRefresh: _reloadAsync,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: filtered.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Boards',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: muted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSectionHeader(
                        total: filtered.length,
                        surface: panel,
                        outline: outlineSoft,
                        muted: muted,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }

                final board = filtered[i - 1];
                return _buildBoardCard(
                  board: board,
                  scheme: scheme,
                  surface: panel,
                  outline: outline,
                  muted: muted,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
