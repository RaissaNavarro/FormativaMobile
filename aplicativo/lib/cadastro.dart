import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final carrosRef = FirebaseFirestore.instance.collection('carros');

  final String usuarioLogado = 'raissa'; 

  void _showCarDialog({String? docId, Map<String, dynamic>? data}) {
    final imgUrlController = TextEditingController(text: data?['imgUrl']);
    final nomeController = TextEditingController(text: data?['nome']);
    final distanciaController = TextEditingController(text: data?['distancia']);
    final combustivelController = TextEditingController(text: data?['combustivel']);
    final precoController = TextEditingController(text: data?['preco']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 65, 65, 65),
          title: Text(
            docId != null ? 'Editar Carro' : 'Novo Carro',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _input(imgUrlController, 'URL da imagem'),
                const SizedBox(height: 10),
                _input(nomeController, 'Nome'),
                _input(distanciaController, 'Distância'),
                _input(combustivelController, 'Combustível'),
                _input(precoController, 'Preço'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final carro = {
                  'proprietario': usuarioLogado,
                  'imgUrl': imgUrlController.text,
                  'nome': nomeController.text,
                  'distancia': distanciaController.text,
                  'combustivel': combustivelController.text,
                  'preco': precoController.text,
                };

                if (docId != null) {
                  carrosRef.doc(docId).update(carro);
                } else {
                  carrosRef.add(carro);
                }

                Navigator.pop(context);
              },
              child: Text(docId != null ? 'Salvar' : 'Adicionar'),
            ),
          ],
        );
      },
    );
  }

  Widget _input(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
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
    );
  }

  bool _isCarEditable(String proprietario) {
    return proprietario == usuarioLogado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Cadastro de Carros'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCarDialog(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: carrosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum carro cadastrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final isEditable = _isCarEditable(data['proprietario']);

              return Card(
                color: const Color(0xFF3A3942),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: data['imgUrl'] != null
                      ? Image.network(
                          data['imgUrl'],
                          width: 100,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.car_rental, color: Colors.white),
                        )
                      : const Icon(Icons.car_rental, color: Colors.white),
                  title: Text(
                    data['nome'] ?? '',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Distância: ${data['distancia']}\nCombustível: ${data['combustivel']}\nPreço: ${data['preco']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: isEditable
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () => _showCarDialog(docId: doc.id, data: data),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => carrosRef.doc(doc.id).delete(),
                            ),
                          ],
                        )
                      : const Text(
                          'Fixado',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
