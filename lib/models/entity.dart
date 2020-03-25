import './booxy-image.dart';

import './working-hours.dart';

class Entity {
  int id;
  int idLevel;
  String entityName_RO;
  String entityName_EN;
  String entityDescription_RO;
  String entityDescription_EN;
  List<BooxyImage> images;
  int defaultServiceDuration;
  int idDurationType;
  double defaultServicePrice;
  bool hasCustomWorkingHours;
  bool hasVariableProgramme;
  int idCustomWorkingHours;
  int maximumMultipleBookings;
  bool isEnabled;
  List<int> childEntityIds;
  int linkedIdUser;
  WorkingHours workingHours;

  Entity(
      {this.id,
      this.idLevel,
      this.entityName_RO,
      this.entityName_EN,
      this.entityDescription_RO,
      this.entityDescription_EN,
      this.images,
      this.defaultServiceDuration,
      this.idDurationType,
      this.defaultServicePrice,
      this.hasCustomWorkingHours,
      this.hasVariableProgramme,
      this.idCustomWorkingHours,
      this.maximumMultipleBookings,
      this.isEnabled,
      this.childEntityIds,
      this.linkedIdUser,
      this.workingHours});

  Entity fromJson(Map json) {
    this.id = json['id'];
    this.idLevel = json['idLevel'];
    this.entityName_RO = json['entityName_RO'];
    this.entityName_EN = json['entityName_EN'];
    this.entityDescription_RO = json['entityDecription_RO'];
    this.entityDescription_EN = json['entityDescription_EN'];
    this.defaultServiceDuration = json['defaultServiceDuration'];
    this.idDurationType = json['idDurationType'];
    this.defaultServicePrice = json['defaultServicePrice'] != null
        ? double.parse(json['defaultServicePrice'].toString())
        : null;
    this.hasCustomWorkingHours = json['hasCustomWorkingHours'];
    this.hasVariableProgramme = json['hasVariableProgramme'];
    this.idCustomWorkingHours = json['idCustomWorkingHours'];
    this.maximumMultipleBookings = json['maximumMultipleBookings'];
    this.isEnabled = json['isEnabled'];
    this.childEntityIds = json['childEntityIds'];
    this.linkedIdUser = json['linkedIdUser'];
    this.workingHours = new WorkingHours().fromJson(json['workingHours']);

    return this;
  }
}
