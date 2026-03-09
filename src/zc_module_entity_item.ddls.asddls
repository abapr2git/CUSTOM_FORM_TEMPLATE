// ********************************************************************
// Change Log
// --------------------------------------------------------------------
// Date       | User       | Description
// --------------------------------------------------------------------
// DD MMM YYYY| DEVELOPER  | Initial Version
// ********************************************************************
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS for ZI_MODULE_ENTITY_ITEM'
define view entity ZC_MODULE_ENTITY_ITEM
  as projection on ZR_MODULE_ENTITY_ITEM
{
  key PurchaseRequisition,
  key PurchaseRequisitionItem,
      Material,
      _Product._Text[1:Language=$session.system_language].ProductName,
      MaterialGroup,
      PurchasingDocumentCategory,
      RequestedQuantity,
      BaseUnit,
      _Header : redirected to parent ZC_MODULE_ENTITY
}
