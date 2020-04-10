import './booxy-image.dart';

class BookingEntity {
  int idEntity;
  bool isAutoAssigned;
  int idLevel;
  bool isMultipleBooking;
  List<BooxyImage> images;
  String entityName_RO;
  String entityName_EN;
  String levelName_RO;
  String levelName_EN;
  int orderIndex;
  int idLevelType;

  BookingEntity(
      {this.idEntity,
      this.isAutoAssigned,
      this.idLevel,
      this.isMultipleBooking,
      this.images,
      this.entityName_RO,
      this.entityName_EN,
      this.levelName_RO,
      this.levelName_EN,
      this.orderIndex,
      this.idLevelType});

  BookingEntity fromJson(Map json) {
    this.idEntity = json['idEntity'];
    this.isAutoAssigned = json['isAutoAssigned'];
    this.idLevel = json['idLevel'];
    this.isMultipleBooking = json['isMultipleBooking'];

    this.images = new List<BooxyImage>();
    List<dynamic> rawImages = json['images'];
    if (rawImages != null)
      for (int i = 0; i < rawImages.length; i++) {
        var imgMap = rawImages[i];
        var image = new BooxyImage().fromJson(imgMap);

        images.add(image);
      }

    this.entityName_RO = json['entityName_RO'];
    this.entityName_EN = json['entityName_EN'];
    this.levelName_RO = json['levelName_RO'];
    this.levelName_EN = json['levelName_EN'];
    this.orderIndex = json['orderIndex'];
    this.idLevelType = json['idLevelType'];

    return this;
  }

  Map toJson() {
    Map obj = {
      'idEntity': this.idEntity,
      'isAutoAssigned': this.isAutoAssigned,
      //'idLevel': this.idLevel,
      //'isMultipleBooking': this.isMultipleBooking,
      // 'images': this.images != null
      //     ? this.images.map((i) => i.toJson()).toList()
      //     : null,
      'entityName_RO': this.entityName_RO,
      'entityName_EN': this.entityName_EN,
      'levelName_RO': this.levelName_RO,
      'levelName_EN': this.levelName_EN
      //'orderIndex': this.orderIndex,
      //'idLevelType': this.idLevelType
    };
    return obj;
  }
}
