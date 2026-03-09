*********************************************************************
*Change Log
*--------------------------------------------------------------------
* Date       | User       | Description
*--------------------------------------------------------------------
*DD MMM YYY | DEVELOPER  |
*********************************************************************
CLASS zcl_module_entity DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_select_key,
        name  TYPE string,
        value TYPE string,
        " data_type type string,
      END OF ts_select_key,
      tt_select_keys TYPE STANDARD TABLE OF ts_select_key WITH KEY name,
      tt_data        TYPE STANDARD TABLE OF zc_module_entity INITIAL SIZE 0 WITH EMPTY KEY.

    INTERFACES if_sadl_exit_calc_element_read.

    CLASS-METHODS:
      get_pdf
        IMPORTING is_data       TYPE zc_module_entity
        RETURNING VALUE(rv_pdf) TYPE xstring.
    CLASS-DATA: mc_duplicate_call TYPE abap_boolean.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
      gen_form_xml
        IMPORTING io_api        TYPE REF TO if_fp_fdp_api
                  is_data       TYPE zc_module_entity
        RETURNING VALUE(rv_xml) TYPE xstring.
    CONSTANTS:
      BEGIN OF gc_key,
        pr TYPE c LENGTH 50 VALUE 'PurchaseRequisition',
      END OF gc_key,
      gc_form TYPE c LENGTH 50 VALUE 'ZMODULE_FORM'.
ENDCLASS.



CLASS zcl_module_entity IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA:
      lt_data  TYPE tt_data.

    lt_data = CORRESPONDING #( it_original_data ).

    DATA(lv_attach_pdf) = COND abap_bool(
          WHEN line_exists( it_requested_calc_elements[ table_line = 'ATTACHMENT' ] )
          THEN abap_true ELSE abap_false ).

    DATA(lv_preview_pdf) = COND abap_bool(
          WHEN line_exists( it_requested_calc_elements[ table_line = 'PREVIEW' ] )
          THEN abap_true ELSE abap_false ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).

      "Is attachment required
      IF ( mc_duplicate_call IS INITIAL ).

        IF     lv_attach_pdf = abap_true.

          <lfs_data>-attachment = get_pdf( <lfs_data> ).

        ELSEIF  lv_preview_pdf = abap_true.

          <lfs_data>-preview    = get_pdf( <lfs_data> ).

        ENDIF.

      ENDIF.

      "Set filename for download attachment
      <lfs_data>-filename = |{ <lfs_data>-purchaserequisition ALPHA = OUT }.pdf|.
      <lfs_data>-mimetype = 'application/pdf'.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    "Prepare field before call method calculate
    DATA(lo_struct) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( gc_key ) ).
    LOOP AT lo_struct->components ASSIGNING FIELD-SYMBOL(<lfs_comp>).

      " Append all field in GC_KEY
      ASSIGN COMPONENT <lfs_comp>-name OF STRUCTURE gc_key TO FIELD-SYMBOL(<lv_field_name>).
      IF sy-subrc = 0.
        APPEND to_upper(  <lv_field_name>  ) TO et_requested_orig_elements.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_pdf.

    mc_duplicate_call = abap_true.

    TRY.
        DATA(lo_form) = cl_fp_form_reader=>create_form_reader( CONV #( gc_form ) ).
        DATA(lo_api)  = cl_fp_fdp_services=>get_instance( lo_form->get_fdp_name( ) ).
        "Get form data XML
        DATA(lv_xml) = gen_form_xml(  io_api  = lo_api
                                      is_data = is_data  ).

        cl_fp_ads_util=>render_pdf(
            EXPORTING
                iv_locale       = 'en_US'
                iv_xdp_layout   = lo_form->get_layout( )
                iv_xml_data     = lv_xml
                is_options      = VALUE #(
                    "0 - only errors <= intended for production
                    "4 - very detailed trace <= intended for development
                    trace_level = 4
                    embed_fonts = lo_form->get_font_embed( ) )
            IMPORTING
                ev_pdf          = rv_pdf
                ev_trace_string = DATA(logs)
        ).
        mc_duplicate_call = abap_false.
      CATCH cx_fp_fdp_error cx_fp_form_reader cx_fp_ads_util INTO DATA(ls_error).
        DATA(lv_message) = ls_error->get_text( ).

        "handle exception
    ENDTRY.
  ENDMETHOD.

  METHOD gen_form_xml.

    TRY.
        DATA(lt_keys) = io_api->get_keys( ).
        "Assign value to key field in form data
        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<lfs_keys>).
          ASSIGN COMPONENT <lfs_keys>-name OF STRUCTURE is_data TO FIELD-SYMBOL(<lfs_value>).
          IF sy-subrc = 0.
            <lfs_keys>-value = <lfs_value>.
          ENDIF.
        ENDLOOP.

        rv_xml = io_api->read_to_xml_v2( lt_keys ).
        "For debug value
        "DATA(ls_data) = io_api->read_to_data( lt_keys ).

      CATCH  cx_fp_fdp_error

      INTO DATA(ls_error).
        DATA(lv_message) = ls_error->get_text( ).

    ENDTRY.


  ENDMETHOD.

ENDCLASS.
