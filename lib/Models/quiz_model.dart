class QuestionsResponseModel {
  QuestionsResponseModel({
    required this.status,
    required this.message,
    required this.questions,
  });

  final int status;
  final String message;
  final List<QuestionModel> questions;

  factory QuestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return QuestionsResponseModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      questions: json["questions"] == null
          ? []
          : List<QuestionModel>.from(
          json["questions"]!.map((x) => QuestionModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "questions": questions.map((x) => x.toJson()).toList(),
  };
}

class QuestionModel {
  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.createdAt,
    required this.v,
  });

  final String id;
  final String question;
  final List<OptionModel> options;
  final DateTime createdAt;
  final int v;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["_id"] ?? "",
      question: json["question"] ?? "",
      options: json["options"] == null
          ? []
          : List<OptionModel>.from(
          json["options"].map((x) => OptionModel.fromJson(x))),
      createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "question": question,
    "options": options.map((x) => x.toJson()).toList(),
    "createdAt": createdAt.toIso8601String(),
    "__v": v,
  };
}

class OptionModel {
  OptionModel({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  final String id;
  final String text;
  final bool isCorrect;

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json["_id"] ?? "",
      text: json["text"] ?? "",
      isCorrect: json["isCorrect"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "text": text,
    "isCorrect": isCorrect,
  };
}
