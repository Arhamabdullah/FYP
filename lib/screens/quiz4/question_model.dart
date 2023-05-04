class Question4 {
  final String questionText;
  final List<Answer4> answersList;

  Question4(this.questionText, this.answersList);
}

class Answer4 {
  final String answerText;
  final bool isCorrect;

  Answer4(this.answerText, this.isCorrect);
}

List<Question4> getQuestions4() {
  List<Question4> list = [];
  //ADD questions and answer here

  list.add(Question4(
    "Who is the owner of Flutter?",
    [
      Answer4("abc", false),
      Answer4("Samsung", false),
      Answer4("Google", true),
      Answer4("Apple", false),
    ],
  ));

  list.add(Question4(
    "Who owns Iphone?",
    [
      Answer4("Apple", true),
      Answer4("Microsoft", false),
      Answer4("Google", false),
      Answer4("Nokia", false),
    ],
  ));

  list.add(Question4(
    "Youtube is _________  platform?",
    [
      Answer4("Music Sharing", false),
      Answer4("Video Sharing", false),
      Answer4("Live Streaming", false),
      Answer4("All of the above", true),
    ],
  ));

  list.add(Question4(
    "Flutter user dart as a language?",
    [
      Answer4("True", true),
      Answer4("False", false),
    ],
  ));

  return list;
}
