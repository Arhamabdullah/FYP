class Question2 {
  final String questionText;
  final List<Answer2> answersList;

  Question2(this.questionText, this.answersList);
}

class Answer2 {
  final String answerText;
  final bool isCorrect;

  Answer2(this.answerText, this.isCorrect);
}

List<Question2> getQuestions2() {
  List<Question2> list = [];
  //ADD questions and answer here

  list.add(Question2(
    "Who is the owner of symbian?",
    [
      Answer2("Nokia", true),
      Answer2("Samsung", false),
      Answer2("Google", false),
      Answer2("Apple", false),
    ],
  ));

  list.add(Question2(
    "Who owns Iphone?",
    [
      Answer2("Apple", true),
      Answer2("Microsoft", false),
      Answer2("Google", false),
      Answer2("Nokia", false),
    ],
  ));

  list.add(Question2(
    "Youtube is _________  platform?",
    [
      Answer2("Music Sharing", false),
      Answer2("Video Sharing", false),
      Answer2("Live Streaming", false),
      Answer2("All of the above", true),
    ],
  ));

  list.add(Question2(
    "Flutter user dart as a language?",
    [
      Answer2("True", true),
      Answer2("False", false),
    ],
  ));

  return list;
}
