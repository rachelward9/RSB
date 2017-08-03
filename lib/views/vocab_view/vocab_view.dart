
//import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/vocab_list_service.dart';
import 'package:angular_components/angular_components.dart';
import '../vocab_list_component/vocab_list_component.dart';
//import 'package:angular_components/src/components/material_tab/material_tab_panel.dart';
//import 'package:angular_components/src/components/material_tab/material_tab.dart';
//import 'vocab_list_service.dart';

@Component(
  selector: 'vocab-view',
  styleUrls: const ['vocab_view.css'],
  templateUrl: 'vocab_view.html',
  directives: const [
    CORE_DIRECTIVES,
//    VocabListService,
    VocabListComponent,
    materialDirectives//,
//    TodoListComponent
  ],
  providers: const [
    materialProviders//,
//    VocabListService
  ],
)

class VocabView {

}
