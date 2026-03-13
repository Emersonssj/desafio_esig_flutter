import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../stores/feed_store.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final FeedStore _feedStore = GetIt.I.get<FeedStore>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Carrega a primeira página ao abrir a tela
    _feedStore.fetchPosts();

    // Fica ouvindo o scroll
    _scrollController.addListener(() {
      // Se chegarmos a 200 pixels do final da lista, pede a próxima página
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _feedStore.fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESIG Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      // RefreshIndicator permite puxar para baixo para recarregar tudo do zero
      body: RefreshIndicator(
        onRefresh: () => _feedStore.fetchPosts(isRefresh: true),
        child: Observer(
          builder: (_) {
            if (_feedStore.posts.isEmpty && _feedStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_feedStore.posts.isEmpty && _feedStore.errorMessage != null) {
              return Center(child: Text(_feedStore.errorMessage!));
            }

            if (_feedStore.posts.isEmpty) {
              return const Center(child: Text('Nenhuma publicação encontrada.'));
            }

            return ListView.builder(
              controller: _scrollController,
              // Adicionamos +1 no itemCount para mostrar o loading no final da lista
              itemCount: _feedStore.posts.length + (_feedStore.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Se for o último item e ainda tiver mais páginas, mostra o loading
                if (index == _feedStore.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = _feedStore.posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabeçalho do Post
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 12),
                            Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Descrição do Post
                        Text(post.description),
                        const SizedBox(height: 12),

                        // Imagem (se houver)
                        if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(), // Se a foto falhar (ex: Render apagou), ignora
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
