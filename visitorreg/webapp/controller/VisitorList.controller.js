sap.ui.define([
    "sap/ui/core/mvc/Controller"
], function (Controller) {
    "use strict";

    return Controller.extend("zmp.visitorreg.controller.VisitorList", {

        onInit: function () {
            this.getOwnerComponent().getRouter().getRoute("RouteVisitorList")
                .attachPatternMatched(this._onRouteMatched, this);
        },

        _onRouteMatched: function () {
            // Reload so visitors created since the last visit show up
            const oBinding = this.byId("visitorTable").getBinding("items");
            if (oBinding) {
                oBinding.refresh();
            }
        },

        // "total" is the $count from the backend, not just the rows loaded so far
        onUpdateFinished: function (oEvent) {
            const oBundle = this.getOwnerComponent().getModel("i18n").getResourceBundle();
            this.byId("tableTitle").setText(oBundle.getText("list.titleCount", [oEvent.getParameter("total")]));
        },

        onNavBack: function () {
            this.getOwnerComponent().getRouter().navTo("RouteDashboard", {}, true);
        }
    });
});
