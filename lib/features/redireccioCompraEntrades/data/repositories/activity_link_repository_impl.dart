import 'package:url_launcher/url_launcher.dart';
import '../../domain/repositories/i_activity_link_repository.dart';

class ActivityLinkRepositoryImpl implements IActivityLinkRepository {
  @override
  Future<void> openTicketLink(String url) async {
    if (url.isEmpty) {
      throw Exception('URL buida');
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw Exception('URL no vàlida: $url');
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No s\'ha pogut obrir l\'enllaç');
    }
  }
}