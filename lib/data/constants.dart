import 'package:rx_shared_preferences/rx_shared_preferences.dart';

const baseUrl = 'node-auth-081098.onrender.com';

//main
const String csDanain = '0811188291';
const String appName = 'Danain';
const String logo = 'assets/images/logo/Danain.svg';
const String footer = 'Berizin dan Diawasi';
const String primaryColor = '0xff24163F';
const String primaryColorHex = '#24663F';
const String lenderColor = '#27AE60';
const String lenderColor2 = '#27AF60';
const String borrowerColor = '#24663F';

//onboarding
const String preferensiTitle = 'Pilih Preferensi Anda';
const String preferensiSub = 'Mohon pilih preferensi sesuai tujuan Anda menggunakan Danain';
const String peminjam = 'Peminjam';
const String peminjamSub = 'Sebagai Peminjam';
const String pendana = 'Pendana';
const String pendanaSub = 'Sebagai Pendana';

//form
const String formLabelName = 'Nama Lengkap';
const String formNamePlaceholder = 'Contoh: John Doe';

const String formLabelEmail = 'Alamat Email';
const String formLabelEmail2 = 'Email';
const String formEmailPlaceHolder = 'Contoh: Johndoe@gmail.com';

const String formLabelPhone = 'Nomor Handphone';
const String formPhonePlaceHolder = 'Contoh: 08xxxxxxxxxx';
const String formPhoneDesc = 'Pastikan nomor HP yang Anda masukkan aktif';

const String formLabelReferral = 'Referal(Opsional)';
const String formReferralPlaceHolder = 'Contoh: 11232';

const String formLabelPassword = 'Kata Sandi';
const String formPasswordPlaceHolder = 'Masukan kata sandi';

const String formLabelConfirm = 'Konfirmasi Kata Sandi';
const String formConfirmPlaceHolder = 'Konfirmasi kata sandi';

const String formProvinceLabel = 'Pilih Provinsi';
const String formCityLabel = 'Pilih Kabupaten/Kota';

//button text
const String createAccount = 'Buat Akun Baru';
const String createAccount2 = 'Buat Akun';
const String registerText = 'Daftar Sekarang';
const String nextRegistText = 'Lanjut Daftar';
const String loginText = 'Masuk';
const String nextText = 'Lanjut';
const String agreeText = 'Setuju';
const String saveText = 'Simpan';
const String cancelText = 'Batal Daftar';
const String checkLocation = 'Cek Lokasi Tersedia';
const String resendEmail = 'Kirim Ulang Verifikasi';
const String changeEmailText = 'Ubah Alamat Email';
const String searchText = 'Cari';
const String count = 'Hitung';
const String totalText = 'Total';
const String resetText = 'Reset';
const String resetPw = 'Atur Ulang Kata Sandi';

//login
const String forgotPasswordHint = 'Lupa Kata Sandi?';

//forgot password
const String forgotPasswordDesc =
    'Masukkan email yang terdaftar untuk pengaturan ulang kata sandi Anda.';

const String forgotPasswordDescLender =
    'Masukkan email yang terdaftar untuk mengirimkan email pengaturan ulang kata sandi Anda.';

//email send
const String checkEmail = 'Cek Email Anda';

//create new password
const String createNPW =
    'Buat kata sandi Anda untuk menjamin keamanan saat melakukan transaksi di Danain';
const String createNPWSuccess = 'Kata Sandi Berhasil Diubah';
const String createNPWSuccessSub = 'Silakan masuk kembali menggunakan kata sandi baru Anda';

//onboarding Borrower
const String pinjamanCarouselTitle = 'Pinjaman Beragunan Emas';
const String pinjamanCarouselSubtitle =
    'Pinjaman beragunan emas dengan proses yang mudah dan aman, sebab bekerja sama dengan pergadaian swasta terpercaya';
const String cicilanCarouselTitle = 'Cicilan Emas';
const String cicilanCarouselSubtitle =
    'Cicilan emas terpercaya tanpa khawatir dengan perubahan harga dan emas aman tersimpan di mitra penyimpan emas';

//choose preference
const String chooseTitle = 'Pilih Preferensi';
const String chooseSubtitle = 'Pilih preferensi sesuai tujuan Anda menggunakan aplikasi Peminjam';
const String pinjamanCard = 'Pinjaman';
const String pinjamanCardSubtitle = 'Pinjaman dengan agunan emas';

const String cicilanCardTitle = 'Cicil Emas';
const String cicilanCardSubtitle = 'Kepemilikan emas dengan angsuran';

//preference
//cicil emas
const String cicilPreferenceTitle = 'Apa Itu Cicil Emas';
const String cicilPreferenceSubtitle =
    'Cicil emas mempermudah Anda memiliki emas untuk aset masa mendatang dengan cara dicicil tanpa khawatir dengan perubahan harga dan emas aman tersimpan di mitra penyimpan emas.';
const String cicilPreferenceTitle2 = 'Kenapa Cicil Emas';

const String cicilEmasMenu1 = 'Harga Tetap Tanpa Pengaruh Fluktuasi';
const String cicilEmasMenuSub1 = 'Harga emas yang diinginkan dapat dikunci di awal transaksi.';

const String cicilEmasMenu2 = 'Angsuran Ringan Tanpa Uang Muka';
const String cicilEmasMenuSub2 =
    'Miliki aset emas lebih terjangkau dengan angsuran ringan dan tanpa uang muka';

const String cicilEmasMenu3 = 'Pilihan Tenor Bervariasi';
const String cicilEmasMenuSub3 =
    'Tenor hingga 24 bulan yang dapat dipilih sesuai dengan kemampuan Anda.';

const String cicilEmasContent1 = 'Simulasi Cicilan';
const String cicilEmasContentSub1 = 'Hitung dan dapatkan informasi cicilan yang Anda ajukan';
const String cicilEmasContent2 = 'Jangkauan Supplier Emas';
const String cicilEmasContentSub2 = 'Hitung dan dapatkan informasi cicilan yang Anda ajukan';

//gadai emas
const String pinjamanIntroduction = 'Kenali Produk Pinjaman';
const String pinjamanDesc =
    'Danain memiliki beberapa produk pinjaman dengan agunan berupa emas dalam bentuk perhiasan atau emas batangan.';

