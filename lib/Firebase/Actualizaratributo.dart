import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/paginas/pagina_principal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class EditarClientePageDos extends StatefulWidget {
  final String documento;
  final String usuario;
  final String correo;
  final String cargo;
  final String imagenUrl; // Nueva variable para la URL de la imagen

  EditarClientePageDos({
    required this.documento,
    required this.usuario,
    required this.correo,
    required this.cargo,
    required this.imagenUrl,
  });

  @override
  _EditarClientePageDosState createState() => _EditarClientePageDosState();
}

class _EditarClientePageDosState extends State<EditarClientePageDos> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;
  late TextEditingController _documentoController;
  late TextEditingController _cargoController;
  late String _docId;
  File? _imageFile; // Variable para almacenar el archivo de imagen seleccionado

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidoController = TextEditingController();
    _correoController = TextEditingController();
    _documentoController = TextEditingController();
    _cargoController = TextEditingController();
    _cargarDatosCliente();
  }

  Future<void> _cargarDatosCliente() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('documento', isEqualTo: widget.documento)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot clienteSnapshot = querySnapshot.docs.first;
        _docId = clienteSnapshot.id;

        Map<String, dynamic>? datosCliente =
            clienteSnapshot.data() as Map<String, dynamic>?;
        if (datosCliente != null) {
          setState(() {
            _nombreController.text = datosCliente['nombre'] ?? '';
            _apellidoController.text = datosCliente['apellido'] ?? '';
            _correoController.text = datosCliente['correo'] ?? '';
            _documentoController.text = datosCliente['documento'] ?? '';
            _cargoController.text = datosCliente['cargo'] ?? '';
          });
        } else {
          print('No se encontraron datos en el documento del cliente.');
        }
      } else {
        print('El cliente con el documento ${widget.documento} no existe.');
      }
    } catch (error) {
      print('Error al cargar los datos del cliente: $error');
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _documentoController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Future<void> _actualizarCliente() async {
    if (_formkey.currentState!.validate()) {
      try {
        String imageUrl = widget.imagenUrl; // Utiliza la URL de la imagen existente como predeterminada
        if (_imageFile != null) {
          // Si se selecciona un nuevo archivo de imagen, súbelo a Firebase Storage
          final String downloadUrl =
              await uploadImageToFirebaseStorage(_imageFile!);
          imageUrl = downloadUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_docId)
            .update({
          'nombre': _nombreController.text.trim(),
          'apellido': _apellidoController.text.trim(),
          'correo': _correoController.text.trim(),
          'documento': _documentoController.text.trim(),
          'cargo': _cargoController.text.trim(),
          'imagen': imageUrl, // Actualiza la URL de la imagen en la base de datos
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario actualizado')));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              imagenUrl: imageUrl,
              eldocumento: _documentoController.text,
              elcorreo: _correoController.text,
              elapellido: _apellidoController.text,
              cargo: _cargoController.text,
              usuario: _nombreController.text,
            ),
          ),
          (route) => false,
        );
      } catch (error) {
        print('Error al actualizar el cliente: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al actualizar usuario')));
      }
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      // Crea una referencia a la ubicación en Firebase Storage
      firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('users')
          .child('${widget.documento}_avatar.jpg');

      // Sube el archivo a Firebase Storage
      await ref.putFile(imageFile);

      // Devuelve la URL de descarga
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error al subir la imagen a Firebase Storage: $error');
      throw error;
    }
  }

  Future<void> _mostrarAlertaSeleccionImagen() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar origen de la imagen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Cámara'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _seleccionarImagen(ImageSource.camera);
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Text('Galería'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _seleccionarImagen(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar usuario'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mostrar imagen actual si existe imagenUrl
                if (widget.imagenUrl.isNotEmpty && _imageFile == null)
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.imagenUrl),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _mostrarAlertaSeleccionImagen,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          backgroundColor: Color(0xFF14A60F),
                        ),
                        child: Text(
                          'Cambiar foto de perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                // Mostrar imagen seleccionada si _imageFile no es null
                if (_imageFile != null)
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_imageFile!),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _mostrarAlertaSeleccionImagen,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          backgroundColor: Color(0xFF14A60F),
                        ),
                        child: Text(
                          'Cambiar foto de perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un apellido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un correo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _documentoController,
                  decoration: const InputDecoration(labelText: 'Documento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un documento';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cargoController,
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce un cargo';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _actualizarCliente,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    backgroundColor: Color(0xFF14A60F),
                  ),
                  child: Text(
                    'Actualizar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
