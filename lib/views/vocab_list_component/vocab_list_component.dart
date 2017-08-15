
import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/vocab_list_service.dart';
//import '../flashcard_component/flashcard.dart';

//import 'package:angular_components/src/components/material_tab/material_tab_panel.dart';
//import 'package:angular_components/src/components/material_tab/material_tab.dart';

@Component(
  selector: 'vocab-list',
  styleUrls: const ['vocab_list_component.css'],
  templateUrl: 'vocab_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives//,
//    TodoListComponent
  ],
  providers: const [
    materialProviders,
    VocabListService
  ],
)

class VocabListComponent implements OnInit {
  final VocabListService vocabListService;

  List<String> views = const [
//    "addView",
//    "listView",
//    "flashcards"
      "add words",
      "list view",
      "flashcards"
  ];
//  "add words",
//  "list view",
//  "flashcards"
  String currentView = "";

// There's gotta be a better way to do this.
  List<String> wordList = [];
  List<String> defList = [];

  bool editMode = false;
  bool menuVisible = false;
  bool defVisible = true;
  bool listOrderWordFirst = true;

  /* List */


  /* Flashcards */
  bool cardOrderWordFirst = true;
  bool showingWord = true;
  int cardIndex = 0;

//  List<String> newListWords = [];
//  Set<String> newSetWords = new Set(); // It's a vocab list, so each entry should be unique.
  Map<String, String> vocabMap = {};
//  SplayTreeMap<String, String> sortedVocab;
  String newWord = "";
  String newDef = "";

  VocabListComponent(this.vocabListService);

  @override
  Future<Null> ngOnInit() async {
    //newListWords = await vocabListService.getVocabList();
//    newSetWords.addAll(newListWords);
    Map<String, String> otherMap = await vocabListService.getVocabMap();
    vocabMap.addAll(otherMap);
    currentView = views.elementAt(0); // 0th index should be first view.

    if (vocabMap.isNotEmpty) {
      vocabMap.forEach((String word, String def) {
        wordList.add(word);
        defList.add(def);
      });
    }
  } // End ngOnInit()



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
    if (cardIndex < (wordList.length - 1)) { // Already on first card.
      showingWord = true;
      cardIndex++;
    }
  }

  void toggleMenu() {
    menuVisible = !menuVisible;
  }

  void changeVocabView(int newIndex) {
    currentView = views.elementAt(newIndex);
  }

  void add(String word, [String definition = ""]) {
//    vocabMap.putIfAbsent(word, () => word);
//    vocabMap[word] = definition;
  // I think this does the above two functions in one line.
    wordList.add(word);
    defList.add(definition);
    vocabMap[word] = definition;
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  String remove(String word) {
    int idx = wordList.indexOf(word);
    wordList.removeAt(idx);
    defList.removeAt(idx);
    vocabMap.remove(word);
  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
}
