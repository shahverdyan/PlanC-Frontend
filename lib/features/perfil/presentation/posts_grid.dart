import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/create_post_screen.dart';
import 'package:plan_c_frontend/features/publicacions/presentation/post_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class PostsGrid extends ConsumerWidget {
  final bool isOwnProfile;
  final int numPosts;
  final List<PostPreview> posts;

  const PostsGrid({
    super.key,
    required this.isOwnProfile,
    required this.numPosts,
    required this.posts,
  });
@override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    if (posts.isEmpty) {
      if (isOwnProfile) {
        return SliverPadding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    t.profileNoPosts,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(t.createPost),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      } else {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            child: Center(
              child: Text(
                t.profileNoPosts,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }

    return SliverPadding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0, 
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (isOwnProfile && index == 0) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade300,
                  borderRadius: BorderRadius.zero,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add, size: 28, color: Colors.orange),
                ),
              );
            }

            final postIndex = isOwnProfile ? index - 1 : index;
            final post = posts[postIndex];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostScreen(postId: post.id),
                  ),
                );
              },
            
              child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                  ? Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_outlined, color: Colors.grey),
                    ),
            );
          },
          childCount: isOwnProfile ? posts.length + 1 : posts.length,
        ),
      ),
    );
  }
}
