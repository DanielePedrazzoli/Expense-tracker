import 'package:expense_tracker/models/tag.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final Function() onTap;
  final bool isSelected;
  const TagChip({
    super.key,
    required this.tag,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: isSelected ? Colors.white : null);

    return InputChip(
      label: Text(tag.name, style: textStyle),
      selected: isSelected,
      onPressed: onTap,
      showCheckmark: false,
      deleteIconColor: Colors.white,
      surfaceTintColor: Color(tag.color),
      color: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return Color(tag.color).withOpacity(0.2);
        }
        return Theme.of(context).colorScheme.surfaceContainerLow;
      }),
      side: BorderSide(color: Color(tag.color)),
    );
  }
}
