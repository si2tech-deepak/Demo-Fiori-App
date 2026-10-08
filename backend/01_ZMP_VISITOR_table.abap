@EndUserText.label : 'Visitor Register'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmp_visitor {

  key client            : abap.clnt not null;
  key visitor_uuid      : sysuuid_x16 not null;
  visitor_name          : abap.char(80);
  mobile_no             : abap.char(10);
  email_id              : abap.char(100);
  company_name          : abap.char(80);
  visit_purpose         : abap.char(100);
  host_employee         : abap.char(80);
  visit_date            : abap.dats;
  checkin_time          : abap.tims;
  id_proof_type         : abap.char(20);
  id_proof_number       : abap.char(30);
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  local_last_changed_by : abp_locinst_lastchange_user;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  last_changed_at       : abp_lastchange_tstmpl;

}
