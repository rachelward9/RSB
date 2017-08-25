import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;

//import 'package:firebase/src/assets/assets.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/models/learner.dart';

@Injectable()
class FirebaseService {// implements OnInit {
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
  firebase.DatabaseReference fbVocabListData;
  firebase.DatabaseReference fbVocabListMeta;
  firebase.StorageReference userStorage; // Unnecessary?

  firebase.User fbUser;
  Learner learner;

  /* Users info */
  Map _userDataMap = {};
  Map _userMetaMap = {};

  Map _singleUserData = {};
  Map _singleUserMeta = {};

  // For debug only, really.
  Map get udm => _userDataMap;
  Map get umm => _userMetaMap;
  Map get sud => _singleUserData;
  Map get sum => _singleUserMeta;

  /* Languages info */
  String selectedLanguage = "";
  Map<String, String> vocabMeta = {};
  Map<String, Map<String, Map<String, String>>> allUsersVocabLists = {};
  Map<String, Map<String, String>> singleUsersVocabLists = {};
//  bool hasLanguage = false;
//  Map tempData = {};
  Map allLangMeta = {};
  Map singleLangMeta = {};
  List<String> languages = [];
  Map<String,Map<String, Map<String, Map<String, dynamic>>>> fullLanguageData = {};
  Map<String, Map<String, Map<String, dynamic>>> singleLangData = {};

  FirebaseService(LoggerService this._log) {
    _log.info("$runtimeType()::defaultConstructor()");
    firebase.initializeApp(
        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: "gs://langstudbud.appspot.com/"
    );

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    _fbDatabase = firebase.database();
    fbUserMeta = _fbDatabase.ref("usermeta");
    fbUserData = _fbDatabase.ref("userdata");
    fbLangList = _fbDatabase.ref("languagesList");
    fbLangData = _fbDatabase.ref("languagesData");
    fbLangMeta = _fbDatabase.ref("languagesMeta");
    fbVocabListData = _fbDatabase.ref("vocabLists");
    fbVocabListMeta = _fbDatabase.ref("vocabMeta");
//    fbStorageRoot = _fbStorage.ref("/");  // Unnecessary?

    fbLangList.onValue.listen((firebase.QueryEvent lList) async {
//      _log.info("$runtimeType()::defaultConstructor()::fbLang.onValue.listen...");
      languages = await lList.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::language list: ${languages}");
    });

    fbUserMeta.onValue.listen((firebase.QueryEvent uMeta) async {
      _userMetaMap = await uMeta.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::_userMetaMap::${_userMetaMap}");
    });

    fbLangMeta.onValue.listen((firebase.QueryEvent lMeta) async {
      allLangMeta = await lMeta.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::allLangMeta: ${allLangMeta.toString()}");
    });

    fbUserData.onValue.listen((firebase.QueryEvent uData) async {
      _userDataMap = await uData.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::user data: ${_userDataMap.toString()}");
    });

    fbLangData.onValue.listen((firebase.QueryEvent lData) async {
      fullLanguageData = await lData.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::allLangData: ${fullLanguageData.toString()}");
    });

    fbVocabListMeta.onValue.listen((firebase.QueryEvent vMeta) async {
      vocabMeta = await vMeta.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::vocabMeta: ${vocabMeta.toString()}");
    });

//    await getUserMeta();
//    await getAllLangMeta();
//    await getLangList();
//    await getVocabMeta();
//    await getAllLangData(); // Necessary?
  }

  /*** Try to simplify initialization, write functions to get all da shits. ***/

  ///todo: Make all firebase function synchronous, with asynchronous bits inside them. (So they don't return futures!)
//  Future<bool>
  bool isUserInDatabase(String userID) { // async {
    _log.info("$runtimeType()::isUserInDatabase()");
    bool isUserInDB = false;
    if (_userMetaMap == null || _userMetaMap.isEmpty) {
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
        if (e.snapshot.exists()) {
          _userMetaMap = await e.snapshot.val();
          _log.info("$runtimeType()::_userMetaMap.onValue.listen::${e.snapshot.val().toString()}");
        }
      });
    }
    if (_userMetaMap.containsKey(userID)) {
      _log.info("$runtimeType()::isUserInDatabase():: -- true");
      isUserInDB = true;
    }
    else {
      _log.info("$runtimeType()::isUserInDatabase():: -- false");
    }
    return isUserInDB;
  }

