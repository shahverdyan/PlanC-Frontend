import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart'; // 👈 Vuelve a ser necesario para los MediaType
import 'package:plan_c_frontend/features/publicacions/domain/repositories/post_respository.dart';

class PostRepositoryImpl implements PostRepository {
  final Dio _dio;

  PostRepositoryImpl(this._dio);

  @override
  Future<void> createPost({
    required String userId,
    required String text,
    required String activityId,
    required List<XFile> images,
    required List<String> userIds,
  }) async {
    try {
      final List<MultipartFile> imageFiles = [];
      
      for (final XFile image in images) {
        final extension = image.name.split('.').last.toLowerCase();
        String mimeType = 'image/jpeg';
        if (extension == 'png') mimeType = 'image/png';
        if (extension == 'webp') mimeType = 'image/webp';

        imageFiles.add(
          await MultipartFile.fromFile(
            image.path,
            filename: image.name,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }
      final String userIdsJson = jsonEncode(userIds); 
      final formData = FormData.fromMap({
        'textDescripcio': text,          
        'activitatId': activityId,        
        'quedadaId': null,                
        'mencions': userIdsJson, 
        'fitxers': imageFiles,        
      });

      await _dio.post(
        '/publicacio', 
        data: formData,
        options: Options(
          headers: {
            'usuari-id': userId, 
          },
        ),
      ); 


    } on DioException catch (e) {
      debugPrint('Error al crear post: $e');
      rethrow; 
      
    } catch (e) {
      debugPrint('Error inesperado al crear post: $e');
      rethrow;
    }
  }


@override
Future<void> updatePost({
  required String postId,
  required String userId,
  required String textDescripcio,
  required List<String> multimediaAEliminar,
  required List<String> mencions, // 👈 ¡Ahora sí acepta las menciones dinámicas!
  required List<File> novesImatges,
}) async {
  try {
    final List<MultipartFile> imageFiles = [];
    
    for (final imatge in novesImatges) {
      final filename = imatge.path.split('/').last;
      final extension = filename.split('.').last.toLowerCase();
      
      String mimeType = 'image/jpeg';
      if (extension == 'png') mimeType = 'image/png';
      if (extension == 'webp') mimeType = 'image/webp';

      imageFiles.add(
        await MultipartFile.fromFile(
          imatge.path,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    final formData = FormData.fromMap({
      'textDescripcio': textDescripcio,
      'multimediaAEliminar': jsonEncode(multimediaAEliminar),
      'mencions': jsonEncode(mencions), 
      'fitxers': imageFiles,
    });

    await _dio.patch(
      '/publicacio/$postId',
      data: formData,
      options: Options(
        headers: {
          'usuari-id': userId,
        },
      ),
    );//92282d6a-1659-4053-8f99-7ce413dcfeda

  } on DioException catch (e) {
    debugPrint('Error al editar post: $e');
    rethrow;
  } catch (e) {
    debugPrint('Error inesperado al editar post: $e');
    rethrow;
  }
}

  @override
  Future<void> deletePost({required String postId, required String userId}) async {
    try {
      await _dio.delete(
        '/publicacio/$postId',
        options: Options(
          headers: {
            'usuari-id': userId,
          },
        ),
      );
    } on DioException catch (e) {
      debugPrint('Error al eliminar post: $e');
      rethrow;
    } catch (e) {
      debugPrint('Error inesperado al eliminar post: $e');
      rethrow;
    }
  }
}