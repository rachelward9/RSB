
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';

@Component(
  selector: 'lang-msg',
  styleUrls: const ['lang_msg.css'],
  templateUrl: 'lang_msg.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class LangMsg { //implements OnInit {
  final LoggerService _log;

  String langMsg;

  String _language;
  @Input()
  void set language(String lang) {
    if (_language != lang) {
      _language = lang;
      _initMe();
    }
  }
  String get language => _language;

  void _initMe() {
    _log.info("$runtimeType()::_initMe()");
    if (_language == null || _language.isEmpty) {
      langMsg = "No language selected";
      return;
    }
    else {
      langMsg = "Now viewing $language";
    }
    _log.info("$runtimeType()::_initMe()::language: $_language");
  }

  LangMsg(this._log) {
    _log.info("$runtimeType()");
  }
}