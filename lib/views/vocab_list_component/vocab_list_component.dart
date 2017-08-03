
import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB_170605/services/vocab_list_service.dart';

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

  static const List<String> views = const [
    "addView",
    "listView",
    "flashcards"
  ];
  String currentView = "";
//  String currentView = views[0]; // 0th index should be first view.

  bool editMode = false;
  bool menuVisible = false;
  bool defVisible = false;
  bool cardOrderWordFirst = false;

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
  }

  void changeEditMode() {
    editMode = !editMode;
  }

  void changeListView() {
    defVisible = !defVisible;
  }

  void changeCardView() {
    cardOrderWordFirst = !cardOrderWordFirst;
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
    vocabMap[word] = definition;
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  String remove(String word) => vocabMap.remove(word);
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
}
