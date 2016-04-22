<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<fieldset class="quoteSnapshot sidebar-box hidden-sm tieredHospitalCover">
    <h4>Quote Summary</h4>
    <div class="default">
        <div>
            <p>We compare policies from seven of the top ten funds in Australia (as well as some smaller ones),
                saving you time and effort when searching for the right policy.
            </p>
        </div>
    </div>
    <div class="row snapshot cover-for">
        <div class="col-md-5">
            <span class="snapshot-title">Cover for:</span>
        </div>
        <div class="col-md-7">
            <span class="snapshot-items hidden-xs hidden-sm">
                <span data-source="#health_situation_healthCvr"></span><a data-slide-control="start" href="javascript:;" class="btn btn-xs btn-edit"><span>Edit</span></a>
            </span>
        </div>
    </div>
    <div class="row snapshot living-in">
        <div class="col-md-5">
            <span class="snapshot-title">Living in:</span>
        </div>
        <div class="col-md-7">
            <span class="snapshot-items hidden-xs hidden-sm">
                <span data-source="#health_situation_location"></span><a data-slide-control="start" href="javascript:;" class="btn btn-xs btn-edit"><span>Edit</span></a>
            </span>
        </div>
    </div>
    <div class="row snapshot looking-to">
        <div class="col-md-5">
            <span class="snapshot-title">Looking to:</span>
        </div>
        <div class="col-md-7">
            <span class="snapshot-items hidden-xs hidden-sm">
                <span data-source="#health_situation_healthSitu"></span>
            </span>
        </div>
    </div>
    <div class="row snapshot cover-type ">
        <div class="col-md-5">
            <span class="snapshot-title">Cover type:</span>
        </div>
        <div class="col-md-7">
            <span class="snapshot-items hidden-xs hidden-sm"><!-- empty --></span>
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

