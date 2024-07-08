import 'package:flutter/material.dart';

import 'new_pendanaan.dart';

class ListPendanaan extends StatelessWidget {
  const ListPendanaan({
    super.key,
    required this.data,
  });

  final List data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.map(
            (e) {
              return NewPendanaanWidget(
                idAgreement: e['idAgreement'],
                idPendanaan: e['idAgreement'],
                namaProduk: e['namaProduk'],
                picture: e['img'],
                noPerjanjianPinjaman: e['noPengajuan'],
                jumlahPendanaan: e['pokokHutang'],
                tenor: e['tenor'],
                bunga: e['ratePendana'],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
