import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../sample_exception/src/sample_exception.dart';
// import '../navigation/navigation_service.dart';

typedef ErrorHandleCallback = Function(SampleException exception, bool resolved, {dynamic result});

class ErrorHandle {
  // const ErrorHandle(this.context);

  // factory ErrorHandle.global() =>
      // ErrorHandle(NavigationService().navKey.currentContext);

  // factory ErrorHandle.overlay() =>
  //     ErrorHandle(NavigationService().navKey.currentState?.overlay?.context);

  // final BuildContext? context;

  void catcher(SampleException exception, {ErrorHandleCallback? callback}) {
    if (kDebugMode) {
      print(exception);
    }
  }
}
