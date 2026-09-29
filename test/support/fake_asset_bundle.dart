import 'package:flutter/services.dart';

/// AssetBundle minimal pour les tests : sert un JSON fourni en mémoire
/// et compte les appels, pour vérifier le comportement de cache.
class FakeAssetBundle extends CachingAssetBundle {
  FakeAssetBundle(this._contents);

  final String _contents;
  int loadStringCallCount = 0;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadStringCallCount++;
    return _contents;
  }

  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError('Not needed for these tests');
  }
}
