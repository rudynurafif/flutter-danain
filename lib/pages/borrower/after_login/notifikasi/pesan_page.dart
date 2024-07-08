import 'package:flutter/material.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_index.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class PesanPage extends StatefulWidget {
  final NotifBloc nBloc;
  const PesanPage({
    super.key,
    required this.nBloc,
  });

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  @override
  void initState() {
    super.initState();
    widget.nBloc.setPagePesan(1);
    widget.nBloc.getPesan(1);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        widget.nBloc.getPesan(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.nBloc;
    return StreamBuilder<List<dynamic>?>(
      stream: bloc.pesanList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data ?? [];
          if (data.length == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Center(
                child: noMessageWidget(context),
              ),
            );
          }
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: data.map((e) {
                return GestureDetector(
                  onTap: () {
                    bloc.readNotif(e['id_notif']);
                  },
                  child: contentNotifikasi(
                    context,
                    e['judul'],
                    e['keterangan'],
                    e['created_at'],
                    e['is_read'],
                  ),
                );
              }).toList(),
            ),
          );
        }
        return notifikasiLoading(context);
      },
    );
  }

  Widget noMessageWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/icons/no_message.svg'),
          const SizedBox(height: 8),
          const Headline2(
            text: 'Belum Ada Pesan',
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Subtitle2(
            text: 'Belum ada pesan yang tersedia untuk Anda',
            align: TextAlign.center,
            color: HexColor('#777777'),
          ),
        ],
      ),
    );
  }
}
