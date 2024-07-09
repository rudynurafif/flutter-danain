import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_danain/domain/repositories/transaksi_repository.dart';
import 'package:flutter_danain/domain/usecases/api_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_auth_state_use_case.dart';
import 'package:flutter_danain/domain/usecases/get_riwayat_transaksi_v3.dart';
import 'package:flutter_danain/domain/usecases/post_konfirmasi_penyerahan_pinjaman.dart';
import 'package:flutter_danain/domain/usecases/post_konfirmasi_validasi_otp_use_case.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cnd_use_case.dart';
import 'package:flutter_danain/domain/usecases/resend_otp_forgot_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/reset_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/upload_file_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_otp_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_pin_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_register_use_case.dart';
import 'package:flutter_danain/domain/usecases/simulasi_cicilan_use_case.dart';
import 'package:flutter_danain/domain/usecases/simulasi_maxi_use_case.dart';
import 'package:flutter_danain/domain/usecases/ubah_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/use_case.dart';
import 'package:flutter_danain/domain/usecases/val_otp_forgot_pin_use_case.dart';
import 'package:flutter_danain/domain/usecases/verifikasi_use_case.dart';
import 'package:flutter_danain/pages/auxpage/dokumen_perjanjian_pinjaman.dart';
import 'package:flutter_danain/pages/auxpage/preference.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi_akun_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/aktivasi_akun/aktivasi_akun_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/case_privy/case_prify_upload.dart';
import 'package:flutter_danain/pages/borrower/after_login/case_privy_borrower/case_privy_borrower_upload.dart';
import 'package:flutter_danain/pages/borrower/after_login/complete_data/complete_data_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_cd_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/home/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_cd_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/introduction/introduction_product_page.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_deeplink.dart';
import 'package:flutter_danain/pages/borrower/email_deeplink/email_deeplink_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_bank/info_bank_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pekerjaan/info_pekerjaan_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/ubah_password/ubah_password.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_bloc.dart';
import 'package:flutter_danain/pages/borrower/new_register/new_register_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_jadwal_survey_cd/konfirmasi_jadwal_survey_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/konfirmasi_pinjaman_cd/konfirmasi_penyerahan_bpkb_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/mitra/mitra_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/notifikasi/notifikasi_index.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_bloc2.dart';
import 'package:flutter_danain/pages/borrower/after_login/penawaran_pinjaman/penawaran_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/pencairan/detail_pencairan/detail_pencairan_bloc.dart';
import 'package:flutter_danain/pages/borrower/after_login/pencairan/detail_pencairan/detail_pencairan_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/pengajuan_pinjaman/pengajuan_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/simulasi/simulasi_choose_page.dart';
import 'package:flutter_danain/pages/borrower/info_product/info_product.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/hubungan_keluarga/hubungan_keluarga_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/hubungan_keluarga/hubungan_keluarga_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/konfirmasi_pinjaman_cd/konfirmasi_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/bloc/pengajuan_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pengajuan/pengajuan_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/transaksi/detail_transaksi/detail_transaksi_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/pinjaman/proses/proses_pengajuan_page.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/bloc/simulasi_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cash_drive/simulasi/simulasi_page.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/page_gagal.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/product/cicil_emas_page.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_bloc.dart';
import 'package:flutter_danain/pages/borrower/product/cicil_emas/toko_emas/toko_emas_index.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/change_phone_number/change_phone_number_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/fill_personal_data_page.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/step-verif/index_step.dart';
import 'package:flutter_danain/pages/borrower/after_login/verification/verification_complete_page.dart';
import 'package:flutter_danain/pages/borrower/auxpage/choose_preference_page.dart';
import 'package:flutter_danain/pages/borrower/auxpage/emailVerificationSuccess/email_status_verif%202.dart';
import 'package:flutter_danain/pages/borrower/auxpage/emailVerificationSuccess/email_status_verif_bloc.dart';
import 'package:flutter_danain/pages/borrower/auxpage/email_send_page.dart';
import 'package:flutter_danain/pages/borrower/auxpage/introduction_product_page.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/expired_page.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/forgot_password.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/new_password_page.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_bloc.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/request/request_page.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/validate/validate_bloc.dart';
import 'package:flutter_danain/pages/borrower/forgot_password/validate/validate_page.dart';
import 'package:flutter_danain/pages/borrower/home/home_bloc.dart';
import 'package:flutter_danain/pages/borrower/home/home_page.dart';
import 'package:flutter_danain/pages/borrower/home/qrcode_pages.dart';
import 'package:flutter_danain/pages/borrower/menu/help/detail/answer_page.dart';
import 'package:flutter_danain/pages/borrower/menu/help/detail/detail_page.dart';
import 'package:flutter_danain/pages/borrower/menu/help/help_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/files/kebijakan_privasi_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/files/syarat_ketentuan_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pekerjaan/info_pekerjaan_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/detail/pribadi/info_pribadi_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/info_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/info_pribadi/info_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/send_verif_ubah_hp/ubah_hp_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/settings_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/tutup_akun/tutup_akun_index.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/deeplink_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_email/ubah_email_page.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/profile/tab_menu/settings/update_hp/update_hp_page.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/cicilan/detail_cicilan/detail_cicilan_index.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/detail_pinjaman/detail_riwayat_pinjaman_proses_page.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_page.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/menu/transaction/pinjaman/pembayaran/pembayaran_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/lokasi_penyimpanan_emas_page.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/supplier_bloc.dart';
import 'package:flutter_danain/pages/borrower/mitra_emas/supplier_page.dart';
import 'package:flutter_danain/pages/borrower/register/Email_Status_Verif_Success_Borrower.dart';
import 'package:flutter_danain/pages/borrower/register/register_page.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_Page.dart';
import 'package:flutter_danain/pages/borrower/registerNew/registerNew_bloc.dart';
import 'package:flutter_danain/pages/borrower/simulasi/cicilan/simulasi_cicilan_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_bloc.dart';
import 'package:flutter_danain/pages/borrower/simulasi/pinjaman/simulasi_pinjaman_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/simulasi_cicilan_page.dart';
import 'package:flutter_danain/pages/borrower/simulasi/tambah_emas_page.dart';
import 'package:flutter_danain/pages/borrower/verifikasi_email/verif_email_bloc.dart';
import 'package:flutter_danain/pages/borrower/verifikasi_email/verif_email_page.dart';
import 'package:flutter_danain/pages/dokumen/html/dokumen_bloc.page.dart';
import 'package:flutter_danain/pages/dokumen/html/dokumen_html_page.dart';
import 'package:flutter_danain/pages/dokumen/pdf/dokumen_page.dart';
import 'package:flutter_danain/pages/help_temp/help_temp.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman.page.dart';
import 'package:flutter_danain/pages/lender/ajak_teman/ajak_teman_bloc.dart';
import 'package:flutter_danain/pages/lender/check_pin/check_pin_page.dart';
import 'package:flutter_danain/pages/lender/home/home_lendar_bloc.dart';
import 'package:flutter_danain/pages/lender/home/home_page.dart';
import 'package:flutter_danain/pages/lender/home/home_tkb_page.dart';
import 'package:flutter_danain/pages/lender/login/login_bloc.dart';
import 'package:flutter_danain/pages/lender/login/login_page.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_bloc.dart';
import 'package:flutter_danain/pages/lender/lupa_pin/lupa_pin_page.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_detail_pendanaan/new_detail_pendanaan_bloc.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_detail_pendanaan/new_detail_pendanaan_page.dart';
import 'package:flutter_danain/pages/lender/new_pendanaan/new_pendanaan.dart';
import 'package:flutter_danain/pages/lender/notif/notif_lender_bloc.dart';
import 'package:flutter_danain/pages/lender/notif/notif_lender_index.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan_bloc.dart';
import 'package:flutter_danain/pages/lender/pendanaan/pendanaan_page.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin.dart';
import 'package:flutter_danain/pages/lender/pengaturan_akun/ubah_pin_bloc.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/detail_portofolio_bloc.dart';
import 'package:flutter_danain/pages/lender/portfolio/detail/portofolio_detail_page.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/detail/detail_transaksi_bloc.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/detail/detail_transaksi_page.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/riwayat_transaksi_bloc.dart';
import 'package:flutter_danain/pages/lender/portfolio/riwayatTransaksi/riwayat_transaksi_page.dart';
import 'package:flutter_danain/pages/lender/profile/info/info_data.dart';
import 'package:flutter_danain/pages/lender/profile/info/info_data_bloc.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_bloc.dart';
import 'package:flutter_danain/pages/lender/profile/info_bank/info_bank_lender_page.dart';
import 'package:flutter_danain/pages/lender/profile/settings/settings_lender.dart';
import 'package:flutter_danain/pages/lender/rdl/regis_rdl_bloc.dart';
import 'package:flutter_danain/pages/lender/register/email_status_verif_success.dart';
import 'package:flutter_danain/pages/lender/register/register_bloc.dart';
import 'package:flutter_danain/pages/lender/register/register_page.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana_bloc.dart';
import 'package:flutter_danain/pages/lender/setor_dana/setor_dana_page.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_bloc.dart';
import 'package:flutter_danain/pages/lender/simulasi/simulasi_page.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana_bloc.dart';
import 'package:flutter_danain/pages/lender/tarik_dana/tarik_dana_page.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_bloc.dart';
import 'package:flutter_danain/pages/lender/verifikasi/verifikasi_page.dart';
import 'package:flutter_danain/pages/login/login_bloc.dart';
import 'package:flutter_danain/pages/login/login_page.dart';
import 'package:flutter_danain/pages/route_main/onboarding.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_danain/app.dart';
import 'package:flutter_danain/domain/repositories/user_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/send_otp_register_borrower_use_case.dart';
import 'domain/usecases/simulasi_pinjaman_use_case.dart';
import 'domain/usecases/tarik_dana_use_case.dart';
import 'domain/usecases/ubah_email_use_case_1.dart';
import 'domain/usecases/ubah_email_use_case_2.dart';
import 'domain/usecases/ubah_hp_use_case.dart';
import 'domain/usecases/ubah_hp_validasi_user_case.dart';
import 'domain/usecases/validate_otp_pendanaan_use_case.dart';
import 'package:flutter_danain/domain/usecases/send_email_register_use_case.dart';

