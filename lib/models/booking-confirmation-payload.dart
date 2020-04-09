import './auto-assigned-entity-combination.dart';

import './company.dart';

class BookingConfirmationPayload {
  Company company;
  AutoAssignedEntityCombination autoAssignedEntityCombination;
  DateTime bookingStartDate;

  BookingConfirmationPayload(
      {this.company, this.autoAssignedEntityCombination, this.bookingStartDate});

  
}
