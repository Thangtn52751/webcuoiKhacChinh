import 'invitation_api.dart';
import 'guestbook_entry.dart';

/// Keeps guestbook API calls and JSON conversion outside the presentation UI.
class GuestbookRepository {
  const GuestbookRepository();

  Future<List<GuestbookEntry>> loadEntries() async {
    final entries = await InvitationApi.loadGuestbook();
    return entries.map(GuestbookEntry.fromJson).toList(growable: false);
  }

  Future<GuestbookEntry> addEntry({
    required String name,
    required String message,
  }) async {
    final result = await InvitationApi.addGuestbookEntry(
      name: name,
      message: message,
    );
    final data = result['data'];
    if (data is! Map) {
      throw const InvitationApiException('Máy chủ không trả về lời chúc.');
    }
    return GuestbookEntry.fromJson(Map<String, dynamic>.from(data));
  }
}
