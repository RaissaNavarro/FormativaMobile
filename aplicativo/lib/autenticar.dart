import 'package:aplicativo/auth.dart';
import 'package:aplicativo/login.dart';
import 'package:flutter/material.dart';

class Autenticar extends StatefulWidget {
  const Autenticar({super.key});

  @override
  State<Autenticar> createState() => _AutenticarState();
}

class _AutenticarState extends State<Autenticar> {
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2B34), // cor de fundo igual ao login
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2B34),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // volta pra tela anterior
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
              'Crie sua conta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Preencha os campos abaixo',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 35),

            // Campo de email
            TextField(
              controller: _email,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: 'Digite seu email',
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Campo de senha
            TextField(
              controller: _senha,
              obscureText: true,
              obscuringCharacter: '*',
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: 'Digite sua senha',
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Botão cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final message = await AuthService().registration(
                    email: _email.text.trim(),
                    password: _senha.text.trim(),
                  );

                  if (message == 'Success') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message ?? 'Erro desconhecido')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 117, 117, 117),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Botão limpar
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _email.clear();
                  _senha.clear();
                },
                child: const Text(
                  'Limpar',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Já tem uma conta? ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Fazer login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