//  Future<Map>
  Map getUserMeta() { // async {
    _log.info("$runtimeType()::getUserMeta()");
    if (_userMetaMap == null || _userMetaMap.isEmpty) {
      ///todo: Are two async calls necessary?
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
//        if (e.snapshot.exists()) {
//          _log.info("$runtimeType()::getUserMeta()::e.snapshot.exists() == true!");
          _userMetaMap = await e.snapshot.val();
          _log.info("$runtimeType()::getUserMeta()::e.snapshot.val(): ${e.snapshot.val()}");
//        }
//        else {
//          _log.info("$runtimeType()::getUserMeta()::e.snapshot.exists() == false!");
//        }
      });
    }
    return _userMetaMap;
  }

//  Future<Map>
  Map _getAllUserData() { // async {
    _log.info("$runtimeType()::_getAllUserData()");
    if (_userDataMap == null || _userDataMap.isEmpty) {
      fbUserData.onValue.listen((firebase.QueryEvent e) async {
//        if (e.snapshot.exists()) {
          _userDataMap = await e.snapshot.val();
          _log.info("$runtimeType()::_getAllUserData()::_userDataMap.onValue.listen::${e.snapshot.val()}");
//        }
      });
    }
    return _userDataMap;
  }

  //  Future<Map>
  Map getSingleUserData(String userID) { // async {
    _log.info("$runtimeType()::getSingleUserData()");
    try {
      fbSingUserData = _fbDatabase.ref("$USER_DATA/$userID");
      fbSingUserData.onValue.listen((firebase.QueryEvent e) async {
        _singleUserData = await e.snapshot.val();
      });
    }
    catch (er) {
      _log.info("$runtimeType()::getSingleUserData()::error -- $er");
      _log.info("$runtimeType()::getSingleUserData()::userData not present in database!");
      _singleUserData = {};
    }
    return _singleUserData;
  }

  //  Future<Map>
  Map getSingleUserMeta(String userID) { // async {
    _log.info("$runtimeType()::getSingleUserMeta()");
    try {
      fbSingUserMeta = _fbDatabase.ref("$USER_META/$userID");
      fbSingUserMeta.onValue.listen((firebase.QueryEvent e) async {
        _singleUserMeta = await e.snapshot.val();
      });
    }
    catch (er) {
      _log.info("$runtimeType()::getSingleUserMeta()::error -- $er");
      _log.info("$runtimeType()::getSingleUserMeta()::userMeta not present in database!");
      _singleUserMeta = {};
    }
    return _singleUserData;
  }

//  Future<Map<String, Map<String, String>>>
  Map<String, Map<String, String>> getAllLangMeta() { // async {
    _log.info("$runtimeType()::getAllLangMeta()");
    if (allLangMeta == null || allLangMeta.isEmpty) {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        allLangMeta = await e.snapshot.val();
        _log.info("$runtimeType()::languageMeta.onValue.listen::${e.snapshot.val()}");
      });
    }
    return allLangMeta;
  }

//  Future<Map<String, String>>
  Map<String, String> getSingleLangMeta(String lang) { // async {
    _log.info("$runtimeType()::getSingleLangMeta($lang)");
    if (allLangMeta != null && allLangMeta.isNotEmpty) {
      singleLangMeta = allLangMeta[lang];
    }
    else {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        allLangMeta = await e.snapshot.val();
        _log.info("$runtimeType()::getSingleLangMeta():: allLangMeta = ${allLangMeta}");
        singleLangMeta = allLangMeta[lang];
        _log.info("$runtimeType()::getSingleLangMeta()::singLangMeta = ${singleLangMeta}");
      });
    }
    return singleLangMeta;
  }

//  Future<Map<String,Map<String, Map<String, Map<String, dynamic>>>>>
  Map<String,Map<String, Map<String, Map<String, dynamic>>>> getAllLangData() { // async {
    _log.info("$runtimeType()::getAllLangData()");
    if (fullLanguageData == null || fullLanguageData.isEmpty) {
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        fullLanguageData = await e.snapshot.val();
        _log.info("$runtimeType()::fullLanguageData::${fullLanguageData}");
      });
    }
    return fullLanguageData;
  }

//  Future<Map<String, Map<String, Map<String, dynamic>>>>
  Map<String, Map<String, Map<String, dynamic>>> getSingleLangData(String lang) { // async {
    _log.info("$runtimeType()::getSingleLangData($lang)");
    if (fullLanguageData != null && fullLanguageData.isNotEmpty) {
      singleLangData = fullLanguageData[lang];
    }
    else {
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        fullLanguageData = await e.snapshot.val();
        singleLangData = fullLanguageData[lang];
        _log.info("$runtimeType()::getSingleLangData()::singleLangData = ${singleLangData}");
      });
    }
    return singleLangData;
  }


