import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class PostRepository {
  Future<void> createPost({
    required String userId,
    required String text,
    required String activityId,
    required List<XFile> images,
    required List<String> userIds,
  });

  Future<void> deletePost({required String postId, required String userId});

  Future<void> updatePost({
    required String postId,
    required String userId,
    required String textDescripcio,
    required List<String> multimediaAEliminar,
    required List<String> mencions,
    required List<File> novesImatges,
  });
}

