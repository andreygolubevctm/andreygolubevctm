<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_v2:fieldset legend="Snapshot of Your Quote" className="hidden quoteSnapshot">
	<div class="row snapshot">
		<div class="col-sm-3">
			<div class="icon"></div>
		</div>
		<div class="col-sm-9">
			<div class="row">
				<div class="col-sm-12 snapshot-title">
					<span data-source="#home_coverType"></span>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<span data-source="#home_property_address_fullAddress" data-callback="meerkat.modules.homeSnapshot.getAddress"></span>
				</div>
			</div>
		</div>
	</div>
</form_v2:fieldset>