import 'pages/lender/check_pin/check_pin_bloc.dart';
import 'pages/lender/rdl/regis_rdl_page.dart';

class Routers {
  static final Map<String, WidgetBuilder> routes = {
    // Define your routes here
    Navigator.defaultRouteName: (context) {
      return Provider<GetAuthStateUseCase>.factory(
        (context) => GetAuthStateUseCase(context.get()),
        child: const Home(),
      );
    },
    LoginPage.routeName: (context) {
      return BlocProvider<LoginBloc>(
        initBloc: (context) => LoginBloc(
          LoginUseCase(context.get()),
        ),
        child: const LoginPage(),
      );
    },
    OnboardingMaster.routeName: (context) => const OnboardingMaster(),
    NotifikasiPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return NotifBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const NotifikasiPage(),
      );
    },
    ChoosePreference.routeName: (context) {
      return const ChoosePreference();
    },
    IntroductionProduct.routeName: (context) {
      return const IntroductionProduct();
    },
    RegisterIndex.routeName: (context) {
      return const RegisterIndex();
    },
    PreferencePage.routeName: (context) {
      return const PreferencePage();
    },
    SimulasiPinjaman.routeName: (context) {
      return BlocProvider<SimulasiPinjamanBloc>(
        initBloc: (context) => SimulasiPinjamanBloc(
          SimulasiPinjamanUseCase(
            context.get(),
          ),
        ),
        child: const Material(
          child: SimulasiPinjaman(),
        ),
      );
    },
    HomePage.routeName: (context) {
      return BlocProvider<HomeBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return HomeBloc(
            LogoutUseCase(userRepository),
            GetAuthStateStreamUseCase(userRepository),
            GetBerandaUseCase(userRepository),
            CheckPinUseCase(userRepository),
            PostKonfirmasiPenyerahanPinjamanUseCase(transaksiRepository),
            GetRiwayatTransaksiUseCase(transaksiRepository),
            GetRequestUseCase(userRepository),
          );
        },
        child: const HomePage(),
      );
    },
    SimulasiCicilanEmas.routeName: (context) {
      return const SimulasiCicilanEmas();
    },

    SimulasiCicilan.routeName: (context) {
      return const SimulasiCicilan();
    },
    TambahEmas.routeName: (context) {
      return const TambahEmas();
    },
    ForgotPasswordPage.routeName: (context) {
      return const ForgotPasswordPage();
    },
    NewPasswordPage.routeName: (context) {
      return const NewPasswordPage();
    },
    EmailSend.routeName: (context) {
      return const EmailSend();
    },

    PenyimpananEmas.routeName: (context) {
      return const PenyimpananEmas();
    },
    HelpContent.routeName: (context) {
      return const HelpContent();
    },
    HomeTkbPage.routeName: (context) => const HomeTkbPage(),
    DokumenPerjanjianPinjaman.routeName: (context) =>
        const DokumenPerjanjianPinjaman(),
    FaqDetailPage.routeName: (context) {
      return const FaqDetailPage();
    },
    AnswerFaqPage.routeName: (context) {
      return const AnswerFaqPage();
    },

    EmailStatusVerif.routeName: (context) {
      return BlocProvider<EmailStatusVerifBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return EmailStatusVerifBloc(
            GetBerandaUserUseCase(userRepository),
          );
        },
        child: EmailStatusVerif(),
      );
    },
    EmailStatusVerifSuccess.routeName: (context) {
      return EmailStatusVerifSuccess();
    },
    EmailStatusVerifSuccessBorrower.routeName: (context) {
      return BlocProvider<EmailStatusVerifBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();

          return EmailStatusVerifBloc(
            GetBerandaUserUseCase(userRepository),
          );
        },
        child: EmailStatusVerifSuccessBorrower(),
      );
    },
    //after login
    IntroductionProductAfterLogin.routeName: (context) {
      return const IntroductionProductAfterLogin();
    },
    CompleteDataPage.routeName: (context) {
      return const CompleteDataPage();
    },

    FillPersonalDataPage.routeName: (context) {
      return const FillPersonalDataPage();
    },

    IndexStepPage.routeName: (context) {
      return const IndexStepPage();
    },
    ChangeNoHpPage.routeName: (context) {
      return const ChangeNoHpPage();
    },
    VerificationCompletePage.routeName: (context) {
      return const VerificationCompletePage();
    },

    //pengajuan pinjaman
    PengajuanPinjaman.routeName: (context) {
      return const PengajuanPinjaman();
    },

    //penawaran pinjaman
    PenawaranPinjamanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return PenawaranPinjamanBloc2(
              GetAuthStateStreamUseCase(userRepository),
              PenawaranPinjamanUseCase(transaksiRepository));
        },
        child: const PenawaranPinjamanPage(),
      );
    },

    KonfirmasiPinjamanCDPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return KonfirmasiPincamanCdBloc(
              GetAuthStateStreamUseCase(userRepository),
              PenawaranPinjamanUseCase(transaksiRepository));
        },
        child: const KonfirmasiPinjamanCDPage(),
      );
    },

    DetailPencairanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DetailPencairanBloc(GetAuthStateStreamUseCase(userRepository));
        },
        child: const DetailPencairanPage(),
      );
    },

    //transaksi pinjaman
    DetailRiwayatPinjaman.routeName: (context) {
      return BlocProvider<DetailRiwayatPinjamanBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DetailRiwayatPinjamanBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const Material(
          child: DetailRiwayatPinjaman(),
        ),
      );
    },
    PembayaranPage.routeName: (context) {
      return BlocProvider<PembayaranBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return PembayaranBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const Material(
          child: PembayaranPage(),
        ),
      );
    },
    TokoEmasIndex.routeName: (context) {
      return BlocProvider<SupplierEmasBloc>(
        initBloc: (context) {
          return SupplierEmasBloc();
        },
        child: const TokoEmasIndex(),
      );
    },
    PengajuanCicilanGagal.routeName: (context) {
      return const PengajuanCicilanGagal();
    },
    DetailCicilanIndex.routeName: (context) {
      return BlocProvider<CicilanDetailBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();

          return CicilanDetailBloc(
            GetAuthStateStreamUseCase(userRepository),
            ActionCicilanUseCase(transaksiRepo),
            CicilEmasReqUseCase(transaksiRepo),
            CicilEmasValUseCase(transaksiRepo),
            GetPaymentUseCase(transaksiRepo),
          );
        },
        child: const DetailCicilanIndex(),
      );
    },

    DetailTransaksi.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as DetailTransaksi;
      return BlocProvider<DetailTransaksiBlocV3>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();

          return DetailTransaksiBlocV3(
            GetRiwayatTransaksiUseCase(transaksiRepo),
            GetAuthStateStreamUseCase(userRepository),
            PostRequestDocumentUseCase(userRepository),
          );
        },
        child: DetailTransaksi(
          idAgreement: args.idAgreement,
        ),
      );
    },

    //case privy
    CasePrivy.routeName: (context) {
      return const CasePrivy();
    },
    CasePrivyBorrower.routeName: (context) {
      return const CasePrivyBorrower();
    },

    MitraPage.routeName: (context) {
      return const MitraPage();
    },
    SimulasiChoosePage.routeName: (context) {
      return const SimulasiChoosePage();
    },
    SupplierEmasPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          return GetSupplierBloc();
        },
        child: const SupplierEmasPage(),
      );
    },
    QrcodePages.routeName: (context) {
      return const QrcodePages();
    },

    //profile
    InfoBorrowerPage.routeName: (context) {
      return BlocProvider<InfoBorrowerBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return InfoBorrowerBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const InfoBorrowerPage(),
      );
    },

    //settings
    TutupAkunIndex.routeName: (context) => const TutupAkunIndex(),

    InformasiPekerjaanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return InfoKerjaBloc(GetDataUser(userRepo));
        },
        child: const InformasiPekerjaanPage(),
      );
    },
    InformasiPribadiPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return InfoPribadiBloc(GetDataUser(userRepo));
        },
        child: const InformasiPribadiPage(),
      );
    },
    KonfirmasiPenyerahanBpkbPage.routeName: (context) =>
        const KonfirmasiPenyerahanBpkbPage(),

    InfoBankPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return InformasiBankBloc(
            GetDataUser(userRepo),
            GetRequestUseCase(userRepo),
            GetRequestV2UseCase(userRepo),
            PostRequestUseCase(userRepo),
          );
        },
        child: const InfoBankPage(),
      );
    },
    InfoBankLenderPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return InfoLenderBankBloc(
            GetRequestUseCase(userRepo),
            GetRequestV2UseCase(userRepo),
            PostRequestUseCase(userRepo),
            PostRequestV2UseCase(userRepo),
          );
        },
        child: const InfoBankLenderPage(),
      );
    },
    ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
    KonfirmasJadwalSurveyPage.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments
          as KonfirmasJadwalSurveyPage;
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return KonfirmasiJadwalSurveyBloc(
            GetAuthStateStreamUseCase(userRepository),
            PostKonfirmasiJadwalSurveyUseCase(transaksiRepository),
            GetRequestUseCase(userRepository),
          );
        },
        child: KonfirmasJadwalSurveyPage(
          idTaskPengajuan: args.idTaskPengajuan,
          idPengajuan: args.idPengajuan,
        ),
      );
    },

    //cicil emas
    CicilEmas2Page.routeName: (context) {
      return BlocProvider<CicilEmas2Bloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();
          return CicilEmas2Bloc(
            GetAuthStateStreamUseCase(userRepository),
            CicilEmasReqUseCase(transaksiRepo),
            CicilEmasValUseCase(transaksiRepo),
          );
        },
        child: const CicilEmas2Page(),
      );
    },

    UbahEmailPage.routeName: (context) {
      return BlocProvider<UbahEmailBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return UbahEmailBloc(
              GetAuthStateStreamUseCase(userRepository),
              UpdateEmailUseCase1(userRepository),
              UpdateEmailUseCase2(userRepository));
        },
        child: const UbahEmailPage(),
      );
    },
    UbahHpPage.routeName: (context) {
      return BlocProvider<UbahHpBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return UbahHpBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const UbahHpPage(),
      );
    },
    UpdateHpPage.routeName: (context) {
      return BlocProvider<UpdateHpBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return UpdateHpBloc(
            GetAuthStateStreamUseCase(userRepository),
            UpdateHpUseCase(userRepository),
            UpdateHpValidasiUseCase(userRepository),
          );
        },
        child: const UpdateHpPage(),
      );
    },
    DeepLinkPage.routeName: (context) {
      return const DeepLinkPage();
    },
    SyaratKetentuan.routeName: (context) => const SyaratKetentuan(),
    KebijakanPrivasiPage.routeName: (context) => const KebijakanPrivasiPage(),
    DokumenPdfPage.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as DokumenPdfPage;
      return DokumenPdfPage(
        title: args.title,
        link: args.link,
      );
    },
    DokumenHtmlPage.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as DokumenHtmlPage;
      return BlocProvider<DokumenBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DokumenBloc(GetDokumenUseCase(userRepository));
        },
        child: DokumenHtmlPage(
          link: args.link,
          param: args.param,
          title: args.title,
        ),
      );
    },
    ReqKodeForgotPassword.routeName: (context) {
      return BlocProvider<ForgotPasswordEmailBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return ForgotPasswordEmailBloc(
            ForgotPasswordUseCase(userRepository),
          );
        },
        child: const ReqKodeForgotPassword(),
      );
    },

    MakeNewPasswordPage.routeName: (context) {
      return BlocProvider<MakeNewPasswordBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return MakeNewPasswordBloc(
            MakeNewPasswordUseCase(userRepository),
          );
        },
        child: const MakeNewPasswordPage(),
      );
    },

    ExpiredScreen.routeName: (context) {
      return const ExpiredScreen();
    },
    HelpTemporary.routeName: (context) => const HelpTemporary(),

    VerifikasiPage.routeName: (context) {
      return BlocProvider<VerifikasiBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return VerifikasiBloc(
            VerifikasiLenderUseCase(userRepository),
          );
        },
        child: const VerifikasiPage(),
      );
    },

    SettingPageBorrower.routeName: (context) {
      return BlocProvider<SettingsBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return SettingsBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const SettingPageBorrower(),
      );
    },

    EmailDeepLinkPage.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as EmailDeepLinkPage;
      return BlocProvider<EmailDeepLinkBloc>(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return EmailDeepLinkBloc(GetAuthStateStreamUseCase(userRepo));
        },
        child: EmailDeepLinkPage(
          keys: args.keys,
          isVerifikasi: args.isVerifikasi,
        ),
      );
    },

    //lender
    RegistrasiLenderPage.routeName: (context) {
      return BlocProvider<RegisterLenderBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return RegisterLenderBloc(
            ReqOtpRegisterUseCase(userRepository),
            SendOtpRegisterUseCase(userRepository),
            SendRegisterUseCase(userRepository),
            SendPinRegisterUseCase(userRepository),
            SendEmailRegisterUseCase(userRepository),
          );
        },
        child: const RegistrasiLenderPage(),
      );
    },

    RegisterNewPage.routeName: (context) {
      return BlocProvider<RegisterNewBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return RegisterNewBloc(
            ReqOtpRegisterBorrowerUseCase(userRepository),
            SendOtpRegisterBorrowerUseCase(userRepository),
          );
        },
        child: const RegisterNewPage(),
      );
    },

    SetorDanaLenderPage.routeName: (context) {
      return BlocProvider<SetorDanaBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return SetorDanaBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetRequestUseCase(userRepository),
          );
        },
        child: const SetorDanaLenderPage(),
      );
    },

    TarikDanaPage.routeName: (context) {
      return BlocProvider<TarikDanaBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return TarikDanaBloc(
            GetAuthStateStreamUseCase(userRepository),
            TarikDanaUseCase(transaksiRepository),
            GetRequestUseCase(userRepository),
            PostRequestUseCase(userRepository),
          );
        },
        child: const TarikDanaPage(),
      );
    },

    PendanaanPage.routeName: (context) {
      return BlocProvider<PendanaanBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return PendanaanBloc(
            GetAuthStateStreamUseCase(userRepository),
            ReqOtpPendanaanUseCase(transaksiRepository),
            ValidasiOtpPendanaanUseCase(transaksiRepository),
          );
        },
        child: const PendanaanPage(),
      );
    },
    DetailRiwayatPinjamanProsesPage.routeName: (context) {
      return BlocProvider<DetailRiwayatPinjamanBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DetailRiwayatPinjamanBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const Material(
          child: DetailRiwayatPinjamanProsesPage(),
        ),
      );
    },
    AjakTemanPage.routeName: (context) {
      return BlocProvider<AjakTemanBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return AjakTemanBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const AjakTemanPage(),
      );
    },
    PortofolioDetail.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as PortofolioDetail;
      return BlocProvider<DetailPortoBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DetailPortoBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetRequestUseCase(userRepository),
            GetDokumenUseCase(userRepository),
          );
        },
        child: PortofolioDetail(
          idAgreement: args.idAgreement,
        ),
      );
    },
    NotifikasiLenderPage.routeName: (context) {
      return BlocProvider<NotifLenderBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return NotifLenderBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const NotifikasiLenderPage(),
      );
    },
    RiwayatTransaksiPage.routeName: (context) {
      return BlocProvider<RiwayatTransaksiBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return RiwayatTransaksiBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetRequestUseCase(userRepository),
            GetRiwayatTransaksiUseCase(transaksiRepository),
          );
        },
        child: const RiwayatTransaksiPage(),
      );
    },
    UbahPinLenderPage.routeName: (context) {
      return BlocProvider<UbahPinLenderBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return UbahPinLenderBloc(
            UbahPinLenderUseCase(userRepository),
            CheckPinUseCase(userRepository),
          );
        },
        child: const UbahPinLenderPage(),
      );
    },
    LupaPinPage.routeName: (context) {
      return BlocProvider<LupaPinBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return LupaPinBloc(
            GetAuthStateStreamUseCase(userRepository),
            ReqOtpForgotPinUseCase(userRepository),
            ResendOtpForgotPinUseCase(userRepository),
            ValOtpForgotPinUseCase(userRepository),
            ResetPinUseCase(userRepository),
          );
        },
        child: const LupaPinPage(),
      );
    },
    SettingsLender.routeName: (context) => const SettingsLender(),
    InfoDataLender.routeName: (context) {
      return BlocProvider<InfoLenderBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return InfoLenderBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const InfoDataLender(),
      );
    },
    CheckPinLenderPage.routeName: (context) {
      return BlocProvider<CheckPinLenderBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();

          return CheckPinLenderBloc(
            PostRequestUseCase(userRepository),
            LogoutUseCase(userRepository),
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const CheckPinLenderPage(),
      );
    },
    SimulasiPendanaanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final transaksiRepository = context.get<TransaksiRepository>();
          return SimulasiPendanaanBloc(
            SimulasiMaxiUseCase(transaksiRepository),
            SimulasiCicilanUseCase(transaksiRepository),
          );
        },
        child: const SimulasiPendanaanPage(),
      );
    },
    DetailTransaksiPage.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as int;
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return DetailTransaksiBloc(
            args,
            GetRequestUseCase(userRepository),
          );
        },
        child: const DetailTransaksiPage(),
      );
    },
    RegisRdlPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return RegisRdlBloc(
            GetAuthStateStreamUseCase(userRepository),
            RegisRdlLenderUseCase(userRepository),
          );
        },
        child: const RegisRdlPage(),
      );
    },
    PembayaranPinjamanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return PembayaranPinjamanBloc(
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const PembayaranPinjamanPage(),
      );
    },

    // dari sini udah mulai v3 bpkb
    InfoProduct.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return InfoProductBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetProdukUseCase(userRepository),
          );
        },
        child: const InfoProduct(),
      );
    },

    SimulasiCashDrivePage.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as SimulasiCashDriveParams;
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();
          return SimulasiCashDriveBLoc(
            GetAuthStateStreamUseCase(userRepository),
            SimulasiCndUseCase(transaksiRepo),
            GetMasterDataUseCase(transaksiRepo),
          );
        },
        child: SimulasiCashDrivePage(
          isPengajuan: args.isPengajuan,
        ),
      );
    },
    PengajuanCashDrivePage.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments
          as PengajuanCashDriveParams;
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();
          return PengajuanCashDriveBloc(
            GetAuthStateStreamUseCase(userRepo),
            UploadFileUseCase(transaksiRepo),
            GetMasterDataUseCase(transaksiRepo),
            PengajuanCndUseCase(transaksiRepo),
            GetHubunganKeluargaUseCase(userRepo),
          );
        },
        child: PengajuanCashDrivePage(
          params: args,
        ),
      );
    },

    HubunganKeluargaPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          final transaksiRepo = context.get<TransaksiRepository>();
          return HubunganKeluargaBloc(
            GetAuthStateStreamUseCase(userRepo),
            GetMasterDataUseCase(transaksiRepo),
            GetHubunganKeluargaUseCase(userRepo),
            PostHubunganKeluargaUseCase(userRepo),
          );
        },
        child: const HubunganKeluargaPage(),
      );
    },

    NewRegisterBorrowerPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return NewRegisterBloc(
            GetRequestUseCase(userRepo),
            GetRequestV2UseCase(userRepo),
            PostRequestUseCase(userRepo),
            RegisterBorrowerUseCase(userRepo),
          );
        },
        child: const NewRegisterBorrowerPage(),
      );
    },
    VerifikasiEmailPage.routeName: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as VerifikasiEmailPage;
      return BlocProvider(
        initBloc: (context) {
          final userRepo = context.get<UserRepository>();
          return VerifEmailBloc(
            GetRequestUseCase(userRepo),
            PostRequestUseCase(userRepo),
          );
        },
        child: VerifikasiEmailPage(email: args.email),
      );
    },

    AktivasiPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return AktivasiAkunBloc(
            GetRequestV2UseCase(userRepository),
            GetInfoBankUseCase(userRepository),
            PostDataPendukungUseCase(userRepository),
          );
        },
        child: const AktivasiPage(),
      );
    },

    KonfirmasiPinjamanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return KonfirmasiPinjamanBloc2(
            GetAuthStateStreamUseCase(userRepository),
            PostKonfirmasiValidasiOtpUseCase(transaksiRepository),
            GetRequestUseCase(userRepository),
            PostKonfirmasiPenyerahanPinjamanUseCase(transaksiRepository),
            PostRequestDocumentUseCase(userRepository),
          );
        },
        child: const KonfirmasiPinjamanPage(),
      );
    },

    //lender
    LoginLenderPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return LoginLenderBloc(
            LoginUseCase(userRepository),
          );
        },
        child: const LoginLenderPage(),
      );
    },
    HomePageLender.routeNeme: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as HomePageLender?;
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return HomeLenderBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetRequestUseCase(userRepository),
            GetBerandaUseCase(userRepository),
            LogoutUseCase(userRepository),
          );
        },
        child: HomePageLender(index: args?.index ?? 0),
      );
    },

    NewPendanaanPage.routeName: (context) {
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return NewPendanaanBloc(
            GetRequestUseCase(userRepository),
            PostRequestUseCase(userRepository),
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const NewPendanaanPage(),
      );
    },
    NewDetailPendanaanPage.routeName: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as int;
      return BlocProvider(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          return NewDetailPendanaanBloc(
            args,
            GetRequestUseCase(userRepository),
            PostRequestUseCase(userRepository),
            PostRequestDocumentUseCase(userRepository),
            GetAuthStateStreamUseCase(userRepository),
          );
        },
        child: const NewDetailPendanaanPage(),
      );
    },
    ProsesPengajuanPage.routeName: (context) {
      return BlocProvider<ProsesPengajuanBloc>(
        initBloc: (context) {
          final userRepository = context.get<UserRepository>();
          final transaksiRepository = context.get<TransaksiRepository>();
          return ProsesPengajuanBloc(
            GetAuthStateStreamUseCase(userRepository),
            GetRequestUseCase(userRepository),
            GetRiwayatTransaksiUseCase(transaksiRepository),
          );
        },
        child: const ProsesPengajuanPage(),
      );
    },
  };
}
