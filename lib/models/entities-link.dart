class EntitiesLink {
  int idParentEntity;
  int idChildEntity;

  EntitiesLink({this.idParentEntity, this.idChildEntity});

  EntitiesLink fromJson(Map json) {
    this.idParentEntity = json['idParentEntity'];
    this.idChildEntity = json['idChildEntity'];

    return this;
  }
}
