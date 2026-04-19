import 'package:hive/hive.dart';

class JournalEntry {
  final String id;
  final String ambienceTitle;
  final int durationListened;
  final String mood;
  final String notes;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.ambienceTitle,
    required this.durationListened,
    required this.mood,
    required this.notes,
    required this.date,
  });
}


class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    return JournalEntry(
      id: reader.readString(),
      ambienceTitle: reader.readString(),
      durationListened: reader.readInt(),
      mood: reader.readString(),
      notes: reader.readString(),
      date: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.ambienceTitle);
    writer.writeInt(obj.durationListened);
    writer.writeString(obj.mood);
    writer.writeString(obj.notes);
    writer.writeString(obj.date.toIso8601String());
  }
}
