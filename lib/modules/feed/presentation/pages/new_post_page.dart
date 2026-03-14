import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart' show AssetEntityImageProvider;
import 'package:shared_preferences/shared_preferences.dart';

import '../stores/feed_store.dart';
import '../stores/new_post_store.dart';

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

  List<AssetEntity> _mediaList = [];
  bool _isLoadingGallery = true;

  @override
  void initState() {
    super.initState();
    _loadDevicePhotos();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadDevicePhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth || ps.hasAccess) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);

      if (albums.isNotEmpty) {
        List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 60);

        if (mounted) {
          setState(() {
            _mediaList = media;
            _isLoadingGallery = false;
          });

          if (media.isNotEmpty) {
            final firstFile = await media.first.file;
            if (firstFile != null) {
              _newPostStore.setImagePath(firstFile.path);
            }
          }
        }
      } else {
        setState(() => _isLoadingGallery = false);
      }
    } else {
      setState(() => _isLoadingGallery = false);
      PhotoManager.openSetting();
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (photo != null) {
      _newPostStore.setImagePath(photo.path);
    }
  }

  Future<void> _publish() async {
    FocusScope.of(context).unfocus();
    final prefs = GetIt.I.get<SharedPreferences>();
    final loggedUsername = prefs.getString('logged_username') ?? 'Usuário';

    final success = await _newPostStore.createPost(loggedUsername, _descriptionController.text);

    if (!mounted) return;

    if (success) {
      _descriptionController.clear();
      _newPostStore.setImagePath('');
      _feedStore.fetchPosts(isRefresh: true);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Publicado com sucesso!'), backgroundColor: Colors.green));

      widget.onPostSuccess();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_newPostStore.appError!.message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Publicação'),
        actions: [
          Observer(
            builder: (_) {
              final isReady = _newPostStore.imagePath != null && _newPostStore.imagePath!.isNotEmpty;

              if (_newPostStore.isLoading) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                );
              }

              return IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: isReady ? _publish : null,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingGallery
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: _mediaList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return InkWell(
                          onTap: _takePhoto,
                          child: Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40),
                                SizedBox(height: 4),
                                Text('Câmera', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      }
                      final asset = _mediaList[index - 1];
                      return InkWell(
                        onTap: () async {
                          final file = await asset.file;
                          if (file != null) {
                            _newPostStore.setImagePath(file.path);
                          }
                        },
                        child: Image(
                          image: AssetEntityImageProvider(
                            asset,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(250),
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1, offset: const Offset(0, -1))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Observer(
                  builder: (_) {
                    final path = _newPostStore.imagePath;
                    if (path != null && path.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(path), width: 80, height: 80, fit: BoxFit.cover),
                      );
                    }
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Escreva uma legenda...', border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
