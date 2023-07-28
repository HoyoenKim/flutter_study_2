class DataUtils {
  static pathToUrl(String value) {
    //now: add ip when request
    //return 'http://$ip$value';
    return value;
  }

  static urlToPath(String value) {
    //now: add ip when request
    return value;
    //return value.substring('http://$ip'.length, value.length);
  }
}
