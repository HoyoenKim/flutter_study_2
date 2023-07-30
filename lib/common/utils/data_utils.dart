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
}
