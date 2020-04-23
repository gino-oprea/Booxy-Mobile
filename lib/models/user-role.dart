class UserRole {
  int idRole;
  String roleName;
  int idCompany;
  int idUser;
  String companyName;
  bool isEditable;
  bool isOption;
  bool isCompanyOwner;

  UserRole(
      {this.idRole,
      this.roleName,
      this.idCompany,
      this.idUser,
      this.companyName,
      this.isEditable,
      this.isOption,
      this.isCompanyOwner});

  UserRole fromJson(Map json) {
    this.idRole = json['idRole'];
    this.roleName = json['roleName'];
    this.idCompany = json['idCompany'];
    this.idUser = json['idUser'];
    this.companyName = json['companyName'];
    this.isEditable = json['isEditable'];
    this.isOption = json['isOption'];
    this.isCompanyOwner = json['isCompanyOwner'];

    return this;
  }

  Map toJson() {
    Map obj = {
      'idRole': this.idRole,
      'roleName': this.roleName,
      'idCompany': this.idCompany,
      'idUser': this.idUser,
      'companyName': this.companyName,
      'isEditable': this.isEditable,
      'isOption': this.isOption,
      'isCompanyOwner': this.isCompanyOwner
    };

    return obj;
  }
}
