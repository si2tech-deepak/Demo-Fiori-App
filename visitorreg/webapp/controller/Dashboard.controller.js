sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/core/format/DateFormat",
    "sap/m/MessageBox"
], function (Controller, JSONModel, Filter, FilterOperator, DateFormat, MessageBox) {
    "use strict";

    return Controller.extend("zmp.visitorreg.controller.Dashboard", {

        onInit: function () {
            this.getView().setModel(new JSONModel({ total: 0, today: 0, busy: true }), "dashboard");

            // Runs every time the dashboard is shown, so the numbers are fresh after creating a visitor
            this.getOwnerComponent().getRouter().getRoute("RouteDashboard")
                .attachPatternMatched(this._loadCounts, this);
        },

        onShowVisitors: function () {
            this.getOwnerComponent().getRouter().navTo("RouteVisitorList");
        },

        onCreate: function () {
            this.getOwnerComponent().getRouter().navTo("RouteCreate");
        },

        _loadCounts: function () {
            const oViewModel = this.getView().getModel("dashboard");
            const sToday = DateFormat.getDateInstance({ pattern: "yyyy-MM-dd" }).format(new Date());

            oViewModel.setProperty("/busy", true);

            // Both requests go to the backend together in one $batch
            Promise.all([
                this._count(),
                this._count([new Filter("VisitDate", FilterOperator.EQ, sToday)])
            ]).then(function (aCounts) {
                oViewModel.setData({ total: aCounts[0], today: aCounts[1], busy: false });
            }).catch(function (oError) {
                oViewModel.setProperty("/busy", false);
                MessageBox.error(oError.message);
            });
        },

        // Asks the backend how many Visitor rows match; reads one row, the total comes from $count
        _count: function (aFilters) {
            const oBinding = this.getOwnerComponent().getModel()
                .bindList("/Visitor", undefined, undefined, aFilters, { $count: true });

            return oBinding.requestContexts(0, 1).then(function () {
                const iCount = oBinding.getHeaderContext().getProperty("$count");
                oBinding.destroy();
                return iCount;
            });
        }
    });
});
