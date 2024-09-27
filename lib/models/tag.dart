import 'package:isar/isar.dart';

part 'tag.g.dart';

@collection
class Tag {
  Id id = Isar.autoIncrement;
  late String name;
  late int color;

  @override
  bool operator ==(Object other) => other is Tag && other.name == name && other.color == color;

  @override
  int get hashCode => Object.hash(name, color);

  Tag copy() {
    Tag copy = Tag();

    copy.id = id;
    copy.name = name;
    copy.color = color;

    return copy;
  }
}
