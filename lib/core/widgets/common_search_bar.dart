import 'package:flutter/material.dart';

class CommonSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String initialValue;

  const CommonSearchBar({
    super.key,
    this.hintText = 'Search by name...',
    required this.onChanged,
    this.onClear,
    this.initialValue = '',
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CommonSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && _controller.text.isEmpty) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        key: const Key('search_bar_text_field'),
        controller: _controller,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  key: const Key('search_bar_clear_button'),
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }
}
