<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_new:fieldset legend="Snapshot of Your Quote" className="hidden-sm hidden quoteSnapshot">
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
					<span data-source="#home_property_address_streetNum"></span>
					<span data-source="#home_property_address_streetName"></span><br />
					<span data-source="#home_property_address_suburb"></span><br />
					<span data-source="#home_property_address_state"></span>
					<span data-source="#home_property_address_postCode"></span>
				</div>
			</div>
		</div>
	</div>
</form_new:fieldset>