// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      categoryId: json['categoryId'] as String,
      walletId: json['walletId'] as String,
      note: json['note'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      recurring: json['recurring'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      locationName: json['locationName'] as String?,
      locationLatitude: (json['locationLatitude'] as num?)?.toDouble(),
      locationLongitude: (json['locationLongitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amount': instance.amount,
      'type': instance.type,
      'categoryId': instance.categoryId,
      'walletId': instance.walletId,
      'note': instance.note,
      'date': instance.date?.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt?.toIso8601String(),
      'recurring': instance.recurring,
      'tags': instance.tags,
      'locationName': instance.locationName,
      'locationLatitude': instance.locationLatitude,
      'locationLongitude': instance.locationLongitude,
    };

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      iconCode: (json['iconCode'] as num).toInt(),
      colorValue: (json['colorValue'] as num).toInt(),
      type: json['type'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'iconCode': instance.iconCode,
      'colorValue': instance.colorValue,
      'type': instance.type,
      'isCustom': instance.isCustom,
    };

_$WalletModelImpl _$$WalletModelImplFromJson(Map<String, dynamic> json) =>
    _$WalletModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      balance: (json['balance'] as num).toDouble(),
      iconCode: (json['iconCode'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$WalletModelImplToJson(_$WalletModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'balance': instance.balance,
      'iconCode': instance.iconCode,
      'type': instance.type,
    };

_$BudgetModelImpl _$$BudgetModelImplFromJson(Map<String, dynamic> json) =>
    _$BudgetModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      categoryId: json['categoryId'] as String,
      limitAmount: (json['limitAmount'] as num).toDouble(),
      period: json['period'] as String,
      usedAmount: (json['usedAmount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$BudgetModelImplToJson(_$BudgetModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'limitAmount': instance.limitAmount,
      'period': instance.period,
      'usedAmount': instance.usedAmount,
    };
