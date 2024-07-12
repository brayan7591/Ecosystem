import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/Firebase/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:myapp/paginas/pagina_huella.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController imagenPerfilController = TextEditingController(text: "");
  TextEditingController certificadoController = TextEditingController(text: "");
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController apellidoController = TextEditingController(text: "");
  String? Institucion;
  String? rol;
  TextEditingController cursoController = TextEditingController(text: "");
  TextEditingController identificacionController = TextEditingController(text: "");
  TextEditingController correoController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmController = TextEditingController(text: "");

  Uint8List? _imagenEnBytes; 

  Future obtenerImagen() async {
    if (!kIsWeb) {
      final picker = ImagePicker();
      final pickedfile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedfile != null) {
          _imagenEnBytes = File(pickedfile.path).readAsBytesSync();
        }
      });  
    }else{
      final input = html.FileUploadInputElement();
      input.accept = 'image/*';
      input.click();

      input.onChange.listen((e) async {
        final files = input.files;
        if (files!.isNotEmpty) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) async {
            setState(() {
              _imagenEnBytes = reader.result as Uint8List?;
            });
          });
        }
      });
    }
    
  }

Uint8List? _pdfenbites; 

  Future obtenerpdf() async {
    if (!kIsWeb) {
      FilePickerResult? archivo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      setState(() {
        if (archivo != null) {
          _pdfenbites = File(archivo.files.single.path!).readAsBytesSync();
        }
      });  
    }else{
      final input = html.FileUploadInputElement();
      input.accept = 'application/pdf';
      input.click();

      input.onChange.listen((e) async {
        final files = input.files;
        if (files!.isNotEmpty) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(files[0]);
          reader.onLoadEnd.listen((e) async {
            setState(() {
              _pdfenbites = reader.result as Uint8List?;
            });
          });
        }
      });
    }
    
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF401201),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10,),

                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('img/loguito.png'),
                ),

                const SizedBox(height: 20,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Foto de perfil', style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),),
                      const SizedBox(height: 20.0,),
                      Container(
                        child: _imagenEnBytes == null ? const Text('No hay ninguna imagen seleccionada') 
                        : ClipRRect(borderRadius: BorderRadius.circular(100.0), child: Image.memory(_imagenEnBytes!, fit: BoxFit.cover, width: 200.0, height: 200.0,),) ,
                      ),
                      const SizedBox(height: 10.0,),
                      ElevatedButton(
                        onPressed: obtenerImagen,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          backgroundColor: Color(0xFF14A60F),
                        ),
                        child: const Text(
                          'Agregar imagen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16.0,),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Agrega un certificado de estudio en pdf', style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),),
                      const SizedBox(height: 10.0,),
                      ElevatedButton(
                        onPressed: obtenerpdf,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          backgroundColor: Color(0xFF14A60F),
                        ),
                        child: const Text(
                          'Agregar certificado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      _pdfenbites != null ? const Text('Pdf agregado') : const Text('No hay ningun pdf')
                    ],
                  ),
                ),
                
                const SizedBox(height: 16.0,),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: const Color(0xFF14A60F)),
                  ),

                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'Profesor',
                        child: Text('Profesor'),
                      ),
                      DropdownMenuItem(
                        value: 'Estudiante',
                        child: Text('Estudiante'),
                      ),
                    ],
                    hint: const Text('Selecciona la opcion correspondiente'),
                    value: rol,
                    borderRadius: const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                    focusColor: Colors.white,
                    onChanged: (String? nuevoValorRol) {
                      setState(() {
                        rol = nuevoValorRol;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tipo de usuario:',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona una opcion';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16.0,),
                
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: TextFormField(
                    controller: apellidoController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu apellido';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: 'SENA',
                        child: Text('SENA'),
                      ),
                      DropdownMenuItem(
                        value: 'Roberto Velandia',
                        child: Text('Roberto Velandia'),
                      ),
                      DropdownMenuItem(
                        value: 'La paz',
                        child: Text('La paz'),
                      ),
                    ],
                    hint: const Text('Selecciona una opcion'),
                    value: Institucion,
                    borderRadius: const BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                    focusColor: Colors.white,
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        Institucion = nuevoValor;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Institucion',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecciona una opcion';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: TextFormField(
                    controller: cursoController,
                    decoration: const InputDecoration(
                      labelText: 'Curso',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese tu curso actual';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: TextFormField(
                    controller: identificacionController,
                    decoration: const InputDecoration(
                      labelText: 'Numero de identificación',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el numero de documento';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Color(0xFF14A60F)),
                  ),

                  child: TextFormField(
                    controller: correoController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el email';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: const Color(0xFF14A60F)),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    obscureText: true,
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la contraseña';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: const Color(0xFF14A60F)),
                  ),
                  child: TextFormField(
                    controller: passwordConfirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      contentPadding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Color(0xFF14A60F)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme la contraseña';
                      } else if (value != passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(passwordConfirmController.text);

                      if (passwordController.text != passwordConfirmController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Las contraseñas no coinciden'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        int? aut = await registrarUsuario(_imagenEnBytes, _pdfenbites, rol!, nombreController.text, apellidoController.text, Institucion!, int.parse(cursoController.text), int.parse(identificacionController.text), correoController.text, passwordConfirmController.text);
                        if (aut == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La contraseña es muy vulnerable, por favor intenta con otra.')));
                        } else if (aut == 2) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email ya registrado :(')));
                        } else if (aut != null) {
                          print('Usuario registrado.');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario registrado :)')));
                        } else {
                          Navigator.pop(context);
                        }

                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    backgroundColor: Color(0xFF14A60F),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Huella()),
                    );
                  },
                  child: const Text(
                    'Crear Huella Digital',
                    style: TextStyle(
                      color: Color(0xFF14A60F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 