managed implementation in class zbp_mp_r_visitor unique;
strict ( 2 );

define behavior for ZMP_R_VISITOR alias Visitor
persistent table zmp_visitor
lock master
authorization master ( global )
etag master LocalLastChangedAt
{
  create;

  field ( numbering : managed, readonly ) VisitorUUID;
  field ( readonly ) CreatedBy, CreatedAt, LocalLastChangedBy, LocalLastChangedAt, LastChangedAt;
  field ( mandatory ) VisitorName, MobileNumber, VisitPurpose, HostEmployee, VisitDate;

  validation validateVisitor on save { create; }

  mapping for zmp_visitor
  {
    VisitorUUID        = visitor_uuid;
    VisitorName        = visitor_name;
    MobileNumber       = mobile_no;
    EmailId            = email_id;
    CompanyName        = company_name;
    VisitPurpose       = visit_purpose;
    HostEmployee       = host_employee;
    VisitDate          = visit_date;
    CheckInTime        = checkin_time;
    IdProofType        = id_proof_type;
    IdProofNumber      = id_proof_number;
    CreatedBy          = created_by;
    CreatedAt          = created_at;
    LocalLastChangedBy = local_last_changed_by;
    LocalLastChangedAt = local_last_changed_at;
    LastChangedAt      = last_changed_at;
  }
}
