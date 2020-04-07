import './entity-with-level.dart';

class AutoAssignedEntityCombination {
  int idPotentialBooking;
  List<EntityWithLevel> entityCombination;
  int duration;

  AutoAssignedEntityCombination(
      {this.idPotentialBooking, this.entityCombination, this.duration});

  AutoAssignedEntityCombination fromJson(Map json) {
    this.idPotentialBooking = json['idPotentialBooking'];
    this.entityCombination = new List<EntityWithLevel>();
    List<dynamic> rawEnt = json['entityCombination'];
    for (int i = 0; i < rawEnt.length; i++) {
      var entMap = rawEnt[i];
      var ent = new EntityWithLevel().fromJson(entMap);

      entityCombination.add(ent);
    }

    this.duration = json['duration'];

    return this;
  }
}
