import 'package:equatable/equatable.dart';

enum ChatType {
  group,
  individual,
}

abstract class Chat extends Equatable {
  final String id;
  final DateTime createdAt;
  final ChatType type;

  const Chat({
    required this.id,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object> get props => [id, createdAt, type];
}
