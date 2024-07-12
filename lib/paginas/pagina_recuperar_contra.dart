import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarContrasena extends StatefulWidget {
  @override
  _RecuperarContrasenaState createState() => _RecuperarContrasenaState();
}

class _RecuperarContrasenaState extends State<RecuperarContrasena> {
  final _formKey = GlobalKey<FormState>();
  late String _emailController;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Se envió al correo la confirmación.',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recuperación de la contraseña',
          style: TextStyle(
            color: Color(0xFF401201),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10,),
              Container(
                width: 200,
                height: 200,
                child: Image.asset('img/loguito.png'),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Color(0xFF14A60F)),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
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
                  onSaved: (value) {
                    _emailController = value!;
                  },
                ),
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  backgroundColor: Color(0xFF14A60F),
                ),
                child: Text(
                  'Enviar',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
