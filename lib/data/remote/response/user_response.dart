import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_danain/data/serializers.dart';

part 'user_response.g.dart';

abstract class UserResponse
    implements Built<UserResponse, UserResponseBuilder> {
  @BuiltValueField(wireName: 'username')
  String? get username;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'id_borrower')
  int get idborrower;

  @BuiltValueField(wireName: 'id_rekening')
  int get idrekening;

  @BuiltValueField(wireName: 'tlp_mobile')
  String get tlpmobile;

  @BuiltValueField(wireName: 'ktp')
  String get ktp;


  static Serializer<UserResponse> get serializer => _$userResponseSerializer;

  UserResponse._();

  factory UserResponse([void Function(UserResponseBuilder) updates]) =
      _$UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<UserResponse>(serializer, json)!;

  Map<String, dynamic> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, dynamic>;
}
