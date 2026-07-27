import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';

/// Crear una publicación: texto, hasta 4 fotos y visibilidad.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _textController = TextEditingController();
  final List<XFile> _images = [];
  String _visibility = 'members';
  bool _sending = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(limit: 4);
    if (picked.isEmpty) return;
    setState(() {
      _images
        ..clear()
        ..addAll(picked.take(4));
    });
  }

  Future<void> _publish() async {
    final user = ref.read(currentUserProvider);
    final text = _textController.text.trim();
    if (user == null || (text.isEmpty && _images.isEmpty)) return;

    setState(() => _sending = true);
    final controller = ref.read(communityControllerProvider.notifier);
    try {
      final files = <({List<int> bytes, String name})>[
        for (final image in _images)
          (bytes: await image.readAsBytes(), name: image.name),
      ];
      final urls = files.isEmpty
          ? const <String>[]
          : await controller.uploadImages(files);
      await controller.createPost(
        author: user,
        text: text,
        imageUrls: urls,
        visibility: _visibility,
      );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicado en la comunidad')),
        );
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicación'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _sending ? null : _publish,
              child: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Publicar'),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: _textController,
                maxLines: 8,
                minLines: 4,
                maxLength: 2000,
                decoration: const InputDecoration(
                  hintText: '¿Qué quieres compartir con la comunidad?',
                ),
              ),
              const SizedBox(height: 16),
              if (_images.isNotEmpty) ...[
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          child: FutureBuilder(
                            future: _images[i].readAsBytes(),
                            builder: (context, snap) => snap.hasData
                                ? Image.memory(
                                    snap.data!,
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 110,
                                    height: 110,
                                    color: theme.colorScheme.surfaceContainer,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => setState(() => _images.removeAt(i)),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              OutlinedButton.icon(
                onPressed: _sending ? null : _pickImages,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  _images.isEmpty
                      ? 'Añadir fotos (hasta 4)'
                      : 'Cambiar fotos (${_images.length})',
                ),
              ),
              const SizedBox(height: 24),
              Text('Visibilidad', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'members',
                    label: Text('Socios'),
                    icon: Icon(Icons.badge_outlined),
                  ),
                  ButtonSegment(
                    value: 'public',
                    label: Text('Pública'),
                    icon: Icon(Icons.public),
                  ),
                ],
                selected: {_visibility},
                onSelectionChanged: (value) =>
                    setState(() => _visibility = value.first),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
