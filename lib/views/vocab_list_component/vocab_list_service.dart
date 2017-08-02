import 'dart:async';

import 'package:angular2/core.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class VocabListService {
//  List<String> mockVocabList = <String>[];
  Map<String, String> mockVocabMap = <String, String>{};
//  Future<List<String>> getVocabList() async => mockVocabList;
  Future<Map<String, String>> getVocabMap() async => mockVocabMap;
}
