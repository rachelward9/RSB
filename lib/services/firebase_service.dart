import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;

//import 'package:firebase/src/assets/assets.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/models/learner.dart';

@Injectable()
class FirebaseService {
  final LoggerService _log;

  firebase.Auth _fbAuth;
  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Database _fbDatabase; // = firebase.database();
  firebase.Storage _fbStorage;
  firebase.DatabaseReference fbUserMeta; // = database.ref("test");
  firebase.DatabaseReference fbUserData;
  firebase.DatabaseReference fbLangList; // = database.ref("test");
  firebase.DatabaseReference fbLangData;
  firebase.DatabaseReference fbLangMeta;

  firebase.User fbUser;
  Learner learner;

  /* Users info */
  Map _userDataMap = {};
  Map _userMetaMap = {};

  /* Languages info */
  String selectedLanguage = "";

//  bool hasLanguage = false;
  Map tempData = {};
  Map allLangMeta = {};
  Map singleLangMeta = {};
  List<String> languages = [];
  Map<String,
      Map<String, Map<String, Map<String, dynamic>>>> fullLanguageData = {};
  Map<String, Map<String, Map<String, dynamic>>> singleLangData = {};

  FirebaseService(LoggerService this._log) {
    _log.info("$runtimeType()");
//    learner = new Learner(_log);
    firebase.initializeApp(
        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: "gs://langstudbud.appspot.com/");

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    _fbDatabase = firebase.database();
    fbUserMeta = _fbDatabase.ref("usermeta");
    fbUserData = _fbDatabase.ref("userdata");
    fbLangList = _fbDatabase.ref("languagesList");
    fbLangData = _fbDatabase.ref("languagesData");
    fbLangMeta = _fbDatabase.ref("languagesMeta");
  }

  /*** Try to simplify initialization, write functions to get all da shits. ***/

  Future<Map> getUserMeta() async {
    _log.info("$runtimeType()::getUserMeta()");
    ///todo: Are two async calls necessary?
    fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
      if (e.snapshot.exists()) {
        _log.info("$runtimeType()::_userMetaMap.onValue.listen::${e.snapshot.exportVal().toString()}");
        _userMetaMap = await e.snapshot.exportVal();
      }
    });
    return _userMetaMap;
  }

  Future<Map> getUserData() async {
    _log.info("$runtimeType()::getUserData()");
    fbUserData.onValue.listen((firebase.QueryEvent e) async {
      if (e.snapshot.exists()) {
        _log.info("$runtimeType()::_userDataMap.onValue.listen::${e.snapshot.exportVal().toString()}");
        _userDataMap = await e.snapshot.exportVal();
      }
    });
    return _userDataMap;
  }

  Future<Map<String, Map<String, String>>> getAllLangMeta() async {
    _log.info("$runtimeType()::getAllLangMeta()");
    fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
      _log.info("$runtimeType()::languageMeta.onValue.listen::${e.snapshot.exportVal().toString()}");
      allLangMeta = await e.snapshot.exportVal();
      _log.info("$runtimeType():: tempLangMeta :: ${allLangMeta.toString()}");
    });
    return allLangMeta;
  }

  Future<Map<String, String>> getSingleLangMeta(String lang) async {
    _log.info("$runtimeType()::getSingleLangMeta($lang)");
    if (allLangMeta?.isNotEmpty) {
      singleLangMeta = allLangMeta[lang];
    }
    else {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::languageMeta.onValue.listen::${e.snapshot.exportVal().toString()}");
        allLangMeta = await e.snapshot.exportVal();
        singleLangMeta = allLangMeta[lang];
      });
      return singleLangMeta;
    }
  }

  Future<Map<String,Map<String, Map<String, Map<String, dynamic>>>>> getAllLangData() async {
    fbLangData.onValue.listen((firebase.QueryEvent e) async {
      _log.info("$runtimeType()::languageData.onValue.listen::${e.snapshot.exportVal().toString()}");
      fullLanguageData = await e.snapshot.exportVal();
      _log.info("$runtimeType():: fullLanguageData:: ${fullLanguageData.toString()}");
    });
    return fullLanguageData;
  }

  Future<Map<String, Map<String, Map<String, dynamic>>>> getSingleLangData(String lang) async {
    _log.info("$runtimeType()::getSingleLangData($lang)");
    if (fullLanguageData?.isNotEmpty) {
      singleLangData = fullLanguageData[lang];
    }
    else {
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        fullLanguageData = await e.snapshot.exportVal();
        singleLangData = fullLanguageData[lang];
      });
    }
    return singleLangData;
  }


  Future<List> getLangList() async {
    if (languages?.isNotEmpty) {
      return languages;
    }
    else {
      fbLangList.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::languages::${e.snapshot.exportVal().toString()}");
        tempData = await e.snapshot.exportVal();
        tempData.forEach((String notUsed, String lang) {
          _log.info("Adding language $lang");
          languages.add(lang);
        });
        selectedLanguage = languages[0];
      });
      return languages;
    }
  }

  /*** } // end FirebaseService() constructor. ***/
