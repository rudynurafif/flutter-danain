part of '../../user_repository_imp.dart';

abstract class _Mappers {
  ///
  /// Convert error to [Failure]
  ///
  static AppError errorToAppError(Object e, StackTrace s) {
    if (e is CancellationException) {
      return const AppCancellationError();
    }

    if (e is RemoteDataSourceException) {
      if (e.error is CancellationException) {
        return const AppCancellationError();
      }
      return AppError(
        message: e.message,
        error: e,
        stackTrace: s,
      );
    }

    if (e is LocalDataSourceException) {
      if (e.error is CancellationException) {
        return const AppCancellationError();
      }
      return AppError(
        message: e.message,
        error: e,
        stackTrace: s,
      );
    }

    return AppError(
      message: e.toString(),
      error: e,
      stackTrace: s,
    );
  }

  /// Entity -> Domain
  static AuthenticationState userAndTokenEntityToDomainAuthState(
      UserAndTokenEntity? entity) {
    if (entity == null) {
      return UnauthenticatedState();
    }

    final userAndTokenBuilder = UserAndTokenBuilder()
      ..user = _Mappers.userEntityToUserDomain(entity.user)
      ..beranda = entity.beranda
      ..token = entity.token;

    return AuthenticatedState((b) => b.userAndToken = userAndTokenBuilder);
  }

  /// Entity -> Domain
  static UserBuilder userEntityToUserDomain(UserEntity userEntity) {
    return UserBuilder()
      ..username = userEntity.username
      ..email = userEntity.email
      ..idborrower = userEntity.idborrower
      ..idrekening = userEntity.idrekening
      ..tlpmobile = userEntity.tlpmobile
      ..ktp = userEntity.ktp;
  }

  /// Response -> Entity
  static UserEntityBuilder userResponseToUserEntity(UserResponse userResponse) {
    return UserEntityBuilder()
      ..username = userResponse.username
      ..email = userResponse.email
      ..idborrower = userResponse.idborrower
      ..idrekening = userResponse.idrekening
      ..tlpmobile = userResponse.tlpmobile
      ..ktp = userResponse.ktp;
  }

  /// Response -> Entity
  static UserAndTokenEntity userResponseToUserAndTokenEntity(
    UserResponse user,
    String token,
    String refreshToken,
    String beranda,
  ) {
    return UserAndTokenEntity(
      (b) => b
        ..token = token
        ..refreshToken = refreshToken
        ..user = userResponseToUserEntity(user)
        ..beranda = beranda,
    );
  }
}
