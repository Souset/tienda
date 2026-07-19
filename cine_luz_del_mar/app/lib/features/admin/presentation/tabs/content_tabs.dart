import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/collections.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../providers/admin_providers.dart';

/// Ejecuta una acción del panel mostrando errores como SnackBar.
Future<void> runAdminAction(
  BuildContext context,
  Future<void> Function() action, {
  String? successMessage,
}) async {
  try {
    await action();
    if (successMessage != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    }
  } on AppException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

/// Campo de imagen: URL editable + botón para subir una foto a Nicalia.
class CoverField extends ConsumerStatefulWidget {
  const CoverField({
    super.key,
    required this.controller,
    this.folder = 'covers',
  });

  final TextEditingController controller;
  final String folder;

  @override
  ConsumerState<CoverField> createState() => _CoverFieldState();
}

class _CoverFieldState extends ConsumerState<CoverField> {
  bool _uploading = false;

  Future<void> _upload() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw const PermissionException();
      final url = await ref
          .read(storageServiceProvider)
          .uploadFile(
            bytes: await picked.readAsBytes(),
            filename: picked.name,
            folder: widget.folder,
            idToken: idToken,
          );
      widget.controller.text = url;
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            decoration: const InputDecoration(
              labelText: 'Imagen (URL)',
              helperText: 'Pega una URL o sube una foto',
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: _uploading ? null : _upload,
          icon: _uploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload_outlined),
          label: const Text('Subir'),
        ),
      ],
    );
  }
}

/// Andamio común de las pestañas de contenido.
class _ContentList<T> extends StatelessWidget {
  const _ContentList({
    required this.value,
    required this.emptyLabel,
    required this.itemBuilder,
    required this.onCreate,
    required this.createLabel,
    required this.onRetry,
  });

