// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_and_token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserAndToken extends UserAndToken {
  @override
  final String token;
  @override
  final User user;
  @override
  final String beranda;

  factory _$UserAndToken([void Function(UserAndTokenBuilder)? updates]) =>
      (new UserAndTokenBuilder()..update(updates))._build();

  _$UserAndToken._(
      {required this.token, required this.user, required this.beranda})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(token, r'UserAndToken', 'token');
    BuiltValueNullFieldError.checkNotNull(user, r'UserAndToken', 'user');
    BuiltValueNullFieldError.checkNotNull(beranda, r'UserAndToken', 'beranda');
  }

  @override
  UserAndToken rebuild(void Function(UserAndTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserAndTokenBuilder toBuilder() => new UserAndTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserAndToken &&
        token == other.token &&
        user == other.user &&
        beranda == other.beranda;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, beranda.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserAndToken')
          ..add('token', token)
          ..add('user', user)
          ..add('beranda', beranda))
        .toString();
  }
}

class UserAndTokenBuilder
    implements Builder<UserAndToken, UserAndTokenBuilder> {
  _$UserAndToken? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  String? _beranda;
  String? get beranda => _$this._beranda;
  set beranda(String? beranda) => _$this._beranda = beranda;

  UserAndTokenBuilder();

  UserAndTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _user = $v.user.toBuilder();
      _beranda = $v.beranda;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserAndToken other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserAndToken;
  }

  @override
  void update(void Function(UserAndTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserAndToken build() => _build();

  _$UserAndToken _build() {
    _$UserAndToken _$result;
    try {
      _$result = _$v ??
          new _$UserAndToken._(
              token: BuiltValueNullFieldError.checkNotNull(
                  token, r'UserAndToken', 'token'),
              user: user.build(),
              beranda: BuiltValueNullFieldError.checkNotNull(
                  beranda, r'UserAndToken', 'beranda'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserAndToken', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
