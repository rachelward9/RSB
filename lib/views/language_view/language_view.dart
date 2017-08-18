import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import '../../models/learner.dart';
import 'package:RSB/views/vocab_list_component/vocab_list_component.dart';
import 'package:RSB/views/vocab_view/vocab_view.dart';
import 'package:RSB/views/noun_view/noun_view.dart';
//import 'package:RSB/views/verb_view/verb_view.dart';

@Component(
  selector: 'language-view',
  styleUrls: const ['language_view.css'],
  templateUrl: 'language_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, VocabListComponent, VocabView, NounView],
  providers: const [materialProviders],
)
class LanguageView {
  final LoggerService _log;
  final FirebaseService fbService;

  LanguageView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }

}