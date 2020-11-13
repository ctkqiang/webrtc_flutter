import 'dart:convert';
import 'dart:async';
import 'dart:io';

Map data;
String url;
String responseBody;
HttpClientRequest request;
HttpClientResponse response;

Future<Map> getTurnCredential(String host, int port) async {
  HttpClient client = HttpClient(context: SecurityContext());

  client.badCertificateCallback = (
    X509Certificate cert,
    String host,
    int port,
  ) {
    print('getTurnCredential: Allow self-signed certificate => $host:$port. ');

    return true;
  };

  url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';

  request = await client.getUrl(Uri.parse(url));

  response = await request.close();

  responseBody = await response.transform(Utf8Decoder()).join();

  print('getTurnCredential:response => $responseBody.');

  data = JsonDecoder().convert(responseBody);

  return data;
}