const String pinjamanContent1 = 'Simulasi Pinjaman';
const String pinjamanContentSub1 = 'Hitung dan dapatkan informasi pinjaman yang dapat Anda terima';

const String pinjamanContent2 = 'Temukan Lokasi Penyimpan Emas';
const String pinjamanContentSub2 = 'Cari tahu mitra terdekat dari lokasi Anda saat ini';

//register
const String registerTitle = 'Buat Akun';
const String registerDesc = 'Buat akun sekarang untuk memulai pinjaman di Danain';

const String acceptSyarat1 = 'Saya menyetujui';
const String acceptSyarat2 = 'Syarat & Ketentuan Layanan';

//syarat dan ketentuan
const String scrollHint = 'Scroll ke bawah untuk menyetujui';

//register create password
const String cpTitle = 'Buat Kata Sandi';
const String cpSubtitle =
    'Buat kata sandi Anda untuk menjamin keamanan saat melakukan transaksi di Danain';

//get location
const String locationActive = 'Aktifkan Lokasi';
const String locationActiveSub =
    'Danain membutuhkan lokasi Anda untuk mendapatkan lokasi wilayah yang akurat';

//location not exist
const String locationNotExistTitle = 'Lokasi Belum Terjangkau';
const String locationNotExistSub =
    'Layanan belum tersedia di lokasi Anda. Silakan cek lokasi yang terjangkau layanan Danain';

//nearest location
const String nearestLocationTitle = 'Pilih Wilayah Terdekat';
const String nearestLocationSub = 'Pilih cakupan layanan Danain yang terdekat dengan lokasi Anda';

//change email
const String changeEmailDesc = 'Masukkan email baru untuk mengirimkan email verifikasi akun Anda.';

//save gold location
const String glTitle = 'Temukan Lokasi Mitra Penyimpan Emas';
const String glSub =
    'Temukan mitra penyimpan emas Danain yang tersedia di wilayah Anda. Penyimpan Emas merupakan pergadaian tempat menyimpan emas Anda.';

//simulasi pinjaman
const String spTitle = 'Perhitungan Taksasi Maxi 150';
const String spSub =
    'Untuk menghitung perkiraan nilai emas yang akan Anda gunakan untuk jaminan, silakan masukkan berat emas (gram) dan karat';
const String batasMaksimal = 'Batas Maksimal Pinjaman';

const String nilaiPengajuanLabel = 'Nilai Pengajuan Pinjaman';
const String jangkaWaktuLabel = 'Jangka waktu pelunasan';
const String minJangka = 'Min. 1 hari';
const String maxJangka = 'Max. 150 hari';

const String biayaAdmin = 'Biaya Admin';
const String pencairan = 'Pencairan Pinjaman';
const String bunga = 'Bunga';
const String jasaMitra = 'Fee Jasa Mitra';
const String pokok = 'Pokok';
const String totalPelunasanText = 'Total Pelunasan';
const String ratePertahun = 'Ekuivalensi Rate Pertahun';
const String ratePerbulan = 'Ekuivalensi Rate Perbulan';
const String alertSimulasi =
    'Perkiraan nilai barang dan bunga dapat berbeda dengan perhitungan di mitra penyimpan emas (pergadaian) sesuai dengan ketentuan yang berlaku.';

//simulasi cicilan
const String jenisEmas = 'Jenis Emas';
const String tambahEmas = 'Tambah Emas';
const String urlChat = 'https://wa.me/0811188291';

const String jangkaWaktuCicilan = 'Jangka Waktu Cicilan';
const String simulasiCicilanTitle = 'Simulasi Cicilan';
const String simulasiCicilanDesc =
    'Simulasi belum tersedia. Silakan pilih jenis emas dan jangka waktu cicilan';
const String alertSimulasiCicilan =
    'Rincian simulasi diatas dapat berubah sewaktu-waktu mengikuti perubahan harga emas dan ketentuan yang berlaku di Danain.';

const String cicilanPerBulanText = 'Cicilan Per Bulan';
const String pembayaranAwal = 'Pembayaran Awal';
const String cicilanAwal = 'Cicilan Awal';
const String biayaAdminText = 'Biaya Admin';

//faq
const String faq1 = 'FAQ';
const String faq2 = 'Bantuan';
const String faqDesc = 'Detail pertanyaan seputar Danain';
const String faqDanain = 'Masih bingung dengan Danain?';
const String faqHelper = 'Chat Tim Danain';

