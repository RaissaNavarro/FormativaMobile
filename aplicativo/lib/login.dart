import 'package:flutter/material.dart';
import 'main.dart';
import 'cadastro.dart';

// A parte da tela de login q tem que ser stateful pq ela vai sofrer mudanças
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  // os controllers vão pegar o q o usuário digitar, tipo o input
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  
  void login() {
    final user = userController.text.trim(); // trim remove os espaços do começo e do fim p nn dar erro
    final password = passwordController.text.trim();

    // Fiz so a simulação de login mesmo
    if (user == 'raissa' && password == 'ra1234') {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CadastroPage()), // aq ja joga pra tela de cadastro
      );
    } else {

      // snackbar é tipo pop up, nesse caso quando der erro aq aparece
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha estão incorretos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B34), // cor do fundo 
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2B34),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {

            // aq vai voltar pra tela inicial
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(), 
            Image.asset(
              'assets/images/carFrota.png', 
              width: 500,
              height: 220,
              fit: BoxFit.contain,
            ),
            const Text(
              'Bem vindo de volta!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Faça login para continuar',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 35),

            // Campo de usuário
            TextField(
              controller: userController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Usuário',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Parte da senha
            TextField(
              controller: passwordController,
              obscureText: true, // vai remover o que esta digitando
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: login, // ta chamando a funcão do login aq
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), 
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                ),
              ),
            ),

            const Spacer(), // preenche o espaço restante pra deixar tudo centralizado bonitinho
          ],
        ),
      ),
    );
  }
}