//  Future<List>
  List<String> getLangList() { //async {
    _log.info("$runtimeType()::getLangList()");
    if (languages != null && languages.isNotEmpty) {
      _log.info("$runtimeType()::getLangList()::languages are: ${languages}");
      return languages;
    }
    else {
      fbLangList.onValue.listen((firebase.QueryEvent e) async {
        languages = await e.snapshot.val();
        _log.info("$runtimeType()::languages::${languages}");
        selectedLanguage = languages[0];
      });
      return languages;
    }
  }

//  // I think this will not be used.
//  Future<firebase.StorageReference> getUserStorage(String userID) async {
//    _log.info("$runtimeType()::getUserStorage()");
////    if (_userMetaMap.containsKey(userID) ) {
//    bool isThere = await isUserInDatabase(userID);
//    if (isThere) { // == true)  {
//      _log.info("$userID exists as user storage!");
//    }
//    else {
//      _log.info("$userID does not already exist in storage. Will this create a new bucket?");
//    }
//    ///todo: Will this create a new storage bucket for user if not present?
//    userStorage = await _fbStorage.ref("/$userID");
//
//    return userStorage;
//  }

//  Future<Map<String, String>>
  Map<String, String> getVocabMeta() { //async {
    _log.info("$runtimeType()::getVocabMeta()");
    if (vocabMeta == null || vocabMeta.isEmpty) {
      fbVocabListMeta.onValue.listen((firebase.QueryEvent e) async {
        vocabMeta = await e.snapshot.val();
      });
    }
    return vocabMeta;
  }

//  Future<Map<String,Map<String,String>>>
  Map<String,Map<String,String>> getVocabLists(String userID) { //async {
    _log.info("$runtimeType()::getVocabLists");
    if (allUsersVocabLists == null || allUsersVocabLists.isEmpty) {
      fbVocabListData.onValue.listen((firebase.QueryEvent e) async {
        allUsersVocabLists = await e.snapshot.val();
        _log.info("$runtimeType()::vocabList.onValue.listen::${allUsersVocabLists}");
      });
    }
    if (allUsersVocabLists.containsKey(userID)) {
      singleUsersVocabLists = allUsersVocabLists[userID];
      _log.info("$runtimeType()::getVocabLists():: singleUsersVocabLists = ${singleUsersVocabLists}");
    }
    return singleUsersVocabLists;
  }

  /*** } // end FirebaseService() constructor. ***/


