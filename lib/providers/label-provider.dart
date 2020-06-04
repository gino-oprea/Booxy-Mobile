import 'dart:convert';
import '../config/booxy-config.dart';
import '../models/label.dart';
import 'package:http/http.dart' as http;

class LabelProvider {
  Future<List<Label>> getLabelsByKeyName(List<String> labelKeys) async {
    String url = BooxyConfig.api_endpoint + 'Labels';

    String httpParams = '';
    labelKeys.forEach((key) {
      if (httpParams.isEmpty)
        httpParams = '?labelName=' + key;
      else
        httpParams += '&labelName=' + key;
    });

    url += httpParams;

    final response = await http.get(url);
    final List<Label> loadedLabels = [];
    final extractedData =
        json.decode(response.body) as List<Map<String, dynamic>>;
    if (extractedData == null) {
      return null;
    }

    //final objList = extractedData["objList"];
    extractedData.forEach((value) {
      loadedLabels.add(new Label().fromJson(value));
    });

    return loadedLabels;
  }
}