  final AsyncValue<List<T>> value;
  final String emptyLabel;
  final Widget Function(BuildContext, T) itemBuilder;
  final VoidCallback onCreate;
  final String createLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: createLabel,
        onPressed: onCreate,
        icon: const Icon(Icons.add),
        label: Text(createLabel),
      ),
      body: value.when(
        loading: () => const ShimmerList(itemHeight: 64),
        error: (error, _) => ErrorView(error: error, onRetry: onRetry),
        data: (items) => items.isEmpty
            ? EmptyState(icon: Icons.inbox_outlined, title: emptyLabel)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: items.length,
                itemBuilder: (context, i) => itemBuilder(context, items[i]),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTICIAS
// ---------------------------------------------------------------------------

class NewsTab extends ConsumerWidget {
  const NewsTab({super.key});

  void _edit(BuildContext context, NewsItem? item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => _NewsForm(item: item)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(adminRepositoryProvider);
    return _ContentList<NewsItem>(
      value: ref.watch(allNewsProvider),
      emptyLabel: 'Sin noticias todavía',
      createLabel: 'Nueva noticia',
      onCreate: () => _edit(context, null),
      onRetry: () => ref.invalidate(allNewsProvider),
      itemBuilder: (context, item) => ListTile(
        title: Text(item.title, maxLines: 1),
        subtitle: Text(
          '${item.status == 'published' ? 'Publicada' : 'Borrador'}'
          '${item.featured ? ' · Destacada' : ''}'
          '${item.publishedAt != null ? ' · ${Formatters.dayMonth.format(item.publishedAt!)}' : ''}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => switch (action) {
            'edit' => _edit(context, item),
            'toggle' => runAdminAction(
              context,
              () => repo.saveNews(
                item.copyWith(
                  status: item.status == 'published' ? 'draft' : 'published',
                ),
              ),
              successMessage: item.status == 'published'
                  ? 'Noticia despublicada'
                  : 'Noticia publicada',
            ),
            'featured' => runAdminAction(
              context,
              () => repo.saveNews(item.copyWith(featured: !item.featured)),
            ),
            'delete' =>
              showConfirmDialog(
                context,
                title: 'Borrar noticia',
                message: '"${item.title}" se eliminará definitivamente.',
                confirmLabel: 'Borrar',
                destructive: true,
              ).then((ok) {
                if (ok && context.mounted) {
                  runAdminAction(
                    context,
                    () => repo.deleteDocById(Col.news, item.id),
                  );
                }
              }),
            _ => null,
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(
              value: 'toggle',
              child: Text(
                item.status == 'published' ? 'Despublicar' : 'Publicar',
              ),
            ),
            PopupMenuItem(
              value: 'featured',
              child: Text(item.featured ? 'Quitar destacada' : 'Destacar'),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Borrar')),
          ],
        ),
        onTap: () => _edit(context, item),
      ),
    );
  }
}

class _NewsForm extends ConsumerStatefulWidget {
  const _NewsForm({this.item});

  final NewsItem? item;

  @override
  ConsumerState<_NewsForm> createState() => _NewsFormState();
}

class _NewsFormState extends ConsumerState<_NewsForm> {
  late final _title = TextEditingController(text: widget.item?.title);
  late final _body = TextEditingController(text: widget.item?.body);
  late final _cover = TextEditingController(text: widget.item?.coverUrl);
  late String _status = widget.item?.status ?? 'draft';
  late bool _featured = widget.item?.featured ?? false;
  bool _saving = false;

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y cuerpo son obligatorios')),
      );
      return;
    }
    setState(() => _saving = true);
    final base = widget.item ?? const NewsItem();
    await runAdminAction(context, () async {
      await ref
          .read(adminRepositoryProvider)
          .saveNews(
            base.copyWith(
              title: _title.text.trim(),
              body: _body.text.trim(),
              coverUrl: _cover.text.trim().isEmpty ? null : _cover.text.trim(),
              status: _status,
              featured: _featured,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    }, successMessage: 'Noticia guardada');
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nueva noticia' : 'Editar noticia'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Guardar'),
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
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _body,
                minLines: 6,
                maxLines: 20,
                decoration: const InputDecoration(labelText: 'Cuerpo'),
              ),
              const SizedBox(height: 12),
              CoverField(controller: _cover),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Destacada en portada'),
                value: _featured,
                onChanged: (v) => setState(() => _featured = v),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'draft', label: Text('Borrador')),
                  ButtonSegment(value: 'published', label: Text('Publicada')),
                ],
                selected: {_status},
                onSelectionChanged: (v) => setState(() => _status = v.first),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EVENTOS
// ---------------------------------------------------------------------------

class EventsTab extends ConsumerWidget {
  const EventsTab({super.key});

  void _edit(BuildContext context, EventItem? item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => _EventForm(item: item)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(adminRepositoryProvider);
    return _ContentList<EventItem>(
      value: ref.watch(allEventsProvider),
      emptyLabel: 'Sin eventos todavía',
      createLabel: 'Nuevo evento',
      onCreate: () => _edit(context, null),
      onRetry: () => ref.invalidate(allEventsProvider),
      itemBuilder: (context, item) => ListTile(
        title: Text(item.title, maxLines: 1),
        subtitle: Text(
          '${item.type} · '
          '${item.start != null ? Formatters.dateTime.format(item.start!) : 'sin fecha'}'
          ' · ${item.reservedCount}/${item.capacity} plazas'
          ' · ${item.status == 'published' ? 'Publicado' : 'Borrador'}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => switch (action) {
            'edit' => _edit(context, item),
            'toggle' => runAdminAction(
              context,
              () => repo.saveEvent(
                item.copyWith(
                  status: item.status == 'published' ? 'draft' : 'published',
                ),
              ),
            ),
            'delete' =>
              showConfirmDialog(
                context,
                title: 'Borrar evento',
                message:
                    '"${item.title}" y sus reservas dejarán de estar visibles.',
                confirmLabel: 'Borrar',
                destructive: true,
              ).then((ok) {
                if (ok && context.mounted) {
                  runAdminAction(
                    context,
                    () => repo.deleteDocById(Col.events, item.id),
                  );
                }
              }),
            _ => null,
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(
              value: 'toggle',
              child: Text(
                item.status == 'published' ? 'Despublicar' : 'Publicar',
              ),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Borrar')),
          ],
        ),
        onTap: () => _edit(context, item),
      ),
    );
  }
}

