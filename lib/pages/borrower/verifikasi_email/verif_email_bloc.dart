import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/usecases/api_use_case.dart';

class VerifEmailBloc extends DisposeCallbackBaseBloc {
  final Function1<String, void> getEmail;
  final BehaviorSubject<String?> email;
  final Stream<String?> errorMessage;

  VerifEmailBloc._({
    required this.getEmail,
    required this.email,
    required this.errorMessage,
    required Function0<void> dispose,
  }) : super(dispose);

  factory VerifEmailBloc(
    GetRequestUseCase getRequest,
    PostRequestUseCase postRequest,
  ) {
    final emailController = BehaviorSubject<String?>();
    final errorMessage = BehaviorSubject<String?>();
    Future<void> getEmail(String email) async {
      emailController.add(email);
      try {
        final response = await postRequest.call(
          url: 'api/beeborroweruser/v1/user/email',
          body: {
            'email': email,
          },
        );
        response.fold(
          ifLeft: (left) {
            errorMessage.add(left);
          },
          ifRight: (right) {
            print('udah masuk emailnya bang');
          },
        );
      } catch (e) {
        errorMessage.add(e.toString());
      }
    }

    return VerifEmailBloc._(
      getEmail: getEmail,
      email: emailController,
      errorMessage: errorMessage.stream,
      dispose: () {},
    );
  }
}
