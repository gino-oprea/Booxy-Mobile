class BooxyImage {
  int id;
  int idParent;
  String img;
  bool isDefaultImage;

  BooxyImage({this.id, this.idParent, this.img, this.isDefaultImage});

  BooxyImage fromJson(Map json) {
    this.id = json['id'];
    this.idParent = json['idParent'];
    this.img = json['img'];
    this.isDefaultImage = json['isDefaultImage'];

    return this;
  }
}
