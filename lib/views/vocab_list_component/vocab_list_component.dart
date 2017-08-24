
//import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import 'package:RSB/services/vocab_list_service.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
//import '../flashcard_component/flashcard.dart';

//import 'package:angular_components/src/components/material_tab/material_tab_panel.dart';
//import 'package:angular_components/src/components/material_tab/material_tab.dart';

@Component(
  selector: 'vocab-list',
  styleUrls: const ['vocab_list_component.css'],
  templateUrl: 'vocab_list_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders], //, LoggerService],
)
class VocabListComponent { //implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> views = const [
//    "addView",
//    "listView",
//    "flashcards"
      "add words",
      "list view",
      "flashcards"
  ];

  String currentView = "";

//  bool hasLanguage = false;

// There's gotta be a better way to do this.
  Map<String, String> _vocabList = {};

  @Input()
  void set vocabList(Map vl) {
    if (_vocabList != vl) {
      _vocabList = vl;
      if (_vocabList.isNotEmpty) {
        _vocabList.forEach((String word, String def) {
          wordList.add(word);
          defList.add(def);
        });
      }
      _initMe();
    }
  }
  Map<String, String> get vocabList => _vocabList;

  void _initMe() {
    if (_vocabList == null) {
      return;
    }
    _log.info("$runtimeType()::vocabList: ${_vocabList.toString()}");
  }

//  Map<String, Map<String, String>> tempVocabMap = {};
  List<String> wordList = [];
  List<String> defList = [];

  bool editMode = false;
  bool menuVisible = false;
  bool defVisible = true;
  bool listOrderWordFirst = true;

  /* Flashcards */
  bool cardOrderWordFirst = true;
  bool showingWord = true;
  int cardIndex = 0;

//  List<String> newListWords = [];
//  Set<String> newSetWords = new Set(); // It's a vocab list, so each entry should be unique.

//  SplayTreeMap<String, String> sortedVocab;
  String newWord = "";
  String newDef = "";

//  @override
//  Future<Null> ngOnInit() async {
//    if (vocabList.isEmpty) {
//      if (fbService.learner.checkComplete() == false) {
//        await fbService.completeLearner();
//        if (fbService.learner.currentLanguage != "") { // fbService.learner.currentLanguage != null && // Just the check for empty string should be sufficient.
//          fbService.changeLang(fbService.learner.currentLanguage);
//          tempVocabMap = await fbService.getVocabLists(fbService.learner.uid);
//          vocabList = tempVocabMap[fbService.learner.currentLanguage];
//        }
//      }
//    }
//  }

  VocabListComponent(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
    currentView = views[0];
  }

//  @override
//  Future<Null> ngOnInit() async {
//    if (fbService.learner.currentLanguage != "") { ///todo: Need more checks?
//      hasLanguage = true;
//    }
//    // Should I just do this? Doesn't matter if it's empty,
//    vocabList = fbService.learner.currentVocabList;
//    //    if ()
//    //newListWords = await vocabListService.getVocabList();
////    newSetWords.addAll(newListWords);
////    Map<String, String> otherMap = await vocabListService.getVocabMap();
////    vocabMap.addAll(otherMap);
//    currentView = views.elementAt(0); // 0th index should be first view.
//
//    if (vocabMap.isNotEmpty) {
//      vocabMap.forEach((String word, String def) {
//        wordList.add(word);
//        defList.add(def);
//      });
//    }
//  } // End ngOnInit()



  void changeEditMode() {
    editMode = !editMode;
  }

  void changeListView() {
    defVisible = !defVisible;
  }

  void changeListWordView() {
    listOrderWordFirst = !listOrderWordFirst;
  }

  void changeCardView() {
    cardOrderWordFirst = !cardOrderWordFirst;
  }

  void cardClick() {
    showingWord = !showingWord;
  }

  void previousCard() {
    if (cardIndex > 0) { // Already on first card.
      showingWord = true;
      cardIndex--;
    }
  }
  void nextCard() {
    if (cardIndex < (_vocabList.length - 1)) { // Already on first card.
      showingWord = true;
      cardIndex++;
    }
  }

  void toggleMenu() {
    menuVisible = !menuVisible;
  }

  void changeVocabView(int newIndex) {
//    currentView = views[newIndex];
    currentView = views.elementAt(newIndex);
  }

  void add(String word, [String definition = ""]) {
  // I think this does the above two functions in one line.
    wordList.add(word);
    defList.add(definition);
    _vocabList[word] = definition;
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  void remove(String word) {
    int idx = wordList.indexOf(word);
    wordList.removeAt(idx);
    defList.removeAt(idx);
    _vocabList.remove(word);
  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
}
