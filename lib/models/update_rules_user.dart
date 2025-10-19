import 'package:json_annotation/json_annotation.dart';

part 'update_rules_user.g.dart';

@JsonSerializable()
class UpdateRulesUser {
  final String id;
  final bool isPaid;
  final bool isVip;

  const UpdateRulesUser({
    required this.id,
    required this.isPaid,
    required this.isVip,
  });

  factory UpdateRulesUser.fromJson(Map<String, dynamic> json) => _$UpdateRulesUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRulesUserToJson(this);
}
