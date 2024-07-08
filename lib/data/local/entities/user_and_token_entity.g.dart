// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_and_token_entity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserAndTokenEntity> _$userAndTokenEntitySerializer =
    new _$UserAndTokenEntitySerializer();

class _$UserAndTokenEntitySerializer
    implements StructuredSerializer<UserAndTokenEntity> {
  @override
  final Iterable<Type> types = const [UserAndTokenEntity, _$UserAndTokenEntity];
  @override
  final String wireName = 'UserAndTokenEntity';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, UserAndTokenEntity object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'token',
      serializers.serialize(object.token,
          specifiedType: const FullType(String)),
      'refreshToken',
      serializers.serialize(object.refreshToken,
          specifiedType: const FullType(String)),
      'user',
      serializers.serialize(object.user,
          specifiedType: const FullType(UserEntity)),
      'beranda',
      serializers.serialize(object.beranda,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  UserAndTokenEntity deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserAndTokenEntityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'refreshToken':
          result.refreshToken = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'user':
          result.user.replace(serializers.deserialize(value,
              specifiedType: const FullType(UserEntity))! as UserEntity);
          break;
        case 'beranda':
          result.beranda = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$UserAndTokenEntity extends UserAndTokenEntity {
  @override
  final String token;
  @override
  final String refreshToken;
  @override
  final UserEntity user;
  @override
  final String beranda;

  factory _$UserAndTokenEntity(
          [void Function(UserAndTokenEntityBuilder)? updates]) =>
      (new UserAndTokenEntityBuilder()..update(updates))._build();

  _$UserAndTokenEntity._(
      {required this.token,
      required this.refreshToken,
      required this.user,
      required this.beranda})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        token, r'UserAndTokenEntity', 'token');
    BuiltValueNullFieldError.checkNotNull(
        refreshToken, r'UserAndTokenEntity', 'refreshToken');
    BuiltValueNullFieldError.checkNotNull(user, r'UserAndTokenEntity', 'user');
    BuiltValueNullFieldError.checkNotNull(
        beranda, r'UserAndTokenEntity', 'beranda');
  }

  @override
  UserAndTokenEntity rebuild(
          void Function(UserAndTokenEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserAndTokenEntityBuilder toBuilder() =>
      new UserAndTokenEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserAndTokenEntity &&
        token == other.token &&
        refreshToken == other.refreshToken &&
        user == other.user &&
        beranda == other.beranda;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, beranda.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserAndTokenEntity')
          ..add('token', token)
          ..add('refreshToken', refreshToken)
          ..add('user', user)
          ..add('beranda', beranda))
        .toString();
  }
}

class UserAndTokenEntityBuilder
    implements Builder<UserAndTokenEntity, UserAndTokenEntityBuilder> {
  _$UserAndTokenEntity? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  UserEntityBuilder? _user;
  UserEntityBuilder get user => _$this._user ??= new UserEntityBuilder();
  set user(UserEntityBuilder? user) => _$this._user = user;

  String? _beranda;
  String? get beranda => _$this._beranda;
  set beranda(String? beranda) => _$this._beranda = beranda;

  UserAndTokenEntityBuilder();

  UserAndTokenEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _refreshToken = $v.refreshToken;
      _user = $v.user.toBuilder();
      _beranda = $v.beranda;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserAndTokenEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserAndTokenEntity;
  }

  @override
  void update(void Function(UserAndTokenEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserAndTokenEntity build() => _build();

  _$UserAndTokenEntity _build() {
    _$UserAndTokenEntity _$result;
    try {
      _$result = _$v ??
          new _$UserAndTokenEntity._(
              token: BuiltValueNullFieldError.checkNotNull(
                  token, r'UserAndTokenEntity', 'token'),
              refreshToken: BuiltValueNullFieldError.checkNotNull(
                  refreshToken, r'UserAndTokenEntity', 'refreshToken'),
              user: user.build(),
              beranda: BuiltValueNullFieldError.checkNotNull(
                  beranda, r'UserAndTokenEntity', 'beranda'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'UserAndTokenEntity', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
