class Question3 {
  final String questionText;
  final List<Answer3> answersList;

  Question3(this.questionText, this.answersList);
}

class Answer3 {
  final String answerText;
  final bool isCorrect;

  Answer3(this.answerText, this.isCorrect);
}

List<Question3> getQuestions3() {
  List<Question3> list = [];
  //ADD questions and answer here

  list.add(Question3(
    "Who is the owner of Flutter?",
    [
      Answer3("lpc", false),
      Answer3("Samsung", false),
      Answer3("Google", true),
      Answer3("Apple", false),
    ],
  ));

  list.add(Question3(
    "Who owns Iphone?",
    [
      Answer3("Apple", true),
      Answer3("Microsoft", false),
      Answer3("Google", false),
      Answer3("Nokia", false),
    ],
  ));

  list.add(Question3(
    "Youtube is _________  platform?",
    [
      Answer3("Music Sharing", false),
      Answer3("Video Sharing", false),
      Answer3("Live Streaming", false),
      Answer3("All of the above", true),
    ],
  ));

  list.add(Question3(
    "Flutter user dart as a language?",
    [
      Answer3("True", true),
      Answer3("False", false),
    ],
  ));

  return list;
}
