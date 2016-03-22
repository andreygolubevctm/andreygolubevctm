<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_v2:fieldset legend="Snapshot of Your Quote" className="hidden quoteSnapshot">
	<div class="row snapshot cover-snapshot">
		<div class="col-sm-2">
			<div class="icon icon-house-solid"></div>
		</div>
		<div class="col-sm-10">
            <p><strong>Cover: </strong><span data-source="#home_coverType"></span></p>
            <p><strong>Address: </strong><span data-source="#home_property_address_fullAddress" data-callback="meerkat.modules.homeSnapshot.getAddress"></span></p>
		</div>
	</div>
    <div class="row snapshot amount-snapshot">
        <div class="col-sm-2">
            <div class="icon icon-dollar"></div>
        </div>
        <div class="col-sm-10">
            <p><strong>Home cover: </strong><span data-source="#home_coverAmounts_rebuildCostentry"></span></p>
            <p><strong>Contents cover: </strong><span data-source="#home_coverAmounts_replaceContentsCostentry"></span></p>
        </div>
    </div>
    <div class="row snapshot holder-snapshot">
        <div class="col-sm-2">
            <div class="icon icon-single"></div>
        </div>
        <div class="col-sm-10">
            <p><strong>Policy holder: </strong><span data-source="#home_policyHolder_title"></span> <span data-source="#home_policyHolder_firstName"></span> <span data-source="#home_policyHolder_lastName"></span></p>
            <p><strong>DOB: </strong><span data-source="#home_policyHolder_dob"></span></p>
            <p><strong>Joint Policy holder: </strong><span data-source="#home_policyHolder_jointTitle"></span> <span data-source="#home_policyHolder_jointFirstName"></span> <span data-source="#home_policyHolder_jointLastName"></span></p>
            <p><strong>DOB: </strong><span data-source="#home_policyHolder_jointDob"></span></p>
        </div>
    </div>
</form_v2:fieldset>