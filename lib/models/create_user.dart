import 'package:json_annotation/json_annotation.dart';

part 'create_user.g.dart';

@JsonSerializable()
class CreateUser {
  final String name;

  const CreateUser({required this.name});

  factory CreateUser.fromJson(Map<String, dynamic> json) =>
      _$CreateUserFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserToJson(this);
}
