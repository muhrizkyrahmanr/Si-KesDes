import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sikesdes/DataAnak.dart';
import 'package:sikesdes/Perkembangan_page.dart';
import 'package:sikesdes/service/AnakService.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAnakPage extends StatefulWidget {
  final VoidCallback getReloadAnak;
  final VoidCallback login;
  const FormAnakPage({Key? key, required this.getReloadAnak, required this.login}) : super(key: key);

  @override
  State<FormAnakPage> createState() => _FormAnakPageState();
}

class _FormAnakPageState extends State<FormAnakPage>{
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime = DateTime.now();

  bool _validNIK=true, _validKurang16NIK=true, _validNama=true, _validJenisKelamin=true, _validTanggalLahir=true, _validNoKartuKeluarga=true, _validKurang16KartuKeluarga=true, _validNamaOrangTua=true, _validBeratBadan=true, _validTinggiBadan=true;

  final TextEditingController _controllerNIKAnak = TextEditingController();
  final TextEditingController _controllerNama = TextEditingController();
  String? _jeniskelamin;
  String? Tanggallahir;
  final TextEditingController _controllerTanggalLahir = TextEditingController();
  final TextEditingController _controllerNomorKartuKeluarga = TextEditingController();
  final TextEditingController _controllerNamaOrangTua = TextEditingController();
  final TextEditingController _controllerBeratBadan =  TextEditingController();
  final TextEditingController _controllerTinggiBadan = TextEditingController();

  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Si-KesDes"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 18.0, right: 18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 18.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("NIK Anak", style: TextStyle(fontSize: 13.0, color: _validNIK == false || _validKurang16NIK == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerNIKAnak,
                    inputFormatters: [LengthLimitingTextInputFormatter(16)],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: _validNIK == false || _validKurang16NIK == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan NIK Anak',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validNIK == false || _validKurang16NIK == false ? Colors.red : null
                      ),
                      suffixIcon: _validNIK == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'NIK masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : _validKurang16NIK == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'NIK kurang dari 16 digit',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                        if (value!.isEmpty) {
                          setState(() {
                            _validNIK = false;
                          });
                        } else {
                          if(value!.length < 16){
                            setState(() {
                              _validNIK = true;
                              _validKurang16NIK = false;
                            });
                          }else{
                            setState(() {
                              _validNIK = true;
                              _validKurang16NIK = true;
                            });
                          }
                        }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Nama Anak", style: TextStyle(fontSize: 13.0, color: _validNama == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerNama,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        color: _validNama == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan Nama Anak',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validNama == false ? Colors.red : null
                      ),
                      suffixIcon: _validNama == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Nama masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validNama = false;
                        });
                      } else {
                        setState(() {
                          _validNama = true;
                        });
                      }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Jenis Kelamin", style: TextStyle(fontSize: 13.0, color: _validJenisKelamin == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 5.0,
              ),
              Card(
                  color: Colors.white.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: "l",
                          groupValue: _jeniskelamin,
                          title: Text('Laki-Laki', style: TextStyle(color: _validJenisKelamin == false ? Colors.red : Colors.black.withOpacity(0.5))),
                          dense: true,
                          onChanged: (value) {
                            setState(() {
                              _jeniskelamin = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "p",
                          groupValue: _jeniskelamin,
                          title: Text('Perempuan', style: TextStyle(color: _validJenisKelamin == false ? Colors.red : Colors.black.withOpacity(0.5))),
                          dense: true,
                          onChanged: (value) {
                            setState(() {
                              _jeniskelamin = value;
                            });
                          },
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Tanggal Lahir", style: TextStyle(fontSize: 13.0, color: _validTanggalLahir == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerTanggalLahir,
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onTap: () {
                      selectDate(context);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: _validTanggalLahir == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan Tanggal Lahir',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validTanggalLahir == false ? Colors.red : null
                      ),
                      suffixIcon: _validTanggalLahir == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Tanggal lahir masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validTanggalLahir = false;
                        });
                      } else {
                        setState(() {
                          _validTanggalLahir = true;
                        });
                      }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("No Kartu Keluarga", style: TextStyle(fontSize: 13.0, color: _validNoKartuKeluarga == false || _validKurang16KartuKeluarga == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerNomorKartuKeluarga,
                    inputFormatters: [LengthLimitingTextInputFormatter(16)],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: _validNoKartuKeluarga == false || _validKurang16KartuKeluarga == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan No Kartu Keluarga',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validNoKartuKeluarga == false || _validKurang16KartuKeluarga == false ? Colors.red : null
                      ),
                      suffixIcon: _validNoKartuKeluarga == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'No kartu keluarga masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : _validKurang16KartuKeluarga == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'No kartu keluarga kurang dari 16 digit',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validNoKartuKeluarga = false;
                        });
                      } else {
                        if(value!.length < 16){
                          setState(() {
                            _validNoKartuKeluarga = true;
                            _validKurang16KartuKeluarga = false;
                          });
                        }else{
                          setState(() {
                            _validNoKartuKeluarga = true;
                            _validKurang16KartuKeluarga = true;
                          });
                        }
                      }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Nama Orang Tua", style: TextStyle(fontSize: 13.0, color: _validNamaOrangTua == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerNamaOrangTua,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.supervisor_account,
                        color: _validNamaOrangTua == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan Nama Orang Tua',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validNamaOrangTua == false ? Colors.red : null
                      ),
                      suffixIcon: _validNamaOrangTua == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Nama orang tua masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validNamaOrangTua = false;
                        });
                      } else {
                        setState(() {
                          _validNamaOrangTua = true;
                        });
                      }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Tinggi Badan", style: TextStyle(fontSize: 13.0, color: _validTinggiBadan == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerTinggiBadan,
                    keyboardType: TextInputType. number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.straighten,
                          color: _validTinggiBadan == false ? Colors.red : primaryColor,
                          size: 15.0,
                        ),
                        hintText: 'Masukkan Tinggi Badan (Cm)',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: _validTinggiBadan == false ? Colors.red : null
                        ),
                        suffixIcon: _validTinggiBadan == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Tinggi badan masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validTinggiBadan = false;
                        });
                      } else {
                        setState(() {
                          _validTinggiBadan = true;
                        });
                      }
                    }
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("Berat Badan", style: TextStyle(fontSize: 13.0, color: _validBeratBadan == false ? Colors.red : Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold),),
              ),
              Card(
                color: Colors.white.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      8.0),
                ),
                child: TextFormField(
                    controller: _controllerBeratBadan,
                    keyboardType: TextInputType. number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.speed,
                        color: _validBeratBadan == false ? Colors.red : primaryColor,
                        size: 15.0,
                      ),
                      hintText: 'Masukkan Berat Badan (Kg)',
                      hintStyle: TextStyle(
                          fontSize: 13,
                          color: _validBeratBadan == false ? Colors.red : null
                      ),
                      suffixIcon: _validBeratBadan == false
                            ? Tooltip(
                          preferBelow: false,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9)
                          ),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Berat badan masih kosong',
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20.0,
                          ),
                        )
                            : null
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validBeratBadan = false;
                        });
                      } else {
                        setState(() {
                          _validBeratBadan = true;
                        });
                      }
                    }
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: (){
                      if(_jeniskelamin != null){
                        setState((){
                          _validJenisKelamin = true;
                        });
                      }else{
                        setState((){
                          _validJenisKelamin = false;
                        });
                      }

                      if (_formKey.currentState!.validate()) {
                        if((!_controllerNIKAnak.text.isEmpty && _controllerNIKAnak.text.length == 16) && !_controllerNama.text.isEmpty
                          && _jeniskelamin != null && !_controllerTanggalLahir.text.isEmpty
                          && (!_controllerNomorKartuKeluarga.text.isEmpty &&  _controllerNomorKartuKeluarga.text.length == 16) && !_controllerNamaOrangTua.text.isEmpty
                          && !_controllerBeratBadan.text.isEmpty && !_controllerTinggiBadan.text.isEmpty){
                          showAlertDialogLoading(context);
                          tambahAnak();
                        }
                      }
                  },
                  child: Container(
                    height: 45,
                    child: Center(
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  tambahAnak() async{
    var serviceAnak = await AnakService().tambahAnak(_controllerNIKAnak.text,_controllerNama.text,_jeniskelamin!,Tanggallahir!,_controllerNomorKartuKeluarga.text,_controllerNamaOrangTua.text,_controllerBeratBadan.text,_controllerTinggiBadan.text);
    if(serviceAnak == 1){
      Navigator.pop(context);
      Navigator.pop(context);
      widget.getReloadAnak();
      showMessage(true,"Menambah Anak NIK ${_controllerNIKAnak.text}");
    }else if(serviceAnak == 2){
      Navigator.pop(context);
      showMessage(false,"Menambah Anak NIK ${_controllerNIKAnak.text} sudah ada");
    }else if(serviceAnak == 3){
      Navigator.pop(context);
      Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      setState(() {
        widget.login();
      });
    }else{
      Navigator.pop(context);
      showMessage(false,"Gagal Terhubung Keserver");
    }
  }

  showMessage(bool success, String text) async{
    await Future.delayed(Duration(seconds: 0));
    return QuickAlert.show(
      context: context,
      type: success == true ? QuickAlertType.success : QuickAlertType.error,
      confirmBtnColor: primaryColor,
      title: success == true ? "Sukses" : "Gagal",
      text: '${text}',
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        locale: Locale('id', 'ID'),
        initialDate: _dateTime,
        firstDate: DateTime(1923),
        lastDate: DateTime(2100));
    if (_datePicker != null) {
      _dateTime = _datePicker;
      Tanggallahir = DateFormat('yyyy-MM-dd').format(_dateTime);
      _controllerTanggalLahir.text =
          DateFormat('dd/MM/yyyy').format(_dateTime);
    }
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: primaryColor,
          ),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Loading...",
                style: const TextStyle(fontFamily: 'poppins'),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    );
  }
}
