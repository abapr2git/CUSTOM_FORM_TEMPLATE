// เพิ่มตรง sap.ui5  แก้เป็น project ตัวเอง
"extends": {
      "extensions": {
        "sap.ui.controllerExtensions": {
          "sap.fe.templates.ListReport.ListReportController": {
            "controllerName": "demopdf2.ext.controller.PrintPreview"
          }
        }
      }
    }
