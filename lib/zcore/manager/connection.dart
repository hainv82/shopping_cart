import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:core_ui/manager/app_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'app_manager.dart';

enum Connection {
  noInternetAccess,
  normal,
}

class ConnectionManager extends AppManager<Connection> {
  ConnectionManager()
      : connectivity = Connectivity(),
        super(Connection.normal) {
    _watchdog();
  }

  static final _inst = ConnectionManager();

  static ConnectionManager get shared => _inst;

  final Connectivity connectivity;
  late final StreamSubscription _subscription;

  Connection _connection = Connection.normal;

  Connection get connection => _connection;

  @override
  Future close() {
    _subscription.cancel();
    return super.close();
  }

  _watchdog() {
    _subscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        _connection = Connection.normal;
        add(Connection.normal);
      } else if (event == ConnectivityResult.wifi) {
        _connection = Connection.normal;
        add(Connection.normal);
      } else if (event == ConnectivityResult.none) {
        _connection = Connection.noInternetAccess;
        add(Connection.noInternetAccess);
      }
    });
  }
}
