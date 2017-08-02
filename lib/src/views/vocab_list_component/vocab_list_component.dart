
import 'dart:async';
import 'dart:collection';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'vocab_list_service.dart';

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

  bool editMode = false;
//  List<String> newListWords = [];
//  Set<String> newSetWords = new Set(); // It's a vocab list, so each entry should be unique.
  Map<String, String> vocabMap = {};
  SplayTreeMap<String, String> sortedVocab;
  String newWord = "";
  String newDef = "";

  VocabListComponent(this.vocabListService);

  @override
  Future<Null> ngOnInit() async {
    //newListWords = await vocabListService.getVocabList();
//    newSetWords.addAll(newListWords);
    Map<String, String> otherMap = await vocabListService.getVocabMap();
    vocabMap.addAll(otherMap);
  }

  void changeEditMode() {
    editMode = !editMode;
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
