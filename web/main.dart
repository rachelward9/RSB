// Copyright (c) 2017, MrPin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/platform/browser.dart';
//import 'dart:html';
//import 'dart:convert';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/main_app.dart';
import 'package:RSB/services/logger_service.dart';

const String APP_NAME = "RSB";
final LoggerService _log = new LoggerService(appName: APP_NAME);


main() { // async { // Added async
//
//  try {
//    firebase.initializeApp(
//        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
//        authDomain: "langstudbud.firebaseapp.com",
//        databaseURL: "https://langstudbud.firebaseio.com",
//        storageBucket: ""
//      //    projectId: "langstudbud",
////    messagingSenderId: "872996626564"
//    );
//    new AuthApp();
//  } on firebase.FirebaseJsNotLoadedException catch (e) {
//    print(e);
//  }
//
//  firebase.Database database = firebase.database();
//  firebase.DatabaseReference dbRef = database.ref("messages");
//
//  dbRef.onValue.listen((e) {
//    firebase.DataSnapshot dataSnapshot = e.snapshot;
//    // Do something with snapshot here.
//  });

  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log)
  ]);
}
//
//class AuthApp {
//  final firebase.Auth auth;
//  final FormElement registerForm;
//  final InputElement email, password;
//  final AnchorElement logout;
//  final TableElement authInfo;
//  final ParagraphElement error;
//  final ButtonElement verifyEmail;
//
//  AuthApp()
//    : this.auth = firebase.auth(),
//      this.email = querySelector("#email"),
//      this.password = querySelector("#password"),
//      this.authInfo = querySelector("#auth_info"),
//      this.error = querySelector("#register_form p"),
//      this.logout = querySelector("#logout_btn"),
//      this.registerForm = querySelector("#register_form"),
//      this.verifyEmail = querySelector("#verify_email") {
//    logout.onClick.listen((e) {
//      e.preventDefault();
//      auth.signOut();
//    });
//
//    this.registerForm.onSubmit.listen((e) {
//      e.preventDefault();
//      String emailValue = email.value.trim();
//      String passwordValue = password.value.trim();
//      _registerUser(emailValue, passwordValue);
//    });
//
//    // After opening
//    if (auth.currentUser != null) {
//      _setLayout(auth.currentUser);
//    }
//
//    // When auth state changes
//    auth.onAuthStateChanged.listen((e) => _setLayout(e));
//
//    verifyEmail.onClick.listen((e) async {
//      verifyEmail.disabled = true;
//      verifyEmail.text = "Sending verification email...";
//      await auth.currentUser.sendEmailVerification();
//      verifyEmail.text = "Verification email sent!";
//    });
//  }
//
//  _registerUser(String email, String password) async {
//    if (email.isNotEmpty && password.isNotEmpty) {
//      bool trySignin = false;
//      try {
//        await auth.createUserWithEmailAndPassword(email, password);
//      } on firebase.FirebaseError catch (e) {
//        if (e.code == "auth/email-already-in-use") {
//          trySignin = true;
//        }
//      } catch (e) {
//        error.text = e.toString();
//      }
//
//      if (trySignin) {
//        try {
//          await auth.signInWithEmailAndPassword(email, password);
//        } catch (e) {
//          error.text = e.toString();
//        }
//      }
//    } else {
//      error.text = "Please input correct email and password!";
//    }
//  }
//
//  void _setLayout(firebase.User user) {
//    if (user != null) {
//      registerForm.style.display = "none";
//      logout.style.display = "block";
//      email.value = "";
//      password.value = "";
//      error.text = "";
//      authInfo.style.display = "block";
//
//      var data = <String, dynamic>{
//        "email": user.email,
//        "emailVerified": user.emailVerified,
//        "isAnonymous": user.isAnonymous
//      };
//
//      data.forEach((k, v) {
//        if (v != null) {
//          var row = authInfo.addRow();
//
//          row.addCell()
//            ..text = k
//            ..classes.add("header");
//          row.addCell()
//            ..text = "$v";
//        }
//      });
//
//      print("User.toJson:");
//      print(const JsonEncoder.withIndent(' ').convert(user));
//
//      verifyEmail.style.display = user.emailVerified ? "none" : "block";
//    } else {
//      registerForm.style.display = "block";
//      authInfo.style.display = "none";
//      logout.style.display = "none";
//      verifyEmail.style.display = "none";
//      authInfo.children.clear();
//    }
//  } // end _setLayout
//
//}