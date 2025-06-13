// import 'package:aplicativo/auth.dart';
// import 'package:aplicativo/login.dart';
// import 'package:flutter/material.dart';

// class Autenticar extends StatefulWidget {
//   const Autenticar({super.key});

//   @override
//   State<Autenticar> createState() => _AutenticarState();
// }

// class _AutenticarState extends State<Autenticar> {
//   TextEditingController _email = TextEditingController();
//   TextEditingController _senha = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Cadastrar Usuário")),
//       body: Center(
//         child: Column(
//           children: [
//             TextField(
//               controller: _email,
//               decoration: InputDecoration(hintText: "Digite seu email"),
//             ),
//             TextField(
//               controller: _senha,
//               decoration: InputDecoration(hintText: "Digite sua senha"),
//               obscureText: true,
//               obscuringCharacter: "*",
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     final message = await AuthService().registration(
//                       email: _email.text,
//                       password: _senha.text,
//                     );
//                     if (message != null && message.contains('Sucess')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoginPage(),
//                         ),
//                       );
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(message ?? "Erro desconhecido")),
//                     );
//                   },
//                   child: Text("Cadastrar"),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     _email.text = '';
//                     _senha.text = '';
//                   },
//                   child: Text("Limpar credenciais"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
