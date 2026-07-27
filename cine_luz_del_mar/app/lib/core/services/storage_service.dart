import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';

/// Servicio de subida de archivos contra la mini-API PHP del hosting.
///
/// Firebase Storage no se usa (la asociación aloja los medios en su propio
/// hosting Nicalia); en su lugar hacemos un POST multipart autenticado con el
/// idToken de Firebase Auth y la API devuelve la URL pública del archivo.
class StorageService {
  StorageService(this._dio);

  final Dio _dio;

  /// Sube [bytes] al servidor dentro de [folder] y devuelve la URL pública.
  ///
  /// El backend valida el [idToken] (Bearer) antes de aceptar la subida.
  Future<String> uploadFile({
    required List<int> bytes,
    required String filename,
    required String folder,
    required String idToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        'folder': folder,
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/upload.php',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $idToken'},
          responseType: ResponseType.json,
        ),
      );

      final url = response.data?['url'];
      if (url is! String || url.isEmpty) {
        throw const StorageException('Respuesta de subida sin URL válida');
      }
      return url;
    } on StorageException {
      rethrow;
    } on DioException catch (error) {
      throw StorageException(
        'No se pudo subir el archivo: ${error.message ?? 'error de red'}',
      );
    } catch (_) {
      throw const StorageException();
    }
  }
}

/// Proveedor del servicio de almacenamiento con una instancia de Dio propia.
final storageServiceProvider = Provider<StorageService>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
  return StorageService(dio);
});
