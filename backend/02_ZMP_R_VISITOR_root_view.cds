@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visitor - Root View Entity'
define root view entity ZMP_R_VISITOR
  as select from zmp_visitor
{
  key visitor_uuid          as VisitorUUID,
      visitor_name          as VisitorName,
      mobile_no             as MobileNumber,
      email_id              as EmailId,
      company_name          as CompanyName,
      visit_purpose         as VisitPurpose,
      host_employee         as HostEmployee,
      visit_date            as VisitDate,
      checkin_time          as CheckInTime,
      id_proof_type         as IdProofType,
      id_proof_number       as IdProofNumber,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
