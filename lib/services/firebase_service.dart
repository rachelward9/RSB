
import 'dart:html';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';



@Injectable()
class FirebaseService {
  firebase.Auth _fbAuth;
  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Database _fbDatabase;
  firebase.Storage _fbStorage;
  firebase.DatabaseReference _fbRefMessages;

  FirebaseService() {
    firebase.initializeApp(
      apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: ""
    );
  }
}