///todo: should all if() statements that get firebase data use the Elvis operator?
  _authChanged(firebase.User newUser) {
    _log.info("$runtimeType()::_authChanged()");
//    _log.info("$runtimeType()::newUser.runtimeType:${newUser.runtimeType}");
    fbUser = newUser;
//    _log.info("$runtimeType()::fbUser.runtimeType:${fbUser.runtimeType}");
//    _log.info("$runtimeType()::newUser::${newUser.toString()}");
    if (newUser != null) {
//      _log.info("$runtimeType()::newUser.uid::${newUser.uid}");
      _log.info(
          "$runtimeType()::newUser.displayName::${newUser.displayName}");
//      _log.info("$runtimeType()::newUser.email::${newUser.email}");
      if (_userMetaMap?.containsKey(newUser.uid)) {
        _log.info("$runtimeType()::_userMetaMap::${_userMetaMap.toString()}");
        learner = new Learner.fromMap(_userDataMap, _log);
      }
      else {
        learner = new Learner.constructNewLearner(_log, newUser.uid, newUser.displayName, newUser.email);
      }
      //      _log.info("$runtimeType()::_authChanged()::_userMetaMap.keys:: ${_userMetaMap.keys.toString()}");
//      _userMetaMap.forEach((String uuid, var unused) {
//        _log.info("$runtimeType():: $uuid");
//      });
//      if (_userMetaMap.isNotEmpty) {
//        _log.info("$runtimeType():: _userMetaMap.isNotEmpty::${_userMetaMap.isNotEmpty}");
//        fbUserMeta.onValue.listen((firebase.QueryEvent e) {
//          if (e.snapshot.exists()) {
//            _log.info("$runtimeType()::_authChanged()::_userMetaMap::${e.snapshot.exportVal().toString()}");
//            _userMetaMap = e.snapshot.exportVal();
//          }
//        });
//      }
//      else {
//        _log.info("$runtimeType():: _userMetaMap is empty!");
//        _log.info("$runtimeType()::_authChanged()::_userMetaMap.isEmpty::${_userMetaMap.isEmpty}");
//        fbUserMeta.onValue.listen((firebase.QueryEvent e) {
//          if (e.snapshot.exists()) {
//            _log.info("$runtimeType()::_authChanged()::_userMetaMap::${e.snapshot.exportVal().toString()}");
//            _userMetaMap = e.snapshot.exportVal();
//          }
//        });
//        _log.info("$runtimeType()::_authChanged()::_userMetaMap.isEmpty::${_userMetaMap.isEmpty}");
//      }
//      if (_userMetaMap.containsKey(newUser.uid)) {
//        Map userInfoMap;
//        _userDataMap.forEach((String userID, Map info) {
//          if (userID == "i8TSwVSuzSaJYs4gAm6eeqfqwEa2") {
//            userInfoMap = info;
//            info.forEach((String key, var value){
//              _log.info("$runtimeType()::key: $key, value:: ${value.toString()}");
////              _log.info("");
//            });
//            _log.info("$runtimeType()::My User:: ${userInfoMap.toString()}");
//          }
//        });
//        _log.info("$runtimeType()::_authChanged()::_userMetaMap::${_userMetaMap.toString()}");
//        learner = new Learner.fromMap(userInfoMap, _log);
//        _log.info("$runtimeType()::learner 1::${learner.toString()}");
//      }
//      else {
////        learner.constructNewLearner(newUser.uid, newUser.displayName, newUser.email);
//        _log.info("$runtimeType()::learner 2::${learner.toString()}");
//      }
    }
  } // end _authChanged

  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
      _log.info("$runtimeType::login() -- logging in...");
    }
    catch (error) {
      _log.info("$runtimeType::login() -- $error");
    }
  }

  void signOut() {
    _log.info("$runtimeType::logout()");
    _fbAuth.signOut();
  }

  Future<Null> changeLang(String lang) async {
    if (selectedLanguage?.isEmpty) { // First time picking; easy.
      // Set current language to the selected language.
      selectedLanguage = lang;
      // Get language metadata
      singleLangMeta = await getSingleLangMeta(lang);

      // Get the language data for the selected language.
      singleLangData = await getSingleLangData(lang);
    }
    else {
      learner.changeLang(lang);
    }
  }

} //end class FirebaseService


//  void _newMessage(firebase.QueryEvent event) {
////    Message msg = new Message.fromMap(event.snapshot.val());
////    Message.add(msg);
//
////    print(msg.text);
//  }


//  _registerUser(String email, String password) {
////    if (email.isNotEmpty && password.isNotEmpty) {
////      _fbAuth.createUserWithEmailAndPassword(email, password);
////
////    }
//  }
//}
