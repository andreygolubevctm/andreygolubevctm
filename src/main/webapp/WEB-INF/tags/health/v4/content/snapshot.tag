<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionDataUtils" class="com.ctm.web.core.utils.SessionDataUtils" scope="page" />

<fieldset class="quoteSnapshot sidebar-box hidden-sm tieredHospitalCover">
    <div class="row snapshot living-in">
        <div class="col-md-4">
            <span class="snapshot-title">Living In</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items hidden-xs hidden-sm">
                <span data-source=".health-situation-state" data-type="radiogroup"></span>
            </span>
        </div>
    </div>
    <div class="row snapshot cover-for">
        <div class="col-md-4">
            <span class="snapshot-title">Cover For</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items hidden-xs hidden-sm">
                <span data-source=".health-situation-healthCvr" data-type="radiogroup"></span>
            </span>
        </div>
    </div>
    <div class="row snapshot born">
        <div class="col-md-12">
            <div class="row born-labels">
                <div class="col-md-4 col-md-offset-4">You</div>
                <div class="col-md-4">Partner</div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <span class="snapshot-title">Born</span>
                </div>
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-6">
                            <span class="snapshot-items hidden-xs hidden-sm primary-dob">
                                <span data-source="#health_healthCover_primary_dob"></span>
                            </span>
                        </div>
                        <div class="col-md-6">
                            <span class="snapshot-items hidden-xs hidden-sm partner-dob">
                                <span data-source="#health_healthCover_partner_dob"></span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

