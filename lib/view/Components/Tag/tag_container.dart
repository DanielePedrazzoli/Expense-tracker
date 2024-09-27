import 'package:expense_tracker/models/tag.dart';
import 'package:expense_tracker/view/Components/Tag/tag_chip.dart';
import 'package:flutter/material.dart';

class TagContainer extends StatelessWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final Function(Tag)? onTagPress;
  final bool shouldFollowSelected;
  const TagContainer({super.key, required this.tags, this.selectedTags = const [], this.onTagPress, this.shouldFollowSelected = false});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const Text("Nessuna tag associata");
    }

    List<Widget> chip = [];
    for (Tag t in tags) {
      bool? isSelected = selectedTags.contains(t);

      chip.add(TagChip(
        tag: t,
        onTap: () {
          if (onTagPress != null) onTagPress!(t);
        },
        isSelected: !shouldFollowSelected ? true : isSelected,
      ));
    }

    return Wrap(spacing: 8, children: chip);
  }
}
