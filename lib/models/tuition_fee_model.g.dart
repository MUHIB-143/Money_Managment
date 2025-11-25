// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuition_fee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TuitionPaymentAdapter extends TypeAdapter<TuitionPayment> {
  @override
  final int typeId = 3;

  @override
  TuitionPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TuitionPayment(
      amount: fields[0] as double,
      date: fields[1] as DateTime,
      receipt: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TuitionPayment obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.receipt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TuitionPaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TuitionFeeAdapter extends TypeAdapter<TuitionFee> {
  @override
  final int typeId = 4;

  @override
  TuitionFee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TuitionFee(
      id: fields[0] as String,
      totalAmount: fields[1] as double,
      payments: (fields[2] as List?)?.cast<TuitionPayment>(),
      dueDate: fields[3] as DateTime?,
      semester: fields[4] as String,
      institution: fields[5] as String?,
      createdDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TuitionFee obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalAmount)
      ..writeByte(2)
      ..write(obj.payments)
      ..writeByte(3)
      ..write(obj.dueDate)
      ..writeByte(4)
      ..write(obj.semester)
      ..writeByte(5)
      ..write(obj.institution)
      ..writeByte(6)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TuitionFeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
