import "package:flutter/material.dart";

class InlineColumnTitle extends StatefulWidget {
  final String initialTitle;
  final Future<void> Function(String newTitle) onTitleChanged;

  const InlineColumnTitle({
    super.key,
    required this.initialTitle,
    required this.onTitleChanged,
  });

  @override
  State<InlineColumnTitle> createState() => _InlineColumnTitleState();
}

class _InlineColumnTitleState extends State<InlineColumnTitle> {
  late final TextEditingController _controller;
  String _savedTitle = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _savedTitle = widget.initialTitle;
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InlineColumnTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTitle != widget.initialTitle) {
      _savedTitle = widget.initialTitle;
      _controller.text = widget.initialTitle;
    }
  }

  Future<void> _saveTitle() async {
    if (_saving) return;
    final typed = _controller.text.trim();

    if (typed.isEmpty || typed == widget.initialTitle) {
      _controller.text = _savedTitle;
      return;
    }

    if (typed == _savedTitle) {
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onTitleChanged(typed);
      _savedTitle = typed;
    } catch (e) {
      _controller.text = _savedTitle;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o título da coluna')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _controller,
      autofocus: false,
      onSubmitted: (_) => _saveTitle(),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        fillColor: scheme.surfaceVariant,
        focusColor: scheme.surface,
        isDense: true,
        suffixIcon: _saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
  }
}
