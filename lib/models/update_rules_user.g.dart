// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_rules_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateRulesUser _$UpdateRulesUserFromJson(Map<String, dynamic> json) =>
    UpdateRulesUser(
      id: json['id'] as String,
      isPaid: json['isPaid'] as bool,
      isVip: json['isVip'] as bool,
    );

Map<String, dynamic> _$UpdateRulesUserToJson(UpdateRulesUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isPaid': instance.isPaid,
      'isVip': instance.isVip,
    };
