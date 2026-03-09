@EndUserText.label: 'Return type for PDF form'
define abstract entity ZI_PDF_CNT
{
      @EndUserText.label: 'PDF Binary Stream'
      key pdf : abap.rawstring(0); 
      
      @EndUserText.label: 'File Name'
      filename   : abap.char(100);
      
      @EndUserText.label: 'Mime Type'
      mimetype   : abap.char(100);
}
