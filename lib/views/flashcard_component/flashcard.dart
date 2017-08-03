import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/vocab_list_service.dart';


@Component(
  selector: 'flashcard',
  styleUrls: const ['flashcard.css'],
  templateUrl: 'flashcard.html',
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

class Flashcard {

}