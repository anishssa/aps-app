import 'package:flutter/material.dart';

class BottomSheetSearchDropdown<T> extends StatefulWidget {
  const BottomSheetSearchDropdown({
    super.key,
    required this.items,
    required this.itemAsString,
    this.onChanged,
    this.hintText,
    this.titleText,
    this.searchHintText,
  });

  final List<T> items;
  final String Function(T) itemAsString;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? titleText;
  final String? searchHintText;

  @override
  State<BottomSheetSearchDropdown<T>> createState() => _BottomSheetSearchDropdownState<T>();
}

class _BottomSheetSearchDropdownState<T> extends State<BottomSheetSearchDropdown<T>> {
  T? selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openPicker,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Select item',
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
        ),
        child: Text(selected != null ? widget.itemAsString(selected as T) : ''),
      ),
    );
  }

  Future<void> _openPicker() async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _BottomSheetSearch<T>(
        title: widget.titleText ?? 'Select',
        searchHint: widget.searchHintText ?? 'Search...',
        items: widget.items,
        itemAsString: widget.itemAsString,
        selected: selected,
      ),
    );

    if (picked != null && picked != selected) {
      setState(() => selected = picked);
      widget.onChanged?.call(picked);
    }
  }
}

class _BottomSheetSearch<T> extends StatefulWidget {
  const _BottomSheetSearch({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.itemAsString,
    required this.selected,
  });

  final String title;
  final String searchHint;
  final List<T> items;
  final String Function(T) itemAsString;
  final T? selected;

  @override
  State<_BottomSheetSearch<T>> createState() => _BottomSheetSearchState<T>();
}

class _BottomSheetSearchState<T> extends State<_BottomSheetSearch<T>> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<T> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List.of(widget.items);
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = q.isEmpty
          ? List.of(widget.items)
          : widget.items.where((e) => widget.itemAsString(e).toLowerCase().contains(q)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(widget.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final item = _filtered[i];
                final isSelected = widget.selected != null && item == widget.selected;
                return ListTile(
                  title: Text(widget.itemAsString(item)),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

