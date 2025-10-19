import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sId;

  @HiveField(3)
  final bool isPaid;

  @HiveField(4)
  final bool isVip;

  bool get canAccess => isPaid || isVip;

  User({
    String? id,
    required this.name,
    required this.sId,
    this.isPaid = true,
    this.isVip = false,
  }) : id = id ?? const Uuid().v4();

  factory User.createUser(String name, String sId) {
    return User(id: Uuid().v4(), name: name, sId: sId);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? sId,
    bool? isPaid,
    bool? isVip,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      sId: sId ?? this.sId,
      isPaid: isPaid ?? this.isPaid,
      isVip: isVip ?? this.isVip,
    );
  }
}