//case privy
const List<Map<String, dynamic>> casePrivyList = [
  {
    'code': '',
    'word': 'Dokumen Anda saat ini belum berhasil diverifikasi. Silakan hubungi tim kami',
    'txtUpload': '',
    'wordBottom': '',
    'mustUpload': ['']
  },
  {
    'code': 'PRVK003',
    'word':
        'Foto KTP yang Anda unggah tidak terlihat jelas. Silakan unggah kembali foto KTP Anda sesuai panduan kami untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP']
  },
  {
    'code': 'PRVD005',
    'word':
        'Foto KTP yang Anda unggah tidak terlihat jelas. Silakan unggah kembali foto KTP Anda sesuai panduan kami untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP']
  },
  {
    'code': 'KBSK012',
    'word':
        'Foto KTP yang Anda unggah tidak terlihat jelas. Silakan unggah kembali foto KTP Anda sesuai panduan kami untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP']
  },
  {
    'code': 'PRVK004',
    'word':
        'Selfie yang Anda unggah belum terlihat jelas. Silakan unggah kembali Selfie untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP']
  },
  {
    'code': 'PRVK013',
    'word':
        'Selfie yang Anda unggah belum terlihat jelas. Silakan unggah kembali Selfie untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP']
  },
  {
    'code': 'PRVK006',
    'word':
        'Foto wajah pada KTP yang Anda unggah tidak terlihat jelas. Silakan unggah dokumen pendukung berupa Surat Izin Mengemudi (SIM) untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVK012',
    'word':
        'Foto wajah pada KTP yang Anda unggah tidak terlihat jelas. Silakan unggah dokumen pendukung berupa Surat Izin Mengemudi (SIM) untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVK002',
    'word':
        'Foto KTP yang Anda unggah tidak terlihat jelas. Silakan unggah kembali foto KTP Anda sesuai panduan kami untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP untuk memastikan kebenaran identitas Anda.',
    // 'mustUpload': ['KTP']
  },
  {
    'code': 'PRVK011',
    'word':
        'Tidak terdapat tanda tangan dalam KTP yang Anda unggah. Silakan unggah dokumen pendukung berupa Surat Izin Mengemudi (SIM) untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVK017',
    'word':
        'Sebagian data pada KTP Anda tidak dapat terbaca dan foto wajah Anda pudar. Silakan unggah foto *KK* dan SIM Anda untuk melanjutkan proses verifikasi.',
    'txtUpload': 'KK dan SIM',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KK dan SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP', 'SIM']
  },
  {
    'code': 'PRVK016',
    'word':
        'Foto KTP yang Anda unggah belum terlihat jelas dan foto wajah Anda pudar. Silakan unggah foto KTP dan SIM untuk melanjutkan proses verifikasi.',
    'txtUpload': 'KTP dan SIM',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KTP dan SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP', 'SIM']
  },
  {
    'code': 'PRVK019',
    'word':
        'Foto KTP yang Anda unggah rusak sehingga tidak dapat terbaca. Silakan unggah foto KTP dan KK Anda agar registrasi dapat diproses',
    'txtUpload': 'KTP dan KK',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KTP dan KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP', 'KK']
  },
  {
    'code': 'PRVK015',
    'word':
        'Sebagian data pada KTP Anda tidak dapat terbaca atau kurang lengkap.  Silakan unggah dokumen pendukung berupa Kartu Keluarga (KK) untuk melanjutkan proses verifikasi.',
    'txtUpload': 'KK',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KK dan SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVK018',
    'word':
        'Sebagian data pada KTP Anda tidak dapat terbaca atau kurang lengkap.  Silakan unggah dokumen pendukung berupa Kartu Keluarga (KK) untuk melanjutkan proses verifikasi.',
    'txtUpload': 'KK',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KK dan SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVK008',
    'word':
        'Masa berlaku KTP yang Anda unggah sudah habis. Silakan unggah foto KTP yang berlaku atau KK agar registrasi dapat diproses',
    'txtUpload': 'KTP atau KK',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali KTP yang berlaku atau foto KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTPKK']
  },
  {
    'code': 'PRVS003',
    'word':
        'Foto selfie yang Anda unggah tidak sesuai dengan panduan kami. Silakan unggah foto selfie kembali untuk melanjutkan proses verifikasi.',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali Selfie untuk memastikan kebenaran identitas Anda.',
    'txtUpload': 'Kembali Selfie',
    'mustUpload': ['Selfie']
  },
  {
    'code': 'PRVS006',
    'word':
        'Foto selfie yang Anda unggah tidak sesuai dengan panduan kami. Silakan unggah foto selfie kembali untuk melanjutkan proses verifikasi.',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['Selfie']
  },
  {
    'code': 'PRVS001',
    'word':
        'Foto selfie yang Anda unggah tidak sesuai dengan panduan kami. Silakan unggah foto selfie kembali untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['Selfie']
  },
  {
    'code': 'PRVS004',
    'word':
        'Anda belum mengunggah Selfie. Silakan unggah Selfie untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Kembali Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['Selfie']
  },
  {
    'code': 'PRVS002',
    'word':
        'Selfie yang Anda unggah tidak sesuai dengan foto di KTP. Silakan unggah Selfie memegang KTP  untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Selfie dan KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah Selfie dengan KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['Selfie Dengan KTP']
  },
  {
    'code': 'PRVN004',
    'word':
        'NIK tidak terdaftar pada data Dukcapil. Silakan unggah foto Kartu Keluarga (KK) Anda untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan dokumen pendukung  Anda berupa KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVN005',
    'word':
        'Data NIK Anda tidak sesuai dengan data di Dukcapil.  Silakan unggah foto Kartu Keluarga (KK) Anda untuk melanjutkan proses verifikasi.',
    'txtUpload': 'Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan dokumen pendukung  Anda berupa KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVD001',
    'word':
        'Anda belum mengunggah foto KTP dan Selfie. Silakan unggah KTP dan Selfie Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali KTP dan Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali  KTP dan Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP', 'Selfie']
  },
  {
    'code': 'PRVD002',
    'word':
        'Anda belum mengunggah foto KTP dan Selfie. Silakan unggah KTP dan Selfie Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali KTP dan Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali  KTP dan Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KTP', 'Selfie']
  },
  {
    'code': 'PRVD007',
    'word':
        'Sebagian data pada KTP Anda tidak dapat terbaca dan Selfie yang Anda unggah belum terlihat jelas. Silakan unggah KK dan Selfie Anda agar registrasi dapat diproses',
    'txtUpload': 'KK dan Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KK dan Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK', 'Selfie']
  },
  {
    'code': 'PRVD009',
    'word':
        'Data NIK Anda tidak sesuai dengan data di Dukcapil dan Selfie yang Anda unggah belum terlihat jelas. Silakan unggah KK dan Selfie Anda agar registrasi dapat diproses',
    'txtUpload': 'KK dan Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah KK dan Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK', 'Selfie']
  },
  {
    'code': 'PRVD013',
    'word':
        'Foto wajah pada KTP Anda pudar dan Selfie yang Anda unggah belum terlihat jelas. Silakan unggah SIM dan Selfie Anda agar registrasi dapat diproses',
    'txtUpload': 'SIM dan Selfie',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah SIM dan Selfie untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM', 'Selfie']
  },
  {
    'code': 'PRVP001',
    'word':
        'Tidak terdeteksi KK dalam foto yang Anda unggah. Silakan unggah kembali foto KK Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVP003',
    'word':
        'Tidak terdeteksi KK dalam foto yang Anda unggah. Silakan unggah kembali foto KK Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVP002',
    'word':
        'Foto KK yang Anda unggah belum terlihat jelas. Silakan unggah kembali foto KK Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa KK untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['KK']
  },
  {
    'code': 'PRVP005',
    'word':
        'Foto SIM yang Anda unggah belum terlihat jelas. Silakan unggah kembali foto SIM Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVP015',
    'word':
        'Foto SIM yang Anda unggah tidak sesuai dengan data KTP Anda. Silakan unggah kembali foto SIM Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVP012',
    'word':
        'Foto SIM yang Anda unggah tidak sesuai dengan ketentuan. Silakan unggah kembali foto SIM Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVP004',
    'word':
        'Tidak terdeteksi SIM dalam foto yang Anda unggah. Silakan unggah kembali foto SIM Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVP006',
    'word':
        'Tidak terdeteksi SIM dalam foto yang Anda unggah. Silakan unggah kembali foto SIM Anda agar registrasi dapat diproses',
    'txtUpload': 'Kembali Dokumen Pendukung',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah kembali dokumen pendukung Anda berupa SIM untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['SIM']
  },
  {
    'code': 'PRVP014',
    'word':
        'Foto wajah pada KTP dan dokumen pendukung belum terlihat jelas. Silakan unggah Selfie memegang KTP agar registrasi dapat diproses',
    'txtUpload': 'Selfie dengan KTP',
    'wordBottom':
        'Mohon maaf kami membutuhkan Anda untuk mengunggah Selfie dengan KTP untuk memastikan kebenaran identitas Anda.',
    'mustUpload': ['Selfie Dengan KTP']
  },
];

