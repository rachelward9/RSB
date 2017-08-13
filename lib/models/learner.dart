
class Learner {
  final String name;
  final String email;
//  int numLanguages; // Does this matter? Probably not.

  // Custom vocabulary list creatable by the user.
  // Map<LanguageName, Map<word, definition>>
  Map<String, Map<String, String>> myVocabLists = {};

  List<String> myLanguages = [];
  String currentLanguage = "";
  Map<String, String> currentVocabList = {};

  // Should all arguments be optional? Guest accounts, etc?
  Learner(this.name, this.email, [this.myVocabLists, this.myLanguages, this.currentLanguage]) {
    if (currentLanguage != "") {
      currentVocabList = myVocabLists[currentLanguage];
    }
  }

  Learner.fromMap(Map map) : this(map["name"], map["email"], map["myVocabLists"], map["myLanguage"], map["currentLanguage"]);

  Map toMap() => {
    "name": name,
    "email": email,
    "currentLanguage": currentLanguage,
    "myVocabLists": myVocabLists,
    "myLanguages": myLanguages
  };

  void changeLang(String newLang) {
    currentVocabList.forEach((String word, String def) {
//      vocabLists[currentLanguage].putIfAbsent(word, () => def);
      myVocabLists[currentLanguage][word] = def; // Same?
    });
//    // Does this do the above?
//    vocabLists[currentLanguage] = currentVocabList;
    currentLanguage = newLang;
    currentVocabList = myVocabLists[newLang];
  }

  void addWord(String newWord, [String newDef = ""]) {
    currentVocabList[newWord] = newDef;
  }

  void removeWord(String oldWord) {
    currentVocabList.remove(oldWord);
  }

}