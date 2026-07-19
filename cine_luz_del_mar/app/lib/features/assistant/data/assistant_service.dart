import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/collections.dart';

/// Asistente de IA de la asociación, sobre Gemini (Firebase AI Logic,
/// capa gratuita del plan Spark).
///
/// Antes de abrir la sesión de chat carga contexto real de Firestore
/// (próximas actividades, películas destacadas y últimas noticias) para que
/// las respuestas sean concretas y actuales.
class AssistantService {
  AssistantService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  ChatSession? _chat;

  static const _systemPrompt = '''
Eres el asistente de "Cine Luz del Mar", una asociación cultural dedicada al
cine, la cultura y la educación audiovisual. Respondes SIEMPRE en español,
con un tono cercano, breve y cinéfilo.

Puedes ayudar con:
- Información sobre la asociación y cómo hacerse socio (se solicita a la
  junta directiva en cualquier actividad o desde la propia app; los socios
  tienen carné digital, ventajas y acceso a todo el material).
- Recomendar películas del catálogo y actividades de la agenda.
- Explicar cómo reservar plaza (desde la ficha de cada actividad en la
  pestaña Agenda) y cómo funciona la app.
- Resumir eventos y noticias de la asociación.

Si te preguntan por datos que no aparecen en el contexto, dilo con
honestidad y sugiere consultar la Agenda o las Noticias de la app. No
inventes fechas, precios ni títulos.''';

  /// Prepara la sesión con contexto actual. Idempotente.
  Future<void> _ensureSession() async {
    if (_chat != null) return;

    final context = await _buildContext();
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system('$_systemPrompt\n\n$context'),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 800,
      ),
    );
    _chat = model.startChat();
  }

  Future<String> _buildContext() async {
    final buffer = StringBuffer('CONTEXTO ACTUAL DE LA ASOCIACIÓN\n');
    final dateFormat = DateFormat("EEEE d 'de' MMMM, HH:mm", 'es');

    try {
      final events = await _firestore
          .collection(Col.events)
          .where('status', isEqualTo: 'published')
          .where('start', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('start')
          .limit(6)
          .get();
      if (events.docs.isNotEmpty) {
        buffer.writeln('\nPróximas actividades:');
        for (final doc in events.docs) {
          final d = doc.data();
          final start = (d['start'] as Timestamp?)?.toDate();
          final plazas = (d['capacity'] ?? 0) - (d['reservedCount'] ?? 0);
          buffer.writeln(
            '- ${d['title']} (${d['type']}) · '
            '${start == null ? 'fecha por confirmar' : dateFormat.format(start)}'
            ' · ${plazas > 0 ? 'quedan $plazas plazas' : 'completo'}',
          );
        }
      }

      final films = await _firestore
          .collection(Col.films)
          .where('featured', isEqualTo: true)
          .limit(8)
          .get();
      if (films.docs.isNotEmpty) {
        buffer.writeln('\nPelículas del catálogo:');
        for (final doc in films.docs) {
          final d = doc.data();
          buffer.writeln(
            '- ${d['title']} (${d['year'] ?? 's.f.'}) de ${d['director'] ?? '?'}'
            ' · nota media ${d['avgRating'] ?? '-'} · ${d['synopsis'] ?? ''}',
          );
        }
      }

      final news = await _firestore
          .collection(Col.news)
          .where('status', isEqualTo: 'published')
          .orderBy('publishedAt', descending: true)
          .limit(3)
          .get();
      if (news.docs.isNotEmpty) {
        buffer.writeln('\nÚltimas noticias:');
        for (final doc in news.docs) {
          final d = doc.data();
          buffer.writeln('- ${d['title']}: ${d['body']}');
        }
      }
    } catch (error) {
      // Sin contexto el asistente sigue funcionando en modo general.
      debugPrint('Contexto del asistente no disponible: $error');
    }

    return buffer.toString();
  }

  Future<String> send(String message) async {
    try {
      await _ensureSession();
      final response = await _chat!.sendMessage(Content.text(message));
      final text = response.text?.trim() ?? '';
      if (text.isEmpty) {
        throw const UnknownException('El asistente no ha devuelto respuesta');
      }
      return text;
    } on AppException {
      rethrow;
    } catch (error) {
      debugPrint('Error del asistente: $error');
      _chat = null; // La próxima pregunta reintenta con sesión nueva.
      throw const NetworkException(
        'No he podido contactar con el asistente. Comprueba la conexión o '
        'que la IA esté activada (Firebase AI Logic).',
      );
    }
  }

  void reset() => _chat = null;
}
