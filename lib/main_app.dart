// Copyright (c) 2017, MrPin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import '../../todo_list/todo_list_component.dart';
import 'views/vocab_view/vocab_view.dart';
import 'views/vocab_list_component/vocab_list_component.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'main-app',
  styleUrls: const ['main_app.css'],
  templateUrl: 'main_app.html',
  directives: const [materialDirectives, VocabListComponent, VocabView], //TodoListComponent
  providers: const [materialProviders],
)

class MainApp {
  // Nothing here yet. All logic is in TodoListComponent.
}
