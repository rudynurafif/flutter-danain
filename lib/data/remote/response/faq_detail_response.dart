class FaqDetailResponse {
  final dynamic id_faq_detail;
  final String question;
  final String answer;
  final String kategori;
  final List<dynamic>? tutor;

  FaqDetailResponse(
      {required this.id_faq_detail,
      required this.question,
      required this.answer,
      required this.kategori,
      this.tutor});

  factory FaqDetailResponse.fromJson(Map<String, dynamic> json) {
    return FaqDetailResponse(
      id_faq_detail: json['id_faq_detail'],
      question: json['question'],
      answer: json['answer'],
      kategori: json['ketegori'],
      tutor: json['tutor'] ?? null
    );
  }
}
