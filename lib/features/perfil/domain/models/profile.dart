import 'package:plan_c_frontend/features/perfil/domain/models/trophy.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';

class Profile {
  final String name;
  final String surname;
  final String username;
  final String description;
  final List<Trophy> trophies;
  final String? profilePictureUrl;
  final int numFriends;
  final int numPosts;
  final List<PostPreview> posts;

  Profile({
    required this.name,
    required this.surname,
    required this.username,
    required this.description,
    required this.trophies,
    this.profilePictureUrl,
    required this.numFriends,
    required this.numPosts,
    required this.posts,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final trophies =
        (json['trophies'] as List<dynamic>?)
                ?.map(
                  (e) => Trophy(
                    category: e['category'] ?? '',
                    level: e['level'] ?? 0,
                    // Suportem els dos formats mentre el backend es desplega:
                    // - nou: points / rank
                    // - antic: punts / rangActual
                    points: e['points'] ?? e['punts'] ?? 0,
                    rank: e['rank'] ?? e['rangActual'] ?? '',
                  ),
                )
                .toList() ??
            [];

    const rankOrder = {
      'Principiant': 0,
      'Aficionat': 1,
      'Expert': 2,
    };

    trophies.sort(
      (a, b) => (rankOrder[b.rank] ?? 0).compareTo(rankOrder[a.rank] ?? 0),
    );

    final posts = (json['posts'] as List<dynamic>?)
            ?.map(
              (e) => PostPreview(
                id: e['id'] as String? ?? '',
                imageUrl: e['attachment'] as String?,
              ),
            )
            .toList() ??
        [];

    return Profile(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      username: json['username'] ?? '',
      description: json['biografia'] ?? '',
      trophies: trophies,
      profilePictureUrl: json['fotoPerfil'],
      // Suportem els dos formats mentre el backend es desplega:
      // - nou: friends_count / posts_count
      // - antic: friendscount / postscount
      numFriends: json['friends_count'] ?? json['friendscount'] ?? 0,
      numPosts: json['posts_count'] ?? json['postscount'] ?? posts.length,
      posts: posts,
    );
  }
}
