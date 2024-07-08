class CalculateCicilanResponse {
  final Map<String, dynamic> angsuranPertama;
  final dynamic dpMurni;
  final List<Map<String, dynamic>> jadwalAngsuran;
  final double rate;
  final double rateAdmin;
  final List<Map<String, dynamic>> skemaPembayaran;
  final dynamic sukuBungaEfektif;
  final dynamic tanggalKontrak;
  final Map<String, dynamic> totalAngsuranBulanan;

  const CalculateCicilanResponse({
    required this.angsuranPertama,
    required this.dpMurni,
    required this.jadwalAngsuran,
    required this.rate,
    required this.rateAdmin,
    required this.skemaPembayaran,
    required this.sukuBungaEfektif,
    required this.tanggalKontrak,
    required this.totalAngsuranBulanan,
  });

  Map<String, dynamic> data() {
    return {
      'angsuranPertama': angsuranPertama,
      'dpMurni': dpMurni,
      'jadwalAngsuran': jadwalAngsuran,
      'rate': rate,
      'rateAdmin': rateAdmin,
      'skemaPembayaran': skemaPembayaran,
      'sukuBungaEfektif': sukuBungaEfektif,
      'tanggalKontrak': tanggalKontrak,
      'totalAngsuranBulanan': totalAngsuranBulanan
    };
  }
}
