class Question {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String question;
  final String? answer;
  final String? answeredBy;
  final DateTime? answeredAt;
  final DateTime createdAt;
  
  Question({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.question,
    this.answer,
    this.answeredBy,
    this.answeredAt,
    required this.createdAt,
  });
  
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name'] ?? json['user']['name'] ?? 'Anonymous',
      question: json['question'] ?? '',
      answer: json['answer'],
      answeredBy: json['answered_by'],
      answeredAt: json['answered_at'] != null 
          ? DateTime.parse(json['answered_at']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  
  bool get isAnswered => answer != null && answer!.isNotEmpty;
}