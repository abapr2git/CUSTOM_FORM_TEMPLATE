sap.ui.define([], function () {
    "use strict";

    return {
        /**
         * Unwrap result จาก invokeAction ให้ได้ object จริง
         * @param {*} result - ผลลัพธ์จาก invokeAction
         * @returns {object|null}
         */
        unwrap: function (result) {
            if (!result) return null;

            // OData v4 context
            if (result.context?.getObject) {
                try { return result.context.getObject(); } catch (e) { console.warn("PrintUtils.unwrap: context.getObject failed", e); }
            }

            // Direct getObject
            if (result.getObject) {
                try { return result.getObject(); } catch (e) { console.warn("PrintUtils.unwrap: getObject failed", e); }
            }

            // Array result (e.g. batch response)
            if (Array.isArray(result)) {
                const first = result[0];
                const v = first?.value ?? first;
                if (v?.getObject) {
                    try { return v.getObject(); } catch (e) { console.warn("PrintUtils.unwrap: array[0].getObject failed", e); }
                }
                return v;
            }

            // Plain value wrapper
            if (typeof result === "object" && "value" in result) return result.value;

            return result;
        },

        /**
         * แปลง Base64 เป็น Blob URL สำหรับเปิด PDF
         * @param {string} b64 - Base64 string
         * @param {string} [mime="application/pdf"] - MIME type
         * @returns {string} Blob URL
         */
        toBlobUrlFromBase64: function (b64, mime) {
            if (typeof b64 !== "string" || !b64) throw new Error("Invalid base64 payload");

            // Strip data URI prefix ถ้ามี
            const raw = b64.includes("base64,") ? b64.split("base64,").pop() : b64;

            const bin = atob(raw);
            const bytes = new Uint8Array(bin.length);
            for (let i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);

            const blob = new Blob([bytes], { type: mime || "application/pdf" });
            return URL.createObjectURL(blob);
        }
    };
});
