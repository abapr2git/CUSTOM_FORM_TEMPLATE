// ********************************************************************
// Change Log
// --------------------------------------------------------------------
// Date       | User       | Description
// --------------------------------------------------------------------
// DD MMM YYYY| DEVELOPER  | Initial Version
// ********************************************************************
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity for get database table'
define root view entity ZR_MODULE_ENTITY
  as select from I_PurchaseRequisitionAPI01
  composition [0..*] of ZR_MODULE_ENTITY_ITEM as _Item
  //association [0..*] to ZR_XX_ITEM as _Item
  //   on _Item.PurchaseRequisition = $projection.PurchaseRequisition
{
  key PurchaseRequisition,
      PurReqnDescription,
      PurchaseRequisitionType,
      LastChangeDateTime,
      /* Associations */
      _Item

}
