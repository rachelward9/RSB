/* AngularDart info: https://webdev.dartlang.org/angular
   Components info: https://webdev.dartlang.org/components */

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'models/learner.dart';
import 'views/login_view/login_view.dart';
import 'views/menu_view/menu_view.dart';
//import 'views/vocab_list_component/vocab_list_component.dart';
//import 'views/noun_view/noun_view.dart';
import 'views/language_view/language_view.dart';
//import 'models/learner.dart';
//import 'views/verb_view/verb_view.dart';

@Component(
  selector: 'main-app',
  styleUrls: const ['main_app.css'],
  templateUrl: 'main_app.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, LoginView, MenuView, LanguageView],
  providers: const [materialProviders],
)
class MainApp implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> views = const [
    "menuView",
    "languageView"
  ];

  String currentView;

  @override
  ngOnInit() {
    fbService.completeLearner();
  }

  MainApp(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
//    _log.info("$runtimeType()::fbService.selectedLanguage::${fbService.selectedLanguage}");
    currentView = views[0];
  }

  void changeMenu(int idx) {
    currentView = views[idx];
  }

//  void showMenu() {
//
//  }
//
//  void showKnowledge() {
//
//  }
}
