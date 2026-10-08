sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/Messaging",
    "sap/m/MessageToast",
    "sap/m/MessageBox"
], function (Controller, Messaging, MessageToast, MessageBox) {
    "use strict";

    const GROUP_ID = "visitorGroup";

    return Controller.extend("zmp.visitorreg.controller.Main", {

        onInit: function () {
            // Show input-format errors (e.g. invalid date) on the fields themselves
            Messaging.registerObject(this.getView(), true);

            this._oModel = this.getOwnerComponent().getModel();
            this._oListBinding = this._oModel.bindList("/Visitor", undefined, undefined, undefined, {
                $$updateGroupId: GROUP_ID
            });

            this._createEntry();
        },

        onSubmit: function () {
            const oView = this.getView();
            const oBundle = this._getBundle();

            // Block submit while fields still contain unparsable input
            const aInputErrors = this._getMessages(false).filter(function (oMsg) {
                return oMsg.getType() === "Error";
            });
            if (aInputErrors.length > 0) {
                MessageBox.error(oBundle.getText("msg.fixInput"));
                return;
            }

            // Clear backend messages from the previous attempt
            Messaging.removeMessages(this._getMessages(true));

            oView.setBusy(true);
            this._oModel.submitBatch(GROUP_ID).then(function () {
                oView.setBusy(false);

                if (this._oModel.hasPendingChanges(GROUP_ID)) {
                    // Backend rejected the record; the entry stays in the browser for correction
                    const sText = this._getMessages(true)
                        .filter(function (oMsg) { return oMsg.getType() === "Error"; })
                        .map(function (oMsg) { return oMsg.getMessage(); })
                        .join("\n");
                    MessageBox.error(sText || oBundle.getText("msg.saveFailed"));
                    return;
                }

                const sName = this._oContext.getProperty("VisitorName");
                MessageToast.show(oBundle.getText("msg.saved", [sName]));
                this._createEntry();
            }.bind(this)).catch(function (oError) {
                oView.setBusy(false);
                MessageBox.error(oBundle.getText("msg.saveFailed") + "\n" + oError.message);
            });
        },

        onClear: function () {
            Promise.resolve(this._oModel.resetChanges(GROUP_ID)).then(function () {
                this._createEntry();
            }.bind(this));
        },

        onNavBack: function () {
            // Discard a half-filled form so it doesn't reappear next time
            this.onClear();
            this.getOwnerComponent().getRouter().navTo("RouteDashboard", {}, true);
        },

        _createEntry: function () {
            Messaging.removeAllMessages();

            this._oContext = this._oListBinding.create({
                VisitDate: this._today(),
                CheckInTime: this._now()
            });

            // Resetting a new entry cancels it; that is expected. Anything else is propagated.
            this._oContext.created().catch(function (oError) {
                if (!oError.canceled) {
                    throw oError;
                }
            });

            this.byId("visitorForm").setBindingContext(this._oContext);
        },

        _getMessages: function (bFromBackend) {
            const oModel = this._oModel;
            return Messaging.getMessageModel().getData().filter(function (oMsg) {
                return (oMsg.getMessageProcessor() === oModel) === bFromBackend;
            });
        },

        _getBundle: function () {
            return this.getOwnerComponent().getModel("i18n").getResourceBundle();
        },

        _today: function () {
            const d = new Date();
            return d.getFullYear() + "-" + this._pad(d.getMonth() + 1) + "-" + this._pad(d.getDate());
        },

        _now: function () {
            const d = new Date();
            return this._pad(d.getHours()) + ":" + this._pad(d.getMinutes()) + ":00";
        },

        _pad: function (n) {
            return String(n).padStart(2, "0");
        }
    });
});