class ListProductResponse {
  final dynamic id;
  final dynamic nama;
  final dynamic detail;
  final dynamic isActive;
  final dynamic rateProduk;
  final dynamic keteranganProduk;
  final dynamic tenor;
  final dynamic nilai_pinjaman_min;
  final dynamic nilai_pinjaman_max;
  final dynamic deskripsi;
  final dynamic image_deskripsi;
  final dynamic subtitle;

  ListProductResponse({
    required this.id,
    required this.nama,
    required this.detail,
    required this.isActive,
    required this.rateProduk,
    required this.keteranganProduk,
    required this.tenor,
    this.nilai_pinjaman_min,
    this.nilai_pinjaman_max,
    this.deskripsi,
    this.image_deskripsi,
    this.subtitle,
  });

  factory ListProductResponse.fromJson(Map<String, dynamic> json) {
    return ListProductResponse(
      id: json['id'],
      nama: json['nama'],
      detail: json['detail'],
      isActive: json['is_active'],
      rateProduk: json['rate_produk'],
      keteranganProduk: json['keterangan_produk'],
      tenor: json['tenor'],
      nilai_pinjaman_min: json['nilai_pinjaman_min'],
      nilai_pinjaman_max: json['nilai_pinjaman_max'],
      deskripsi: json['deskripsi'],
      image_deskripsi: json['image_deskripsi'],
      subtitle: json['subtitle'],
    );
  }
}