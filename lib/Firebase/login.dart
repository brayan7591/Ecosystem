import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

FirebaseAuth _authenticacion = FirebaseAuth.instance;

//Registrar usuarios

Future registrarUsuario(imagen, pdf, String rol, String nombre, String apellido, String institucion, int curso, int identificacion, String correo, String pass) async{

  // Verificar de que el usuario no este repetido con el correo o de errores de authenticacion
  try{
    await _authenticacion.createUserWithEmailAndPassword(email: correo, password: pass).then((variable) async {
      final id = variable.user?.uid;
      //Guardando la imagen
      final storageReferencia = FirebaseStorage.instance.ref().child('imagenes/${DateTime.now().toString()}');
      UploadTask uploadTask =  storageReferencia.putData(imagen, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await uploadTask;
      String urlimagen = await snapshot.ref.getDownloadURL();

      //Guardando el pdf
      final storageReferencia2 = FirebaseStorage.instance.ref().child('certificates/${DateTime.now().toString()}');
      UploadTask uploadTaskpdf =  storageReferencia2.putData(pdf, SettableMetadata(contentType: 'application/pdf'));
      TaskSnapshot snapshot2 = await uploadTaskpdf;
      String urlpdf = await snapshot2.ref.getDownloadURL();

      //Creando el usuario
      await db.collection("usuarios").doc(id).set({"approved": false, "email": correo, "identificacion": identificacion, "institucion": institucion, "lastname": apellido, "name": nombre,  "role": rol, "certificateUrl": urlpdf, "urlImagen": urlimagen, "uid": id});

      return null;
    });

    
  } on FirebaseAuthException catch(e){
    if(e.code == 'weak-password'){
      return 1;
    }
    else if(e.code == 'email-already-in-use'){
      return 2;
    }
  }
  return null;
}


//Iniciar sesion
Future loginUsuario(String correo, String passw) async{
    if(correo.isNotEmpty && passw.isNotEmpty){
      try{
        UserCredential  uc = await _authenticacion.signInWithEmailAndPassword(
          email: correo, password: passw);
          final u = uc.user;

          if (u != null){
            return u.uid;//auternticacion exitosa
          }

      }on FirebaseAuthException catch(e){
        print('error de autenticacion: ${e.code}');

        if (e.code == 'user-not-found' || e.code == 'wrong-password'){
          return "1";//usuario  y contra incorrectos
        }
      }catch (e){
        print('error: $e');
      }
    }
    else{
      print('correo y contraseña no pueden estar vacios');
       return "1";
    }

  }