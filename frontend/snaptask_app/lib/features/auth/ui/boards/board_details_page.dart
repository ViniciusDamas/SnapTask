import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/http/api_exception.dart';
import 'package:snaptask_app/core/layout/app_shell.dart';
import 'package:snaptask_app/core/search/app_search.dart';
import 'package:snaptask_app/features/auth/data/boards_api.dart';
import 'package:snaptask_app/features/auth/data/boards_models.dart';
import 'package:snaptask_app/features/auth/data/cards_api.dart';
import 'package:snaptask_app/features/auth/data/columns_api.dart';

class BoardDetailsPage extends StatefulWidget {
  final String boardId;

  const BoardDetailsPage({super.key, required this.boardId});

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  late final BoardsApi _api;
  late final ColumnsApi _columnsApi;
  late final CardsApi _cardsApi;
  late Future<BoardDetails> _future;
  BoardDetails? _board;

  @override
  void initState() {
    super.initState();
    _api = BoardsApi(ApiClient(baseUrl: 'http://localhost:8080'));
    _columnsApi = ColumnsApi(ApiClient(baseUrl: 'http://localhost:8080'));
    _cardsApi = CardsApi(ApiClient(baseUrl: 'http://localhost:8080'));
    _future = _loadBoard();
  }

  void _reload() {
    if (!mounted) return;
    setState(() {
      _future = _loadBoard();
    });
  }

  Future<BoardDetails> _loadBoard() async {
    final details = await _api.getById(widget.boardId);
    if (mounted) {
      setState(() => _board = details);
    }
    return details;
  }

  void _setBoard(BoardDetails board) {
    if (!mounted) return;
    setState(() => _board = board);
  }

  Future<void> _reloadAsync() async {
    _reload();
    try {
      await _future;
    } catch (_) {}
  }

  int _countCards(List<ColumnDetails> columns) {
    return columns.fold<int>(0, (total, c) => total + c.cards.length);
  }

  List<ColumnDetails> _filterColumns(
    List<ColumnDetails> columns,
    String query,
  ) {
    List<CardSummary> sortCards(List<CardSummary> cards) {
      final sorted = [...cards]..sort((a, b) => a.order.compareTo(b.order));
      return sorted;
    }

    if (query.isEmpty) {
      final sorted = [...columns]..sort((a, b) => a.order.compareTo(b.order));
      return sorted
          .map(
            (col) => ColumnDetails(
              id: col.id,
              name: col.name,
              order: col.order,
              cards: sortCards(col.cards),
            ),
          )
          .toList();
    }

    final normalized = query.toLowerCase();
    final filtered = <ColumnDetails>[];
    for (final col in columns) {
      final matchesColumn = col.name.toLowerCase().contains(normalized);
      final matchingCards = col.cards
          .where(
            (card) =>
                card.title.toLowerCase().contains(normalized) ||
                (card.description ?? '').toLowerCase().contains(normalized),
          )
          .toList();

      if (matchesColumn || matchingCards.isNotEmpty) {
        filtered.add(
          ColumnDetails(
            id: col.id,
            name: col.name,
            order: col.order,
            cards: sortCards(matchesColumn ? col.cards : matchingCards),
          ),
        );
      }
    }

    filtered.sort((a, b) => a.order.compareTo(b.order));
    return filtered;
  }

