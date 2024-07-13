// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageDaoAdapter extends TypeAdapter<MessageDao> {
  @override
  final int typeId = 0;

  @override
  MessageDao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageDao(
      id: fields[0] as String,
      text: fields[1] as String,
      isMine: fields[2] as bool,
      status: fields[3] as MessageStatus?,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MessageDao obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isMine)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageDaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