//panduan
const String buttonPanduan = 'Ambil Foto';

const String panduanKtpTitle = 'Panduan Unggah KTP';
const List<String> panduanKtp = [
  'Pastikan Anda Mengunggah foto KTP asli. Bukan hasil scan atau fotokopi.',
  'Pastikan KTP terlihat jelas dalam kotak foto dan tidak blur.',
  'Informasi pada KTP harus terlihat jelas (tidak tergores/terkelupas).',
  'Foto ktp harus terlihat jelas (tidak tergores/terkelupas).',
];

const String panduanKkTitle = 'Panduan Unggah KK';
const List<String> panduanKk = [
  'Pastikan Anda Mengunggah foto KK asli. Bukan hasil scan atau fotokopi.',
  'Data pada dokumen dapat terbaca dengan jelas dan utuh.',
  'Data anda terdapat pada KK yang diunggah.',
  'Terdapat tanda tangan pengesahan dari dinas yang mengeluarkan dokumen.',
];

const String panduanSelfieTitle = 'Panduan Unggah Selfie';
const List<String> panduanSelfie = [
  'Pastikan wajah anda terlihat dengan pencahayaan yang cukup, tidak buram dan tidak gelap.',
  'Pastikan hanya terdapat 1 wajah dalam frame foto dan diambil secara close up.',
  'Pastikan area wajah terlihat jelas tanpa menggunakan aksesoris (kacamata, masker, dll).',
];

const String panduanSelfieKTPTitle = 'Panduan Unggah Selfie dengan KTP';
const List<String> panduanSelfieKTP = [
  'Pastikan Anda mengambil selfie dengan memegang KTP pada bingkai yang disediakan.',
  'Pastikan foto mendapatkan pencahayaan yang cukup, tidak buram dan tidak gelap.',
  'Pastikan semua informasi pada KTP terlihat jelas.',
];

const String panduanSimTitle = 'Panduan Unggah Sim';
const List<String> panduanSim = [
  'Pastikan Anda mengunggah foto SIM asli. Bukan hasil scan atau fotokopi.',
  'Pastikan SIM terlihat jelas dalam bingkai foto dan tidak blur.',
  'Nama pada SIM sesuai dengan nama pada KTP/E-KTP Anda.',
  'Dapat memenuhi kelengkapan data pada KTP seperti foto wajah dan informasi pendukung.'
];

// list emas dummy
const List<Map<String, dynamic>> listEmasDummy = [
  {
    'idJenisEmas': 1,
    'id': 1,
    'image': 'assets/images/simulasi/antam.svg',
    'varian': 'Antam - 0,5 gr',
    'harga': 540000,
    'stok': 15
  },
  {
    'idJenisEmas': 1,
    'id': 2,
    'image': 'assets/images/simulasi/antam.svg',
    'varian': 'Antam - 1 gr',
    'harga': 1040000,
    'stok': 20
  },
  {
    'idJenisEmas': 1,
    'id': 3,
    'image': 'assets/images/simulasi/antam.svg',
    'varian': 'Antam - 2 gr',
    'harga': 2010000,
    'stok': 14
  },
  {
    'idJenisEmas': 1,
    'id': 4,
    'image': 'assets/images/simulasi/antam.svg',
    'varian': 'Antam - 5 gr',
    'harga': 4010000,
    'stok': 16
  },
  {
    'idJenisEmas': 1,
    'id': 5,
    'image': 'assets/images/simulasi/antam.svg',
    'varian': 'Antam - 10 gr',
    'harga': 9010000,
    'stok': 0
  },
  {
    'idJenisEmas': 2,
    'id': 1,
    'image': 'assets/images/simulasi/lotus.svg',
    'varian': 'Lotus - 0,5 gr',
    'harga': 540000,
    'stok': 20
  },
  {
    'idJenisEmas': 2,
    'id': 2,
    'image': 'assets/images/simulasi/lotus.svg',
    'varian': 'Lotus - 1 gr',
    'harga': 1040000,
    'stok': 20
  },
  {
    'idJenisEmas': 2,
    'id': 3,
    'image': 'assets/images/simulasi/lotus.svg',
    'varian': 'Lotus - 2 gr',
    'harga': 2010000,
    'stok': 20
  },
  {
    'idJenisEmas': 2,
    'id': 4,
    'image': 'assets/images/simulasi/lotus.svg',
    'varian': 'Lotus - 5 gr',
    'harga': 4010000,
    'stok': 20
  },
  {
    'idJenisEmas': 2,
    'id': 5,
    'image': 'assets/images/simulasi/lotus.svg',
    'varian': 'Lotus - 10 gr',
    'harga': 9010000,
    'stok': 20
  },
];

