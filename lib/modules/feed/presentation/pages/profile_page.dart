import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/stores/auth_store.dart';
import '../stores/feed_store.dart';
import 'post_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authStore = GetIt.I.get<AuthStore>();
  final _feedStore = GetIt.I.get<FeedStore>();
  final _prefs = GetIt.I.get<SharedPreferences>();

  late String loggedUsername;

  @override
  void initState() {
    super.initState();
    loggedUsername = _prefs.getString('logged_username') ?? 'Usuário';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loggedUsername),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await _authStore.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              loggedUsername.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          Text(loggedUsername, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          const Divider(),

          Expanded(
            child: Observer(
              builder: (_) {
                final myPosts = _feedStore.posts.where((p) => p.username == loggedUsername).toList();

                if (myPosts.isEmpty) {
                  return const Center(child: Text('Você ainda não tem publicações.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: myPosts.length,
                  itemBuilder: (context, index) {
                    final post = myPosts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailsPage(post: post)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: post.imageUrl != null
                            ? Image.network(post.imageUrl!, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.text_snippet, color: Colors.grey),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
