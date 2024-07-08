// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String username;
  @override
  final String email;
  @override
  final int idborrower;
  @override
  final int idrekening;
  @override
  final String tlpmobile;
  @override
  final String ktp;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (new UserBuilder()..update(updates))._build();

  _$User._(
      {required this.username,
      required this.email,
      required this.idborrower,
      required this.idrekening,
      required this.tlpmobile,
      required this.ktp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(username, r'User', 'username');
    BuiltValueNullFieldError.checkNotNull(email, r'User', 'email');
    BuiltValueNullFieldError.checkNotNull(idborrower, r'User', 'idborrower');
    BuiltValueNullFieldError.checkNotNull(idrekening, r'User', 'idrekening');
    BuiltValueNullFieldError.checkNotNull(tlpmobile, r'User', 'tlpmobile');
    BuiltValueNullFieldError.checkNotNull(ktp, r'User', 'ktp');
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        username == other.username &&
        email == other.email &&
        idborrower == other.idborrower &&
        idrekening == other.idrekening &&
        tlpmobile == other.tlpmobile &&
        ktp == other.ktp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, idborrower.hashCode);
    _$hash = $jc(_$hash, idrekening.hashCode);
    _$hash = $jc(_$hash, tlpmobile.hashCode);
    _$hash = $jc(_$hash, ktp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('username', username)
          ..add('email', email)
          ..add('idborrower', idborrower)
          ..add('idrekening', idrekening)
          ..add('tlpmobile', tlpmobile)
          ..add('ktp', ktp))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  int? _idborrower;
  int? get idborrower => _$this._idborrower;
  set idborrower(int? idborrower) => _$this._idborrower = idborrower;

  int? _idrekening;
  int? get idrekening => _$this._idrekening;
  set idrekening(int? idrekening) => _$this._idrekening = idrekening;

  String? _tlpmobile;
  String? get tlpmobile => _$this._tlpmobile;
  set tlpmobile(String? tlpmobile) => _$this._tlpmobile = tlpmobile;

  String? _ktp;
  String? get ktp => _$this._ktp;
  set ktp(String? ktp) => _$this._ktp = ktp;

  UserBuilder();

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _username = $v.username;
      _email = $v.email;
      _idborrower = $v.idborrower;
      _idrekening = $v.idrekening;
      _tlpmobile = $v.tlpmobile;
      _ktp = $v.ktp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    final _$result = _$v ??
        new _$User._(
            username: BuiltValueNullFieldError.checkNotNull(
                username, r'User', 'username'),
            email:
                BuiltValueNullFieldError.checkNotNull(email, r'User', 'email'),
            idborrower: BuiltValueNullFieldError.checkNotNull(
                idborrower, r'User', 'idborrower'),
            idrekening: BuiltValueNullFieldError.checkNotNull(
                idrekening, r'User', 'idrekening'),
            tlpmobile: BuiltValueNullFieldError.checkNotNull(
                tlpmobile, r'User', 'tlpmobile'),
            ktp: BuiltValueNullFieldError.checkNotNull(ktp, r'User', 'ktp'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
