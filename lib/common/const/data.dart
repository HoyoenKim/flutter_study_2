import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: constant_identifier_names
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';

// ignore: constant_identifier_names
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

//localhost
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

const storage = FlutterSecureStorage();
