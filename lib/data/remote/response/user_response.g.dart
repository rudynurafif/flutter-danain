// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserResponse> _$userResponseSerializer =
    new _$UserResponseSerializer();

class _$UserResponseSerializer implements StructuredSerializer<UserResponse> {
  @override
  final Iterable<Type> types = const [UserResponse, _$UserResponse];
  @override
  final String wireName = 'UserResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'id_borrower',
      serializers.serialize(object.idborrower,
          specifiedType: const FullType(int)),
      'id_rekening',
      serializers.serialize(object.idrekening,
          specifiedType: const FullType(int)),
      'tlp_mobile',
      serializers.serialize(object.tlpmobile,
          specifiedType: const FullType(String)),
      'ktp',
      serializers.serialize(object.ktp, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.username;
    if (value != null) {
      result
        ..add('username')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UserResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'id_borrower':
          result.idborrower = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'id_rekening':
          result.idrekening = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'tlp_mobile':
          result.tlpmobile = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'ktp':
          result.ktp = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$UserResponse extends UserResponse {
  @override
  final String? username;
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

  factory _$UserResponse([void Function(UserResponseBuilder)? updates]) =>
      (new UserResponseBuilder()..update(updates))._build();

  _$UserResponse._(
      {this.username,
      required this.email,
      required this.idborrower,
      required this.idrekening,
      required this.tlpmobile,
      required this.ktp})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(email, r'UserResponse', 'email');
    BuiltValueNullFieldError.checkNotNull(
        idborrower, r'UserResponse', 'idborrower');
    BuiltValueNullFieldError.checkNotNull(
        idrekening, r'UserResponse', 'idrekening');
    BuiltValueNullFieldError.checkNotNull(
        tlpmobile, r'UserResponse', 'tlpmobile');
    BuiltValueNullFieldError.checkNotNull(ktp, r'UserResponse', 'ktp');
  }

  @override
  UserResponse rebuild(void Function(UserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserResponseBuilder toBuilder() => new UserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserResponse &&
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
    return (newBuiltValueToStringHelper(r'UserResponse')
          ..add('username', username)
          ..add('email', email)
          ..add('idborrower', idborrower)
          ..add('idrekening', idrekening)
          ..add('tlpmobile', tlpmobile)
          ..add('ktp', ktp))
        .toString();
  }
}

class UserResponseBuilder
    implements Builder<UserResponse, UserResponseBuilder> {
  _$UserResponse? _$v;

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

  UserResponseBuilder();

  UserResponseBuilder get _$this {
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
  void replace(UserResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserResponse;
  }

  @override
  void update(void Function(UserResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserResponse build() => _build();

  _$UserResponse _build() {
    final _$result = _$v ??
        new _$UserResponse._(
            username: username,
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'UserResponse', 'email'),
            idborrower: BuiltValueNullFieldError.checkNotNull(
                idborrower, r'UserResponse', 'idborrower'),
            idrekening: BuiltValueNullFieldError.checkNotNull(
                idrekening, r'UserResponse', 'idrekening'),
            tlpmobile: BuiltValueNullFieldError.checkNotNull(
                tlpmobile, r'UserResponse', 'tlpmobile'),
            ktp: BuiltValueNullFieldError.checkNotNull(
                ktp, r'UserResponse', 'ktp'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
