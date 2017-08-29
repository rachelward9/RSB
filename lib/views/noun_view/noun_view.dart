import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import '../../services/noun_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'noun-view',
  styleUrls: const ['noun_view.css'],
  templateUrl: 'noun_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],//, LoggerService],
)
class NounView { //implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;
  
  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

  NounView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    currentView = views.elementAt(0); // 0th index should be first view.
  }

//  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.
//Map<gender, Map<example index, Map<case, Map<sing_or_plurl, word>>>  OR
//Map<gender, Map<index, Map<type/word, desc/example>>>

  Map<String, Map<String, Map<String, dynamic>>> _nounDataMap = {};
//  Map<String, Map<String, dynamic>> mascSingMap = {};
//  Map<String, Map<String, dynamic>> mascPlMap = {};
//  Map<String, Map<String, dynamic>> femSingMap = {};
//  Map<String, Map<String, dynamic>> femPlMap = {};
//  Map<String, Map<String, dynamic>> neutSingMap = {};
//  Map<String, Map<String, dynamic>> neutPlMap = {};
//  List<String> declensionTypes = [];


  @Input()
  void set nounDataMap(Map<String, Map<String, Map<String, dynamic>>> singleLangData) {
//  void set nounDataMap(Map singleLangData) {
//    if (_nounDataMap != singleLangData["nouns"]) {
//      _nounDataMap = singleLangData["nouns"];
//      initializeMe();
//    }
  }
  Map<String, Map<String, Map<String, dynamic>>> get nounDataMap => _nounDataMap;

  Map<String, bool> _nounMetaMap = {};
  @Input()
  void set nounMetaMap(Map<String, bool> singleLangMeta) {
//    if (_nounMetaMap != singleLangMeta) {
//      _nounMetaMap = singleLangMeta;
//      initializeMe();
//    }
  }
  Map<String, bool> get nounMetaMap => _nounMetaMap;

  void initializeMe() {
//    if (_nounDataMap == null || _nounMetaMap == null) {
//      _log.info("$runtimeType()::initializeMe()::--data inputs are null!");
//      return;
//    }
//    else {
//      if (_nounMetaMap['hasDeclensions'] == true) {
//        _log.info("$runtimeType()::initMe()::nounDataMap = ${_nounDataMap}");
//        _log.info("$runtimeType()::initMe()::nounDataMap['masculine'] = ${_nounDataMap['masculine']}");
//        _log.info("$runtimeType()::initMe()::nounDataMap['feminine'] = ${_nounDataMap['feminine']}");
//        _log.info("$runtimeType()::initMe()::nounDataMap['neuter'] = ${_nounDataMap['neuter']}");
//        _nounDataMap['masculine'][0].forEach((String decType, Map other) {
//          declensionTypes.add(decType);
//          _log.info("$runtimeType()::initMe():: found declension type: $decType!");
//        });
//        Map<String, Map<String, dynamic>> mascSingMap = {};
//        Map<String, Map<String, dynamic>> mascPlMap = {};
//        Map<String, Map<String, dynamic>> femSingMap = {};
//        Map<String, Map<String, dynamic>> femPlMap = {};
//        Map<String, Map<String, dynamic>> neutSingMap = {};
//        Map<String, Map<String, dynamic>> neutPlMap = {};
//        List<String> declensionTypes = [];
//      }
//      else {
//        _log.info("$runtimeType()::initMe():: --No declensions for this language!");  
//      }
//      _log.info("$runtimeType()::initializeMe()::--success!");
//    }
  }


} // end class NounView
