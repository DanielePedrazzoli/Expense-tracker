import 'package:expense_tracker/models/TransactionType.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  late double price;
  late String name;
  DateTime? date;
  late String note;

  @enumerated
  late TransactionType type;

  final tags = IsarLinks<Tag>();
  List<Tag> tempTag = [];

  Transaction copy() {
    Transaction copy = Transaction();

    copy.date = date;
    copy.id = id;
    copy.name = name;
    copy.note = note;
    copy.price = price;
    copy.type = type;
    copy.tempTag = tags.toList();

    return copy;
  }

  String? get formattedDate => date == null ? null : DateFormat('dd/MM/yyyy').format(date!);

  List<Tag> getAllTags() {
    return tempTag.toList();
  }

  void toggleTag(Tag tag) {
    if (tempTag.contains(tag)) {
      tempTag.remove(tag);
    } else {
      tempTag.add(tag);
    }
  }
}
