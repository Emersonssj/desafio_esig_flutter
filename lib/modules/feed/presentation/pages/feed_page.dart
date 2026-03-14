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
    _feedStore.fetchPosts(isRefresh: true);

    _scrollController.addListener(() {
      if (_feedStore.isLoading || !_feedStore.hasMore) return;

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
      appBar: AppBar(title: SizedBox(width: 80, height: 80, child: Image.asset('assets/logo.png')), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => _feedStore.fetchPosts(isRefresh: true),
        child: Observer(
          builder: (_) {
            if (_feedStore.posts.isEmpty && _feedStore.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_feedStore.posts.isEmpty && _feedStore.appError != null) {
              return Center(child: Text(_feedStore.appError!.message));
            }

            if (_feedStore.posts.isEmpty) {
              return const Center(child: Text('Nenhuma publicação encontrada.'));
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: _feedStore.posts.length + (_feedStore.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _feedStore.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final post = _feedStore.posts[index];
                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(offset: Offset(0, 50 * (1 - value)), child: child),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.person)),
                              const SizedBox(width: 12),
                              Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(post.description),
                          const SizedBox(height: 12),
                          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                post.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 250,
                                errorBuilder: (_, _, _) => const SizedBox.shrink(),
                              ),
                            ),
                        ],
                      ),
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
