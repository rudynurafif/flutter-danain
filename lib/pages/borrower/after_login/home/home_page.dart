import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_http/cupertino_http.dart';
import 'package:did_change_dependencies/did_change_dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/data/constants.dart';
import 'package:flutter_danain/data/remote/api_service.dart';
import 'package:flutter_danain/domain/models/app_error.dart';
import 'package:flutter_danain/domain/models/auth_state.dart';
import 'package:flutter_danain/domain/models/user.dart';
import 'package:flutter_danain/layout/appBar_previousTitleCustom.dart';
import 'package:flutter_danain/layout/footer_Lisence.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_page.dart';
import 'package:flutter_danain/utils/snackbar.dart';
import 'package:flutter_danain/widgets/widget_element.dart';
import 'package:flutter_danain/component/home/home_component.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http_client_hoc081098/http_client_hoc081098.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/string_format.dart';
import '../pencairan/detail_pencairan/detail_pencairan_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/home_page_loading.dart';

class HomePageAfterLogin extends StatefulWidget {
  static const routeName = 'homePage';
  final HomeBloc homeBloc;
  const HomePageAfterLogin({super.key, required this.homeBloc});

  @override
  State<HomePageAfterLogin> createState() => _HomePageAfterLoginState();
}

class _HomePageAfterLoginState extends State<HomePageAfterLogin>
    with DidChangeDependenciesStream, DisposeBagMixin {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  final TextEditingController provinsiController = TextEditingController();
  final LocalStorage storage = LocalStorage('todo_app.json');
  final rxPrefs = RxSharedPreferences(
    SharedPreferences.getInstance(),
    kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
  );
  Map<String, dynamic> dataHome = {};

  int currentIndex = 0;
  bool isRefresh = false;
  CarouselController _carouselController = CarouselController();
  bool isLoading = true;
  final ApiService _apiService = ApiService(
    SimpleHttpClient(
      client: Platform.isIOS || Platform.isMacOS
          ? CupertinoClient.defaultSessionConfiguration()
          : http.Client(),
    ),
  );
  @override
  void initState() {
    super.initState();
    widget.homeBloc.setBeranda();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([_one, _two, _three]));
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<HomeBloc>().messageBeranda$)
        .exhaustMap(validationBeranda)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<HomeBloc>().authState$)
        .exhaustMap(validationAuth)
        .collect()
        .disposedBy(bag);
    didChangeDependencies$
        .exhaustMap((_) => context.bloc<HomeBloc>().isUploading$)
        .exhaustMap(validationKonfirmation)
        .collect()
        .disposedBy(bag);
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = widget.homeBloc;
    // homeBloc.setBeranda;
    print('check home check');
    return StreamBuilder<Result<AuthenticationState>?>(
      stream: homeBloc.authState$,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          final beranda = result?.orNull()?.userAndToken?.beranda;
          final user = result?.orNull()?.userAndToken?.user;
          final Map<String, dynamic> decodedToken = JwtDecoder.decode(beranda!);
          print('ini beranda bang $decodedToken');
          dataHome = decodedToken['beranda'];
          print("datahome survey ${dataHome["penyerahanBPKB"]}");
          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                homeBloc.setBeranda();
              },
              child: bodyHomeWidget(
                context,
                homeBloc,
                user,
              ),
            ),
          );
        } else {
          print('disini kosong ${snapshot.data}');
          return const HomePageLoading();
        }
      },
    );
  }

  Stream<void> validationAuth(response) async* {
    isLoading = false;
    await delay(1000);
  }

  Stream<void> validationKonfirmation(response) async* {
    print(response);
    await delay(1000);
  }

  Stream<void> validationBeranda(response) async* {
    build(context);
    isLoading = false;
    await delay(1000);
  }

  Future<void> alertBack(BuildContext context) async {
    // Show dialog
    await showDialog(
      context: context,
      builder: (context) {
        return const ModalPopUpNoClose(
          icon: 'assets/images/icons/check.svg',
          title: 'Berhasil Konfirmasi',
          message: 'Berhasil konfirmasi penyerahan BPKB',
          actions: [],
        );
      },
    );
  }

  Widget bodyHomeWidget(BuildContext context, HomeBloc homeBloc, User? user) {
    const num tkb = 90;
    final String tkbString = tkb.toString();
    final int decimalIndex = tkbString.indexOf('.');
    final String tkbConvert = tkbString.substring(0, decimalIndex + 3);

    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/home/background_borrower.svg',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitWidth,
        ),
        Column(
          children: [
            AppBarHome(
              tkb: tkbConvert,
              notif: dataHome['status']['notifikasi'],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagihanComponent(
                      tagihan: dataHome['pinjaman']['tagihan_bulan_ini'] ?? 0,
                      totalCashback: dataHome['status']['total_cash_back'] ?? 0,
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            const SpacerV(value: 50),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MenusWidget(data: dataHome),
                            ),
                            const SpacerV(value: 16),
                            // Add more widgets here as needed
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  konfirmasiSurveyComponent(dataHome),
                                  penyerahanBpkbComponent(dataHome),
                                  if (dataHome['pengajuan_pinjaman']
                                          ['nilai_pinjaman'] !=
                                      0)
                                    PinjamanBPKBComponent(
                                      nilaiPinjaman:
                                          dataHome['pengajuan_pinjaman']
                                                  ['nilai_pinjaman'] ??
                                              '',
                                      noPenawaran:
                                          dataHome['pengajuan_pinjaman']
                                                  ['no_penawaran'] ??
                                              '',
                                      tipe: dataHome['pengajuan_pinjaman']
                                              ['keterangan'] ??
                                          '',
                                      jenisKendaraan:
                                          dataHome['pengajuan_pinjaman']
                                                  ['id_jenis_kendaraan'] ??
                                              0,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          KonfirmasiPinjamanPage.routeName,
                                          arguments: KonfirmasiPinjamanPage(
                                            idPengajuan:
                                                dataHome['pengajuan_pinjaman']
                                                    ['id_pengajuan'],
                                            idTaskPengajuan:
                                                dataHome['pengajuan_pinjaman']
                                                    ['id_task_pengajuan'],
                                          ),
                                        );
                                      },
                                    ),
                                  const CarouselProduk(),
                                  dividerFull(context),
                                  footerLisence(context),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget konfirmasiSurveyComponent(Map<String, dynamic>? data) {
    if (data!['konfirmasi_survey'] != null) {
      return DetailKonfirmasiJadwalSurveyComponent(
        idTask: data['konfirmasi_survey']['noPengajuan'],
        jumlahPinjaman: data['konfirmasi_survey']['pengajuan'],
        status: '-',
        alamatUtama: data['konfirmasi_survey']['alamat'],
        alamatDetail: data['konfirmasi_survey']['detailAlamat'],
        tglSurvey: data['konfirmasi_survey']['tglSurvey'],
        onTap: () {
          Navigator.pushNamed(
            context,
            KonfirmasJadwalSurveyPage.routeName,
            arguments: KonfirmasJadwalSurveyPage(
              idTaskPengajuan:
                  data['konfirmasi_survey']['idTaskPengajuan'] ?? 0,
              idPengajuan: data['konfirmasi_survey']['idPengajuan'] ?? 0,
            ),
          );
        },
        isStatus: data['konfirmasi_survey']['isStatus'],
        jenisKendaraan: data['konfirmasi_survey']['idJenisKendaraan'],
      );
    }
    return const SizedBox.shrink();
  }

  // Define the penyerahanBpkbComponent function
  Widget penyerahanBpkbComponent(Map<String, dynamic>? data) {
    print("file penyerahan 1 ${data!['penyerahanBPKB']}");
    if (data!['penyerahanBPKB'] != null) {
      return PengajuanPenyerahanBPKBComponent(
        nilaiPinjaman: num.parse(data['penyerahanBPKB']['nilai'].toString()),
        tipe: data['penyerahanBPKB']['keterangan'],
        isPenyerahan: data['penyerahanBPKB']['isPenyerahan'],
        onTap: () {
          if (data['penyerahanBPKB']['isPenyerahan'] == 1) {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) => btmSheetPenyerahan(
                context,
                data['penyerahanBPKB']['file'],
                data,
              ),
            );
          }
          if (data['penyerahanBPKB']['isPenyerahan'] == 0) {
            Navigator.pushNamed(
              context,
              KonfirmasiPinjamanPage.routeName,
              arguments: KonfirmasiPinjamanPage(
                idPengajuan: dataHome['penyerahanBPKB']['idPengajuan'],
                idTaskPengajuan: dataHome['penyerahanBPKB']['idTaskPengajuan'],
                isStep: 4,
                Data: dataHome['penyerahanBPKB']['dataPencairan'],
              ),
            );
          }

          if (data['penyerahanBPKB']['isPenyerahan'] == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _KonfirmasiPinjamanQrCodePage(
                  data: data['penyerahanBPKB'],
                ),
              ),
            );
          }
        },
        noPengajuan: data['penyerahanBPKB']['noPengajuan'],
        jenisKendaraan: data['penyerahanBPKB']['idJenisKendaraan'],
      );
    }
    return const SizedBox.shrink();
  }

  Widget penawaranPencairan(BuildContext context, List<dynamic> dataHome) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Headline3(text: 'Proses Pencairan'),
            ),
            const SizedBox(height: 12),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 208,
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: dataHome.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  reverse: false,
                  disableCenter: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.92,
                  enlargeFactor: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                      _carouselController.animateToPage(index);
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final data = dataHome[realIndex];
                  final List<dynamic> items = data['detail_jaminan'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, DetailPencairanPage.routeName,
                          arguments: DetailPencairanPage(
                            idjaminan: data['id_jaminan'],
                            idproduk: data['idproduk'],
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: HexColor('#DAF1DE'),
                        ),
                        color: HexColor('#F9FFFA'),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: HexColor('#E9F6EB'),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/home/maxi.svg',
                                      ),
                                      const SizedBox(width: 8),
                                      Subtitle2Extra(
                                        text: data['nama_produk'].toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                Subtitle2(
                                  text:
                                      data['no_perjanjian_pinjaman'].toString(),
                                  color: HexColor('#777777'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 11,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Subtitle3(
                                      text: 'Jumlah Pinjaman',
                                      color: HexColor('#AAAAAA'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: HexColor('#FEF4E8'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Subtitle3(
                                            text: 'Proses',
                                            color: HexColor('#F7951D'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Headline2(
                                    text:
                                        rupiahFormat(data['jumlah_pinjaman'])),
                                dividerFull2(context),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Nama Mitra',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text:
                                              shortText(data['nama_mitra'], 16),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Berat',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text: shortenText(items
                                              .map((val) => '${val['berat']}G')
                                              .join(',')),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Subtitle3(
                                          text: 'Karat',
                                          color: HexColor('#AAAAAA'),
                                        ),
                                        const SizedBox(height: 4),
                                        Subtitle2Extra(
                                          text: shortenText(items
                                              .map((val) => '${val['karat']}k')
                                              .join(',')),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pengajuanPinjamanStatusWidget(
      Map<String, dynamic> dataHome, User? user) {
    if (dataHome['barcode'] != '') {
      return havePengajuanPinjaman(context, dataHome['barcode'], user!);
    }
    return Container();
  }

  Widget accountStatusWidget(int isAktivasi) {
    if (isAktivasi > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: accountVerifWidget(
          dataHome['status'],
          dataHome['dataPrivy'],
        ),
      );
    }
    return Container();
  }

  Widget accountVerifWidget(
    Map<String, dynamic> statusAccount,
    Map<String, dynamic> statusPrivy,
  ) {
    switch (statusPrivy['types']) {
      case 'Hard Reject':
        return privyRejected(context);
      default:
        switch (statusAccount['is_aktivasi']) {
          case 10:
            return haveverifData(context);
          case 9:
            return verifDataProgress(context);
          case 0:
            return haventverifData(context);
          case 12:
            return privyFixDocumentBorrower(
                context, statusPrivy, statusPrivy['dataUpdate'] ?? []);
          case 13:
            return privyRejected(context);
          default:
            return const SizedBox.shrink();
        }
    }
  }

  Widget updateDataStatus(Map<String, dynamic> data) {
    if (data['status']['status_request_hp'] == 'waiting' ||
        data['status']['status_request_email'] == 'waiting') {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: verifDataProgress(context),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget statusTutupAkun(Map<String, dynamic> data) {
    if (data.containsKey('dataTutupAkun') &&
        data['dataTutupAkun']['idClose'] != 0) {
      final DateTime dateTime =
          DateTime.parse(data['dataTutupAkun']['tglTutupAkun']);

      // Format the date
      final String formattedDate =
          DateFormat('d MMMM yyyy', 'en_US').format(dateTime);
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: HexColor('#FEF4E8'),
              border: Border.all(width: 1, color: HexColor('#FDE8CF')),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/images/icons/warning_red.svg'),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Headline5(text: 'Proses Penutupan Akun'),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(children: <TextSpan>[
                            const TextSpan(
                              text:
                                  'Proses penutupan akun memerlukan waktu 3 hari kerja. Akun Anda akan ditutup pada ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xff777777),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: formattedDate,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ButtonCustom(
                btntext: 'Batalkan Penutupan Akun',
                textcolor: HexColor('#FF8829'),
                color: HexColor('#FEF4E8'),
                action: () async {
                  final response = await _apiService
                      .cancelTutupAkun(data['dataTutupAkun']['idClose']);
                  if (response.statusCode == 201) {
                    widget.homeBloc.setBeranda();
                  } else {
                    // ignore: use_build_context_synchronously
                    context.showSnackBarError('Maaf sepertinya ada kesalahan');
                  }
                },
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget btmSheetPenyerahan(
      BuildContext context, String file, Map<String, dynamic>? data) {
    print('file penyerahan $file');
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 90,
                  height: 4,
                  color: HexColor('#DDDDDD'),
                ),
              ),
              const SizedBox(height: 24),
              Headline2500(
                  text: data!['penyerahanBPKB']['isPenyerahan'] == 1
                      ? 'Konfirmasi Penyerahan BPKB'
                      : 'Penyerahan BPKB'),
              const SizedBox(height: 8),
              Headline4500(
                  text:
                      'Pastikan foto surveyor dan data kendaraan yang ditampilkan sesuai',
                  color: HexColor('##777777')),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    file,
                    // width: 500,
                    height: 512,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Button1(
                btntext: 'Konfirmasi',
                action: () {
                  widget.homeBloc
                      .postKonfirmasiPenyerahanKonfirmasPinjamanCND();
                  alertBack(context);
                  Future.delayed(const Duration(seconds: 3), () {
                    // Show the alert dialog
                    // Navigate to the home page after the dialog is shown
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HomePage.routeName);
                  });

                  // Navigator.pushNamed(context, HomePage.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KonfirmasiPinjamanQrCodePage extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  const _KonfirmasiPinjamanQrCodePage({Key? key, required this.data})
      : super(key: key);

  @override
  _KonfirmasiPinjamanQrCodePageState createState() =>
      _KonfirmasiPinjamanQrCodePageState();
}

class _KonfirmasiPinjamanQrCodePageState
    extends State<_KonfirmasiPinjamanQrCodePage> {
  @override
  Widget build(BuildContext context) {
    print("masuk ${widget.data}");
    return Scaffold(
      appBar: previousTitleCustom(context, 'Penyerahan BPKB', () {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/home/mitra.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Subtitle3(
                        text: 'Lokasi Penyerahan BPKB',
                        color: HexColor('#777777'),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Headline3500(
                      text:
                          widget.data['mitra']['namaCabang'] ?? 'MAS MELAWAI'),
                  const SizedBox(height: 8),
                  Subtitle2(
                    text: widget.data['mitra']['alamat'],
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: 32,
                        child: Button2(
                          btntext: 'Hubungi Kami',
                          textcolor: Colors.white,
                          action: () async {
                            final url = dotenv.env['CALL_CENTER'].toString();
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              context.showSnackBarError(
                                'Maaf sepertinya terjadi kesalahan',
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        height: 32,
                        child: Button2(
                          btntext: 'Maps',
                          color: Colors.white,
                          textcolor: HexColor(primaryColorHex),
                          action: () async {
                            final url =
                                'http://maps.google.com/maps?q=${widget.data['mitra']['longitude']},${widget.data['mitra']['latitude']}';

                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              context.showSnackBarError(
                                'Maaf sepertinya terjadi kesalahan',
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            dividerFull(context),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Headline2500(text: 'QR Code'),
                  const SizedBox(height: 8),
                  Subtitle2(
                    text:
                        'Silakan datang ke lokasi mitra dan tunjukkan QR code untuk penyerahan BPKB.',
                    color: HexColor('#777777'),
                  ),
                  const SizedBox(height: 24),
                  qrCode(
                      widget.data['isPenyerahan'] == 2
                          ? widget.data['noKtp']
                          : widget.data['Qr'],
                      widget.data['Qr'],
                      widget.data['namaBorrower'])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget qrCode(String? value, String? qr, String? borrower) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: HexColor('#FFFFFF'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: HexColor('#EEF4EE'),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Headline3500(text: borrower ?? 'User'),
          const SizedBox(height: 4),
          Subtitle2(
            text: value ?? 'value',
            color: HexColor('#777777'),
          ),
          const SizedBox(height: 24),
          qrCodeImage(qr ?? ''),
        ],
      ),
    );
  }

  Widget qrCodeImage(String valueQr) {
    if (valueQr == '') {
      return Container(
        height: 260,
        alignment: Alignment.center,
        child: const TextWidget(
          text: 'Qr code tidak tersedia',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return QrImageView(
      data: valueQr,
      embeddedImage: const AssetImage('assets/images/logo/logo_splash.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(40, 40),
      ),
      size: 260,
      errorStateBuilder: (context, error) {
        return const Subtitle1(text: 'Maaf terjadi kesalahan');
      },
    );
  }
}
