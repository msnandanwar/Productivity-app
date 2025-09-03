// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Task(
      title: fields[0] as String,
      notes: fields[1] as String?,
      dueDate: fields[2] as DateTime?,
      completed: fields[3] as bool,
      priority: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.priority);
  }
}
