import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Importar la pantalla de perfil o la pantalla correspondiente a cada categoría
import 'Pagina_perfil.dart';
import 'package:myapp/categorias/categoria_1.dart'; // Importar la pantalla de comunidad

// ignore: must_be_immutable
class Home extends StatelessWidget {
  final String usuario;
  final String imagenUrl;
  final String cargo;
  final String eldocumento;
  final String elapellido;
  final String elcorreo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Home({
    Key? key,
    required this.eldocumento,
    required this.usuario,
    required this.elapellido,
    required this.imagenUrl,
    required this.elcorreo,
    required this.cargo,
  }) : super(key: key);

  void _irAPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Perfil(
          eldocumento: eldocumento,
          usuario: usuario,
          elapellido: elapellido,
          elcorreo: elcorreo,
          imagenUrl: imagenUrl,
          cargo: cargo,
        ),
      ),
    );
  }

  void _irACategoria(BuildContext context, String categoria) {
    // Manejar la navegación según la categoría seleccionada
    if (categoria == 'Comunidad') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RedSocialScreen(),
        ),
      );
    } else {
      // Navegación a otras categorías
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Perfil(
            eldocumento: eldocumento,
            usuario: usuario,
            elapellido: elapellido,
            elcorreo: elcorreo,
            imagenUrl: imagenUrl,
            cargo: cargo,
          ),
        ),
      );
    }
  }

  // Mapa que asocia cada categoría con la ruta de la imagen correspondiente
  Map<String, String> imagenesCategorias = {
    'Reciclaje': 'img/cate1.jpg',
    'Conciencia Ambiental': 'img/cate2.jpg',
    'Juegos Educativos': 'img/cate3.jpg',
    'Desafíos y Metas': 'img/cate4.jpg',
    'Guías de Sostenibilidad': 'img/cate5.jpg',
    'Comunidad': 'img/cate6.jpg',
    'Noticias y Eventos': 'img/cate7.jpg',
    'Recursos Educativos': 'img/cate8.jpg',
  };

  @override
  Widget build(BuildContext context) {
    List<String> categorias = [
      'Reciclaje',
      'Conciencia Ambiental',
      'Juegos Educativos',
      'Desafíos y Metas',
      'Guías de Sostenibilidad',
      'Comunidad',
      'Noticias y Eventos',
      'Recursos Educativos',
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('Imagen clickeada, navegando a Perfil');
                        _irAPerfil(context);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(imagenUrl),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¡Hola, $usuario!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF14A60F),
                                ),
                              ),
                              Text(
                                '$cargo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF401201),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFC2D91A),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido a EcoSystem',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14A60F),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Lorem ipsum dolor sit amet consectetur adipiscing elit dui praesent, ornare tincidunt tempus cubilia class sed.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF401201),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage('assets/images/home1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF401201),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: categorias.map((categoria) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          _irACategoria(context, categoria);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage(imagenesCategorias[categoria] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black.withOpacity(0.3), // Color semitransparente
                            ),
                            child: Center(
                              child: Text(
                                categoria,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Contenido Adicional',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF401201),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Aquí puedes agregar más contenido relacionado con las categorías o cualquier otro tema relevante para tu aplicación.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Más contenido aquí...
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(imagenUrl),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '¡Hola, $usuario!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$cargo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
                // Implementar la navegación para configuración si es necesario
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
                // Implementar la función para cerrar sesión si es necesario
              },
            ),
          ],
        ),
      ),
    );
  }
}
