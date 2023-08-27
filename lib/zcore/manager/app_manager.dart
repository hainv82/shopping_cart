import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AppManager<T> {
  AppManager(T initialData) : event = BehaviorSubject.seeded(initialData);

  final BehaviorSubject<T> event;

  add(T data) {
    event.add(data);
  }

  addError(Object error, StackTrace stackTrace) {
    event.addError(error, stackTrace);
  }

  addStream(
      Stream<T> source, {
        bool? cancelOnError,
      }) {
    event.addStream(source, cancelOnError: cancelOnError);
  }

  StreamSubscription listen(
      void Function(T value)? onData, {
        Function? onError,
        void Function()? onDone,
        bool? cancelOnError,
      }) {
    return event.listen(onData,
        onDone: onDone, onError: onError, cancelOnError: cancelOnError);
  }

  @mustCallSuper
  Future close() => event.close();
}
