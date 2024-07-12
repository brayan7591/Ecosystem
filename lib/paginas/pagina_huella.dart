import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firebase Firestore
import 'package:local_auth/local_auth.dart'; // Importa Local Authentication
import 'package:myapp/paginas/pagina_principal.dart';// Asegúrate de importar correctamente tus clases

class Huella extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autenticación Biométrica'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _authenticateUser(context);
          },
          child: Text('Autenticar con Huella'),
        ),
      ),
    );
  }

  Future<void> _authenticateUser(BuildContext context) async {
    var localAuth = LocalAuthentication();
    var firestore = FirebaseFirestore.instance; // Instancia de Firestore

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        print('No se puede acceder a la autenticación biométrica');
        return;
      }

      List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        print('No hay sensores biométricos disponibles');
        return;
      }

      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Autentícate para acceder',
        useErrorDialogs: true,
        stickyAuth: true,
      );

      if (authenticated) {
        print('Usuario autenticado exitosamente');

        // Obtener el ID del usuario actualmente autenticado
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Obtener datos del usuario desde Firestore
        Map<String, dynamic>? userData = await _getUserDataFromFirestore(firestore, userId);

        if (userData != null) {
          // Navegar a la pantalla Home con los datos del usuario
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home(
              eldocumento: userData['documento'],
              usuario: userData['nombre'],
              elapellido: userData['apellido'],
              elcorreo: userData['correo'],
              imagenUrl: userData['imagen'],
              cargo: userData['cargo'],
            )),
          );
        } else {
          print('No se encontraron datos de usuario');
        }
      } else {
        print('Fallo la autenticación');
      }
    } catch (e) {
      print('Error de autenticación: $e');
    }
  }

  Future<Map<String, dynamic>?> _getUserDataFromFirestore(FirebaseFirestore firestore, String userId) async {
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return null; // Devuelve null explícitamente si no se encuentra el usuario
    }
  }
}