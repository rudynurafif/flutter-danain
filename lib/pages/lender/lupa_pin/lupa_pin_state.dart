import 'package:meta/meta.dart';

@immutable
abstract class LupaPinMessage {}

class LupaPinSuccessMessage implements LupaPinMessage {
  const LupaPinSuccessMessage();
}

class LupaPinErrorMessage implements LupaPinMessage {
  final Object error;
  final String message;

  const LupaPinErrorMessage(this.message, this.error);

  @override
  String toString() => 'LupaPinErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements LupaPinMessage {
  const InvalidInformationMessage();
}
