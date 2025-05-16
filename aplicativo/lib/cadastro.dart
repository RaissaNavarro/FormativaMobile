import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final carrosRef = FirebaseFirestore.instance.collection('carros');

  Future<String?> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('carros/$fileName.jpg');

    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();
  }

  void _showEditDialog(String docId, Map<String, dynamic> data) {
    final nomeController = TextEditingController(text: data['nome']);
    final distanciaController = TextEditingController(text: data['distancia']);
    final combustivelController = TextEditingController(text: data['combustivel']);
    final precoController = TextEditingController(text: data['preco']);
    String? imgUrl = data['img'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Carro'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final uploadedUrl = await _uploadImage();
                    if (uploadedUrl != null) {
                      setState(() => imgUrl = uploadedUrl);
                    }
                  },
                  child: imgUrl != null && imgUrl!.isNotEmpty
                      ? Image.network(imgUrl!, height: 100)
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.camera_alt),
                        ),
                ),
                TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
                TextField(controller: distanciaController, decoration: const InputDecoration(labelText: 'Distância')),
                TextField(controller: combustivelController, decoration: const InputDecoration(labelText: 'Combustível')),
                TextField(controller: precoController, decoration: const InputDecoration(labelText: 'Preço')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                await carrosRef.doc(docId).update({
                  'nome': nomeController.text,
                  'distancia': distanciaController.text,
                  'combustivel': combustivelController.text,
                  'preco': precoController.text,
                  'img': imgUrl ?? '',
                });
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
            child: data['img'] != null && data['img'].toString().isNotEmpty
                ? Image.network(data['img'], width: 150, height: 100)
                : Image.asset('assets/images/carFrota.png', width: 150, height: 100),
          ),
          const SizedBox(height: 20),
          Text(data['nome'] ?? 'Sem nome', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Distância: ${data['distancia'] ?? ""}'),
          Text('Combustível: ${data['combustivel'] ?? ""}'),
          Text(data['preco'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(doc.id, data),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
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
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: carrosRef.where('editavel', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Column(
                  children: snapshot.data!.docs.map((doc) => _buildCarCard(doc)).toList(),
                );
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await carrosRef.add({
                    'nome': 'Novo Carro',
                    'distancia': '0 km',
                    'combustivel': '100%',
                    'preco': 'R\$ 0,00/h',
                    'img': '',
                    'editavel': true,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF282931),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
