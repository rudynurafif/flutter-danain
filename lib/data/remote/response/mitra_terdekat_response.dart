// ignore_for_file: non_constant_identifier_names

class MitraTerdekatResponse {
  final int id_branch;
  final int id_company;
  final String kode_branch;
  final String nama_branch;
  final String alamat_branch;
  final int id_kota;
  final int id_provinsi;
  final String kodepos_branch;
  final int is_active;
  final int is_jf;
  final int add_user;

  const MitraTerdekatResponse({
    required this.id_branch,
    required this.id_company,
    required this.kode_branch,
    required this.nama_branch,
    required this.alamat_branch,
    required this.id_kota,
    required this.id_provinsi,
    required this.kodepos_branch,
    required this.is_active,
    required this.is_jf,
    required this.add_user,
  });

  factory MitraTerdekatResponse.fromJson(Map<String, dynamic> json) {
    return MitraTerdekatResponse(
      id_branch: json['id_branch'],
      id_company: json['id_company'],
      kode_branch: json['kode_branch'],
      nama_branch: json['nama_branch'],
      alamat_branch: json['alamat_branch'],
      id_kota: json['id_kota'],
      id_provinsi: json['id_provinsi'],
      kodepos_branch: json['kodepos_branch'],
      is_active: json['is_active'],
      is_jf: json['is_jf'],
      add_user: json['add_user'],
    );
  }
}
