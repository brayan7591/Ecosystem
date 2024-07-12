import 'package:flutter/material.dart';

class Datoscliente extends StatelessWidget {
  final Map<String,dynamic> data;
  Datoscliente ({required this.data});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos del usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Documento: ${data['documento']}'),
            Text('Nombre: ${data['nombre']}'),
             Text('Apellido: ${data['apellido']}'),
             Text('Correo: ${data['correo']}'),
             Image.network(data['imagen']),      
          ],
          ),
          ),
    );
  }
}