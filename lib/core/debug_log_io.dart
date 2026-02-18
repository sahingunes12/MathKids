import 'dart:async';
import 'dart:convert';
import 'dart:io';

// #region agent log
void debugLog(String location, String message, Map<String, dynamic> data, {String? hypothesisId}) {
  final payload = {
    'sessionId': '114f02',
    'runId': data['runId'] ?? 'run1',
    if (hypothesisId != null) 'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };
  unawaited(_send(payload));
}

Future<void> _send(Map<String, dynamic> payload) async {
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('http://127.0.0.1:7487/ingest/406decec-b1f6-4288-ab04-22bcd54ff87c'));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('X-Debug-Session-Id', '114f02');
    request.write(jsonEncode(payload));
    final response = await request.close();
    await response.drain();
    client.close();
  } catch (_) {}
}
// #endregion
