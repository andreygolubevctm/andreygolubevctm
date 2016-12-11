<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionDataUtils" class="com.ctm.web.core.utils.SessionDataUtils" scope="page" />

<fieldset class="quoteSnapshot sidebar-box hidden-sm tieredHospitalCover">
    <%--<div class="row header">--%>
        <%--<div class="col-sm-9">--%>
            <%--<h4>Quote Summary</h4>--%>
        <%--</div>--%>
        <%--<div class="col-sm-3">--%>
            <%--<form_v3:save_results_button label="Save" />--%>
        <%--</div>--%>
    <%--</div>--%>
    <%--<div class="row snapshot quote-ref">--%>
        <%--<div class="col-md-5">--%>
            <%--<span class="snapshot-title">Quote Reference:</span>--%>
        <%--</div>--%>
        <%--<div class="col-md-7">--%>
            <%--<span class="snapshot-items hidden-xs hidden-sm">--%>
                <%--${sessionDataUtils.getTransactionId(data)}--%>
            <%--</span>--%>
        <%--</div>--%>
    <%--</div>--%>
        <div class="row snapshot living-in">
            <div class="col-md-3">
                <span class="snapshot-title">Living In</span>
            </div>
            <div class="col-md-9">
                <span class="snapshot-items hidden-xs hidden-sm">
                    <span data-source="#health_situation_state"></span>
                </span>
            </div>
        </div>
        <div class="row snapshot cover-for">
            <div class="col-md-3">
                <span class="snapshot-title">Cover For</span>
            </div>
            <div class="col-md-9">
                <span class="snapshot-items hidden-xs hidden-sm">
                    <span data-source="#health_situation_healthCvr"></span>
                </span>
            </div>
        </div>
        <div class="row snapshot primary-born">
            <div class="col-md-3">
                <span class="snapshot-title">Born</span>
            </div>
            <div class="col-md-9">
                <span class="snapshot-items hidden-xs hidden-sm">
                    <span data-source="#health_healthCover_primary_dob"></span>
                </span>
            </div>
        </div>
    <%--<div class="row snapshot looking-to">--%>
        <%--<div class="col-md-5">--%>
            <%--<span class="snapshot-title">Looking to:</span>--%>
        <%--</div>--%>
        <%--<div class="col-md-7">--%>
            <%--<span class="snapshot-items hidden-xs hidden-sm">--%>
                <%--<span data-source=".health-situation-healthSitu" data-type="radiogroup"></span>--%>
            <%--</span>--%>
        <%--</div>--%>
    <%--</div>--%>
    <%--<div class="row snapshot cover-type ">--%>
        <%--<div class="col-md-5">--%>
            <%--<span class="snapshot-title">Cover type:</span>--%>
        <%--</div>--%>
        <%--<div class="col-md-7">--%>
            <%--<span class="snapshot-items hidden-xs hidden-sm"><!-- empty --></span>--%>
        <%--</div>--%>
    <%--</div>--%>
    <div class="row snapshot hospital">
        <div class="col-md-5">
            <span class="snapshot-title">Hospital</span>
        </div>
        <div class="col-md-7">
            <span class="snapshot-items hidden-xs hidden-sm">
                <ul class="snapshot-list"></ul>
            </span>
        </div>
    </div>
    <div class="row snapshot extras">
        <div class="col-md-5">
            <span class="snapshot-title">Extras</span>
        </div>
        <div class="col-md-7">
        <span class="snapshot-items hidden-xs hidden-sm">
            <ul class="snapshot-list"></ul>
        </span>
        </div>
    </div>
</fieldset>

