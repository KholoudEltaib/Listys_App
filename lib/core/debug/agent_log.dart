import 'dart:convert';
import 'dart:io';

// #region agent log
Future<void> agentLog({
  required String location,
  required String message,
  Map<String, dynamic>? data,
  required String hypothesisId,
  required String runId,
}) async {
  final payload = <String, dynamic>{
    'sessionId': 'debug-session',
    'runId': runId,
    'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data ?? <String, dynamic>{},
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };

  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse('http://127.0.0.1:7242/ingest/1bab8527-3130-4282-9b60-c2909d61d0e3'),
    );
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.add(utf8.encode(jsonEncode(payload)));
    await request.close();
  } catch (_) {
    // Swallow all logging errors to avoid affecting app behavior.
  } finally {
    client.close(force: true);
  }
}
// #endregion