const List<Map<String, dynamic>> dataReviewDummy = [
  {
    'nama_user': 'Sip Med',
    'rating': 4,
    'ulasan': 'Lorem ipsum Dolor Sit Amet sadasdasdasdasd asdhasdhajsfasgdasfasdlafasdhafsdasd',
    'tanggal': '20 Nov 2020'
  },
  {'nama_user': 'Alice', 'rating': 5, 'ulasan': 'Great product!', 'tanggal': '15 Dec 2020'},
  {
    'nama_user': 'Bob',
    'rating': 3,
    'ulasan': "It's okay, could be better",
    'tanggal': '5 Jan 2021'
  },
  {
    'nama_user': 'Eve',
    'rating': 2,
    'ulasan': 'Not satisfied with the quality',
    'tanggal': '10 Feb 2021'
  },
  {'nama_user': 'Charlie', 'rating': 4, 'ulasan': 'Impressive!', 'tanggal': '25 Mar 2021'},
  {'nama_user': 'David', 'rating': 5, 'ulasan': 'Absolutely fantastic', 'tanggal': '1 Apr 2021'},
  {'nama_user': 'Grace', 'rating': 4, 'ulasan': 'Good value for money', 'tanggal': '20 May 2021'},
  {'nama_user': 'Hannah', 'rating': 3, 'ulasan': 'Average experience', 'tanggal': '15 Jun 2021'},
  {'nama_user': 'Ivy', 'rating': 5, 'ulasan': 'Exceeded my expectations', 'tanggal': '10 Jul 2021'},
  {'nama_user': 'Kevin', 'rating': 4, 'ulasan': 'Satisfactory', 'tanggal': '5 Aug 2021'},
  {'nama_user': 'Liam', 'rating': 3, 'ulasan': 'Could be improved', 'tanggal': '20 Sep 2021'},
  {'nama_user': 'Mia', 'rating': 4, 'ulasan': 'Happy with the purchase', 'tanggal': '15 Oct 2021'},
  {'nama_user': 'Nora', 'rating': 5, 'ulasan': 'Top-notch quality', 'tanggal': '10 Nov 2021'},
  {'nama_user': 'Olivia', 'rating': 4, 'ulasan': 'Impressed', 'tanggal': '5 Dec 2021'},
  {'nama_user': 'Peter', 'rating': 2, 'ulasan': 'Not recommended', 'tanggal': '20 Jan 2022'},
  {'nama_user': 'Quinn', 'rating': 4, 'ulasan': 'Good choice', 'tanggal': '15 Feb 2022'},
  {'nama_user': 'Rachel', 'rating': 3, 'ulasan': 'Mediocre', 'tanggal': '10 Mar 2022'},
  {'nama_user': 'Sam', 'rating': 4, 'ulasan': 'Satisfied customer', 'tanggal': '5 Apr 2022'},
  {'nama_user': 'Tom', 'rating': 5, 'ulasan': 'Absolutely amazing', 'tanggal': '20 May 2022'},
  {'nama_user': 'Uma', 'rating': 4, 'ulasan': 'Good value for the price', 'tanggal': '15 Jun 2022'},
  {'nama_user': 'Vera', 'rating': 3, 'ulasan': 'Average product', 'tanggal': '10 Jul 2022'},
  {
    'nama_user': 'Walter',
    'rating': 4,
    'ulasan': 'Happy with the purchase',
    'tanggal': '5 Aug 2022'
  },
  {'nama_user': 'Xander', 'rating': 2, 'ulasan': 'Not what I expected', 'tanggal': '20 Sep 2022'},
  {'nama_user': 'Yara', 'rating': 4, 'ulasan': 'Impressive', 'tanggal': '15 Oct 2022'},
  {'nama_user': 'Zoe', 'rating': 5, 'ulasan': 'Outstanding!', 'tanggal': '10 Nov 2022'},
  {'nama_user': 'Aaron', 'rating': 4, 'ulasan': 'Great experience', 'tanggal': '5 Dec 2022'},
  {'nama_user': 'Bella', 'rating': 3, 'ulasan': 'Could be better', 'tanggal': '20 Jan 2023'},
  {'nama_user': 'Caleb', 'rating': 4, 'ulasan': 'Satisfactory', 'tanggal': '15 Feb 2023'},
  {'nama_user': 'Diana', 'rating': 5, 'ulasan': 'Excellent', 'tanggal': '10 Mar 2023'},
  {'nama_user': 'Ethan', 'rating': 4, 'ulasan': 'Good value for money', 'tanggal': '5 Apr 2023'},
  {'nama_user': 'Fiona', 'rating': 3, 'ulasan': 'Average quality', 'tanggal': '20 May 2023'},
  {
    'nama_user': 'George',
    'rating': 4,
    'ulasan': 'Impressed with the product',
    'tanggal': '15 Jun 2023'
  },
  {
    'nama_user': 'Hazel',
    'rating': 4,
    'ulasan': 'Happy with the purchase',
    'tanggal': '10 Jul 2023'
  },
  {'nama_user': 'Isla', 'rating': 5, 'ulasan': 'Amazing!', 'tanggal': '5 Aug 2023'},
  {'nama_user': 'Jack', 'rating': 4, 'ulasan': 'Satisfied customer', 'tanggal': '20 Sep 2023'},
  {'nama_user': 'Kylie', 'rating': 3, 'ulasan': 'Could be improved', 'tanggal': '15 Oct 2023'},
  {'nama_user': 'Liam', 'rating': 4, 'ulasan': 'Good experience', 'tanggal': '10 Nov 2023'},
  {'nama_user': 'Mia', 'rating': 5, 'ulasan': 'Absolutely fantastic', 'tanggal': '5 Dec 2023'},
  {'nama_user': 'Noah', 'rating': 4, 'ulasan': 'Impressive!', 'tanggal': '20 Jan 2024'},
  {'nama_user': 'Olivia', 'rating': 3, 'ulasan': 'Average', 'tanggal': '15 Feb 2024'},
  {'nama_user': 'Parker', 'rating': 4, 'ulasan': 'Great value for money', 'tanggal': '10 Mar 2024'},
  {'nama_user': 'Quinn', 'rating': 4, 'ulasan': 'Satisfactory', 'tanggal': '5 Apr 2024'},
  {'nama_user': 'Rachel', 'rating': 5, 'ulasan': 'Exceptional!', 'tanggal': '20 May 2024'},
  {'nama_user': 'Sam', 'rating': 4, 'ulasan': 'Good purchase', 'tanggal': '15 Jun 2024'},
  {'nama_user': 'Tom', 'rating': 3, 'ulasan': 'Average experience', 'tanggal': '10 Jul 2024'},
  {'nama_user': 'Uma', 'rating': 4, 'ulasan': 'Happy with the product', 'tanggal': '5 Aug 2024'},
  {'nama_user': 'Vera', 'rating': 4, 'ulasan': 'Impressive quality', 'tanggal': '20 Sep 2024'},
  {'nama_user': 'Walter', 'rating': 5, 'ulasan': 'Outstanding!', 'tanggal': '15 Oct 2024'}
];

