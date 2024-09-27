import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:expense_tracker/view/Components/menu/value_list.dart';
import 'package:expense_tracker/view/Components/menu/value_list_item.dart';
import 'package:expense_tracker/view/pages/Tag/edit_tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagList extends StatefulWidget {
  const TagList({super.key});

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  List<Tag> tags = [];

  @override
  void initState() {
    super.initState();
    loadTag();
  }

  void loadTag() {
    tags = locator<DatabaseBridge>().getAllTags();
  }

  List<ValueListItem> _buildTile() {
    List<ValueListItem> tile = [];

    for (Tag t in tags) {
      tile.add(
        ValueListItem(
          title: t.name,
          value: Icon(Icons.circle, color: Color(t.color)),
          padding: 12,
          onTap: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EditTag(tag: t, isNewTag: false),
              ),
            );
            loadTag();
            setState(() {});
          },
        ),
      );
    }
    return tile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impostazioni tag"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                "Qui sono presenti tutte le tag create.\nPremere su una tag per accedere al menu di modifica\nPer aggiungere una nuova tag premere sul pulsante in basso a destra",
              ),
            ),
          ),
          ValueList(
            children: [
              ..._buildTile(),
            ],
          ),
        ],
      ),
    );
  }
}
