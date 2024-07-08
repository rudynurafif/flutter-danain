import 'package:flutter_danain/domain/models/app_error.dart';

abstract class SimulasiRepository {
  UnitResultSingle simulasiPinjaman({
    required int gram,
    required int karat,
    int jangkaWaktu,
    int nilaiPinjaman,
  });

}