const List<Map<String, dynamic>> dataCicilDummy = [
  {
    'id_cicilan': 1231,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1000000,
    'tanggal': '11 November 2022',
    'status': 1,
    'jangka_waktu': 12,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
  {
    'id_cicilan': 1232,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1000000,
    'tanggal': '13 November 2022',
    'status': 2,
    'jangka_waktu': 6,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
  {
    'id_cicilan': 1234,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1000000,
    'tanggal': '11 Agustus 2022',
    'status': 4,
    'jangka_waktu': 24,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
  {
    'id_cicilan': 1233,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1000000,
    'tanggal': '11 Juli 2022',
    'status': 3,
    'jangka_waktu': 6,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
  {
    'id_cicilan': 1236,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1000000,
    'tanggal': '11 Oktober 2022',
    'status': 5,
    'jangka_waktu': 6,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
  {
    'id_cicilan': 1237,
    'nama': 'Cicil Emas Logam Mulia',
    'total_pembayaran': 1100000,
    'tanggal': '11 Desember 2022',
    'status': 1,
    'jangka_waktu': 6,
    'gambar': 'assets/images/simulasi/antam.svg',
    'nama_toko': 'Toko Emas Semar Nusantara',
    'gambar_toko': 'assets/images/simulasi/lotus.svg'
  },
];

const List<Map<String, dynamic>> angsuranEmasDummy = [
  {'nama': 'Angsuran ke-1', 'tanggal': '11 Des 2022', 'total_bayar': 753000, 'status': 3},
  {'nama': 'Angsuran ke-2', 'tanggal': '11 Jan 2023', 'total_bayar': 753000, 'status': 2},
  {'nama': 'Angsuran ke-3', 'tanggal': '11 Feb 2023', 'total_bayar': 753000, 'status': 4},
  {'nama': 'Angsuran ke-4', 'tanggal': '11 Mar 2023', 'total_bayar': 753000, 'status': 5},
  {'nama': 'Angsuran ke-5', 'tanggal': '11 Apr 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-6', 'tanggal': '11 Mei 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-7', 'tanggal': '11 Jun 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-8', 'tanggal': '11 Jul 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-9', 'tanggal': '11 Aug 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-10', 'tanggal': '11 Sep 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-11', 'tanggal': '11 Okt 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-12', 'tanggal': '11 Nov 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-13', 'tanggal': '11 Des 2023', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-14', 'tanggal': '11 Jan 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-15', 'tanggal': '11 Feb 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-16', 'tanggal': '11 Mar 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-17', 'tanggal': '11 Apr 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-18', 'tanggal': '11 Mei 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-19', 'tanggal': '11 Jun 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-20', 'tanggal': '11 Jul 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-21', 'tanggal': '11 Aug 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-22', 'tanggal': '11 Sep 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-23', 'tanggal': '11 Okt 2024', 'total_bayar': 753000, 'status': 1},
  {'nama': 'Angsuran ke-24', 'tanggal': '11 Nov 2024', 'total_bayar': 753000, 'status': 1},
];

const List<String> tutupAkunList = [
  'Pastikan Anda tidak memiliki pinjaman aktif dan angsuran saat ini.',
  'Anda akan diberikan waktu 3 hari kerja untuk pembatalan penutupan akun.',
  'Setelah penutupan akun disetujui, Anda tidak dapat mengakses akun peminjam Anda.'
];

const List<Map<String, dynamic>> statusKawinList = [
  {'id': 1, 'nama': 'BELUM KAWIN'},
  {'id': 2, 'nama': 'KAWIN'},
  {'id': 3, 'nama': 'DUDA'},
  {'id': 4, 'nama': 'JANDA'}
];

const List<Map<String, dynamic>> pendidikanList = [
  {'id': 1, 'nama': 'SD'},
  {'id': 2, 'nama': 'SMP'},
  {'id': 3, 'nama': 'SMA'},
  {'id': 4, 'nama': 'DIPLOMA'},
  {'id': 5, 'nama': 'S1'},
  {'id': 6, 'nama': 'S2'},
  {'id': 7, 'nama': 'S3'},
];
const List<Map<String, dynamic>> agamaList = [
  {'id': 1, 'nama': 'ISLAM'},
  {'id': 2, 'nama': 'KRISTEN'},
  {'id': 3, 'nama': 'KATOLIK'},
  {'id': 4, 'nama': 'BUDHA'},
  {'id': 5, 'nama': 'HINDU'},
  {'id': 6, 'nama': 'KONG HU CHU'},
  {'id': 7, 'nama': 'LAINNYA'}
];
const List<Map<String, dynamic>> statusRumahList = [
  {'id': 1, 'nama': 'Milik Sendiri'},
  {'id': 2, 'nama': 'Milik Keluarga'},
  {'id': 3, 'nama': 'Milik Kantor'},
  {'id': 4, 'nama': 'Sewa/kontrak'}
];

const List<Map<String, dynamic>> pekerjaanList = [
  {'id': '001', 'nama': 'Pegawai Swasta'},
  {'id': '002', 'nama': 'Pegawai BUMN'},
  {'id': '003', 'nama': 'Pegawai Negeri'},
  {'id': '004', 'nama': 'TNI / POLRI'},
  {'id': '005', 'nama': 'Tidak Memiliki Penghasilan Tetap'},
  {'id': '006', 'nama': 'Pensiunan'},
  {'id': '007', 'nama': 'Wiraswasta'},
  {'id': '008', 'nama': 'Profesional'}
];
const List<Map<String, dynamic>> jabatanList = [
  {'id': '00', 'nama': 'Tidak Bekerja'},
  {'id': '04', 'nama': 'Kepala Wilayah'},
  {'id': '05', 'nama': 'Manager'},
  {'id': '06', 'nama': 'Kepala Bagian'},
  {'id': '07', 'nama': 'Kepala Seksi '},
  {'id': '08', 'nama': 'Staff'},
  {'id': '09', 'nama': 'Non Staff'},
  {'id': '20', 'nama': 'Ibu Rumah Tangga'},
  {'id': '21', 'nama': 'Pelajar'},
  {'id': '22', 'nama': 'Pemilik'}
];
const List<Map<String, dynamic>> sumberDanaList = [
  {'id': 1, 'nama': 'Gaji / Upah'},
  {'id': 2, 'nama': 'Hasil Investasi'},
  {'id': 3, 'nama': 'Hasil Usaha'},
  {'id': 4, 'nama': 'Fee'},
  {'id': 5, 'nama': 'Orang Tua / Suami / Anak'}
];
const List<Map<String, dynamic>> penghasilanBulananList = [
  {'id': 1, 'nama': '< Rp 5.000.000'},
  {'id': 2, 'nama': 'Rp. 5.000.000 - 15.000.000'},
  {'id': 3, 'nama': 'Rp. 15.000.000 - 30.000.000'},
  {'id': 4, 'nama': 'Rp. 30.000.000 - 50.000.000'},
  {'id': 5, 'nama': '> Rp. 50.000.000'}
];
const List<Map<String, dynamic>> tujuanPendanaanList = [
  {'id': 1, 'nama': 'Persiapan hari tua'},
  {'id': 2, 'nama': 'Rencana pendidikan anak'},
  {'id': 3, 'nama': 'Passive income'},
  {'id': 4, 'nama': 'Dana cadangan'},
];
const List<Map<String, dynamic>> bidangUsahaList = [
  {'id': 1, 'nama': 'PERTANIAN, PETERNAKAN, PERIKANAN DAN KEHUTANAN'},
  {'id': 2, 'nama': 'PERTAMBANGAN & PENGGALIAN'},
  {'id': 3, 'nama': 'INDUSTRI PENGOLAHAN'},
  {'id': 4, 'nama': 'LISTRIK, AIR, GAS & KONSTRUKSI'},
  {'id': 5, 'nama': 'PERDAGANGAN'},
  {'id': 6, 'nama': 'AKOMODASI, MAKANAN MINUMAN, KOMUNIKASI & TRANSPORTASI'},
  {'id': 7, 'nama': 'KEUANGAN, REAL ESTATE, DAN PERSEWAAN'},
  {'id': 8, 'nama': 'JASA '},
  {'id': 9, 'nama': 'PEGAWAI PEMERINTAHAN'}
];

Future<int?> getUserStatus() async {
  final prefs = RxSharedPreferences.getInstance();
  return await prefs.getInt('user_status');
}

// final firebaseApp = Firebase.app();
// final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://danain-70baa-default-rtdb.asia-southeast1.firebasedatabase.app/');

const Map<String, dynamic> setorDana = {
  'BCA': {
    'ATM BCA': [
      'Masukkan kartu ATM, lalu masukkan PIN',
      'Pilih Menu "TRANSAKSI LAINNYA"',
      'Pilih Menu "Ke Rekening BCA Virtual Account"',
      'Masukkan Nomor Virtual Account Kamu',
      'Masukkan Jumlah Dana',
      'Validasi Pembayaran Anda',
      'Setor Dana Selesai'
    ],
    'M-BCA': [
      'Lakukan Log in pada aplikasi BCA mobile',
      'Pilih “m-BCA” masukan kode akses m-BCA',
      'Pilih “m-Transfer”',
      'Pilih “BCA Virtual Account”',
      'Masukkan Nomor Virtual Account Kamu',
      'Masukkan Jumlah Dana',
      'Masukkan PIN M-BCA',
      'Setor Dana Selesai'
    ],
    'Klik BCA': [
      'Lakukan Log in pada aplikasi KlikBCA Individual',
      'Masukkan User ID dan PIN',
      'Pilih “Transfer Dana”',
      'Pilih “Transfer ke BCA Virtual Account”',
      'Masukkan Nomor Virtual Account Kamu',
      'Masukkan Jumlah Dana',
      'Masukkan PIN M-BCA',
      'Setor Dana Selesai'
    ]
  },
  'BNI': {
    'ATM BNI': [
      'Masukkan kartu ATM, lalu masukkan PIN',
      'Pilih Menu "Menu Lainnya"',
      'Pilih Menu "Transfer"',
      'Pilih "Virtual Account Biling"',
      'Masukkan Nomor Virtual Account Kamu',
      'Tagihan yang harus dibayarkan akan muncul pada layar konfirmasi',
      'Validasi Pembayaran Anda',
      'Setor Dana Selesai'
    ],
    'Mobile Banking BNI': [
      'Lakukan Log in pada aplikasi Mobile Banking BNI',
      'Pilih “Transfer”',
      'Pilih “Virtual Account Billing”, kemudian pilih rekening debet',
      'Masukkan Nomor Virtual Account Kamu pada menu "Input Baru"',
      'Tagihan yang harus dibayarkan akan muncul pada layar konfirmasi',
      'Konfirmasi transaksi dan masukkan password transaksi',
      'Setor Dana Selesai'
    ],
    'Internet Banking BNI': [
      'Lakukan Log in pada aplikasi Internet Banking BNI',
      'Pilih “Transfer”',
      'Pilih “Virtual Account Billing”',
      'Masukkan Nomor Virtual Account Kamu, lalu pilih rekening debet. kemudian tekan lanjut',
      'Tagihan yang harus dibayarkan akan muncul pada layar konfirmasi',
      'Masukkan Kode Otentikasi Token',
      'Setor Dana Selesai'
    ],
  },
  'AtmBersama': {
    'ATM Bersama': [
      'Masukkan kartu ATM, lalu masukkan PIN',
      'Silakan pilih “Transaksi Lainnya”',
      'Pilih “Transfer”',
      'Pilih “transfer ke Bank Lain”',
      'Masukkan kode bank BNI (009) dan nomor “Virtual Account BNI” kamu',
      'Masukkan nominal transfer sesuai tagihan Anda',
      'Konfirmasi rincian Anda akan tampil di layar, kemudian tekan “ya” untuk melanjutkan',
      'Transaksi Anda selesai'
    ]
  },
  'ATM Prima': {
    'ATM Prima': [
      'Masukkan kartu ATM, lalu masukkan PIN',
      'Silakan pilih menu “Transfer”',
      'Pilih “Transfer ke Bank Lain”',
      'Masukkan kode bank BNI (009)',
      'Masukkan jumlah yang ingin di transfer',
      'Masukkan nomor “Virtual Account BNI” Kamu',
      'Pilih tabungan/Giro',
      'Tekan tombol benar jika sudah sesuai',
      'Konfirmasi transaksi telah berhasil'
    ]
  },
  'ATM Alto': {
    'ATM Alto': [
      'Masukkan kartu ATM, lalu masukkan PIN',
      'Silakan pilih menu “Transfer”',
      'Pilih “Bank Lainnya”',
      'Masukkan kode bank BNI (009)',
      'Masukkan nomor “Virtual Account BNI” Kamu',
      'Masukkan nominal yang ingin di transfer',
      'Tekan tombol benar jika sudah sesuai',
      'Konfirmasi transaksi telah berhasil'
    ]
  }
};

List<String> tarikDanaSyarat = [
  'Penarikan dana pada hari Jum’at, Sabtu dan Minggu akan ditransfer ke rekening Anda di hari Senin',
  'Penarikan pada hari Senin dan Selasa, dana akan ditransfer di hari Rabu',
  'Penarikan pada hari Rabu dan Kamis, dana akan ditransfer di hari Jumat',
  'Pangajuan proses penarikan dana disarankan sebelum pukul 22.00. Setelah waktu tersebut, penarikan dana dihitung hari setelahnya'
];

const List<String> definisiAjakTemanList = [
  'AJAK TEMAN adalah program marketing yang memungkinkan orang atau badan hukum menjadi perantara/mediator bagi Danain dalam meningkatkan jumlah Pendananya.',
  'Representatif Danain adalah perorangan atau badan hukum yang bekerjasama dengan Danain untuk melakukan aktivitas-aktivitas mereferensikan atau mengajak calon Pendana menjadi Pendana baru di platform dan atas upayanya tersebut mendapatkan sejumlah keuntungan berupa reward.',
  'Calon Pendana adalah orang atau badan hukum yang belum menjadi Pendana di platform.',
  'Pendana baru adalah Pendana, baik individu atau badan hukum yang didapatkan dari aktivitas yang dilakukan oleh Representatif Danain.',
  'Reward adalah sejumlah uang yang diterima Representatif Danain atas keberhasilan upayanya sebagai Representatif Danain, sebagaimana dijelaskan dalam poin 2 di atas.',
  'Nomor referensi adalah sebuah nomor yang secara otomatis diterbitkan oleh platform dan bersifat unik karena menunjuk kepada satu Representatif Danain saja.',
];

const List<String> caraKerjaList = [
  'Representatif Danain wajib mendaftarkan diri di platform sebagai Pendana dan oleh karenanya, semua syarat dan ketentuan sebagai pengguna platform berlaku dan mengikat sebagai satu kesatuan dengan syarat dan  ketentuan ini.',
  'Representatif Danain akan mendapatkan nomor referensi dari platform dan nomor referensi tersebut bisa dibuka oleh calon Pendana yang mendapatkannya.',
  'Representatif Danain dalam melakukan aktivitasnya memberikan nomor referensi tersebut ke calon Pendana, di mana bila nomor referensi  tersebut dibuka, maka calon Pendana bisa melakukan pendaftaran menjadi Pendana baru di platform.',
  'Platform secara otomatis akan mencatat Pendana baru yang dimaksud dalam poin 3 di atas sebagai Pendana baru yang didapatkan oleh Representatif Danain yang memberikan nomor referensi  tersebut.',
  'Reward yang didapatkan oleh Representatif Danain dihitung dari hasil pendanaan yang dilakukan oleh Pendana baru sebagaimana dijelaskan dalam poin 4 di atas berturut turut selama satu tahun kalender sejak hari pertama Pendana baru tersebut melakukan registrasi sebagai Pendana di platform.',
  'Besarnya reward adalah 5% dari imbal hasil atau bunga yang didapatkan oleh Pendana baru dari hasil pendanaannya yang telah dilunasi oleh peminjam.',
  'Representatif Danain menyetujui bahwa setelah satu tahun dari tanggal Pendana baru melakukan registrasi, maka atas hasil pendanaan yang sedang atau akan dilakukan oleh Pendana baru, Representatif Danain tidak mendapatkan reward lagi. ',
  'Representatif Danain menyetujui bahwa perusahaan berhak melakukan perubahan-perubahan atas ketentuan dalam poin 5, 6 dan 7 di atas, atas pertimbangan perusahaan dan mengikat bagi semua pihak. ',
  'Representatif Danain berjanji dalam melakukan aktivitasnya akan menjunjung tinggi norma-norma yang berlaku, tidak memberi informasi yang menyesatkan, melainkan berpatokan dengan segala informasi yang disediakan di platform.',
];

const List<String> laranganAjakTeman = [
  'Representatif Danain di dalam melakukan aktivitas ini dilarang menyebarkan berita-berita bohong, informasi-informasi bohong, dan semua upaya tipu daya, baik secara langsung atau tidak langsung mengatasnamakan perusahaan, platform, direksi, komisaris, karyawan atau rekanannya sedemikian rupa, sehingga menggerakkan orang lain, calon Pendana atau Pendana baru untuk mengikuti semua perintah dan kemauannya.',
  'Representatif Danain di dalam melakukan aktivitas ini dilarang menerima uang, cek, giro atau metode pembayaran lainnya dari calon Pendana dan atau Pendana baru atau dari pihak manapun. Semua transaksi keuangan wajib melalui platform. Segala transaksi di luar platform bukan merupakan tanggung jawab perusahaan.',
  'Representatif Danain dalam melakukan aktivitasnya ini dilarang meminta imbalan dalam bentuk apapun kepada calon Pendana, Pendana baru dan atau Pendana lainnya. ',
  'Representatif Danain dalam melakukan aktivitas ini dilarang menjanjikan tambahan imbalan, atau keuntungan lainnya di luar ketentuan yang diatur di platform kepada calon Pendana dan atau Pendana baru. ',
  'Representatif Danain dalam melakukan aktivitas ini dilarang mengaku sebagai karyawan, pejabat atau pihak internal perusahaan.',
  'Representatif Danain dalam melakukan aktivitasnya dilarang menggunakan kata atau rangkaian kata berunsur SARA, Politik, ataupun kata atau rangkaian kata di luar norma kewajaran.'
];

const String pembacaanSyaratKetentuan =
    'Syarat dan ketentuan ini telah dibaca dan dimengerti oleh Representatif  Danain dan berjanji mematuhi semua syarat dan ketentuan ini.';

const List<String> bulanList = [
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];
