class QAEntry {
  final String id;
  final String collegeId;
  final List<QuestionItem> questions;

  QAEntry({required this.id, required this.collegeId, required this.questions});

  factory QAEntry.fromMap(Map<String, dynamic> map) {
    return QAEntry(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      questions: List<QuestionItem>.from(
        (map['questions'] ?? []).map((q) => QuestionItem.fromMap(q)),
      ),
    );
  }
}

class QuestionItem {
  final String question;
  final String answer;
  final String user;
  final DateTime createdAt;

  QuestionItem({
    required this.question,
    required this.answer,
    required this.user,
    required this.createdAt,
  });

  factory QuestionItem.fromMap(Map<String, dynamic> map) {
    return QuestionItem(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      user: map['user'] ?? 'Anonymous',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
