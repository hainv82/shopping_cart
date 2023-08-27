import '../../sample_exception/example/example.dart';

mixin BlocErrorHandle {
  void onError(BlocException error, void Function(dynamic event) add);
}