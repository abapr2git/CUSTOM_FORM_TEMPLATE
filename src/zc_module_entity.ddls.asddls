// ********************************************************************
// Change Log
// --------------------------------------------------------------------
// Date       | User       | Description
// --------------------------------------------------------------------
// DD MMM YYY | DEVELOPER  |
// ********************************************************************
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Requisition Header'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
@Metadata.allowExtensions: true
define root view entity ZC_MODULE_ENTITY
  provider contract transactional_query
  as projection on ZR_MODULE_ENTITY
{

  key     PurchaseRequisition,
          PurReqnDescription,
          PurchaseRequisitionType,
          LastChangeDateTime,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MODULE_ENTITY'
  virtual FileName   : abap.char( 50 ),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MODULE_ENTITY'
          @Semantics.mimeType: true
  virtual MimeType   : abap.char( 50 ),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MODULE_ENTITY'
          @Semantics.largeObject: {
              mimeType: 'MimeType',
              fileName: 'FileName',
              contentDispositionPreference: #ATTACHMENT
          }
  virtual Attachment : abap.rawstring( 0 ),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MODULE_ENTITY'
          @Semantics.largeObject: {
                mimeType: 'MimeType',
                //fileName: 'FileName',
              contentDispositionPreference: #INLINE
          }
  virtual Preview    : abap.rawstring( 0 ),
          /* Associations */
          _Item : redirected to composition child ZC_MODULE_ENTITY_ITEM
}
