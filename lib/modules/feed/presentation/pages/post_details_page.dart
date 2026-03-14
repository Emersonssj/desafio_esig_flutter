import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/post_entity.dart';
import '../stores/feed_store.dart';
import '../stores/edit_post_store.dart';

class PostDetailsPage extends StatefulWidget {
  final PostEntity post;

  const PostDetailsPage({super.key, required this.post});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late final EditPostStore _editPostStore = EditPostStore(GetIt.I.get<FeedStore>(), originalPost: widget.post);
  late final TextEditingController _descriptionController = TextEditingController(text: widget.post.description);

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (photo != null) {
      _editPostStore.setNewImagePath(photo.path);
    }
  }

  void _saveChanges() async {
    FocusScope.of(context).unfocus();

    final success = await _editPostStore.saveChanges();

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicação atualizada com sucesso!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editPostStore.errorMessage ?? 'Erro ao atualizar'), backgroundColor: Colors.red),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Publicação'),
        content: const Text('Tem certeza que deseja apagar esta postagem definitivamente?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await GetIt.I.get<FeedStore>().deletePost(widget.post.id);

              if (success && mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Excluído com sucesso!')));
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Publicação'),
        actions: [
          Observer(
            builder: (_) {
              if (_editPostStore.isLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.check, color: Colors.blue, size: 28),
                tooltip: 'Salvar alterações',
                onPressed: _editPostStore.hasChanges ? _saveChanges : null,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Excluir postagem',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Observer(
              builder: (_) {
                if (_editPostStore.newImagePath != null) {
                  return Stack(
                    children: [
                      Image.file(
                        File(_editPostStore.newImagePath!),
                        fit: BoxFit.cover,
                        height: 400,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          // Botão para cancelar a troca de imagem e voltar para a original
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => _editPostStore.setNewImagePath(null),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // 2. Cenário: Mostrando a foto original (que já estava no servidor)
                if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) {
                  return Stack(
                    children: [
                      Image.network(widget.post.imageUrl!, fit: BoxFit.cover, height: 400, width: double.infinity),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton.small(
                          onPressed: _pickImage,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }

                // 3. Cenário: O post não tinha foto nenhuma originalmente
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    height: 300,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Adicionar uma foto', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 12),
                      Text(widget.post.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    onChanged: (value) => _editPostStore.setNewDescription(value),
                    decoration: InputDecoration(
                      hintText: 'O que você quer compartilhar?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Criado em: ${widget.post.createdAt.day.toString().padLeft(2, '0')}/${widget.post.createdAt.month.toString().padLeft(2, '0')}/${widget.post.createdAt.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
