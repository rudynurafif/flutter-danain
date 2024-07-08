class DetailPendanaan {
  final Detail detail;
  final SkemaPendanaan skemaPendanaan;
  final Agunan agunan;
  final InformasiPeminjam informasiPeminjam;

  DetailPendanaan({
    required this.detail,
    required this.skemaPendanaan,
    required this.agunan,
    required this.informasiPeminjam,
  });

  factory DetailPendanaan.fromJson(Map<String, dynamic> json) {
    return DetailPendanaan(
      detail: Detail.fromJson(json['detail']),
      skemaPendanaan: SkemaPendanaan.fromJson(json['skemaPendanaan']),
      agunan: Agunan.fromJson(json['agunan']),
      informasiPeminjam: InformasiPeminjam.fromJson(json['informasiPeminjam']),
    );
  }
}

class Detail {
  final num idAgreement;
  final num idPengajuan;
  final String noPengajuan;
  final num pokokHutang;
  final num tenor;
  final num ratePendana;
  final String status;
  final String namaProduk;
  final String img;
  final String keterangan;
  final List<AngsuranDetail> angsuranDetail;
  final num bungaHutang;
  final String tujuan;
  final num angsuran;

  Detail({
    required this.idAgreement,
    required this.idPengajuan,
    required this.noPengajuan,
    required this.pokokHutang,
    required this.tenor,
    required this.ratePendana,
    required this.status,
    required this.namaProduk,
    required this.img,
    required this.keterangan,
    required this.angsuranDetail,
    required this.bungaHutang,
    required this.tujuan,
    required this.angsuran,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      idAgreement: json['idAgreement'],
      idPengajuan: json['idPengajuan'],
      noPengajuan: json['noPengajuan'],
      pokokHutang: json['pokokHutang'],
      tenor: json['tenor'],
      ratePendana: json['ratePendana'],
      status: json['status'],
      namaProduk: json['namaProduk'],
      img: json['img'],
      keterangan: json['keterangan'],
      angsuranDetail:
          (json['angsuranDetail'] as List).map((i) => AngsuranDetail.fromJson(i)).toList(),
      bungaHutang: json['bungaHutang'],
      tujuan: json['tujuan'],
      angsuran: json['angsuran'],
    );
  }
}

class AngsuranDetail {
  final String tglJt;
  final num nourut;
  final num bungaHutang;
  final num saldoPinjam;
  final num pokok;
  final num angsuran;
  final num tglBayar;
  final num nilBayar;
  final num ovd;
  final num nilaiDenda;

  AngsuranDetail({
    required this.tglJt,
    required this.nourut,
    required this.bungaHutang,
    required this.saldoPinjam,
    required this.pokok,
    required this.angsuran,
    required this.tglBayar,
    required this.nilBayar,
    required this.ovd,
    required this.nilaiDenda,
  });

  factory AngsuranDetail.fromJson(Map<String, dynamic> json) {
    return AngsuranDetail(
      tglJt: json['tglJt'],
      nourut: json['nourut'],
      bungaHutang: json['bungaHutang'],
      saldoPinjam: json['saldoPinjam'],
      pokok: json['pokok'],
      angsuran: json['angsuran'],
      tglBayar: json['tglBayar'],
      nilBayar: json['nilBayar'],
      ovd: json['ovd'],
      nilaiDenda: json['nilaiDenda'],
    );
  }
}

class SkemaPendanaan {
  final String angsuranBunga;
  final String angsuranPokok;

  SkemaPendanaan({
    required this.angsuranBunga,
    required this.angsuranPokok,
  });

  factory SkemaPendanaan.fromJson(Map<String, dynamic> json) {
    return SkemaPendanaan(
      angsuranBunga: json['angsuranBunga'],
      angsuranPokok: json['angsuranPokok'],
    );
  }
}

class Agunan {
  final String cc;
  final DataCabang dataCabang;
  final String img;
  final String jenisKendaraan;
  final String keterangan;
  final String kondisi;
  final String namaKendaraan;
  final String tahun;
  final String type;

  Agunan({
    required this.cc,
    required this.dataCabang,
    required this.img,
    required this.jenisKendaraan,
    required this.keterangan,
    required this.kondisi,
    required this.namaKendaraan,
    required this.tahun,
    required this.type,
  });

  factory Agunan.fromJson(Map<String, dynamic> json) {
    return Agunan(
      cc: json['cc'],
      dataCabang: DataCabang.fromJson(json['dataCabang']),
      img: json['img'],
      jenisKendaraan: json['jenisKendaraan'],
      keterangan: json['keterangan'],
      kondisi: json['kondisi'],
      namaKendaraan: json['namaKendaraan'],
      tahun: json['tahun'],
      type: json['type'],
    );
  }
}

class DataCabang {
  final String alamat;
  final String keterangan;
  final String namaCabang;

  DataCabang({
    required this.alamat,
    required this.keterangan,
    required this.namaCabang,
  });

  factory DataCabang.fromJson(Map<String, dynamic> json) {
    return DataCabang(
      alamat: json['alamat'],
      keterangan: json['keterangan'],
      namaCabang: json['namaCabang'],
    );
  }
}

class InformasiPeminjam {
  final num idBorrower;
  final String namaBorrower;
  final String kreditSkor;

  InformasiPeminjam({
    required this.idBorrower,
    required this.namaBorrower,
    required this.kreditSkor,
  });

  factory InformasiPeminjam.fromJson(Map<String, dynamic> json) {
    return InformasiPeminjam(
      idBorrower: json['id_borrower'],
      namaBorrower: json['nama_borrower'],
      kreditSkor: json['kredit_skor'],
    );
  }
}
