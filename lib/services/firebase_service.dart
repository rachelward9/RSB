import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;

//import 'package:firebase/src/assets/assets.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/models/learner.dart';

@Injectable()
class FirebaseService {
  ///todo: check this once errors are resolved.
  static const String USER_META = "usermeta";
  static const String USER_DATA = "userdata";

  final LoggerService _log;

  firebase.Auth _fbAuth;
  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Database _fbDatabase; // = firebase.database();
  firebase.Storage _fbStorage;
  firebase.DatabaseReference fbUserData;
  firebase.DatabaseReference fbUserMeta; // = database.ref("test");
  firebase.DatabaseReference fbSingUserMeta; // = database.ref("test");
  firebase.DatabaseReference fbSingUserData;
  firebase.DatabaseReference fbLangList; // = database.ref("test");
  firebase.DatabaseReference fbLangData;
  firebase.DatabaseReference fbLangMeta;
  firebase.DatabaseReference fbVocabList;
  firebase.StorageReference userStorage; // Unnecessary?

  firebase.User fbUser;
  Learner learner;

  /* Users info */
  Map _userDataMap = {};
  Map _userMetaMap = {};

  Map _singleUserData = {};
  Map _singleUserMeta = {};


  /* Languages info */
  String selectedLanguage = "";

  Map<String, Map<String, Map<String, String>>> allUsersVocabLists = {};
  Map<String, Map<String, String>> singleUsersVocabLists = {};
//  bool hasLanguage = false;
  Map tempData = {};
  Map allLangMeta = {};
  Map singleLangMeta = {};
  List<String> languages = [];
  Map<String,Map<String, Map<String, Map<String, dynamic>>>> fullLanguageData = {};
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
    fbVocabList = _fbDatabase.ref("vocabLists");
//    fbStorageRoot = _fbStorage.ref("/");  // Unnecessary?
  }

  /*** Try to simplify initialization, write functions to get all da shits. ***/

  Future<bool> isUserInDatabase(String userID) async {
    bool isUserInDB = false;
    if (_userMetaMap == null || _userMetaMap.isEmpty) {
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
        if (e.snapshot.exists()) {
          _userMetaMap = await e.snapshot.exportVal();
          _log.info("$runtimeType()::_userMetaMap.onValue.listen::${e.snapshot.exportVal().toString()}");
        }
      });
    }
    if (_userMetaMap.containsKey(userID)) {
      isUserInDB = true;
    }
    return isUserInDB;
  }

  Future<Map> getUserMeta() async {
    _log.info("$runtimeType()::getUserMeta()");
    if (_userMetaMap == null || _userMetaMap.isEmpty) {
      ///todo: Are two async calls necessary?
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
        if (e.snapshot.exists()) {
          _userMetaMap = await e.snapshot.exportVal();
          _log.info("$runtimeType()::_userMetaMap.onValue.listen::${e.snapshot.exportVal().toString()}");
        }
      });
    }
    return _userMetaMap;
  }

  Future<Map> _getAllUserData() async {
    _log.info("$runtimeType()::_getAllUserData()");
    if (_userDataMap == null || _userDataMap.isEmpty) {
      fbUserData.onValue.listen((firebase.QueryEvent e) async {
        if (e.snapshot.exists()) {
          _userDataMap = await e.snapshot.exportVal();
          _log.info("$runtimeType()::_userDataMap.onValue.listen::${e.snapshot.exportVal().toString()}");
        }
      });
    }
    return _userDataMap;
  }

  Future<Map> getSingleUserData(String userID) async {
    _log.info("$runtimeType()::getSingleUserData()");
//    String dbRefPath = USER_DATA + userID;
//    if (_userDataMap == null || _userDataMap.isEmpty) {
//      fbUserData.onValue.listen((firebase.QueryEvent e) async {
//        if (e.snapshot.exists()) {
//          _userDataMap = await e.snapshot.exportVal();
//          _log.info("$runtimeType()::_userDataMap.onValue.listen::${e.snapshot.exportVal().toString()}");
//        }
//      });
//    }
    try {
      fbSingUserData = _fbDatabase.ref("$USER_DATA/$userID");
      fbSingUserData.onValue.listen((firebase.QueryEvent e) async {
        _singleUserData = await e.snapshot.exportVal();
      });
    }
    catch (er) {
      _log.info("$runtimeType()::getSingleUserData()::error -- $er");
      _log.info("$runtimeType()::getSingleUserData()::userData not present in database!");
      _singleUserData = {};
    }

    return _singleUserData;
  }

  Future<Map> getSingleUserMeta(String userID) async {
    _log.info("$runtimeType()::getSingleUserMeta()");
    try {
      fbSingUserMeta = _fbDatabase.ref("$USER_META/$userID");
      fbSingUserMeta.onValue.listen((firebase.QueryEvent e) async {
        _singleUserMeta = await e.snapshot.exportVal();
      });
    }
    catch (er) {
      _log.info("$runtimeType()::getSingleUserMeta()::error -- $er");
      _log.info("$runtimeType()::getSingleUserMeta()::userMeta not present in database!");
      _singleUserMeta = {};
    }

    return _singleUserData;
  }

  Future<Map<String, Map<String, String>>> getAllLangMeta() async {
    _log.info("$runtimeType()::getAllLangMeta()");
    if (allLangMeta == null || allLangMeta.isEmpty) {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        allLangMeta = await e.snapshot.exportVal();
        _log.info("$runtimeType()::languageMeta.onValue.listen::${e.snapshot.exportVal().toString()}");
      });
    }
    return allLangMeta;
  }

  Future<Map<String, String>> getSingleLangMeta(String lang) async {
    _log.info("$runtimeType()::getSingleLangMeta($lang)");
    if (allLangMeta != null && allLangMeta.isNotEmpty) {
      singleLangMeta = allLangMeta[lang];
    }
    else {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::languageMeta.onValue.listen::${e.snapshot.exportVal().toString()}");
        allLangMeta = await e.snapshot.exportVal();
        singleLangMeta = allLangMeta[lang];
      });
    }
    return singleLangMeta;
  }

  Future<Map<String,Map<String, Map<String, Map<String, dynamic>>>>> getAllLangData() async {
    if (fullLanguageData == null || fullLanguageData.isEmpty) {
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::languageData.onValue.listen::${e.snapshot.exportVal().toString()}");
        fullLanguageData = await e.snapshot.exportVal();
        _log.info("$runtimeType()::fullLanguageData::${fullLanguageData.toString()}");
      });
    }
    return fullLanguageData;
  }

  Future<Map<String, Map<String, Map<String, dynamic>>>> getSingleLangData(String lang) async {
    _log.info("$runtimeType()::getSingleLangData($lang)");
    if (fullLanguageData != null && fullLanguageData.isNotEmpty) {
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
    if (languages != null && languages.isNotEmpty) {
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
//        selectedLanguage = languages[0];
      });
      return languages;
    }
  }

  // I think this will not be used.
  Future<firebase.StorageReference> getUserStorage(String userID) async {
//    if (_userMetaMap.containsKey(userID) ) {
    bool isThere = await isUserInDatabase(userID);
    if (isThere == true)  {
      _log.info("$userID exists as user storage!");
    }
    else {
      _log.info("$userID does not already exist in storage. Will this create a new bucket?");
    }
    ///todo: Will this create a new storage bucket for user if not present?
    userStorage = await _fbStorage.ref("/$userID");

    return userStorage;
  }


  Future<Map<String,Map<String,String>>> getVocabLists(String userID) async {
    if (allUsersVocabLists == null || allUsersVocabLists.isEmpty) {
      fbVocabList.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::vocabList.onValue.listen::${e.snapshot.exportVal().toString()}");
        allUsersVocabLists = await e.snapshot.exportVal();
        _log.info("$runtimeType():: storedVocabLists:: ${singleUsersVocabLists.toString()}");
      });
    }
    if (allUsersVocabLists.containsKey(userID)) {
      singleUsersVocabLists = allUsersVocabLists[userID];
    }
    return singleUsersVocabLists;
  }

  /*** } // end FirebaseService() constructor. ***/


  Future<Null> completeLearner() async {
//    Map<String, Map<String,

    try {
      _singleUserMeta = await getSingleUserMeta(learner.uid);
    }
    catch (er) {
      _log.info("$runtimeType()::completeLearner()::userMeta::--$er");
    }
    try {
      _singleUserMeta = await getSingleUserData(learner.uid);
    }
    catch (er) {
      _log.info("$runtimeType()::completeLearner()::userData::--$er");
    }

    if (_singleUserMeta["myLanguages"] != null && _singleUserMeta["myLanguages"].isNotEmpty) {
      learner.myLanguages = _singleUserMeta["myLanguages"].values();
    }

    ///todo: finish this.
    ///todo: pass in values to all components, like <noun-view [someData]="passed-in-data"></noun-view>
//    learner.allLanguagesMeta
//    learner.allLanguagesData
  }

  _authChanged(firebase.User newUser) async {
    _log.info("$runtimeType()::_authChanged()");
//    _log.info("$runtimeType()::newUser.runtimeType:${newUser.runtimeType}");
    fbUser = newUser;
//    _log.info("$runtimeType()::fbUser.runtimeType:${fbUser.runtimeType}");
//    _log.info("$runtimeType()::newUser::${newUser.toString()}");
    if (newUser != null) {
//      _log.info("$runtimeType()::newUser.uid::${newUser.uid}");
      _log.info("$runtimeType()::newUser.displayName::${newUser.displayName}");
//      _log.info("$runtimeType()::newUser.email::${newUser.email}");
      if (_userMetaMap != null) {
        _log.info("$runtimeType()::_userMetaMap::${_userMetaMap.toString()}");
//        learner = new Learner.fromMap(_log, _userDataMap);
        if (_userMetaMap.containsKey(newUser.uid)) {
          completeLearner();
        }
      }
      else {
        learner = new Learner.constructNewLearner(_log, newUser.uid, newUser.displayName, newUser.email);
        await getUserMeta();
        if (_userMetaMap.containsKey(newUser.uid)) { // They exist in the database.
          completeLearner();
        }
        else {

        }
      }

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
    if (selectedLanguage != null && selectedLanguage.isEmpty) { // First time picking; easy.
      // Set current language to the selected language.
      selectedLanguage = lang;
      // Get language metadata
      singleLangMeta = await getSingleLangMeta(lang);

      // Get the language data for the selected language.
      singleLangData = await getSingleLangData(lang);
//    }
//    else {
      learner.changeLang(lang); // This should handle all cases I care about...
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
