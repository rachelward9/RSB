import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import '../../services/noun_service.dart';
import 'package:RSB/services/noun_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'noun-view',
  templateUrl: 'noun_view.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives//,
//    TodoListComponent
  ],
  providers: const [
    FirebaseService,
    materialProviders,
    NounService
  ],
  styleUrls: const ['noun_view.css'],
)

class NounView implements OnInit {
  final FirebaseService fbService;
  final NounService nounService;

  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.

  static const List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

  List<String> wordList = [];
  List<String> defList = [];

  String newWord = "";
  String newDef = "";

  NounView(FirebaseService this.fbService, NounService this.nounService);

  @override
  Future<Null> ngOnInit() async {
    //newListWords = await vocabListService.getVocabList();
//    newSetWords.addAll(newListWords);
    masterMap = await nounService.getNounMap();
    currentView = views.elementAt(0); // 0th index should be first view.

    if (masterMap.isNotEmpty) {
      masterMap.forEach((String word, List def) {
        wordList.add(word);
//        defList.add(def);
      });
    }
  } // End ngOnInit()




  void add(String word, [String definition = ""]) {
//    vocabMap.putIfAbsent(word, () => word);
//    vocabMap[word] = definition;
    // I think this does the above two functions in one line.
    wordList.add(word);
    defList.add(definition);
//    vocabMap[word] = definition;
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  String remove(String word) {
    int idx = wordList.indexOf(word);
    wordList.removeAt(idx);
    defList.removeAt(idx);
//    vocabMap.remove(word);
  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
}
