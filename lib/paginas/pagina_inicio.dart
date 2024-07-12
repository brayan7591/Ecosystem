import 'package:flutter/material.dart';
import 'package:myapp/Iniciar_sesion/login.dart';
import 'package:myapp/iniciar_sesion/Registrarse.dart'; // Importa RegisterPage desde aquí

class EcoSystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                child: Image.asset('img/loguito.png'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()), // Asegúrate de que Login esté definido
                  );
                },
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF14A60F),
                  padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()), // Utiliza la importación correcta
                  );
                },
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 20.0, color: Color(0xFF14A60F)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Color(0xFF14A60F)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
