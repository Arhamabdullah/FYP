class Question5 {
  final String questionText;
  final List<Answer5> answersList;

  Question5(this.questionText, this.answersList);
}

class Answer5 {
  final String answerText;
  final bool isCorrect;

  Answer5(this.answerText, this.isCorrect);
}

List<Question5> getQuestions5() {
  List<Question5> list = [];
  //ADD questions and answer here

  list.add(Question5(
    "Who is the owner of Flutter?",
    [
      Answer5("xyz", false),
      Answer5("Samsung", false),
      Answer5("Google", true),
      Answer5("Apple", false),
    ],
  ));

  list.add(Question5(
    "Who owns Iphone?",
    [
      Answer5("Apple", true),
      Answer5("Microsoft", false),
      Answer5("Google", false),
      Answer5("Nokia", false),
    ],
  ));

  list.add(Question5(
    "Youtube is _________  platform?",
    [
      Answer5("Music Sharing", false),
      Answer5("Video Sharing", false),
      Answer5("Live Streaming", false),
      Answer5("All of the above", true),
    ],
  ));

  list.add(Question5(
    "Flutter user dart as a language?",
    [
      Answer5("True", true),
      Answer5("False", false),
    ],
  ));

  return list;
}
