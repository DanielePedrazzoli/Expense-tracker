import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class EditTag extends StatefulWidget {
  final bool isNewTag;
  final Tag? tag;
  const EditTag({super.key, required this.isNewTag, this.tag});

  @override
  State<EditTag> createState() => _EditTagState();
}

class _EditTagState extends State<EditTag> {
  late Tag tag;

  void _saveTag() async {
    if (tag.name.isEmpty) {
      return;
    }

    await locator<DatabaseBridge>().addTag(tag);

    _quit();
  }

  void _deleteTag() async {
    final dialog = AlertDialog(
      title: const Text("Eliminazione tag"),
      content: const Text("Sicuro di voler eliminare questa tag?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annulla")),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Conferma")),
      ],
    );

    bool? result = await showDialog<bool?>(context: context, builder: (context) => dialog);

    if (result == true) {
      await locator<DatabaseBridge>().removeTag(tag);
      _quit();
    }
  }

  void _quit() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isNewTag == false) {
      assert(widget.tag != null, "A null tag is passed during to edit mode");
      tag = widget.tag!.copy();
    } else {
      tag = Tag();
      tag.color = 0xfff44336;
      tag.name = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNewTag ? const Text("Crea tag") : const Text("Modifica tag"),
        // actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: tag.name),
              decoration: const InputDecoration(
                label: Text("Nome"),
              ),
              onChanged: (value) => tag.name = value,
            ),
            const SizedBox(height: 32),
            ColorPicker(
              padding: EdgeInsets.zero,
              title: Text("Colore tag", style: Theme.of(context).textTheme.bodyLarge),
              pickersEnabled: const {
                ColorPickerType.primary: true,
                ColorPickerType.accent: false,
              },
              enableTonalPalette: false,
              enableShadesSelection: false,
              color: Color(tag.color),
              onColorChanged: (Color c) {
                tag.color = c.value;
              },
              width: 32,
              height: 32,
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            const SizedBox(height: 32),
            const Spacer(),
            FilledButton.icon(
              onPressed: _saveTag,
              label: const Text("Salva"),
              icon: const Icon(Icons.save),
            ),
            if (widget.isNewTag == false)
              FilledButton.icon(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.error)),
                onPressed: _deleteTag,
                label: const Text("Elimina"),
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }
}
