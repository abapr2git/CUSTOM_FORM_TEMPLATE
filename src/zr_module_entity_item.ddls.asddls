// ********************************************************************
// Change Log
// --------------------------------------------------------------------
// Date       | User       | Description
// --------------------------------------------------------------------
// DD MMM YYYY| DEVELOPER  | Initial Version
// ********************************************************************
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity item for get database table'
define view entity ZR_MODULE_ENTITY_ITEM
  as select from I_PurchaseRequisitionItemAPI01
  association to parent ZR_MODULE_ENTITY as _Header  on _Header.PurchaseRequisition = $projection.PurchaseRequisition
  association to I_Product               as _Product on _Product.Product = $projection.Material
{
  key PurchaseRequisition,
  key PurchaseRequisitionItem,
      Material,
      MaterialGroup,
      PurchasingDocumentCategory,
      RequestedQuantity,
      BaseUnit,

      /* Associations */
      _PurchaseRequisition,
      _PurReqnAcctAssgmt,
      _Product,
      _Header
}
