import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snaptask_app/app/layout/app_shell.dart';
import 'package:snaptask_app/core/config/env.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/http/exceptions/api_exception.dart';
import 'package:snaptask_app/core/ui/widgets/app_search.dart';
import 'package:snaptask_app/features/boards/data/boards_api.dart';
import 'package:snaptask_app/features/boards/data/boards_models.dart';
import 'package:snaptask_app/features/cards/data/cards_api.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';
import 'package:snaptask_app/features/cards/presentation/widgets/card_details_side_panel.dart';
import 'package:snaptask_app/features/cards/presentation/widgets/card_status.dart';
import 'package:snaptask_app/features/columns/data/columns_api.dart';
import 'package:snaptask_app/features/columns/data/columns_models.dart';
import 'package:snaptask_app/features/columns/presentation/widgets/column_widget.dart';

class BoardDetailsPage extends StatefulWidget {
  final String boardId;
  final VoidCallback onToggleTheme;

  const BoardDetailsPage({
    super.key,
    required this.boardId,
    required this.onToggleTheme,
  });

  @override
  State<BoardDetailsPage> createState() => _BoardDetailsPageState();
}

class _BoardDetailsPageState extends State<BoardDetailsPage> {
  late final BoardsApi _api;
  late final ColumnsApi _columnsApi;
  late final CardsApi _cardsApi;

  late Future<BoardDetails> _future;
  BoardDetails? _board;

  CardSummary? _selectedCard;
  final Map<String, CardStatus> _cardStatus = {};

