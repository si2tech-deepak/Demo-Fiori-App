@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visitor - Projection View'
define root view entity ZMP_C_VISITOR
  provider contract transactional_query
  as projection on ZMP_R_VISITOR
{
  key VisitorUUID,
      VisitorName,
      MobileNumber,
      EmailId,
      CompanyName,
      VisitPurpose,
      HostEmployee,
      VisitDate,
      CheckInTime,
      IdProofType,
      IdProofNumber,
      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