  Future<void> _openCreateColumnDialog() async {
    final controller = TextEditingController();
    bool? created;
    try {
      created = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Nova coluna'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Nome da coluna'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Criar'),
              ),
            ],
          );
        },
      );

      if (!mounted || created != true) return;
      final name = controller.text.trim();
      if (name.isEmpty) return;

      ColumnSummary createdColumn;
      try {
        createdColumn = await _columnsApi.create(
          CreateColumnRequest(boardId: widget.boardId, name: name),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar coluna: $e')));
        return;
      }

      if (!mounted) return;
      final board = _board;
      if (board == null) {
        _reload();
        return;
      }
      final updatedColumns = [
        ...board.columns,
        ColumnDetails(
          id: createdColumn.id,
          name: createdColumn.name,
          order: createdColumn.order,
          cards: const <CardSummary>[],
        ),
      ]..sort((a, b) => a.order.compareTo(b.order));
      _setBoard(
        BoardDetails(
          id: board.id,
          name: board.name,
          createdAt: board.createdAt,
          columns: updatedColumns,
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  Future<void> _openCreateCardDialog(ColumnDetails column) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    bool? created;
    try {
      created = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Novo card - ${column.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Criar'),
              ),
            ],
          );
        },
      );

      if (!mounted || created != true) return;
      final title = titleController.text.trim();
      if (title.isEmpty) return;

      CardSummary createdCard;
      try {
        createdCard = await _cardsApi.create(
          CreateCardRequest(
            columnId: column.id,
            title: title,
            description: descriptionController.text.trim().isEmpty
                ? null
                : descriptionController.text.trim(),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar card: $e')));
        return;
      }

      if (!mounted) return;
      final board = _board;
      if (board == null) {
        _reload();
        return;
      }
      final columnIndex = board.columns.indexWhere((c) => c.id == column.id);
      if (columnIndex == -1) {
        _reload();
        return;
      }
      final target = board.columns[columnIndex];
      final updatedCards = [...target.cards, createdCard]
        ..sort((a, b) => a.order.compareTo(b.order));
      final updatedColumn = ColumnDetails(
        id: target.id,
        name: target.name,
        order: target.order,
        cards: updatedCards,
      );
      final updatedColumns = [...board.columns];
      updatedColumns[columnIndex] = updatedColumn;
      updatedColumns.sort((a, b) => a.order.compareTo(b.order));
      _setBoard(
        BoardDetails(
          id: board.id,
          name: board.name,
          createdAt: board.createdAt,
          columns: updatedColumns,
        ),
      );
    } finally {
      titleController.dispose();
      descriptionController.dispose();
    }
  }

  Widget _buildColumnCard({
    required ColumnDetails column,
    required ColorScheme scheme,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    column.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.more_vert,
                    color: scheme.onSurface.withOpacity(0.6),
                  ),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'rename', child: Text('Renomear')),
                    PopupMenuItem(value: 'delete', child: Text('Excluir')),
                  ],
                  onSelected: (_) {
                    // TODO: Implement rename/delete when column endpoints exist.
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Em breve')));
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: column.cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final card = column.cards[index];
                return Material(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scheme.outline.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if ((card.description ?? '').trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              card.description!,
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withOpacity(0.6),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: OutlinedButton.icon(
              onPressed: () => _openCreateCardDialog(column),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Adicionar card'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withOpacity(0.6);

    return AppShell(
      title: 'SnapTask',
      titleWidget: Image.asset(
        'assets/images/logo_mini.png',
        height: 28,
        fit: BoxFit.contain,
        semanticLabel: 'SnapTask',
      ),
      body: FutureBuilder<BoardDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (_board == null) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final error = snapshot.error;
              ApiException? apiError;
              if (error is DioException && error.error is ApiException) {
                apiError = error.error as ApiException;
              } else if (error is ApiException) {
                apiError = error;
              }

              if (apiError?.statusCode == 404) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.outline),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Board não encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Esse board pode ter sido removido.',
                          style: TextStyle(color: muted),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Voltar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Erro ao carregar board: ${snapshot.error}'),
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
          }

          final details = _board ?? snapshot.data;
          if (details == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final query = AppSearchScope.of(context).query.trim();
          final filteredColumns = _filterColumns(details.columns, query);
          final totalCards = _countCards(filteredColumns);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${filteredColumns.length} colunas com $totalCards cards',
                          style: TextStyle(fontSize: 13, color: muted),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _openCreateColumnDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Nova coluna'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _reloadAsync,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final column in filteredColumns)
                          _buildColumnCard(column: column, scheme: scheme),
                        SizedBox(
                          width: 300,
                          child: OutlinedButton.icon(
                            onPressed: _openCreateColumnDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Nova coluna'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
