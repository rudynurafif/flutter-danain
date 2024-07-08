import 'dart:core';

import 'package:equatable/equatable.dart';

class Pendanaan extends Equatable {
  final int idPendanaan;
  final String namaProduk;
  final String picture;
  final String noPerjanjianPinjaman;
  final String jenis;
  final String merek;
  final String tipe;
  final String kondisi;
  final String keterangan;
  final String tahunProduksi;
  final String ccKendaraan;
  final num jumlahPendanaan;
  final int tenor;
  final num bunga;
  final String skor;
  final String namaPeminjam;

  const Pendanaan({
    required this.idPendanaan,
    required this.namaProduk,
    required this.picture,
    required this.noPerjanjianPinjaman,
    required this.jenis,
    required this.merek,
    required this.tipe,
    required this.kondisi,
    required this.keterangan,
    required this.tahunProduksi,
    required this.ccKendaraan,
    required this.jumlahPendanaan,
    required this.tenor,
    required this.bunga,
    required this.skor,
    required this.namaPeminjam,
  });

  @override
  List<Object?> get props => [
        idPendanaan,
        namaProduk,
        picture,
        noPerjanjianPinjaman,
        jenis,
        merek,
        kondisi,
        keterangan,
        tahunProduksi,
        ccKendaraan,
        jumlahPendanaan,
        tenor,
        bunga,
        skor,
        namaPeminjam,
      ];
}
