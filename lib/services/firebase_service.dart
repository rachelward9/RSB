
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
  firebase.DatabaseReference fbUserList;
  firebase.DatabaseReference fbLangList; // = database.ref("test");
  firebase.DatabaseReference fbLangData;
  firebase.DatabaseReference fbLangMeta;
  firebase.User fbUser;

  Learner learner = new Learner();

  String selectedLanguage = "";
  Map<String, String> tempMap = {};
  List<String> languages = [];

//  Map<String, Map> allLangData = {};
  // Map<langName, Map<grammerCat, List<Map<grammerThing, example>>>>
  Map<String, Map<String, List<Map<String, String>>>> languageData = {};

  FirebaseService(LoggerService this._log) {
    _log.info("$runtimeType()");
    firebase.initializeApp(
        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: "gs://langstudbud.appspot.com/");

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    _fbDatabase = firebase.database();
    fbUserMeta = _fbDatabase.ref("/usermeta");
    fbUserList = _fbDatabase.ref("/userdata");
    fbLangList = _fbDatabase.ref("/languagesList");
    fbLangData = _fbDatabase.ref("/languagesData");
    fbLangMeta = _fbDatabase.ref("/languagesMeta");

    fbUserList.onValue.listen((firebase.QueryEvent e) {
      if (e.snapshot.exists()) {
        _log.info("$runtimeType()::${e.snapshot.exportVal().toString()}");
      }
    });

    fbLangData.onValue.listen((firebase.QueryEvent e) {
      if (e.snapshot.exists()) {
        _log.info("$runtimeType()::${e.snapshot.exportVal().toString()}");
        ///todo: OH SHIT IT'S WORKING!!!!
      }
      else {
        _log.info("$runtimeType()::fbLangData snapshot empty!");
      }
    });

    fbLangList.onValue.listen((firebase.QueryEvent e) {
      if (e.snapshot.exists()) {
        _log.info("$runtimeType()::${e.snapshot.exportVal().toString()}");
        tempMap = e.snapshot.exportVal();
        tempMap.forEach((String notUsed, String lang) {
          _log.info("Adding language $lang");
//          _log.info("What value is this... $notUsed");
          languages.add(lang);
        });
        selectedLanguage = languages[0];
      }
      else {
        _log.info("$runtimeType()::fbLangList snapshot empty!");
      }
    });
  }

  void _authChanged(firebase.User newUser) {
    fbUser = newUser;
    learner = new Learner();
    if (newUser != null) {
      learner.constructLearner(newUser.displayName, newUser.email);
    }
//    fbUser = newUser;
    //    if (_fbUserList.)
//    Learner newLearner = new Learner(newUser.displayName, newUser.email);
  }

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

//  void _newMessage(firebase.QueryEvent event) {
////    Message msg = new Message.fromMap(event.snapshot.val());
////    Message.add(msg);
//
////    print(msg.text);
//  }



  _registerUser(String email, String password) {
//    if (email.isNotEmpty && password.isNotEmpty) {
//      _fbAuth.createUserWithEmailAndPassword(email, password);
//
//    }
  }
}
