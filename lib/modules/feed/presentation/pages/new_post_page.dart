import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../stores/new_post_store.dart';
import '../stores/feed_store.dart';

class NewPostPage extends StatefulWidget {
  final VoidCallback onPostSuccess;
  const NewPostPage({super.key, required this.onPostSuccess});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late final NewPostStore _newPostStore = GetIt.I.get<NewPostStore>();
  late final FeedStore _feedStore = GetIt.I.get<FeedStore>();

  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // Função 1: Abre a Câmera
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (photo != null) {
      _newPostStore.setImagePath(photo.path);
    }
  }

  // Função 2: Abre a Galeria
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      _newPostStore.setImagePath(image.path);
    }
  }

  Future<void> _publish() async {
    FocusScope.of(context).unfocus();

    // 1. Pega o SharedPreferences do GetIt
    final prefs = GetIt.I.get<SharedPreferences>();
    // 2. Resgata o username (com fallback de segurança)
    final loggedUsername = prefs.getString('logged_username') ?? 'Desconhecido';

    // 3. Passa o nome real para a Store
    final success = await _newPostStore.createPost(
      loggedUsername, // <-- AQUI
      _descriptionController.text,
    );

    if (success) {
      // 1. Limpa o campo de texto e a imagem da tela de postagem
      _descriptionController.clear();
      _newPostStore.setImagePath('');

      // 2. Chama a Store do Feed para recarregar a lista lá do servidor
      _feedStore.fetchPosts(isRefresh: true);

      // 3. Mostra o aviso de sucesso
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Publicado com sucesso!'), backgroundColor: Colors.green));

      // 4. MÁGICA: Executa a função que muda para a aba do Feed
      widget.onPostSuccess();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_newPostStore.errorMessage ?? 'Erro'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Publicação'),
        actions: [
          Observer(
            builder: (_) => IconButton(
              icon: _newPostStore.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send, color: Colors.blue),
              onPressed: _newPostStore.isLoading ? null : _publish,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview da Câmera ou Galeria
            Observer(
              builder: (_) {
                // Se não tem imagem, mostra os botões de escolha
                if (_newPostStore.imagePath == null || _newPostStore.imagePath!.isEmpty) {
                  return Row(
                    children: [
                      // Botão Câmera
                      Expanded(
                        child: InkWell(
                          onTap: _takePhoto,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'Câmera',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Botão Galeria
                      Expanded(
                        child: InkWell(
                          onTap: _pickFromGallery,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'Galeria',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Se já escolheu a imagem, mostra o preview com o botão de deletar
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_newPostStore.imagePath!),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _newPostStore.setImagePath(''),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Campo de Descrição
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'O que você quer compartilhar?',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
