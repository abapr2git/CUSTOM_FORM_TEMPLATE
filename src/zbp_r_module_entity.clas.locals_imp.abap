*********************************************************************
*Change Log
*--------------------------------------------------------------------
* Date       | User       | Description
*--------------------------------------------------------------------
*DD MMM YYY | DEVELOPER  |
*********************************************************************
CLASS lhc_zr_module_entity DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_module_entity RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zr_module_entity RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zr_module_entity.

    METHODS render FOR MODIFY
      IMPORTING keys FOR ACTION zr_module_entity~render RESULT result.

ENDCLASS.

CLASS lhc_zr_module_entity IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD render.
    DATA(lo_merger) = cl_rspo_pdf_merger=>create_instance( ).
    DATA(lo_pdf) = NEW zcl_module_entity(  ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
      DATA(ls_data) = VALUE zc_module_entity( purchaserequisition = <lfs_key>-purchaserequisition ).
      DATA(lv_pdf) = lo_pdf->get_pdf( ls_data ).
      lo_merger->add_document( document = lv_pdf ) .

    ENDLOOP.
    TRY.
        DATA(lv_merge_pdf) = lo_merger->merge_documents(  ).
        DATA(output)  = cl_web_http_utility=>encode_x_base64( lv_merge_pdf ).
        APPEND VALUE #( %tky          = keys[ 1 ]-%tky
                        %param-pdf    = output   ) TO result.
      CATCH cx_rspo_pdf_merger.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_module_entity DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_module_entity IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
