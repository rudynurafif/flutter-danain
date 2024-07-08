class FaqResponse {
  final dynamic id_faq;
  final String keterangan;
  final dynamic isActive;

  FaqResponse({
    required this.id_faq,
    required this.keterangan,
    required this.isActive,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      id_faq: json['id_faq'] ?? 0,
      keterangan: json['keterangan'] ?? '',
      isActive: json['isActive'] ?? 0,
    );
  }
}

class FaqResponse2 {
  final dynamic id_bantuan;
  final String judul_bantuan;
  final dynamic isActive;
  final String image;
  final List<dynamic> fa_bantuan_pertanyaan;

  FaqResponse2({
    required this.id_bantuan,
    required this.judul_bantuan,
    required this.isActive,
    required this.image,
    required this.fa_bantuan_pertanyaan,
  });

  factory FaqResponse2.fromJson(Map<String, dynamic> json) {
    return FaqResponse2(
      id_bantuan: json['id_bantuan'] ?? 0,
      judul_bantuan: json['judul_bantuan'] ?? '',
      isActive: json['isActive'] ?? 0,
      image: json['image'] ?? '',
      fa_bantuan_pertanyaan: json['fa_bantuan_pertanyaan'] ?? []
    );
  }
}
