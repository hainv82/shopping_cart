import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin ContentCore<T extends StatefulWidget> on State<T> {
  B read<B>() {
    return context.read<B>();
  }

  ThemeData get theme => Theme.of(context);

  TextTheme get textTheme => Theme.of(context).textTheme;
}
