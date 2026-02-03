import 'package:flutter/material.dart';
import 'package:snaptask_app/core/config/env.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/widgets/confirmation_dialog.dart';
import 'package:snaptask_app/features/cards/data/cards_api.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';
import 'package:snaptask_app/features/cards/ui/card_status.dart';

enum CardMenuAction { delete }

class CardDetailsSidePanel extends StatefulWidget {
  final CardSummary card;
  final CardStatus status;
  final ValueChanged<CardStatus> onStatusChanged;
  final VoidCallback onClose;
  final VoidCallback? onCardDeleted;
  final ValueChanged<CardSummary>? onCardUpdated;

  final String initialTitle;
  final String? initialDescription;

  const CardDetailsSidePanel({
    super.key,
    required this.card,
    required this.status,
    required this.onStatusChanged,
    required this.onClose,
    required this.onCardDeleted,
    required this.initialTitle,
    required this.initialDescription,
    this.onCardUpdated,
  });

  @override
  State<CardDetailsSidePanel> createState() => _CardDetailsSidePanelState();
}

class _CardDetailsSidePanelState extends State<CardDetailsSidePanel> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();

  final ApiClient client = ApiClient(baseUrl: Env.baseUrl);
  late final CardsApi _cardsApi;

  bool isEditing = false;
  late CardStatus _status;

  late String _editedTitle;
  late String _editedDescription;

  @override
  void initState() {
    super.initState();
    _cardsApi = CardsApi(client);

    _editedTitle = widget.initialTitle;
    _editedDescription = widget.initialDescription ?? '';
    _controller.text = _editedTitle;
    _descriptionCtrl.text = _editedDescription;

    _status = widget.status;
  }

  @override
  void didUpdateWidget(covariant CardDetailsSidePanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTitle != widget.initialTitle) {
      _editedTitle = widget.initialTitle;
      _controller.text = widget.initialTitle;
    }

    if (oldWidget.initialDescription != widget.initialDescription) {
      _editedDescription = widget.initialDescription ?? '';
      _descriptionCtrl.text = widget.initialDescription ?? '';
    }

    if (oldWidget.status != widget.status) {
      _status = widget.status;
    }
  }

  bool get _canEdit => _status == CardStatus.open;

  @override
  void dispose() {
    _controller.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;

      _controller.text = _editedTitle;
      _descriptionCtrl.text = _editedDescription;
    });
  }

  Future<void> _update() async {
    final titleTyped = _controller.text.trim();
    final descriptionTyped = _descriptionCtrl.text.trim();

    final sameAsLastSaved =
        titleTyped == _editedTitle && descriptionTyped == _editedDescription;

    if (sameAsLastSaved) {
      setState(() => isEditing = false);
      return;
    }

    try {
      await _cardsApi.update(
        widget.card.id,
        UpdateCardRequest(
          title: titleTyped,
          description: descriptionTyped.isEmpty ? null : descriptionTyped,
        ),
      );
      if (!mounted) return;

      setState(() {
        _editedTitle = titleTyped;
        _editedDescription = descriptionTyped;
        isEditing = false;
      });

      final updated = CardSummary(
        id: widget.card.id,
        title: _editedTitle,
        description: _editedDescription.isEmpty ? null : _editedDescription,
        order: widget.card.order,
        columnId: widget.card.columnId,
        status: widget.card.status,
      );

      widget.onCardUpdated?.call(updated);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card atualizado com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar card: $e')));
    }
  }

  Future<void> _deleteCard(String cardId) async {
    final cardTitle = _editedTitle.isNotEmpty
        ? _editedTitle
        : widget.card.title;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(objectName: cardTitle),
    );

    if (confirmed != true || !mounted) return;

    try {
      widget.onClose();
      await _cardsApi.delete(cardId);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir card: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detalhes do card',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  PopupMenuButton<CardMenuAction>(
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                    position: PopupMenuPosition.under,
                    color: scheme.surface,
                    icon: Icon(
                      Icons.more_horiz,
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: CardMenuAction.delete,
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
                      if (action == CardMenuAction.delete) {
                        _deleteCard(widget.card.id).then((_) {
                          widget.onCardDeleted?.call();
                        });
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    icon: Icon(Icons.close, color: scheme.onSurface),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _controller,
                enabled: _canEdit,
                autofocus: false,
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (_) => setState(() => isEditing = true),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _descriptionCtrl,
                enabled: _canEdit,
                maxLines: 5,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva o card...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() => isEditing = true),
              ),

              const SizedBox(height: 10),

              isEditing
                  ? Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FilledButton(
                          onPressed: _canEdit ? _update : null,
                          child: const Text('Salvar'),
                        ),
                        OutlinedButton(
                          onPressed: _cancelEdit,
                          child: const Text('Cancelar'),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
