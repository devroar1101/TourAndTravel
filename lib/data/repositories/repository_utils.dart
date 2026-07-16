final RegExp _uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false);

/// Whether [id] is a Postgres UUID (a row that truly lives in Supabase).
/// Bundled-catalogue ids ("d01", "p03", …) are not; when such a record is
/// saved against a live database it must be inserted as a new row rather
/// than upserted with an invalid key.
bool isDatabaseId(String id) => _uuidPattern.hasMatch(id);

/// Prepares a model's JSON payload for a Supabase upsert: strips ids that
/// the database did not issue so Postgres generates one.
Map<String, dynamic> upsertPayload(Map<String, dynamic> json) {
  final id = json['id']?.toString() ?? '';
  if (!isDatabaseId(id)) json.remove('id');
  return json;
}
