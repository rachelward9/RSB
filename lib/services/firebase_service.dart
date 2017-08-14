
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
  firebase.DatabaseReference _fbRef; // = database.ref("test");
  firebase.DatabaseReference _fbLangList; // = database.ref("test");
  firebase.DatabaseReference _fbUserList;

  Learner user;

  List<String> languages;

  FirebaseService(LoggerService this._log) {
    firebase.initializeApp(
        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: "gs://langstudbud.appspot.com/");

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    _fbDatabase = firebase.database();
//    _fbRef = _fbDatabase.ref(""); // What is my point of reference?
    _fbLangList = _fbDatabase.ref("languagesList");
    _fbUserList = _fbDatabase.ref("userdata");
  }

  void _authChanged(firebase.User newUser) {
    user = new Learner(newUser.displayName, newUser.email, newUser.uid);
    //    if (_fbUserList.)
//    Learner newLearner = new Learner(newUser.displayName, newUser.email);
  }

//  firebase.User user;


  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
    }
    catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }

  void signOut() {
    _fbAuth.signOut();
  }

  void _newMessage(firebase.QueryEvent event) {
//    Message msg = new Message.fromMap(event.snapshot.val());
//    Message.add(msg);

//    print(msg.text);
  }



  _registerUser(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      _fbAuth.createUserWithEmailAndPassword(email, password);
    }
  }
}
