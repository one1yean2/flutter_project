import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const keyToken = 'token';
  static const keyDisplayName = 'displayName';

  final storage = FlutterSecureStorage();

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  Future<String> getName() async {
    var displayName = await Storage().read(Storage.keyDisplayName);

    if (displayName == null) {
      return '';
    } else {
      return displayName;
    }
  }
}
