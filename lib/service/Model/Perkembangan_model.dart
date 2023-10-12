class PerkembanganModel{
  int? id;
  String? nik;
  int? berat_badan;
  int? tinggi_badan;
  String? bulan;
  String? tahun;

  PerkembanganModel({
        required this.id,
        required this.nik,
        required this.berat_badan,
        required this.tinggi_badan,
        required this.bulan,
        required this.tahun,
  });

  factory PerkembanganModel.fromJson(Map<String, dynamic> json) {
    return PerkembanganModel(
        id: json['id'],
        nik: json['nik'],
        berat_badan: json['berat_badan'],
        tinggi_badan: json['tinggi_badan'],
        bulan: json['bulan'],
        tahun: json['tahun'],
    );
  }
}