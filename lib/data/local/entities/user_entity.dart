import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_danain/data/serializers.dart';

part 'user_entity.g.dart';

abstract class UserEntity implements Built<UserEntity, UserEntityBuilder> {
  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'id_borrower')
  int get idborrower;

  @BuiltValueField(wireName: 'id_rekening')
  int? get idrekening;
  @BuiltValueField(wireName: 'tlp_mobile')
  String get tlpmobile;
  @BuiltValueField(wireName: 'ktp')
  String get ktp;
  static Serializer<UserEntity> get serializer => _$userEntitySerializer;

  UserEntity._();

  factory UserEntity([void Function(UserEntityBuilder) updates]) = _$UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<UserEntity>(serializer, json)!;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;
}
