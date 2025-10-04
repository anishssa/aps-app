import 'package:flutter/material.dart';

import 'NavIconBuilder.dart';

class BottomSheetDropdownComponent extends StatefulWidget {
  final String label;
  final String? hintText;
  final List<dynamic> options;
  final String displayField;
  final Function(Map<String, dynamic>?)? onChanged;
  final Map<String, dynamic>? value;
  final IconData? prefixIcon;
  final bool loading;
  final FormFieldValidator<Map<String, dynamic>?>? validator;

  const BottomSheetDropdownComponent({
    Key? key,
    required this.label,
    this.hintText,
    required this.options,
    required this.displayField,
    this.onChanged,
    this.value,
    this.prefixIcon,
    this.loading = false,
    this.validator,
  }) : super(key: key);

  @override
  State<BottomSheetDropdownComponent> createState() =>
      _BottomSheetDropdownComponentState();
}

class _BottomSheetDropdownComponentState
    extends State<BottomSheetDropdownComponent> {
  String searchText = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.loading;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showBottomSheet(
    BuildContext context,
    FormFieldState<Map<String, dynamic>> field,
  ) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        return _DropdownBottomSheet(
          options: widget.options,
          displayField: widget.displayField,
          value: widget.value,
          onChanged: (option) {
            field.didChange(option);
            if (widget.onChanged != null) {
              widget.onChanged!(option);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Map<String, dynamic>>(
      validator: widget.validator,
      initialValue: widget.value,
      builder: (FormFieldState<Map<String, dynamic>> field) {
        return InkWell(
          onTap: () => _showBottomSheet(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: widget.prefixIcon != null
                  ? IconButton(
                      icon: Icon(
                        widget.prefixIcon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: null,
                    )
                  : null,
              suffixIcon: widget.loading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => _showBottomSheet(context, field),
                    ),
              errorText: field.errorText,
            ),
            child: Text(
              widget.value != null
                  ? widget.value![widget.displayField].toString()
                  : widget.hintText ?? '',
            ),
          ),
        );
      },
    );
  }
}

class _DropdownBottomSheet extends StatefulWidget {
  final List<dynamic> options;
  final String displayField;
  final Map<String, dynamic>? value;
  final Function(Map<String, dynamic>?)? onChanged;

  const _DropdownBottomSheet({
    required this.options,
    required this.displayField,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_DropdownBottomSheet> createState() => _DropdownBottomSheetState();
}

class _DropdownBottomSheetState extends State<_DropdownBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<dynamic> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List.of(widget.options);
    _searchCtrl.addListener(_applyFilter);
  }

  void _applyFilter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = widget.options
          .where(
            (option) => option[widget.displayField]
                .toString()
                .toLowerCase()
                .contains(q),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: buildNavIcon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: _searchCtrl,
            ),
          ),
          Flexible(
            child: _filtered.isEmpty
                ? Center(
              child: Text(
                'No options found',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final option = _filtered[index];
                final isSelected =
                    widget.value != null && option['id'] == widget.value!['id'];
                return ListTile(
                  title: Text(option[widget.displayField].toString()),
                  selected: isSelected,
                  selectedTileColor: Color(0xFFD50009).withOpacity(0.4),
                  onTap: () {
                    if (widget.onChanged != null) {
                      widget.onChanged!(option);
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
