import 'package:shopping_cart/zcore/sample_exception/src/sample_exception.dart';

class BlocException extends SampleException {
  BlocException({
    String errorCode = '',
    dynamic error,
    StackTrace? stackTrace,
  }) : super(errorCode,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      message: 'Error in bloc:');

  @override
  // TODO: implement errorCode
  String get errorCode => 'bloc-${super.errorCode}';
}
