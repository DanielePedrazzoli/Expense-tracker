import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/view/Components/Tag/tag_container.dart';
import 'package:expense_tracker/view/pages/Tag/edit_tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagMenu extends StatefulWidget {
  final Transaction transaction;
  const TagMenu({super.key, required this.transaction});

  @override
  State<TagMenu> createState() => _TagMenuState();
}

class _TagMenuState extends State<TagMenu> {
  late List<Tag> avaiableTags;
  @override
  void initState() {
    super.initState();

    avaiableTags = locator<DatabaseBridge>().getAllTags();
  }

  @override
  Widget build(BuildContext context) {
    if (avaiableTags.isEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tag Disponibili", style: Theme.of(context).textTheme.titleLarge),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const EditTag(isNewTag: true),
                    ),
                  );
                },
                label: const Text("Crea tag"),
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 64),
            child: Center(
              child: Text("Nessuna tag salvata"),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tag Disponibili", style: Theme.of(context).textTheme.titleLarge),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const EditTag(isNewTag: true),
                  ),
                );
              },
              label: const Text("Crea tag"),
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TagContainer(
          tags: avaiableTags,
          selectedTags: widget.transaction.getAllTags(),
          onTagPress: (Tag tag) {
            widget.transaction.toggleTag(tag);
            setState(() {});
          },
          shouldFollowSelected: true,
        ),
      ],
    );
  }
}
