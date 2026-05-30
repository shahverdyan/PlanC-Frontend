/// DTO para usuario en contexto de mensajes (Emisor)
class UserDTO {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  UserDTO({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as String? ?? '',
      nomUsuari: json['nomUsuari'] as String? ?? 'Usuari Desconegut',
      fotoPerfil: json['fotoPerfil'] as String?,
    );
  }
}

/// DTO para categoría (dentro de actividad)
class CategoriaDTO {
  final String nom;

  CategoriaDTO({required this.nom});

  factory CategoriaDTO.fromJson(Map<String, dynamic> json) {
    return CategoriaDTO(
      nom: json['nom'] as String? ?? '',
    );
  }
}

/// DTO para espai/ubicación (dentro de actividad)
class EspaiDTO {
  final String nom;

  EspaiDTO({required this.nom});

  factory EspaiDTO.fromJson(Map<String, dynamic> json) {
    return EspaiDTO(
      nom: json['nom'] as String? ?? '',
    );
  }
}

/// DTO para actividad compartida (dentro de mensaje)
class ActivitatCompartidaDTO {
  final String id;
  final String titol;
  final String descripcio;
  final CategoriaDTO categoria;
  final EspaiDTO espai;
  final DateTime dataInici;
  final DateTime dataFi;
  final double latitud;
  final double longitud;
  final String enlaces;

  ActivitatCompartidaDTO({
    required this.id,
    required this.titol,
    required this.descripcio,
    required this.categoria,
    required this.espai,
    required this.dataInici,
    required this.dataFi,
    required this.latitud,
    required this.longitud,
    required this.enlaces,
  });

  factory ActivitatCompartidaDTO.fromJson(Map<String, dynamic> json) {
    return ActivitatCompartidaDTO(
      id: json['id'] as String? ?? '',
      titol: json['titol'] as String? ?? '',
      descripcio: json['descripcio'] as String? ?? '',
      categoria: json['categoria'] != null 
          ? CategoriaDTO.fromJson(json['categoria'] as Map<String, dynamic>)
          : CategoriaDTO(nom: ''),
      espai: json['espai'] != null 
          ? EspaiDTO.fromJson(json['espai'] as Map<String, dynamic>)
          : EspaiDTO(nom: ''),
      dataInici: json['dataInici'] != null 
          ? DateTime.parse(json['dataInici'].toString()) 
          : DateTime.now(),
      dataFi: json['dataFi'] != null 
          ? DateTime.parse(json['dataFi'].toString()) 
          : DateTime.now(),
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0.0,
      enlaces: json['enllacCompra'] as String? ?? json['enlaces'] as String? ?? '',
    );
  }

  /// Convertir a mapa para serializar
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titol': titol,
      'descripcio': descripcio,
      'categoria': {'nom': categoria.nom},
      'espai': {'nom': espai.nom},
      'dataInici': dataInici.toIso8601String(),
      'dataFi': dataFi.toIso8601String(),
      'latitud': latitud,
      'longitud': longitud,
      'enllacCompra': enlaces,
    };
  }
}

/// DTO para mensaje completo
class MissatgeDTO {
  final String id;
  final String xatId;
  final String emissorId;
  final String text;
  final String? urlImatge;
  final String tipusContingut; // TEXT, IMATGE, ACTIVITAT_COMPARTIDA, SISTEMA
  final DateTime dataEnviament;
  final UserDTO emissor;
  final ActivitatCompartidaDTO? activitatCompartida;

  MissatgeDTO({
    required this.id,
    required this.xatId,
    required this.emissorId,
    required this.text,
    this.urlImatge,
    required this.tipusContingut,
    required this.dataEnviament,
    required this.emissor,
    this.activitatCompartida,
  });

