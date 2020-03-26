import 'dart:convert';
import '../config/booxy-config.dart';
import '../models/entities-link.dart';
import 'package:http/http.dart' as http;

class LevelLinkingProvider {
  Future<List<EntitiesLink>> getEntitiesLinking(
      int idEntity, int idCompany) async {
    String url = BooxyConfig.api_endpoint +
        'LevelLinking/' +
        (idEntity == null ? 'null' : idEntity.toString()) +
        '/' +
        (idCompany == null ? 'null' : idCompany.toString());

    final response = await http.get(url);
    final List<EntitiesLink> entLinks = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //print(extractedData);
    if (extractedData == null) {
      return null;
    }

    final List<dynamic> objList = extractedData["objList"];

    if (objList.length == 0) return null;

    for (int i = 0; i < objList.length; i++) {
      var value = objList[i];
      var entLnk = new EntitiesLink().fromJson(value);

      entLinks.add(entLnk);
    }

    return entLinks;
  }
}
