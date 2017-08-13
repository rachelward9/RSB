/* AngularDart info: https://webdev.dartlang.org/angular
   Components info: https://webdev.dartlang.org/components */

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'models/learner.dart';
import 'views/login_view/login_view.dart';
import 'views/vocab_view/vocab_view.dart';
import 'views/vocab_list_component/vocab_list_component.dart';
import 'views/noun_view/noun_view.dart';
//import 'views/verb_view/verb_view.dart';

@Component(
  selector: 'main-app',
  styleUrls: const ['main_app.css'],
  templateUrl: 'main_app.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, LoginView, VocabListComponent, VocabView, NounView],
  providers: const [materialProviders],
)

class MainApp {
  final LoggerService _log;
  final FirebaseService fbService;

  MainApp(LoggerService this._log, FirebaseService this.fbService) {
    _log.info("$runtimeType()");
  }

}
