import './booxy-image.dart';

class EntityWithLevel {
  int id;
  String entityName_RO;
  String entityName_EN;
  String entityDescription_RO;
  String entityDescription_EN;
  int entityDefaultServiceDuration;
  double defaultServicePrice;
  int entityIdDurationType;
  List<BooxyImage> images;
  int idLevel;
  int idCompany;
  int orderIndex;
  String levelName_RO;
  String levelName_EN;
  int idLevelType;
  bool isMultipleBooking;
  int levelDefaultDuration;
  int levelIdDurationType;

  EntityWithLevel(
      {this.id,
      this.entityName_RO,
      this.entityName_EN,
      this.entityDescription_RO,
      this.entityDescription_EN,
      this.entityDefaultServiceDuration,
      this.defaultServicePrice,
      this.entityIdDurationType,
      this.images,
      this.idLevel,
      this.idCompany,
      this.orderIndex,
      this.levelName_RO,
      this.levelName_EN,
      this.idLevelType,
      this.isMultipleBooking,
      this.levelDefaultDuration,
      this.levelIdDurationType});

  EntityWithLevel fromJson(Map json) {
    this.id = json['id'];
    this.idLevel = json['idLevel'];
    this.entityName_RO = json['entityName_RO'];
    this.entityName_EN = json['entityName_EN'];
    this.entityDescription_RO = json['entityDecription_RO'];
    this.entityDescription_EN = json['entityDescription_EN'];
    this.entityDefaultServiceDuration = json['entityDefaultServiceDuration'];
    this.entityIdDurationType = json['entityIdDurationType'];
    this.defaultServicePrice = json['defaultServicePrice'] != null
        ? double.parse(json['defaultServicePrice'].toString())
        : null;
    this.images = new List<BooxyImage>();
    List<dynamic> rawImages = json['images'];
    for (int i = 0; i < rawImages.length; i++) {
      var imgMap = rawImages[i];
      var image = new BooxyImage().fromJson(imgMap);

      images.add(image);
    }
    this.idCompany = json['idCompany'];
    this.orderIndex = json['orderIndex'];
    this.levelName_RO = json['levelName_RO'];
    this.levelName_EN = json['levelName_EN'];
    this.idLevelType = json['idLevelType'];
    this.isMultipleBooking = json['isMultipleBooking'];
    this.levelDefaultDuration = json['levelDefaultDuration'];
    this.levelIdDurationType = json['levelIdDurationType'];

    return this;
  }
}
