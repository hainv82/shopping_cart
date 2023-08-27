// import 'package:bloc/bloc.dart';
// import 'package:core_ui/core_ui.dart';
// import 'package:core_ui/exceptions/error_handle.dart';
// import 'package:sample_exception/sample_exception.dart';

import 'package:bloc/bloc.dart';
import 'package:shopping_cart/zcore/lib/bloc/bloc_error.dart';

import '../../sample_exception/example/example.dart';
import '../../sample_exception/src/sample_exception.dart';
import '../exception/error_handle.dart';

class _BlocHandle with BlocErrorHandle {
  @override
  void onError(BlocException error, void Function(dynamic event) add) {
    // todo nothing
  }
}

///
/// S is state
/// E is event
abstract class CoreBloc<E, S> extends Bloc<E, S> {
  CoreBloc(initialState, { BlocErrorHandle? handle})
  // CoreBloc(initialState, {required this.errorHandle, BlocErrorHandle? handle})
      : handle = handle ?? _BlocHandle(),
        super(initialState);

  @Deprecated('use ErrorHandle instead')
  BlocErrorHandle handle;

  // ErrorHandle errorHandle;

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    handle.onError(
        BlocException(error: error, stackTrace: stackTrace), addEvent);
    // errorHandle.catcher(BlocException(error: error, stackTrace: stackTrace),
    //     callback: onErrorResolve);
  }

  void onErrorResolve(SampleException exception, bool resolved,
      {dynamic result});

  void addEvent(dynamic event) {
    if (event is E) add(event);
  }

  @override
  void onChange(Change<S> change) {
    super.onChange(change);
    // Logger().debug(object: change.nextState.toString());
    print('object  ${change.nextState.toString()}');
  }
}