  factory MissatgeDTO.fromJson(Map<String, dynamic> json) {
    return MissatgeDTO(
      id: json['id'] as String? ?? '',
      xatId: json['xatId'] as String? ?? '',
      emissorId: json['emissorId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      urlImatge: json['urlImatge'] as String?,
      tipusContingut: json['tipusContingut'] as String? ?? 'TEXT',
      dataEnviament: json['dataEnviament'] != null 
          ? DateTime.parse(json['dataEnviament'].toString()) 
          : DateTime.now(),
      emissor: json['emissor'] != null 
          ? UserDTO.fromJson(json['emissor'] as Map<String, dynamic>)
          : UserDTO(id: '', nomUsuari: 'Sistema'),
      activitatCompartida: json['activitatCompartida'] != null
          ? ActivitatCompartidaDTO.fromJson(json['activitatCompartida'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// DTO para respuesta paginada de mensajes
class MissatgesResponse {
  final List<MissatgeDTO> data;
  final String? nextCursor;

  MissatgesResponse({
    required this.data,
    this.nextCursor,
  });

  factory MissatgesResponse.fromJson(Map<String, dynamic> json) {
    return MissatgesResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => MissatgeDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      nextCursor: json['nextCursor'] as String?,
    );
  }
}

/// DTO para miembro de xat
class MembreXatDTO {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  MembreXatDTO({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory MembreXatDTO.fromJson(Map<String, dynamic> json) {
    return MembreXatDTO(
      id: json['id'] as String? ?? '',
      nomUsuari: json['nomUsuari'] as String? ?? 'Usuari',
      fotoPerfil: json['fotoPerfil'] as String?,
    );
  }
}

/// DTO para respuesta de lista de xats
class XatDTO {
  final String id;
  final String nom;
  final String tipus; // INDIVIDUAL, GRUP_AMICS, QUEDADA
  final String? fotoGrup;
  final String? ultimMissatge;
  final DateTime? dataUltimMissatge;
  final int missatgesNoLlegits;
  final bool teSilenciat;
  final bool actiu;
  final List<MembreXatDTO> membres;
  final String? quedadaId;

  XatDTO({
    required this.id,
    required this.nom,
    required this.tipus,
    this.fotoGrup,
    this.ultimMissatge,
    this.dataUltimMissatge,
    required this.missatgesNoLlegits,
    required this.teSilenciat,
    required this.actiu,
    required this.membres,
    this.quedadaId,
  });

  factory XatDTO.fromJson(Map<String, dynamic> json) {
    return XatDTO(
      id: json['id'] as String? ?? '',
      nom: json['nom'] as String? ?? 'Xat',
      tipus: json['tipus'] as String? ?? 'INDIVIDUAL',
      fotoGrup: json['fotoGrup'] as String?,
      ultimMissatge: json['ultimMissatge'] as String?,
      dataUltimMissatge: json['dataUltimMissatge'] != null
          ? DateTime.parse(json['dataUltimMissatge'].toString())
          : null,
      missatgesNoLlegits: json['missatgesNoLlegits'] as int? ?? 0,
      teSilenciat: json['teSilenciat'] as bool? ?? false,
      actiu: json['actiu'] as bool? ?? true,
      membres: (json['membres'] as List<dynamic>?)
              ?.map((e) => MembreXatDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quedadaId: json['quedadaId'] as String?,
    );
  }
}

/// DTO para solicitud de silenciar xat
class SilenciarXatRequest {
  final bool silenciat;

  SilenciarXatRequest({required this.silenciat});

  Map<String, dynamic> toJson() {
    return {'silenciat': silenciat};
  }
}

/// DTO para respuesta de silenciar xat
class SilenciarXatResponse {
  final String xatId;
  final bool teSilenciat;

  SilenciarXatResponse({
    required this.xatId,
    required this.teSilenciat,
  });

  factory SilenciarXatResponse.fromJson(Map<String, dynamic> json) {
    return SilenciarXatResponse(
      xatId: json['xatId'] as String? ?? '',
      teSilenciat: json['teSilenciat'] as bool? ?? false,
    );
  }
}