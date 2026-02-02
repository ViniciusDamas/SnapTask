import "package:flutter/material.dart";

class ConfirmDeleteDialog extends StatelessWidget {
  final String objectName;

  const ConfirmDeleteDialog({super.key, required this.objectName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: Text(
        'Tem certeza que deseja excluir "$objectName"? Essa ação não pode ser desfeita.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
