class ProcessPinjamanResponse {
  final Map<String, dynamic> response;
  const ProcessPinjamanResponse({required this.response});

  Map<String, dynamic> data() {
    return {
      'id_pinjaman': response['id_pinjaman'],
      'nilai_pinjaman': response['nilai_pinjaman'],
      'rekening': {
        'no_rek': response['rekening']['no_rek'],
        'bank': response['rekening']['bank'],
        'no_atm': response['rekening']['no_atm'],
        'nama_pemilik': response['rekening']['nama_pemilik']
      },
      '': response[''],
      'total_pencairan': response['total_pencairan'],
      'waktu_pengajuan': response['waktu_pengajuan']
    };
  }
}
