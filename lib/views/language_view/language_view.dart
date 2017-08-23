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

  @Input()
  String lang;

  Map langData;
  Map langMeta;

  Map nounData;
  Map nounMeta;

  Map verbData;
  Map verbMeta;

  Map vocab;

  @override
  ngOnInit() async {
    _log.info("$runtimeType()::ngOnInit()");
    langData = await fbService.getSingleLangData(lang);
    _log.info("$runtimeType()::ngOnInit()");
    langMeta = await fbService.getSingleLangMeta(lang);
    _log.info("$runtimeType()::ngOnInit()");
    nounData = langData["nouns"];
    _log.info("$runtimeType()::ngOnInit()");
    nounMeta = langMeta[lang];
    _log.info("$runtimeType()::ngOnInit()");

    if (fbService.vocabMeta != null && fbService.vocabMeta.isNotEmpty) { // There may not be vocab lists.
      if (fbService.vocabMeta.containsKey(fbService.learner.uid)) {
        vocab = await fbService.getVocabLists(fbService.learner.uid);
        _log.info("$runtimeType()::ngOnInit()::getVocab");
      }
    }

//    verbData = langData["verbs"];
  }

  LanguageView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }

}
