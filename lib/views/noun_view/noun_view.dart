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
class NounView implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

//  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.
//Map<gender, Map<example index, Map<case, Map<sing_or_plurl, word>>>  OR
//Map<gender, Map<index, Map<type/word, desc/example>>>

  Map<String, Map<String, Map<String, dynamic>>> nounDataMap = {};
  Map<String, String> nounMetaMap = {};

  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

//  List<String> wordList = [];
//  List<String> defList = [];

//  String newWord = "";
//  String newDef = "";


//  @override
  Future<Null> ngOnInit() async {
    ///todo: Is this right?
    if (nounDataMap.isEmpty) {
      if (fbService.learner.currentLanguage != "") { // fbService.learner.currentLanguage != null && // Just the check for empty string should be sufficient.
        fbService.changeLang(fbService.learner.currentLanguage);
        nounDataMap = await fbService.singleLangData;
        nounMetaMap = await fbService.singleLangMeta;
      }
    }
    currentView = views.elementAt(0); // 0th index should be first view.
//
//    if (fbService.learner.checkComplete() == false) {
//
//    }
  } // End ngOnInit()

  NounView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
  }

  Future<Null> getLanguage(String lang) async {
//    nounDataMap = await fbService.fullLanguageData[lang]["nouns"];
//    nounMetaMap = await fbService.la[lang]["nouns"];
    nounDataMap = await fbService.getSingleLangData(lang);
    nounMetaMap = await fbService.getSingleLangMeta(lang);
  }

} // end class NounView



//  void add(String word, [String definition = ""]) {
////    vocabMap.putIfAbsent(word, () => word);
////    vocabMap[word] = definition;
//    // I think this does the above two functions in one line.
//    wordList.add(word);
//    defList.add(definition);
////    vocabMap[word] = definition;
//    //newSetWords.add(description);
//  }
////  String remove(int index) => newListWords.removeAt(index);
//  void remove(String word) {
//    int idx = wordList.indexOf(word);
//    wordList.removeAt(idx);
//    defList.removeAt(idx);
////    vocabMap.remove(word);
//  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));