class PerkembanganModel{
  int? id;
  String? tanggal;
  String? bulan;
  String? tahun;
  num? berat_badan;
  num? tinggi_badan;

  PerkembanganModel({
        required this.id,
        required this.tanggal,
        required this.bulan,
        required this.tahun,
        required this.berat_badan,
        required this.tinggi_badan,
  });

  factory PerkembanganModel.fromJson(Map<String, dynamic> json) {
    return PerkembanganModel(
        id: json['id'],
        tanggal: json['tanggal'],
        bulan: json['bulan'],
        tahun: json['tahun'],
        berat_badan: json['berat_badan'],
        tinggi_badan: json['tinggi_badan'],
    );
  }
}