import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snaptask_app/core/config/env.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/widgets/confirmation_dialog.dart';
import 'package:snaptask_app/features/cards/ui/card_status.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';
import 'package:snaptask_app/features/cards/ui/card_widget.dart';
import 'package:snaptask_app/features/columns/data/columns_api.dart';
import 'package:snaptask_app/features/columns/data/columns_models.dart';
import 'package:snaptask_app/features/columns/ui/inline_column_title.dart';

enum ColumnMenuAction { delete }

class ColumnWidget extends StatefulWidget {
  final ColumnDetails column;
  final double width;
  final double maxHeight;
  final CardStatus Function(CardSummary card) statusForCard;
  final ValueChanged<CardSummary> onCardTap;
  final VoidCallback onAddCard;
  final VoidCallback? onColumnDeleted;

  const ColumnWidget({
    super.key,
    required this.column,
    required this.width,
    required this.maxHeight,
    required this.statusForCard,
    required this.onCardTap,
    required this.onAddCard,
    this.onColumnDeleted,
  });

  @override
  State<ColumnWidget> createState() => _ColumnWidgetState();
}

class _ColumnWidgetState extends State<ColumnWidget> {
  final TextEditingController _columnTitlectrl = TextEditingController();
  final client = ApiClient(baseUrl: Env.baseUrl);
  late final ColumnsApi _columnsApi;

  @override
  initState() {
    super.initState();
    _columnsApi = ColumnsApi(client);
    _columnTitlectrl.text = widget.column.name;
  }

  Future<void> _renameColumn(String columnId, String newName) async {
    await _columnsApi.updateColumn(widget.column.id, newName);
  }

  Future<void> _deleteColumn(String columnId) async {
    String columnName = widget.column.name;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return ConfirmDeleteDialog(objectName: columnName);
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _columnsApi.delete(columnId);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir coluna: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 64;
    const double footerHeight = 56;
    const double estimatedCardHeight = 72;
    const double maxAllowedHeight = 520;

    final cardCount = widget.column.cards.length;

    final estimatedHeight =
        headerHeight + footerHeight + (cardCount * estimatedCardHeight);

    final columnHeight = math.min(estimatedHeight, maxAllowedHeight);

    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: columnHeight,
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: InlineColumnTitle(
                      initialTitle: widget.column.name,
                      onTitleChanged: (newTitle) async {
                        await _renameColumn(widget.column.id, newTitle);
                      },
                    ),
                  ),
                  PopupMenuButton<ColumnMenuAction>(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    position: PopupMenuPosition.under,
                    color: scheme.surface,
                    icon: Icon(
                      Icons.more_vert,
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: ColumnMenuAction.delete,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: scheme.error,
                            ),
                            const SizedBox(width: 8),
                            const Text('Excluir'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (action) {
                      if (action == ColumnMenuAction.delete) {
                        _deleteColumn(widget.column.id).then((_) {
                          if (widget.onColumnDeleted != null) {
                            widget.onColumnDeleted!();
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: widget.column.cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final card = widget.column.cards[index];
                  return CardWidget(
                    card: card,
                    status: widget.statusForCard(card),
                    onTap: () => widget.onCardTap(card),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: OutlinedButton.icon(
                onPressed: widget.onAddCard,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Adicionar card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