//  Future<Null>
  void completeLearner() { //async {
    _log.info("$runtimeType()::completeLearner()");
    if (learner == null) {
      _log.info("$runtimeType()::completeLearner()::learner is null!");
      getSingleUserData(fbUser.uid);

      _log.info("$runtimeType()::completeLearner()::singleUserData for ${fbUser.uid} is $_singleUserData");
      learner = new Learner.fromMap(_log, _singleUserData);

//      if (_singleUserData == null || _singleUserData.isEmpty) {
//        try {
//          fbSingUserData = _fbDatabase.ref("$USER_DATA/${learner.uid}");
//          fbSingUserData.onValue.listen((firebase.QueryEvent e) async {
//            _singleUserData = await e.snapshot.val();
//          });
//          learner = new Learner.fromMap(_log, _singleUserData);
//        }
//        catch (er) {
//          _log.info("$runtimeType()::completeLearner()::error -- $er");
//          _log.info("$runtimeType()::completeLearner()::userData not present in database!");
//          _singleUserData = {};
//          learner = new Learner.constructNewLearner(_log, learner.uid, learner.name, learner.email);
//        }
//      }
//      learner = new Learner.fromMap(_log, _singleUserData);
    }
    else {
      try {
        _log.info("$runtimeType()::completeLearner()::learner is not null, attempting new Learner.fromMap!");
        getSingleUserData(fbUser.uid);
         learner = new Learner.fromMap(_log, _singleUserData);
        getSingleUserData(fbUser.uid);
        getVocabLists(fbUser.uid);
      }
      catch (e) {
        _log.info("$runtimeType()::completeLearner():: Error: $e");
      }
//      try {
//        _singleUserMeta = await getSingleUserMeta(learner.uid);
//        _log.info("$runtimeType()::completeLearner()::_singleUserMeta: ${_singleUserMeta}");
//      }
//      catch (er) {
//        _log.info("$runtimeType()::completeLearner()::userMeta::error::--$er");
//      }
//      try {
//        _singleUserData = await getSingleUserData(learner.uid);
//        _log.info("$runtimeType()::completeLearner()::_singleUserData: ${_singleUserData}");
//      }
//      catch (er) {
//        _log.info("$runtimeType()::completeLearner()::userData::error::--$er");
//      }
//      if (_singleUserMeta["myLanguages"] == null || _singleUserMeta["myLanguages"].isEmpty) {
//        _log.info('$runtimeType()::completeLearner()::_singleUserMeta["myLanguages"] is null or empty!');
//        _singleUserMeta = await getSingleUserMeta(fbUser.uid);
//        _singleUserData = await getSingleUserData(fbUser.uid);
//      }
//        learner.myLanguages = _singleUserMeta["myLanguages"].values();
//        if (selectedLanguage == null || selectedLanguage.isEmpty) {
//          if (learner.currentLanguage == null || learner.currentLanguage.isEmpty) {
//            learner.currentLanguage = learner.myLanguages[0];
//          }
//          selectedLanguage = learner.currentLanguage;
//        }
//        _log.info("$runtimeType()::myLanguages: ${learner.myLanguages}");
////      }
    }
    ///todo: finish this.
    ///todo: pass in values to all components, like <noun-view [someData]="passed-in-data"></noun-view>
  }

  _authChanged(firebase.User newUser) {
    _log.info("$runtimeType()::_authChanged()");
    fbUser = newUser;
    _log.info("$runtimeType()::_authChanged()::fbUser = newUser: ${fbUser.toString()} = ${newUser.toString()}");
    if (newUser != null) { // newUser will be null on a logout()
//      learner = new Learner.constructNewLearner(_log, newUser.uid, newUser.displayName, newUser.email);
//      _log.info("$runtimeType()::_authChanged()::learner uid: ${learner.uid}");
      _userMetaMap = getUserMeta();
      _log.info("$runtimeType()::_authChanged()::attempting to complete learner!");
      completeLearner();
//      _userMetaMap = await getUserMeta();
//      getUserMeta().then((Map newMap) {
//        _userMetaMap = newMap;
//        _log.info("$runtimeType()::_authChanged()::getUserMeta().then():: ${_userMetaMap}");
//      });
      _log.info("$runtimeType()::_authChanged()::after await getUserMeta(): ${_userMetaMap}");
      if (_userMetaMap.containsKey(newUser.uid)) {
        _log.info("$runtimeType()::_authChanged()::_userMetaMap.containsKey(${newUser.uid}) == true");
        completeLearner();
      }
      else {
        _log.info("$runtimeType()::_authChanged()::_userMetaMap does not contain key ${newUser.uid}!");
      }
    }
//    _log.info("$runtimeType()::fbUser.runtimeType:${fbUser.runtimeType}");
//    _log.info("$runtimeType()::newUser::${newUser.toString()}");
//    if (newUser != null) {
////      _log.info("$runtimeType()::newUser.uid::${newUser.uid}");
//      _log.info("$runtimeType()::newUser.displayName::${newUser.displayName}");
////      _log.info("$runtimeType()::newUser.email::${newUser.email}");
//      if (_userMetaMap != null) {
//        _log.info("$runtimeType()::_userMetaMap::${_userMetaMap.toString()}");
////        learner = new Learner.fromMap(_log, _userDataMap);
//        if (_userMetaMap.containsKey(newUser.uid)) {
//          completeLearner();
//        }
//      }
//      else {
////        learner = new Learner.constructNewLearner(_log, newUser.uid, newUser.displayName, newUser.email);
//        await getUserMeta();
//        if (_userMetaMap.containsKey(newUser.uid)) { // They exist in the database.
//          completeLearner();
//        }
//        else {
//
//        }
//      }
//
//    }
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

  void changeLang(String lang) {
    _log.info("$runtimeType()::changeLang($lang)");
    if (selectedLanguage != null && selectedLanguage.isEmpty) { // First time picking; easy.
      // Set current language to the selected language.
      selectedLanguage = lang;
      // Get language metadata
      singleLangMeta = getSingleLangMeta(lang);

      // Get the language data for the selected language.
      singleLangData = getSingleLangData(lang);
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
