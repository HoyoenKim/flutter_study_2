import 'dart:convert';

class DataUtils {
  static String pathToUrl(String value) {
    //now: add ip when request
    //return 'http://$ip$value';
    return value;
  }

  static String urlToPath(String value) {
    //now: add ip when request
    return value;
    //return value.substring('http://$ip'.length, value.length);
  }

  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);
    return encoded;
  }
}
