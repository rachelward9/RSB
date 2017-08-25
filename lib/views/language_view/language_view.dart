import 'dart:async';
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
class LanguageView { //implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;


  String _lang = "";

  Map _langData = {};
  Map _langMeta = {};

  Map _nounData = {};
  Map _nounMeta = {};

//  Map _verbData = {};
//  Map _verbMeta = {};

  Map _vocab = {};

  @Input()
  void set lang(String l) {
    if (_lang != l) {
      _lang = l;
      _initMe();
    }

  }
  String get lang => _lang;

  @Input()
  void set langData(Map ld) {
    if (_langData != ld) {
      _langData = ld;
      _initMe();
    }
  }
  Map get langData => _langData;

  @Input()
  void set nounData(Map nd) {
    if (_nounData != nd) {
      _nounData = nd;
      _initMe();
    }
  }
  Map get nounData => _nounData;

  @Input()
  void set nounMeta(Map nm) {
    if (_nounMeta != nm) {
      _nounMeta = nm;
      _initMe();
    }
  }
  Map get nounMeta => _nounMeta;

  @Input()
  void set vocab(Map voc) {
    if (voc == null || voc.isEmpty) {
     _vocab = {};
    }
  }
  Map get vocab => _vocab;

  void _initMe() {
    _log.info("$runtimeType()::_initMe()");
    if (_lang == null || _langData == null || _langMeta == null || _nounData == null || _nounMeta == null || _vocab == null) {
      _log.info("$runtimeType()::_initMe()::_lang is $_lang");
      _log.info("$runtimeType()::_initMe()::_langData is ${_lang == null ? 'null' : _lang}");
      _log.info("$runtimeType()::_initMe()::_langMeta is ${_langMeta == null ? 'null' : _langData}");
      _log.info("$runtimeType()::_initMe()::_nounData is ${_nounData == null ? 'null' : _nounData}");
      _log.info("$runtimeType()::_initMe()::_nounData is ${_nounMeta == null ? 'null' : _nounMeta}");
      _log.info("$runtimeType()::_initMe()::_vocab is ${_vocab == null ? 'null' : _vocab}");
      return;
    }
    _log.info("$runtimeType()::initMe()::--success!");
  }

//  @override
//  Future<Null> ngOnInit() async {
//    _log.info("$runtimeType()::ngOnInit()");
//    langData = await fbService.getSingleLangData(_lang);
//    _log.info("$runtimeType()::ngOnInit()::langData::${_langData.toString()}");
//    _langMeta = await fbService.getSingleLangMeta(_lang);
//    _log.info("$runtimeType()::ngOnInit()::langMeta::${_langMeta.toString()}");
//    nounData = _langData["nouns"];
//    _log.info("$runtimeType()::ngOnInit()::nounData::${_nounData.toString()}");
//    nounMeta = _langMeta[_lang];
//    _log.info("$runtimeType()::ngOnInit()::nounMeta::${_nounMeta.toString()}");
//
//    if (fbService.vocabMeta != null && fbService.vocabMeta.isNotEmpty) { // There may not be vocab lists.
//      if (fbService.vocabMeta.containsKey(fbService.learner.uid)) {
//        vocab = await fbService.getVocabLists(fbService.learner.uid);
//        _log.info("$runtimeType()::ngOnInit()::getVocab");
//      }
//    }
//
////    verbData = langData["verbs"];
//  }

  LanguageView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }

}
