// importações necessárias, tanto de design quanto de outras páginas
import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'package:firebase_core/firebase_core.dart'; // conecta o projeto ao Firebase
import 'firebase_options.dart'; // arquivo gerado pelo flutterfire CLI com configs do projeto Firebase
import 'login.dart';


// função principal da aplicação
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // garante que o Flutter esteja pronto antes de inicializar o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // inicializa o Firebase com as configs certas da plataforma
  );
  runApp(const MyApp()); // roda o app chamando o widget raiz
}


// Widget raiz do app, não precisa de estado -> StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // tira a faixa de debug do canto
      theme: ThemeData(
        fontFamily: 'Arial', // define fonte padrão
        scaffoldBackgroundColor: Color(0xFF2C2B34), // cor de fundo padrão
      ),
      home: const MainScreen(), // tela inicial do app
    );
  }
}


// Tela inicial q aparece ao abrir o app
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B34), 
      body: Column(
        children: [
          const Spacer(),
          
          
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/car.png',
              width: 270,
              fit: BoxFit.contain, // nn deixa a imagem fica bixada
            ),
          ),

          const SizedBox(height: 5), 

          // o texto que muda as cores
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Fleets Cars ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '\nAdicione seu carro e faça parte do maior time de Gestão de Frota do Brasil.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )
                      )
                    ]
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 30), 
              ],
            ),
          ),

          // vai levar pra página de login
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {

                  // vai manda pra pagina de login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: Colors.black, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), 
                  ),
                  padding: const EdgeInsets.all(20), 
                ),
                child: const Text(
                  'Vamos começar',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 50), 
        ],
      ),
    );
  }
}
