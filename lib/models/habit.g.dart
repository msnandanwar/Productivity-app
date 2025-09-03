// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Habit(
      name: fields[0] as String,
      notes: fields[1] as String?,
      completions: (fields[2] as List).cast<DateTime>(),
      frequency: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.completions)
      ..writeByte(3)
      ..write(obj.frequency);
  }
}
