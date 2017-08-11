import 'dart:async';

import 'package:angular2/core.dart';

/// Mock service emulating access to a noun declensions list stored on a server.
@Injectable()
class NounService {
  // Get the nouns map of lists from the database.
  Map mockNounMap; // = <Map>[];
//  Future<List<String>> getVocabList() async => mockVocabList;
  Future<Map<String, List<Map<String, dynamic>>>> getNounMap() async => mockNounMap;
//  Future<Map<String, String>> getNounMap() async => mockNounMap;
}
