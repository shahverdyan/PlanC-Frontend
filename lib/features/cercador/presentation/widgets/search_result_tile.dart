import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import '../../domain/entities/search_result.dart';

class ActivityResultTile extends StatelessWidget {
  final ActivitySearchResult activitat;
  final VoidCallback onTap;

  const ActivityResultTile({
    super.key,
    required this.activitat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: activitat.imatgeUrl != null
            ? Image.network(
                activitat.imatgeUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => _placeholderIcon(context),
              )
            : _placeholderIcon(context),
      ),
      title: Text(
        activitat.titol,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: activitat.espaiNom != null
          ? Text(
              activitat.espaiNom!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _placeholderIcon(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class SpaceResultTile extends StatelessWidget {
  final SpaceSearchResult espai;
  final VoidCallback onTap;

  const SpaceResultTile({
    super.key,
    required this.espai,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: espai.imatgeUrl != null
            ? Image.network(
                espai.imatgeUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => _placeholderIcon(context),
              )
            : _placeholderIcon(context),
      ),
      title: Text(
        espai.nom,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _placeholderIcon(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
    );
  }
}
