
//import 'dart:html';
//import 'dart:async';
import 'package:angular2/angular2.dart';
//import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import '../../models/learner.dart';
import 'package:angular2/core.dart';


@Component(
  selector: 'menu-view',
  styleUrls: const ['menu_view.css'],
  templateUrl: 'menu_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class MenuView {
  final LoggerService _log;
  final FirebaseService fbService;

  MenuView(LoggerService this._log, FirebaseService this.fbService) {
    _log.info("$runtimeType()");
  }

}