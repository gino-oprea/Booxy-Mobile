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

  BookingEntity({
    this.idEntity,
  this.isAutoAssigned,
  this.idLevel,
  this.isMultipleBooking,
  this.images,
  this.entityName_RO,
  this.entityName_EN,
  this.levelName_RO,
  this.levelName_EN,
  this.orderIndex,
  this.idLevelType
  });
}