class _EventForm extends ConsumerStatefulWidget {
  const _EventForm({this.item});

  final EventItem? item;

  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm> {
  late final _title = TextEditingController(text: widget.item?.title);
  late final _description = TextEditingController(
    text: widget.item?.description,
  );
  late final _cover = TextEditingController(text: widget.item?.coverUrl);
  late final _venueName = TextEditingController(text: widget.item?.venue?.name);
  late final _venueAddress = TextEditingController(
    text: widget.item?.venue?.address,
  );
  late final _lat = TextEditingController(
    text: widget.item?.venue?.lat.toString() ?? '',
  );
  late final _lng = TextEditingController(
    text: widget.item?.venue?.lng.toString() ?? '',
  );
  late final _capacity = TextEditingController(
    text: widget.item?.capacity.toString() ?? '50',
  );
  late String _type = widget.item?.type ?? 'proyeccion';
  late String _status = widget.item?.status ?? 'draft';
  late bool _featured = widget.item?.featured ?? false;
  late DateTime? _start = widget.item?.start;
  bool _saving = false;

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _start ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_start ?? now),
    );
    setState(() {
      _start = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 19,
        time?.minute ?? 0,
      );
    });
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y fecha son obligatorios')),
      );
      return;
    }
    setState(() => _saving = true);
    final base = widget.item ?? const EventItem();
    await runAdminAction(context, () async {
      await ref
          .read(adminRepositoryProvider)
          .saveEvent(
            base.copyWith(
              type: _type,
              title: _title.text.trim(),
              description: _description.text.trim(),
              start: _start,
              venue: Venue(
                name: _venueName.text.trim(),
                address: _venueAddress.text.trim(),
                lat: double.tryParse(_lat.text.replaceAll(',', '.')) ?? 0,
                lng: double.tryParse(_lng.text.replaceAll(',', '.')) ?? 0,
              ),
              capacity: int.tryParse(_capacity.text) ?? 0,
              coverUrl: _cover.text.trim().isEmpty ? null : _cover.text.trim(),
              status: _status,
              featured: _featured,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    }, successMessage: 'Evento guardado');
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo evento' : 'Editar evento'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Guardar'),
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
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(
                    value: 'proyeccion',
                    child: Text('Proyección'),
                  ),
                  DropdownMenuItem(value: 'taller', child: Text('Taller')),
                  DropdownMenuItem(value: 'charla', child: Text('Charla')),
                  DropdownMenuItem(value: 'festival', child: Text('Festival')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'proyeccion'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _description,
                minLines: 3,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickStart,
                icon: const Icon(Icons.schedule),
                label: Text(
                  _start == null
                      ? 'Elegir fecha y hora'
                      : Formatters.dateTime.format(_start!),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _venueName,
                decoration: const InputDecoration(labelText: 'Lugar'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _venueAddress,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _lat,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Latitud',
                        helperText: 'De openstreetmap.org',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lng,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Longitud'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _capacity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Plazas (capacidad)',
                ),
              ),
              const SizedBox(height: 12),
              CoverField(controller: _cover),
              SwitchListTile(
                title: const Text('Destacado en portada'),
                value: _featured,
                onChanged: (v) => setState(() => _featured = v),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'draft', label: Text('Borrador')),
                  ButtonSegment(value: 'published', label: Text('Publicado')),
                ],
                selected: {_status},
                onSelectionChanged: (v) => setState(() => _status = v.first),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PELÍCULAS
// ---------------------------------------------------------------------------

class FilmsTab extends ConsumerWidget {
  const FilmsTab({super.key});

  void _edit(BuildContext context, Film? item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => _FilmForm(item: item)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(adminRepositoryProvider);
    return _ContentList<Film>(
      value: ref.watch(allFilmsProvider),
      emptyLabel: 'Sin películas en el catálogo',
      createLabel: 'Nueva película',
      onCreate: () => _edit(context, null),
      onRetry: () => ref.invalidate(allFilmsProvider),
      itemBuilder: (context, item) => ListTile(
        title: Text(item.title, maxLines: 1),
        subtitle: Text(
          [
            if (item.year != null) '${item.year}',
            if (item.director != null) item.director!,
            if (item.ratingsCount > 0)
              '★ ${item.avgRating.toStringAsFixed(1)} (${item.ratingsCount})',
          ].join(' · '),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => switch (action) {
            'edit' => _edit(context, item),
            'featured' => runAdminAction(
              context,
              () => repo.saveFilm(item.copyWith(featured: !item.featured)),
            ),
            'delete' =>
              showConfirmDialog(
                context,
                title: 'Borrar película',
                message: '"${item.title}" y sus valoraciones se eliminarán.',
                confirmLabel: 'Borrar',
                destructive: true,
              ).then((ok) {
                if (ok && context.mounted) {
                  runAdminAction(
                    context,
                    () => repo.deleteDocById(Col.films, item.id),
                  );
                }
              }),
            _ => null,
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(
              value: 'featured',
              child: Text(item.featured ? 'Quitar destacada' : 'Destacar'),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Borrar')),
          ],
        ),
        onTap: () => _edit(context, item),
      ),
    );
  }
}

class _FilmForm extends ConsumerStatefulWidget {
  const _FilmForm({this.item});

  final Film? item;

  @override
  ConsumerState<_FilmForm> createState() => _FilmFormState();
}

class _FilmFormState extends ConsumerState<_FilmForm> {
  late final _title = TextEditingController(text: widget.item?.title);
  late final _year = TextEditingController(
    text: widget.item?.year?.toString() ?? '',
  );
  late final _director = TextEditingController(text: widget.item?.director);
  late final _synopsis = TextEditingController(text: widget.item?.synopsis);
  late final _poster = TextEditingController(text: widget.item?.posterUrl);
  late final _genres = TextEditingController(
    text: widget.item?.genres.join(', ') ?? '',
  );
  late bool _featured = widget.item?.featured ?? false;
  bool _saving = false;

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final base = widget.item ?? const Film();
    await runAdminAction(context, () async {
      await ref
          .read(adminRepositoryProvider)
          .saveFilm(
            base.copyWith(
              title: _title.text.trim(),
              year: int.tryParse(_year.text),
              director: _director.text.trim().isEmpty
                  ? null
                  : _director.text.trim(),
              synopsis: _synopsis.text.trim().isEmpty
                  ? null
                  : _synopsis.text.trim(),
              posterUrl: _poster.text.trim().isEmpty
                  ? null
                  : _poster.text.trim(),
              genres: _genres.text
                  .split(',')
                  .map((g) => g.trim())
                  .where((g) => g.isNotEmpty)
                  .toList(),
              featured: _featured,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    }, successMessage: 'Película guardada');
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nueva película' : 'Editar película'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Guardar'),
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
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _year,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Año'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _director,
                      decoration: const InputDecoration(labelText: 'Dirección'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _synopsis,
                minLines: 3,
                maxLines: 8,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _genres,
                decoration: const InputDecoration(
                  labelText: 'Géneros (separados por comas)',
                ),
              ),
              const SizedBox(height: 12),
              CoverField(controller: _poster),
              SwitchListTile(
                title: const Text('Destacada en portada'),
                value: _featured,
                onChanged: (v) => setState(() => _featured = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BIBLIOTECA
// ---------------------------------------------------------------------------

class LibraryTab extends ConsumerWidget {
  const LibraryTab({super.key});

  void _edit(BuildContext context, LibraryResource? item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => _ResourceForm(item: item)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(adminRepositoryProvider);
    return _ContentList<LibraryResource>(
      value: ref.watch(allLibraryProvider),
      emptyLabel: 'Sin recursos en la biblioteca',
      createLabel: 'Nuevo recurso',
      onCreate: () => _edit(context, null),
      onRetry: () => ref.invalidate(allLibraryProvider),
      itemBuilder: (context, item) => ListTile(
        title: Text(item.title, maxLines: 1),
        subtitle: Text(
          '${item.type}'
          '${item.category != null ? ' · ${item.category}' : ''}'
          '${item.minRole != 'invitado' ? ' · solo ${item.minRole}+' : ''}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => switch (action) {
            'edit' => _edit(context, item),
            'delete' =>
              showConfirmDialog(
                context,
                title: 'Borrar recurso',
                message: '"${item.title}" se eliminará de la biblioteca.',
                confirmLabel: 'Borrar',
                destructive: true,
              ).then((ok) {
                if (ok && context.mounted) {
                  runAdminAction(
                    context,
                    () => repo.deleteDocById(Col.library, item.id),
                  );
                }
              }),
            _ => null,
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(value: 'delete', child: Text('Borrar')),
          ],
        ),
        onTap: () => _edit(context, item),
      ),
    );
  }
}

class _ResourceForm extends ConsumerStatefulWidget {
  const _ResourceForm({this.item});

  final LibraryResource? item;

  @override
  ConsumerState<_ResourceForm> createState() => _ResourceFormState();
}

class _ResourceFormState extends ConsumerState<_ResourceForm> {
  late final _title = TextEditingController(text: widget.item?.title);
  late final _description = TextEditingController(
    text: widget.item?.description,
  );
  late final _url = TextEditingController(text: widget.item?.url);
  late final _category = TextEditingController(text: widget.item?.category);
  late final _cover = TextEditingController(text: widget.item?.coverUrl);
  late String _type = widget.item?.type ?? 'document';
  late String _minRole = widget.item?.minRole ?? 'invitado';
  bool _saving = false;

  Future<void> _save() async {
    if (_title.text.trim().isEmpty || _url.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y URL son obligatorios')),
      );
      return;
    }
    setState(() => _saving = true);
    final base = widget.item ?? const LibraryResource();
    await runAdminAction(context, () async {
      await ref
          .read(adminRepositoryProvider)
          .saveResource(
            base.copyWith(
              type: _type,
              title: _title.text.trim(),
              description: _description.text.trim().isEmpty
                  ? null
                  : _description.text.trim(),
              url: _url.text.trim(),
              category: _category.text.trim().isEmpty
                  ? null
                  : _category.text.trim(),
              coverUrl: _cover.text.trim().isEmpty ? null : _cover.text.trim(),
              minRole: _minRole,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    }, successMessage: 'Recurso guardado');
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Nuevo recurso' : 'Editar recurso'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Guardar'),
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
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'document', child: Text('Documento')),
                  DropdownMenuItem(value: 'podcast', child: Text('Podcast')),
                  DropdownMenuItem(value: 'video', child: Text('Vídeo')),
                  DropdownMenuItem(value: 'link', child: Text('Enlace')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'document'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _description,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _url,
                decoration: const InputDecoration(
                  labelText: 'URL del recurso',
                  helperText:
                      'YouTube/Spotify/PDF… (los archivos se pueden subir '
                      'con el botón de imagen y pegar aquí la URL)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _category,
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 12),
              CoverField(controller: _cover, folder: 'library'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _minRole,
                decoration: const InputDecoration(
                  labelText: 'Visible a partir de',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'invitado',
                    child: Text('Todo el mundo'),
                  ),
                  DropdownMenuItem(value: 'socio', child: Text('Socios')),
                  DropdownMenuItem(
                    value: 'coordinador',
                    child: Text('Equipo coordinador'),
                  ),
                ],
                onChanged: (v) => setState(() => _minRole = v ?? 'invitado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
