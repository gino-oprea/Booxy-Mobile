import 'dart:convert';
import '../config/booxy-config.dart';
import '../models/booxy-image.dart';
import 'package:http/http.dart' as http;

class BooxyImageProvider {
  Future<BooxyImage> getEntityImage(int idEntity) async {
    final url = BooxyConfig.api_endpoint +
        'Image/GetEntityImages/' +
        idEntity.toString();
    final response = await http.get(url);
    final List<BooxyImage> loadedImages = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    final objList = extractedData["objList"];
    objList.forEach((value) {
      loadedImages.add(new BooxyImage().fromJson(value));
    });

    if (loadedImages.length > 0)
      return loadedImages[0];
    else
      return null;
  }
}
