CLASS lhc_visitor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Visitor RESULT result.

    METHODS validateVisitor FOR VALIDATE ON SAVE
      IMPORTING keys FOR Visitor~validateVisitor.

ENDCLASS.


CLASS lhc_visitor IMPLEMENTATION.

  METHOD get_global_authorizations.
    " Learning scope: create is allowed for every user.
    " Before productive use, replace with AUTHORITY-CHECK on a custom auth object.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.


  METHOD validateVisitor.

    READ ENTITIES OF zmp_r_visitor IN LOCAL MODE
      ENTITY Visitor
        FIELDS ( VisitorName MobileNumber EmailId VisitPurpose HostEmployee VisitDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_visitors).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_visitors INTO DATA(ls_visitor).

      DATA(lv_has_error) = abap_false.

      IF ls_visitor-VisitorName IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enter the visitor name' )
                        %element-VisitorName = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF NOT matches( val   = CONV string( ls_visitor-MobileNumber )
                      regex = `^[6-9][0-9]{9}$` ).
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enter a valid 10-digit mobile number' )
                        %element-MobileNumber = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF ls_visitor-EmailId IS NOT INITIAL
         AND NOT matches( val   = CONV string( ls_visitor-EmailId )
                          regex = `^[^@\s]+@[^@\s]+\.[^@\s]+$` ).
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enter a valid email address' )
                        %element-EmailId = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF ls_visitor-VisitPurpose IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enter the purpose of the visit' )
                        %element-VisitPurpose = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF ls_visitor-HostEmployee IS INITIAL.
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Enter the employee being visited' )
                        %element-HostEmployee = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF ls_visitor-VisitDate IS INITIAL OR ls_visitor-VisitDate < lv_today.
        lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Visit date must be today or later' )
                        %element-VisitDate = if_abap_behv=>mk-on ) TO reported-visitor.
      ENDIF.

      IF lv_has_error = abap_true.
        APPEND VALUE #( %tky = ls_visitor-%tky ) TO failed-visitor.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
