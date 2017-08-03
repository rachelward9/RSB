// Copyright (c) 2017, MrPin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/main_app.dart';
import 'package:RSB/services/logger_service.dart';

const String APP_NAME = "RSB_170605";
final LoggerService _log = new LoggerService(appName: APP_NAME);


void main() {
  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log)
  ]);
}
