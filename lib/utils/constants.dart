import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static Constants get = Constants._();
  Color lenderColor = const Color(0xff28AF60);
  Color borrowerColor = const Color(0xff24663F);
  int idProdukCashDrive = 2;
  List<dynamic> tipeKendaraan = [
    {
      'idType': 1,
      'namaType': 'Tobrut tipe',
    },
    {
      'idType': 2,
      'namaType': 'Ceker babat tipe',
    },
  ];

  String errorServer = 'Saat ini aplikasi sedang mengalami gangguan';
  Map<String, dynamic> bankLender = {
    'idRekening': 1,
    'namaBank': 'BCA',
    'idBank': 1,
    'cabang': 'Jakarta Utara',
    'noRekening': '9090909',
    'anRekening': 'Muhammad Syamsul Arifin',
  };
  List<dynamic> merekKendaraan = [
    {
      'idMerek': 1,
      'namaMerek': 'Tobrut Merek',
    },
    {
      'idMerek': 2,
      'namaMerek': 'Ceker babat Merek',
    },
  ];
  List<dynamic> modelKendaraan = [
    {
      'idModel': 1,
      'namaModel': 'Tobrut model',
    },
    {
      'idModel': 2,
      'namaModel': 'Ceker babat model',
    },
  ];
  List<dynamic> wilayahList = [
    {
      'idWilayah': 1,
      'namaWilayah': '7F KP.Rambutan rumah pa azzam',
    },
    {
      'idWilayah': 2,
      'namaWilayah': '10 D Kp.Rambutan rumah pa azzam',
    },
  ];
  List<dynamic> anList = [
    {
      'idAn': 1,
      'keterangan': 'Milik Sendiri',
    },
    {
      'idAn': 2,
      'keterangan': 'Milik Pasangan',
    },
  ];
  List<dynamic> tenorList = [
    {
      'idTenor': 12,
      'tenor': 12,
    },
    // {
    //   'idTenor': 18,
    //   'tenor': 18,
    // },
    {
      'idTenor': 24,
      'tenor': 24,
    },
  ];

  List<dynamic> tahunKendaraan = [
    {
      'idTahunKendaraan': 1,
      'tahun': '2002',
    },
    {
      'idTahunKendaraan': 2,
      'tahun': '2012',
    },
    {
      'idTahunKendaraan': 3,
      'tahun': '2023',
    },
    {
      'idTahunKendaraan': 4,
      'tahun': '2024',
    },
  ];

  List<dynamic> peluangPendanaan = [
    {
      'noPp': '001/2312312312/BPKB',
      'idTaskPengajuan': 3,
      'image': 'assets/lender/portofolio/Car_1.png',
      'namaProduk': 'Cash & Drive',
      'idProduk': 2,
      'jumlahPendanaan': 100000000,
      'tenor': 12,
      'bunga': 10.4,
      'isPemula': true,
    },
    {
      'noPp': '001/2312312312/BPKB',
      'idTaskPengajuan': 4,
      'namaProduk': 'Cash & Drive',
      'image': 'assets/lender/portofolio/Car_1.png',
      'idProduk': 2,
      'jumlahPendanaan': 100000000,
      'tenor': 18,
      'bunga': 10.4,
      'isPemula': true,
    },
    {
      'noPp': '001/2312312312/BPKB',
      'idTaskPengajuan': 5,
      'namaProduk': 'Cash & Drive',
      'image': 'assets/lender/portofolio/Car_1.png',
      'idProduk': 2,
      'jumlahPendanaan': 100000000,
      'tenor': 24,
      'bunga': 10.4,
      'isPemula': true,
    },
  ];
  List<dynamic> infoPromo = [
    {
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/borrower-apk%2Ffile-2024-05-29-17-11-536d59eb7643574fb88b8ac558840d5e03.png?Expires=7716977513&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=GQqYU%2BIMjxLUof6vJSW065wKUys%3D',
      'navigate': 'https://www.youtube.com/',
      'isNavigateExternal': 1,
    },
    {
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/borrower-apk%2Ffile-2024-05-29-17-13-547f27360f0a174b63807a559781550f7e.png?Expires=7716977634&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=U7H9RjC5nGChnmcztpAQpEBHp7c%3D',
      'navigate': 'ajak-teman',
      'isNavigateExternal': 0,
    },
  ];

  List<Map<String, dynamic>> pendanaanFilter = [
    {
      'id': 'desc',
      'nama': 'Pendanaan Tertinggi',
    },
    {
      'id': 'asc',
      'nama': 'Pendanaan Terendah',
    },
    {
      'id': 'bunga',
      'nama': 'Bunga Tertinggi',
    },
  ];

  List<Map<String, dynamic>> listProduk = [
    {
      'idProduk': 4,
      'namaProduk': 'Maxi 150',
    },
    {
      'idProduk': 3,
      'namaProduk': 'Cash & Drive',
    },
  ];

  List<dynamic> portofoliLenderList = [
    {
      'idPendanaan': 1,
      'namaProduk': 'Cash n drive',
      'picture':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500001%2F52%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-24-15-41-329eeebdcea0b247b49fda0e7422de68ca.jpg?Expires=7716540092&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=u65plFjApCHz1tyik3OgK8gdxR8%3D',
      'noPerjanjianPinjaman': '1/adsda/231',
      'jumlahPendanaan': 100000,
      'tenor': 10,
      'bunga': 10.4,
      'status': 'Aktif',
      'date': '2024-08-31 15:30:00',
    },
    {
      'idPendanaan': 1,
      'namaProduk': 'Cash n drive',
      'picture':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500001%2F52%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-24-15-41-329eeebdcea0b247b49fda0e7422de68ca.jpg?Expires=7716540092&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=u65plFjApCHz1tyik3OgK8gdxR8%3D',
      'noPerjanjianPinjaman': '1/adsda/231',
      'jumlahPendanaan': 100000,
      'tenor': 10,
      'bunga': 10.38000,
      'status': 'Terlambat',
      'date': '2024-05-31 15:30:00',
    },
    {
      'idPendanaan': 1,
      'namaProduk': 'Cash n drive',
      'picture':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500001%2F52%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-24-15-41-329eeebdcea0b247b49fda0e7422de68ca.jpg?Expires=7716540092&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=u65plFjApCHz1tyik3OgK8gdxR8%3D',
      'noPerjanjianPinjaman': '1/adsda/231',
      'jumlahPendanaan': 100000,
      'tenor': 10,
      'bunga': 10.4,
      'status': 'Aktif',
      'date': '2024-05-31 15:30:00',
    },
  ];

  Map<String, dynamic> detailPorto = {
    'detail': {
      'idAgreement': 23,
      'idPengajuan': 141,
      'noPengajuan': '240500001',
      'pokokHutang': 12000000,
      'tenor': 12,
      'ratePendana': 12,
      'status': 'Konfirmasi',
      'namaProduk': 'Cash & Drive',
      'img':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500001%2F52%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-24-15-41-329eeebdcea0b247b49fda0e7422de68ca.jpg?Expires=7716540092&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=u65plFjApCHz1tyik3OgK8gdxR8%3D',
      'keterangan': 'Kendaraan_Tampak-Samping-Kanan',
      'detail': null,
      'angsuranDetail': [
        {
          'idAgreement': 5,
          'nourut': 1,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 2,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 3,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 4,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 5,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 6,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 7,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 8,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 9,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 10,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 11,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 12,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 13,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 14,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 15,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 16,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 17,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 18,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 19,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 20,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 21,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 22,
          'pokok': 200000000,
          'bunga': 112000000,
          'mitra': 833333.3333333334,
          'angsuran': 312833333.3333333,
          'created_At': '0001-01-01T00:00:00Z'
        },
        {
          'idAgreement': 5,
          'nourut': 23,
          'pokok': 200000000,
          'bunga': 112000000,
          'angsuran': 312833333.3333333,
          'mitra': 833333.3333333334,
        }
      ],
      'bungaHutang': 280000.00000000006,
      'tujuan': 'Produktif',
      'angsuran': 946666.6666666667,
      'potensiPengembalian': 1440000,
    },
    'skemaPendanaan': {
      'angsuranBunga': 'Bulanan',
      'angsuranPokok': 'Akhir Tenor',
      'tglMulai': '2024-05-31 15:30:00',
      'tglJatuhTemo': '2024-05-31 15:30:00',
      'telat': 10,
    },
    'agunanan': {
      'cc': '2000',
      'dataCabang': {
        'alamat': 'Jl. Paus No. 8 RT 02/07 Kel. Rawamangun, Kec. Pulogadung',
        'keterangan':
            'Perusahaan yang bertanggung jawab menyimpan agunan dan melakukan hak sebagai kreditur.',
        'namaCabang': 'GADAI MAS RAWAMANGUN'
      },
      'img':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500001%2F52%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-24-15-41-329eeebdcea0b247b49fda0e7422de68ca.jpg?Expires=7716540092&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=u65plFjApCHz1tyik3OgK8gdxR8%3D',
      'jenisKendaraan': 'Mobil',
      'keterangan': 'ok baiklah',
      'kondisi': 'Baik',
      'merek': 'Toyota',
      'model': 'New Avanza 2022',
      'namaKendaraan': 'Toyota - New Avanza 2022',
      'tahun': '2022',
      'type': 'Avanza'
    },
    'informasiPeminjam': {
      'id_borrower': 2,
      'nama_borrower': 'BORROWER DEV',
      'kredit_skor': 190,
    },
    'dokumen': {
      'dokumenPp':
          'https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf',
      'dokumenPenyaluran': 'https://www.buds.com.ua/images/Lorem_ipsum.pdf',
    },
    'riwayatPengembalian': {
      'totalPengembalian': 1000000,
      'pokoDanaDiterima': 10000000,
      'bungaDiterima': 10000000,
      'denda': 10000000,
      'outstanding': 10000000,
      'detail': [
        {
          'nourut': 1,
          'nominal': 10000,
          'isStatus': 1,
          'keterangan': 'Sudah Dibayar',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '2024-05-30 15:30:00',
          'bunga': 730000,
          'denda': 0,
          'total': 10000000000,
        },
        {
          'nourut': 2,
          'nominal': 10000,
          'isStatus': 3,
          'keterangan': 'Telat 3 hari',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '1-01-01T00:00:00',
          'bunga': 730000,
          'denda': 1000000,
          'total': 10000000000,
        },
        {
          'nourut': 3,
          'nominal': 10000,
          'isStatus': 0,
          'keterangan': 'Belum Dibayar',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '1-01-01T00:00:00',
          'bunga': 730000,
          'denda': 0,
          'total': 10000000000,
        },
        {
          'nourut': 4,
          'nominal': 10000,
          'isStatus': 0,
          'keterangan': 'Belum Dibayar',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '1-01-01T00:00:00',
          'bunga': 730000,
          'denda': 0,
          'total': 10000000000,
        },
        {
          'nourut': 5,
          'nominal': 10000,
          'isStatus': 0,
          'keterangan': 'Belum Dibayar',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '1-01-01T00:00:00',
          'bunga': 730000,
          'denda': 0,
          'total': 10000000000,
        },
        {
          'nourut': 6,
          'nominal': 10000,
          'isStatus': 0,
          'keterangan': 'Belum Dibayar',
          'jatuhTempo': '2024-05-31 15:30:00',
          'tanggalPembayaran': '1-01-01T00:00:00',
          'bunga': 730000,
          'denda': 0,
          'pokokDana': 100000,
          'total': 10000000000,
        },
      ]
    },
  };

  List<dynamic> tkbList = [
    {
      'tkb': 0,
      'chip': '79,06%',
      'subtitle':
          'TKB 0 adalah ukuran tingkat keberhasilan Penyelenggara dalam memfasilitasi penyelesaian kewajiban Pendanaan dalam jangka waktu sampai dengan 0 (nol) hari kalender terhitung sejak jatuh tempo.',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/asset-flutter-tkb%2Ffile-2024-07-01-19-39-02aa548fa85e9a4365b57ff064070703de.png?Expires=7719837542&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=3suwuJ5TrIQJbuY%2BUq8LPAgB0Zs%3D',
    },
    {
      'tkb': 30,
      'chip': '92,39%',
      'subtitle':
          'TKB 30 adalah ukuran tingkat keberhasilan Penyelenggara dalam memfasilitasi penyelesaian kewajiban Pendanaan dalam jangka waktu sampai dengan 30 (tiga puluh) hari kalender terhitung sejak jatuh tempo.',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/asset-flutter-tkb%2Ffile-2024-07-01-19-41-29dc27f77dd9f9458daec7c4d0e52244d6.png?Expires=7719837689&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=%2B%2BqY1dFKPADKvCmn0FNrGDKc1hY%3D',
    },
    {
      'tkb': 60,
      'chip': '94,36%',
      'subtitle':
          'TKB 60 adalah ukuran tingkat keberhasilan Penyelenggara dalam memfasilitasi penyelesaian kewajiban Pendanaan dalam jangka waktu sampai dengan 60 (enam puluh) hari kalender terhitung sejak jatuh tempo.',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/asset-flutter-tkb%2Ffile-2024-07-01-19-43-10d97511922e9941ed947b7f393a327d0e.png?Expires=7719837790&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=yNM9CizYNH%2B0SikZb0D87beCVMI%3D',
    },
    {
      'tkb': 90,
      'chip': '96,22%',
      'subtitle':
          'TKB 90 adalah ukuran tingkat keberhasilan Penyelenggara dalam memfasilitasi penyelesaian kewajiban Pendanaan dalam jangka waktu sampai dengan 90 (sembilan puluh) hari kalender terhitung sejak jatuh tempo.',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/asset-flutter-tkb%2Ffile-2024-07-01-19-45-271422e487cddd4e4bb7d455fdddb86971.png?Expires=7719837927&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=Kg0yWE%2BjLy8fiYkJeVaz6tjqaDo%3D',
    },
  ];

  Map<dynamic, dynamic> responseListPendanaan = {
    'responseCode': '200',
    'responseMessage': 'sukses',
    'responseTimestamp': '2024-05-30T14:17:34.7132142+07:00',
    'responseStatus': true,
    'data': {
      'data': [
        {
          'idAgreement': 49,
          'idPengajuan': 182,
          'noPengajuan': 'A240605BBCCC00000017',
          'pokokHutang': 140000000,
          'tenor': 12,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Cash & Drive',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600040%2F94%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-05-19-03-5786ea3eb26c1f46febf85352936a93705.jpg?Expires=7717589037&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=J5VcK45RsApYIP7DIhni2i%2FH3M8%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 50,
          'idPengajuan': 183,
          'noPengajuan': 'A240605BBCCC00000018',
          'pokokHutang': 200000000,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 150',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600041%2F95%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-06-12-52-40e5c351af6f954d42948d91f94a605a37.jpg?Expires=7717653160&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=Z0L9rU5sK%2B9sR6wjAariwftJyVM%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 51,
          'idPengajuan': 179,
          'noPengajuan': '240500013',
          'pokokHutang': 203000000,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 180',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600037%2F91%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-05-12-21-2384efebfa4a2b4351b211e3e32b96df82.jpg?Expires=7717564883&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=ybNer7t84r1xC5EMg8S51uu4gBg%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 40,
          'idPengajuan': 174,
          'noPengajuan': 'A240605BBCCC00000008',
          'pokokHutang': 230000000,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Cash & Drive',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600032%2F86%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-04-13-59-11c25e2df95f28440ebe8c8c6d7b806d04.jpg?Expires=7717484351&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=j9PZz%2BCSxWp%2BfYf2thMTitY35%2B8%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 41,
          'idPengajuan': 164,
          'noPengajuan': 'A240605BBCCC00000009',
          'pokokHutang': 31050001,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 150',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500022%2F76%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-05-31-15-11-5402de0dc578124394b99c309f8a4b51ef.jpg?Expires=7717143114&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=KH1MhWb8GUum3SR31%2BELjENUwD0%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 42,
          'idPengajuan': 162,
          'noPengajuan': 'A240605BBCCC00000010',
          'pokokHutang': 999966,
          'tenor': 12,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 180',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500020%2F74%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-05-31-10-38-05cab86dc54e7d46e095911aaf7ae9147b.jpg?Expires=7717126685&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=kl8UfjDelsVrWwV%2Btl4ozP9kejU%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 43,
          'idPengajuan': 159,
          'noPengajuan': 'A240605BBCCC00000011',
          'pokokHutang': 30050004,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Cash & Drive',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500017%2F71%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-05-30-14-28-09e5f028bf57274ca7870ab8fea0361001.jpg?Expires=7717054089&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=9jQLSiWnCIOM1iNdZoRBrI51Rp0%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 44,
          'idPengajuan': 157,
          'noPengajuan': 'A240605BBCCC00000012',
          'pokokHutang': 175000000,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 150',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500013%2F67%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-29-13-41-02416575b170d64bb4ad3cdf866efe5b15.jpg?Expires=7716964862&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=S7qVGo2%2FuXMVtSnq5twTwUpwV8U%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 45,
          'idPengajuan': 156,
          'noPengajuan': 'A240605BBCCC00000013',
          'pokokHutang': 29050002,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 180',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500013%2F67%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-29-13-41-02416575b170d64bb4ad3cdf866efe5b15.jpg?Expires=7716964862&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=S7qVGo2%2FuXMVtSnq5twTwUpwV8U%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 46,
          'idPengajuan': 153,
          'noPengajuan': 'A240605BBCCC00000014',
          'pokokHutang': 175000000,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Cash & Drive',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240500005%2F57%2Faset-jaminan%2FKendaraan_Tampak-Samping-Kanan-2024-05-27-12-25-41b5e069448a2f44339668ad9a4508b17d.jpg?Expires=7716787541&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=%2FZBc2SF5DjWKcfKJCaLur6Cv%2Bls%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 47,
          'idPengajuan': 180,
          'noPengajuan': 'A240605BBCCC00000015',
          'pokokHutang': 50600011,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 150',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600038%2F92%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-05-12-42-31cc51fe880f1d40e0b1dab04dcbcce380.jpg?Expires=7717566151&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=ZIrqeiIIq8FzDiNzaHci8fMRRaU%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
        {
          'idAgreement': 48,
          'idPengajuan': 181,
          'noPengajuan': 'A240605BBCCC00000016',
          'pokokHutang': 50600024,
          'tenor': 24,
          'ratePendana': 12,
          'status': 'Open',
          'namaProduk': 'Maxi 180',
          'img':
              'http://surveyor.oss-ap-southeast-5.aliyuncs.com/240600039%2F93%2Faset-jaminan%2F3_Kendaraan_Tampak-Samping-Kanan-2024-06-05-13-17-13ae429328276e4ab0808ded123934ded9.jpg?Expires=7717568233&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=YsKfHuW%2BzmvxUM0QYsd%2FZt3rgPg%3D',
          'keterangan': 'Kendaraan_Tampak-Samping-Kanan'
        },
      ],
      'page': 1,
      'total': 3,
      'page_size': 10,
      'total_page': 1
    }
  };
  Map<String, dynamic> rdlData = {
    'rdl': '1234567890',
    'bank': 'BNI',
  };

  List<dynamic> listBank = [
    {
      'idBank': 1,
      'namaBank': 'BNI',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/borrower-apk%2Ffile-2024-06-21-15-40-319dc2beff50cf4214b087dc038e30b121.png?Expires=7718959231&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=diznWGjL8l8e4sZ4QmR1wGevpJs%3D',
    },
    {
      'idBank': 2,
      'namaBank': 'ATM Bersama',
      'image':
          'http://surveyor.oss-ap-southeast-5.aliyuncs.com/borrower-apk%2Ffile-2024-06-21-15-41-428779f90c57cd4516b76ebaf8de950c13.png?Expires=7718959303&OSSAccessKeyId=LTAI5tL6WektQo3e62QSosiw&Signature=17PrHHKWKunjID6ktX3iP6Q3gss%3D',
    },
  ];

  String textPerjanjian =
      'Lorem ipsum purus in mollis nunc sed id semper. Suspendisse faucibus interdum posuere lorem ipsum. Dictum non consectetur a erat. Risus nullam eget felis eget nunc lobortis mattis aliquam faucibus. Sed adipiscing diam donec adipiscing tristique risus nec feugiat. Faucibus et molestie ac feugiat sed lectus vestibulum mattis. In nibh mauris cursus mattis molestie a iaculis at erat. Velit aliquet sagittis id consectetur purus ut faucibus. Lorem dolor sed viverra ipsum. Facilisis gravida neque convallis a cras. Adipiscing vitae proin sagittis nisl rhoncus. Odio eu feugiat pretium nibh ipsum. Sit amet nulla facilisi morbi. Viverra mauris in aliquam sem. Vitae justo eget magna fermentum. Ultrices dui sapien eget mi proin sed libero. Convallis a cras semper auctor neque vitae tempus quam. Netus et malesuada fames ac turpis egestas. Morbi enim nunc faucibus a pellentesque sit amet porttitor. Suspendisse potenti nullam ac tortor vitae.\nVel turpis nunc eget lorem dolor sed viverra ipsum nunc. Lacinia at quis risus sed. Velit egestas dui id ornare arcu odio ut sem nulla. Lacus vestibulum sed arcu non odio euismod lacinia. Imperdiet nulla malesuada pellentesque elit. Euismod nisi porta lorem mollis aliquam ut porttitor leo a. Tortor pretium viverra suspendisse potenti nullam ac tortor vitae. Nulla facilisi cras fermentum odio eu feugiat pretium nibh ipsum. Morbi tristique senectus et netus et malesuada fames ac turpis. Aliquam sem fringilla ut morbi tincidunt. Adipiscing bibendum est ultricies integer quis auctor elit. In nibh mauris cursus mattis molestie a iaculis at erat. Velit aliquet sagittis id consectetur purus ut faucibus. Lorem dolor sed viverra ipsum. Facilisis gravida neque convallis a cras. Adipiscing vitae proin sagittis nisl rhoncus. Odio eu feugiat pretium nibh ipsum. Sit amet nulla facilisi morbi. Viverra mauris in aliquam sem. Vitae justo eget magna fermentum. Ultrices dui sapien eget mi proin sed libero. Convallis a cras semper auctor neque vitae tempus quam. Netus et malesuada fames ac turpis egestas.';

  final riwayatTrx = {
    'beranda': {
      'SaldoTersedia': 10000000000.44444,
      'dataBank': {'idBank': 1},
      'user_name': 'John Doe',
      'status': {'Aktivasi': 1},
    },
    'riwayatTransaksi': {
      'total_record': 'transaksi'.length,
      'total_transaksi_perpage': 5,
      'transaksi': [
        {
          'status_wd': 1,
          'kdtrans': 'TRX123',
          'keterangan': 'Setor Dana',
          'nominal': 50000,
          'id_produk': 0,
          'no_sbg': '',
          'rref_no': 'REF123456',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 1,
          'kdtrans': 'TRX125',
          'keterangan': 'Refund Pendanaan',
          'nominal': 50000,
          'id_produk': 1,
          'no_sbg': '1012134141',
          'rref_no': 'REF123457',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
          'idAgreement': 1,
          'idPendanaan': 1,
          'namaProduk': 'Cash & Drive',
          'picture': 'assets/lender/portofolio/Car_1.png',
          'noPerjanjianPinjaman': '2022/22/123456751',
          'jumlahPendanaan': 2000000000,
          'bunga': 10,
          'tglJT': '2020-10-15',
          'status': 'Refund',
          'tgl_transaksi': '2020-10-15 10:00:00',
          'jenis_transaksi': 'Pendanaan',
          'total_pembayaran': 550000
        },
        {
          'status_wd': 1,
          'kdtrans': 'TRX125',
          'keterangan': 'Bunga Pendanaan',
          'nominal': 50000,
          'id_produk': 1,
          'no_sbg': '1012134142',
          'rref_no': 'REF123458',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 1,
          'kdtrans': 'TRX125',
          'keterangan': 'Pelunasan Pokok Dana',
          'nominal': 50000,
          'id_produk': 1,
          'no_sbg': '1012134143',
          'rref_no': 'REF123459',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 0,
          'kdtrans': 'WTH',
          'keterangan': 'Tarik Dana',
          'nominal': 50000,
          'id_produk': 0,
          'no_sbg': '',
          'rref_no': 'REF123460',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 1,
          'kdtrans': 'WTH',
          'lunas': true,
          'keterangan': 'Tarik Dana',
          'nominal': 50000,
          'id_produk': 0,
          'no_sbg': '',
          'rref_no': 'REF123461',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 1,
          'kdtrans': 'PNP',
          'keterangan': 'Pendanaan',
          'nominal': 50000,
          'id_produk': 1,
          'no_sbg': '1012134144',
          'rref_no': 'REF123462',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
        {
          'status_wd': 1,
          'kdtrans': 'TRX123',
          'keterangan': 'Ajak Teman',
          'nominal': 50000,
          'id_produk': 0,
          'no_sbg': '',
          'rref_no': 'REF123463',
          'priode': 1,
          'tgl_proses': '2020-10-15 10:00:00',
          'tanggal_cair': '2020-10-16 14:00:00',
        },
      ],
    },
  };

  List<Map<String, dynamic>> listMonth = [
    {
      'bulan': 1,
      'nama': 'Jan',
      'bulan_lengkap': 'Januari',
    },
    {
      'bulan': 2,
      'nama': 'Feb',
      'bulan_lengkap': 'Februari',
    },
    {
      'bulan': 3,
      'nama': 'Mar',
      'bulan_lengkap': 'Maret',
    },
    {
      'bulan': 4,
      'nama': 'Apr',
      'bulan_lengkap': 'April',
    },
    {
      'bulan': 5,
      'nama': 'Mei',
      'bulan_lengkap': 'Mei',
    },
    {
      'bulan': 6,
      'nama': 'Jun',
      'bulan_lengkap': 'Juni',
    },
    {
      'bulan': 7,
      'nama': 'Jul',
      'bulan_lengkap': 'Juli',
    },
    {
      'bulan': 8,
      'nama': 'Agu',
      'bulan_lengkap': 'Agustus',
    },
    {
      'bulan': 9,
      'nama': 'Sep',
      'bulan_lengkap': 'September',
    },
    {
      'bulan': 10,
      'nama': 'Okt',
      'bulan_lengkap': 'Oktober',
    },
    {
      'bulan': 11,
      'nama': 'Nov',
      'bulan_lengkap': 'November',
    },
    {
      'bulan': 12,
      'nama': 'Des',
      'bulan_lengkap': 'Desember',
    },
  ];

  List<Map<String, dynamic>> filterSort = [
    {'id': 'created_at', 'nama': 'Pendanaan Baru'},
    {'id': 'pokokHutangAsc', 'nama': 'Pendanaan Terendah'},
    {'id': 'pokokHutang', 'nama': 'Pendanaan Tertinggi'},
    {'id': 'bungaHutang', 'nama': 'Bunga Tertinggi'},
  ];

  List<Map<String, dynamic>> jenisProduk = [
    {'idProduk': 1, 'namaProduk': 'Maxi 150'},
    {'idProduk': 2, 'namaProduk': 'Cash & Drive'},
  ];
}
