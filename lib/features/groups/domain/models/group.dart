import 'package:flutter/foundation.dart';

enum AttendanceStatus { notJoined, joined, confirmed, validated }

@immutable
class Group {
  final String id;
  final String title;
  final String description;
  final int minParticipants;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> participantIds;
  final List<String> confirmedParticipantIds;
  final List<String> pendingParticipantIds;
  final List<String> validatedParticipantIds;
  final DateTime dateTime;
  final String activityId;
  final String creatorId;
  final String? creatorNomUsuari;
  final DateTime createdAt;
  final String? imageUrl;

  const Group({
    required this.id,
    required this.title,
    required this.description,
    required this.minParticipants,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.participantIds,
    this.confirmedParticipantIds = const [],
    this.pendingParticipantIds = const [],
    this.validatedParticipantIds = const [],
    required this.dateTime,
    required this.activityId,
    required this.creatorId,
    this.creatorNomUsuari,
    required this.createdAt,
    this.imageUrl,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    int participantsCount = 0;
    List<String> parsedParticipantIds = [];
    List<String> parsedConfirmedParticipantIds = [];
    List<String> parsedPendingParticipantIds = [];
    List<String> parsedValidatedParticipantIds = [];
    String parsedCreatorId = '';
    String? parsedCreatorNomUsuari;

    if (json['assistents'] != null && json['assistents'] is List) {
      final assistentsList = json['assistents'] as List;

      participantsCount = assistentsList.length;

      parsedParticipantIds = List<String>.from(
          assistentsList.map((a) => a['usuariId']?.toString() ?? ''));

      parsedConfirmedParticipantIds = List<String>.from(
          assistentsList
              .where((a) => a['estat'] == 'CONFIRMAT' || a['estat'] == 'VALIDAT_GEOLOCALITZACIO')
              .map((a) => a['usuariId']?.toString() ?? ''));

      parsedPendingParticipantIds = List<String>.from(
          assistentsList
              .where((a) => a['estat'] == 'PENDENT_CONFIRMACIO')
              .map((a) => a['usuariId']?.toString() ?? ''));

      parsedValidatedParticipantIds = List<String>.from(
          assistentsList
              .where((a) => a['estat'] == 'VALIDAT_GEOLOCALITZACIO')
              .map((a) => a['usuariId']?.toString() ?? ''));

      for (final assistent in assistentsList) {
        if (assistent['rol'] == 'ADMINISTRADOR') {
          parsedCreatorId = assistent['usuariId'].toString();
          parsedCreatorNomUsuari = assistent['nomUsuari']?.toString() ??
              assistent['usuari']?['nomUsuari']?.toString();
          break;
        }
      }

      // La llista d'assistents pot arribar buida en endpoints de llistat
      // (el backend no inclou les relacions per rendiment).
      // Si el recompte és 0, intentem obtenir-lo de _count o assistentsActuals.
      if (participantsCount == 0) {
        if (json['_count'] != null &&
            json['_count'] is Map &&
            json['_count']['assistents'] != null) {
          participantsCount = json['_count']['assistents'] as int;
        } else if (json['assistentsActuals'] != null) {
          participantsCount = json['assistentsActuals'] as int;
        }
      }
    } else if (json['_count'] != null &&
        json['_count'] is Map &&
        json['_count']['assistents'] != null) {
      participantsCount = json['_count']['assistents'] as int;
    } else if (json['assistentsActuals'] != null) {
      participantsCount = json['assistentsActuals'] as int;
    }

    return Group(
      id: json['id'] ?? '',
      title: json['titol'] ?? '',
      description: json['descripcio'] ?? '',
      minParticipants: json['minimParticipants'] ?? 0,
      maxParticipants: json['maximParticipants'] ?? 0,
      currentParticipants: participantsCount,
      participantIds: parsedParticipantIds,
      confirmedParticipantIds: parsedConfirmedParticipantIds,
      pendingParticipantIds: parsedPendingParticipantIds,
      validatedParticipantIds: parsedValidatedParticipantIds,
      dateTime: DateTime.parse(json['dataHoraTrobada']),
      activityId: json['activitatId'] ?? '',
      creatorId: parsedCreatorId,
      creatorNomUsuari: parsedCreatorNomUsuari,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      imageUrl: json['imatge'] as String?,
    );
  }

  AttendanceStatus attendanceStatusFor(String userId) {
    if (validatedParticipantIds.contains(userId)) return AttendanceStatus.validated;
    if (confirmedParticipantIds.contains(userId)) return AttendanceStatus.confirmed;
    if (pendingParticipantIds.contains(userId) || participantIds.contains(userId)) {
      return AttendanceStatus.joined;
    }
    return AttendanceStatus.notJoined;
  }

  Map<String, dynamic> toJson() {
    return {
      'titol': title,
      'descripcio': description,
      'minimParticipants': minParticipants,
      'maximParticipants': maxParticipants,
      'dataHoraTrobada': dateTime.toUtc().toIso8601String(),
      'activitatId': activityId,
      'creatorId': creatorId,
    };
  }
}