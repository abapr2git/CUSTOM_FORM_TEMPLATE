sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/m/BusyDialog",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "demopdf2/ext/util/PrintUtils" //แก้เป็น project ตัวเอง
], function (ControllerExtension, BusyDialog, MessageToast, MessageBox, PrintUtils) {
    "use strict";

    const PRINT_ACTION_KEYWORD = "PrintJournal";

    return ControllerExtension.extend("demopdf2.ext.controller.PrintPreview", { //แก้เป็น project ตัวเอง

        override: {
            onInit: function () {
                const extensionAPI = this.base.getExtensionAPI();
                const editFlow = extensionAPI.getEditFlow();

                if (!editFlow) return;

                // สร้าง BusyDialog ครั้งเดียว แล้ว reuse
                this._busyDialog = new BusyDialog({ text: "กำลังสร้าง PDF..." });

                const origInvoke = editFlow.invokeAction.bind(editFlow);
                const self = this;

                editFlow.invokeAction = function (sActionName, mParams) {
                    if (!sActionName || !sActionName.includes(PRINT_ACTION_KEYWORD)) {
                        return origInvoke(sActionName, mParams);
                    }

                    self._busyDialog.open();

                    return Promise.resolve(origInvoke(sActionName, mParams))
                        .then((result) => self._handlePrintResult(result))
                        .catch((err) => {
                            self._busyDialog.close();
                            throw err;
                        });
                };
            }
        },

        _handlePrintResult: function (result) {
            this._busyDialog.close();

            const obj = PrintUtils.unwrap(result);
            const b64 = obj?.FileContent || obj?.FileContentB64 || obj?.ContentB64 || obj?.Base64 || obj?.base64;

            if (!b64) {
                MessageToast.show("ดำเนินการเสร็จสิ้น แต่ไม่พบเนื้อหา PDF");
                return result;
            }

            const mime = obj?.MimeType || "application/pdf";

            try {
                const url = PrintUtils.toBlobUrlFromBase64(String(b64), mime);
                sap.m.URLHelper.redirect(url, true);
                setTimeout(() => URL.revokeObjectURL(url), 60000);
            } catch (e) {
                MessageBox.error("เกิดข้อผิดพลาดในการสร้าง PDF: " + e.message);
            }

            return result;
        }
    });
});
