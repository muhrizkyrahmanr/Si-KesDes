class AnakModel{
  int? nik;
  String? nama;
  String? jenis_kelamin;
  String? tanggal_lahir;
  String? nik_keluarga;
  String? nama_orang_tua;
  String? berat_badan;
  String? tinggi_badan;
  String? berat_badan_akhir;
  String? tinggi_badan_akhir;

  AnakModel({
        required this.nik,
        required this.nama,
        required this.jenis_kelamin,
        required this.tanggal_lahir,
        required this.nik_keluarga,
        required this.nama_orang_tua,
        required this.berat_badan,
        required this.tinggi_badan,
        required this.berat_badan_akhir,
        required this.tinggi_badan_akhir,
  });

  factory AnakModel.fromJson(Map<String, dynamic> json) {
    return AnakModel(
        nik: json['nik'],
        nama: json['nama'],
        jenis_kelamin: json['jenis_kelamin'],
        tanggal_lahir: json['tanggal_lahir'],
        nik_keluarga: json['nik_keluarga'],
        nama_orang_tua: json['nama_orang_tua'],
        berat_badan: json['berat_badan'],
        tinggi_badan: json['tinggi_badan'],
        berat_badan_akhir: json['berat_badan_akhir'],
        tinggi_badan_akhir: json['tinggi_badan_akhir']
    );
  }
}