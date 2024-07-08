import 'package:built_value/built_value.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  String get username;

  String get email;

  int get idborrower;

  int get idrekening;

  String get tlpmobile;
  String get ktp;

  User._();

  factory User([void Function(UserBuilder) updates]) = _$User;
}
