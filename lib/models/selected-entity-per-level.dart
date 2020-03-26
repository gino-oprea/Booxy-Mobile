import './booxy-image.dart';

class SelectedEntityPerLevel {
  int idLevel;
  int idEntity;
  int idLevelType;
  List<BooxyImage> images;

  SelectedEntityPerLevel({
    this.idLevel,
    this.idEntity,
    this.idLevelType,
    this.images
  });
}
