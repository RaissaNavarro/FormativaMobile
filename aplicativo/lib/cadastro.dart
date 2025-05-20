import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final carrosRef = FirebaseFirestore.instance.collection('carros');

  void _showCarDialog({String? docId, Map<String, dynamic>? data}) {
    final proprietarioController = TextEditingController(text: data?['proprietario']);
    final nomeController = TextEditingController(text: data?['nome']);
    final distanciaController = TextEditingController(text: data?['distancia']);
    final combustivelController = TextEditingController(text: data?['combustivel']);
    final precoController = TextEditingController(text: data?['preco']);
    final imgUrlController = TextEditingController(text: data?['imgUrl']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docId != null ? 'Editar Carro' : 'Novo Carro'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: imgUrlController,
                  decoration: const InputDecoration(labelText: 'URL da imagem'),
                ),
                const SizedBox(height: 10),
                TextField(controller: proprietarioController, decoration: const InputDecoration(labelText: 'Proprietário')),
                TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
                TextField(controller: distanciaController, decoration: const InputDecoration(labelText: 'Distância')),
                TextField(controller: combustivelController, decoration: const InputDecoration(labelText: 'Combustível')),
                TextField(controller: precoController, decoration: const InputDecoration(labelText: 'Preço')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar'),),
            ElevatedButton(
              onPressed: () async {
                final carroData = {
                  'proprietario' : proprietarioController,
                  'nome': nomeController.text,
                  'distancia': distanciaController.text,
                  'combustivel': combustivelController.text,
                  'preco': precoController.text,
                  'imgUrl': imgUrlController.text,
                  'editavel': true,
                };

                if (docId != null) {
                  await carrosRef.doc(docId).update(carroData);
                } else {
                  await carrosRef.add(carroData);
                }

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: data['imgUrl'] != null && data['imgUrl'].toString().isNotEmpty
                ? Image.network(data['imgUrl'], width: 200, height: 200, errorBuilder: (ctx, err, _) {
                    return const Icon(Icons.broken_image, size: 100);
                  })
                : Image.asset('assets/images/carFrota.png', width: 100, height: 100),
          ),
          const SizedBox(height: 10),
          Text(data['nome'] ?? 'Sem nome', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('Proprietário: ${data['proprietario'] ?? ""}'),
          Text('Distância: ${data['distancia'] ?? ""}'),
          Text('Combustível: ${data['combustivel'] ?? ""}'),
          Text('R\$: ${data['preco'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.w600) ,), 
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showCarDialog(docId: doc.id, data: data),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, ),
                onPressed: () => carrosRef.doc(doc.id).delete(),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text('Gestão de Frota', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 5),
            StreamBuilder<QuerySnapshot>(
              stream: carrosRef.where('editavel', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Column(
                  children: snapshot.data!.docs.map((doc) => _buildCarCard(doc)).toList(),
                );
              },
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showCarDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF282931),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar novo carro',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
