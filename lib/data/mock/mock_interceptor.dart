import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

class MockInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    String? jsonPath;

    // 1. Asignación de rutas
    if (path.contains('/markers')) {
      jsonPath = 'lib/data/mock/markers.json';
    } else if (path.contains('/productos')) {
      jsonPath = 'lib/data/mock/productos_por_marker.json';
    } else if (path.contains('/businesses/')) {
      jsonPath = 'lib/data/mock/business_detail.json';
    } else if (path.contains('/products/')) {
      jsonPath = 'lib/data/mock/product_detail.json';
    }

    // 2. Si no es una ruta mockeada, dejamos pasar la request a la red
    if (jsonPath == null) {
      return handler.next(options);
    }

    try {
      // 3. Cargamos y parseamos el JSON
      final jsonString = await rootBundle.loadString(jsonPath);
      dynamic jsonData = jsonDecode(jsonString);

      // Parseamos la URI una única vez para extraer segmentos de forma segura
      final uri = Uri.parse(path);

      // 4. LÓGICA DE FILTRADO PARA DETALLES DE BUSINESS O PRODUCTO
      if (path.contains('/businesses/') || path.contains('/products/')) {
        final idRequerido = uri.pathSegments.last; // Extracción segura
        final List<dynamic> listaCompleta = jsonData;

        jsonData = listaCompleta.firstWhere(
          (elemento) => elemento['id'] == idRequerido,
          orElse: () => listaCompleta.first, // Fallback de seguridad
        );
      }
      // 5. LÓGICA DE FILTRADO PARA PRODUCTOS POR MARCADOR
      else if (path.contains('/productos')) {
        // Obtenemos el ID del marcador de forma segura buscando el segmento anterior a 'productos'
        final indexProductos = uri.pathSegments.indexOf('productos');
        final markerId = indexProductos > 0
            ? uri.pathSegments[indexProductos - 1]
            : '';

        final List<dynamic> listaCompleta = jsonData;

        // Filtramos buscando que el business_id coincida
        jsonData = listaCompleta.where((p) {
          final businessIdDelProducto = p['business_id'];
          return businessIdDelProducto == markerId ||
              businessIdDelProducto == markerId.replaceAll('marker', 'biz');
        }).toList();
      }

      // 6. Devolvemos la respuesta exitosa
      return handler.resolve(
        Response(requestOptions: options, data: jsonData, statusCode: 200),
      );
    } catch (e) {
      // 7. Manejo de error si el archivo no se carga o parsea correctamente
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Error cargando el archivo mock local: $e',
        ),
      );
    }
  }
}
