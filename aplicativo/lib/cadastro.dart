import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  // ta fazendo a referencia da coleção de carros que ta la no firebase
  final carrosRef = FirebaseFirestore.instance.collection('carros');

  // Deixei raissa como o usuario master pra nn poder mexer no card
  final String usuarioLogado = 'raissa';

  // modalzinho de editar e cadastrar
  void _showCarDialog({String? docId, Map<String, dynamic>? data}) {
    // Controladores para os campos do formulário
    final imgUrlController = TextEditingController(text: data?['imgUrl']);
    final nomeController = TextEditingController(text: data?['nome']);
    final distanciaController = TextEditingController(text: data?['distancia']);
    final combustivelController = TextEditingController(text: data?['combustivel']);
    final precoController = TextEditingController(text: data?['preco']);

    // todos os campos pra preencher com os dados pro carro, tanto cadastrando quanto editando
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    docId != null ? 'Editar Carro' : 'Novo Carro',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Campos de entrada
                  _input(imgUrlController, 'URL da imagem'),
                  const SizedBox(height: 15),
                  _input(nomeController, 'Nome'),
                  const SizedBox(height: 15),
                  _input(distanciaController, 'Distância'),
                  const SizedBox(height: 15),
                  _input(combustivelController, 'Combustível'),
                  const SizedBox(height: 15),
                  _input(precoController, 'Preço'),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 112, 112, 112),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          
                          // Cria o objeto carro
                          final carro = {
                            'proprietario': usuarioLogado,
                            'imgUrl': imgUrlController.text,
                            'nome': nomeController.text,
                            'distancia': distanciaController.text,
                            'combustivel': combustivelController.text,
                            'preco': precoController.text,
                          };

                          // vai atualizar ou add no firebase
                          if (docId != null) {
                            carrosRef.doc(docId).update(carro);
                          } else {
                            carrosRef.add(carro);
                          }

                          Navigator.pop(context); // pop vai fechar
                        },
                        child: Text(docId != null ? 'Salvar' : 'Adicionar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _input(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // vai ver se pertence a o usuario q logou
  bool _isCarEditable(String proprietario) {
    return proprietario == usuarioLogado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Gestão de Frota',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // vai atualizando em tempo real
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
              child: Text('Nenhum carro cadastrado'),
            );
          }

          
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final isEditable = _isCarEditable(data['proprietario']);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  

                  leading: data['imgUrl'] != null && data['imgUrl'].toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data['imgUrl'],
                            width: 110,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.car_rental, size: 50),
                          ),
                        )
                      : const Icon(Icons.car_rental, size: 50),
                  
                  title: Text(
                    data['nome'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  
                  subtitle: Text(
                    'Distância: ${data['distancia']}\n'
                    'Combustível: ${data['combustivel']}\n'
                    'Preço: ${data['preco']}',
                  ),
                  
                  trailing: isEditable
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 80, 80, 80)),
                              onPressed: () => _showCarDialog(docId: doc.id, data: data),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 31, 31, 31)),
                              onPressed: () => carrosRef.doc(doc.id).delete(),
                            ),
                          ],
                        )
                      : const Text(
                          'Fixado',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                ),
              );
            },
          );
        },
      ),
      // Botão pra adicionar o carro, com bastante estilo pra ele ficar bom na tela
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        child: FloatingActionButton.extended(
          onPressed: () => _showCarDialog(),
          backgroundColor: const Color(0xFF4B4B4B),
          label: const Text(
            'Adicionar Carro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Color.fromARGB(99, 255, 255, 255)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
