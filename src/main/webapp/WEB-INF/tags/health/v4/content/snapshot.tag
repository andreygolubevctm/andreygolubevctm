<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="sessionDataUtils" class="com.ctm.web.core.utils.SessionDataUtils" scope="page" />

<fieldset class="quoteSnapshot sidebar-box hidden-sm">
    <div class="row snapshot living-in hidden">
        <div class="col-md-4">
            <span class="snapshot-title">Living In</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items">
                <span data-source="#health_situation_state" data-type="radiogroup"></span>
            </span>
        </div>
    </div>
    <div class="row snapshot cover-for">
        <div class="col-md-4">
            <span class="snapshot-title">Cover For</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items">
                <span data-source=".health-situation-healthCvr" data-type="radiogroup"></span>
            </span>
        </div>
    </div>
    <div class="row snapshot born">
        <div class="col-md-12">
            <div class="row born-labels hidden">
                <div class="col-md-4 col-md-offset-4">You</div>
                <div class="col-md-4">Partner</div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <span class="snapshot-title">Born</span>
                </div>
                <div class="col-md-8">
                    <div class="row">
                        <div class="primary-dob">
                            <span class="snapshot-items">
                                <span data-source="#health_healthCover_primary_dob"></span>
                            </span>
                        </div>
                        <div class="partner-dob">
                            <span class="snapshot-items">
                                <span data-source="#health_healthCover_partner_dob"></span>
                                <a href="javascript:;" class="add-partner-dob hidden">+ Add</a>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row snapshot rebate">
        <div class="col-md-4">
            <span class="snapshot-title">Gov. Rebate</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items rebate-text"></span>
            <span class="snapshot-items sub-text"></span>
        </div>
    </div>
    <div class="row snapshot hospital">
        <div class="col-md-4">
            <span class="snapshot-title">Hospital</span>
        </div>
        <div class="col-md-8">
            <span class="snapshot-items">
                <span class="snapshot-item-first"></span>
                <ul class="snapshot-list"></ul>
                <a href="javascript:;" class="toggle-snapshot-list hidden">
                    and <span class="snapshot-list-count"></span> more
                </a>
            </span>
        </div>
    </div>
    <div class="row snapshot extras">
        <div class="col-md-4">
            <span class="snapshot-title">Extras</span>
        </div>
        <div class="col-md-8">
        <span class="snapshot-items">
                <span class="snapshot-item-first"></span>
                <ul class="snapshot-list"></ul>
                <a href="javascript:;" class="toggle-snapshot-list hidden">
                    and <span class="snapshot-list-count"></span> more
                </a>
        </span>
        </div>
    </div>
    <a href="javascript:;" class="icon-pencil btn-edit" data-slide-control="start"></a>
</fieldset>