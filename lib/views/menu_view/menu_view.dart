
//import 'dart:html';
//import 'dart:async';
import 'dart:async';
import'package:angular2/angular2.dart';
//import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
//import '../../models/learner.dart';
import 'package:angular2/core.dart';


@Component(
  selector: 'menu-view',
  styleUrls: const ['menu_view.css'],
  templateUrl: 'menu_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class MenuView { //implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List _langList = [];
  @Input()
  void set langList(List lm) {
    if (_langList != lm) {
      _langList = lm;
      _initMe();
    }
  }
  List get langList => _langList;

  Map testFullLangMeta = {};
  Map testFullLangData = {};

  void _initMe() {
    if (langList == null) {
      return;
    }
    _log.info("$runtimeType()::_initMe()");
  }

//  @override
//  Future<Null> ngOnInit() async {
//    testFullLangData = await fbService.getAllLangData();
//    testFullLangMeta = await fbService.getAllLangMeta();
//    langList = await fbService.getLangList();
//  }

  MenuView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
    _langList = fbService.getLangList();
  }

  void addLanguage(String lang) {
    _log.info("$runtimeType()::addLanguage($lang)");
    if (fbService.learner != null) {
      fbService.learner.addLanguage(lang);
    }
  }

  void joinGroup(String id) {
    _log.info("$runtimeType()joinGroup($id)");
  }

}