  @override
  void initState() {
    super.initState();
    _api = BoardsApi(ApiClient(baseUrl: Env.baseUrl));
    _columnsApi = ColumnsApi(ApiClient(baseUrl: Env.baseUrl));
    _cardsApi = CardsApi(ApiClient(baseUrl: Env.baseUrl));
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

  Future<void> _reloadAsync() async {
    _reload();
    try {
      await _future;
    } catch (_) {}
  }

  Future<void> _toggleCardStatus(CardSummary card, CardStatus next) async {
    try {
      await _cardsApi.updateStatus(card.id, next);
      final optimistic = card.copyWith(status: next);
      _updateBoardAfterCardUpdated(optimistic);
    } catch (e) {
      _updateBoardAfterCardUpdated(card); // rollback
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
    }
  }

  void _setBoard(BoardDetails board) {
    if (!mounted) return;
    setState(() => _board = board);
  }

  CardStatus _statusFor(CardSummary card) {
    return _cardStatus[card.id] ?? CardStatus.open;
  }

  void _setStatus(CardSummary card, CardStatus status) {
    if (!mounted) return;
    setState(() {
      _cardStatus[card.id] = status;
    });
  }

  void _closeSidePanel() {
    if (!mounted) return;
    setState(() => _selectedCard = null);
  }

  int _countCards(List<ColumnDetails> columns) {
    return columns.fold<int>(0, (total, c) => total + c.cards.length);
  }

  void _updateBoardsAfterColumnDeleted(String columnId) {
    final board = _board;
    if (board == null) {
      _reload();
      return;
    }

    final updatedColumns = board.columns
        .where((col) => col.id != columnId)
        .toList();

    _setBoard(
      BoardDetails(
        id: board.id,
        name: board.name,
        createdAt: board.createdAt,
        columns: updatedColumns,
      ),
    );
  }

  void _upateBoardAfterCardDeleted(String columnId, String cardId) {
    final board = _board;
    if (board == null) {
      _reload();
      return;
    }

    final updatedColumns = board.columns.map((col) {
      if (col.id != columnId) return col;

      final updatedCards = col.cards.where((c) => c.id != cardId).toList();

      return ColumnDetails(
        id: col.id,
        name: col.name,
        order: col.order,
        cards: updatedCards,
      );
    }).toList();

    if (_selectedCard?.id == cardId) {
      _selectedCard = null;
    }

    _setBoard(
      BoardDetails(
        id: board.id,
        name: board.name,
        createdAt: board.createdAt,
        columns: updatedColumns,
      ),
    );
  }

  void _updateBoardAfterCardUpdated(CardSummary updated) {
    final board = _board;
    if (board == null) {
      _reload();
      return;
    }

    final updatedColumns = board.columns.map((col) {
      if (col.id != updated.columnId) return col;

      final idx = col.cards.indexWhere((c) => c.id == updated.id);
      if (idx == -1) {
        // se por algum motivo o card não estiver na lista, adiciona e ordena
        final inserted = [...col.cards, updated]
          ..sort((a, b) => a.order.compareTo(b.order));
        return ColumnDetails(
          id: col.id,
          name: col.name,
          order: col.order,
          cards: inserted,
        );
      }

      final updatedCards = [...col.cards];
      updatedCards[idx] = updated;
      updatedCards.sort((a, b) => a.order.compareTo(b.order));

      return ColumnDetails(
        id: col.id,
        name: col.name,
        order: col.order,
        cards: updatedCards,
      );
    }).toList()..sort((a, b) => a.order.compareTo(b.order));

    setState(() {
      _board = BoardDetails(
        id: board.id,
        name: board.name,
        createdAt: board.createdAt,
        columns: updatedColumns,
      );

      if (_selectedCard?.id == updated.id) {
        _selectedCard = updated;
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.6);

    final screenSize = MediaQuery.sizeOf(context);
    final isWide = screenSize.width >= 900;
    final columnWidth = isWide
        ? 320.0
        : math.min(320.0, screenSize.width * 0.88);
    final maxColumnHeight = screenSize.height * 0.8;

    return AppShell(
      title: 'SnapTask',
      titleWidget: Image.asset(
        'assets/images/logo.png',
        height: 28,
        fit: BoxFit.contain,
        semanticLabel: 'SnapTask',
      ),
      onToggleTheme: widget.onToggleTheme,
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
                      color: scheme.surfaceVariant,
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
                    color: scheme.surfaceVariant,
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

          void openDetails(CardSummary card) {
            if (isWide) {
              setState(() => _selectedCard = card);
              return;
            }

            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: scheme.surfaceVariant,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (sheetContext) {
                return CardDetailsSidePanel(
                  card: card,
                  initialTitle: card.title,
                  initialDescription: card.description,
                  status: _statusFor(card),

                  onStatusChanged: (status) {
                    _setStatus(card, status);
                    Navigator.of(sheetContext).pop();
                  },
                  onCardUpdated: (updated) {
                    _updateBoardAfterCardUpdated(updated);
                  },

                  onClose: () => Navigator.of(sheetContext).pop(),

                  onCardDeleted: () {
                    _upateBoardAfterCardDeleted(card.columnId, card.id);
                  },
                );
              },
            );
          }

          final boardContent = Column(
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
                          ColumnWidget(
                            column: column,
                            width: columnWidth,
                            maxHeight: maxColumnHeight,
                            onCardTap: openDetails,
                            onAddCard: () => _openCreateCardDialog(column),
                            onToggleCardStatus: _toggleCardStatus,
                            onColumnDeleted: () =>
                                _updateBoardsAfterColumnDeleted(column.id),
                          ),

                        SizedBox(
                          width: columnWidth,
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

          final selectedCard = _selectedCard;
          if (!isWide) return boardContent;

          return Row(
            children: [
              Expanded(child: boardContent),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: selectedCard == null ? 0 : 360,
                decoration: BoxDecoration(
                  color: scheme.surfaceVariant,
                  border: Border(left: BorderSide(color: scheme.outline)),
                ),
                child: selectedCard == null
                    ? const SizedBox.shrink()
                    : CardDetailsSidePanel(
                        card: selectedCard,
                        initialTitle: selectedCard.title,
                        initialDescription: selectedCard.description,
                        status: _statusFor(selectedCard),
                        onStatusChanged: (status) =>
                            _setStatus(selectedCard, status),
                        onCardUpdated: (updated) {
                          _updateBoardAfterCardUpdated(updated);
                        },

                        onClose: _closeSidePanel,
                        onCardDeleted: () {
                          _upateBoardAfterCardDeleted(
                            selectedCard.columnId,
                            selectedCard.id,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
