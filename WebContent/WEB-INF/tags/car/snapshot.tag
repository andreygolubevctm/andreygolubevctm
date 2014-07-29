<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form_new:fieldset legend="Snapshot of Your Quote" className="hidden-sm hidden quoteSnapshot">
	<div class="row snapshot">
		<div class="col-sm-3">
			<div class="icon icon-car"></div>
		</div>
		<div class="col-sm-9">
			<div class="row">
				<div class="col-sm-12 snapshot-title">
					<span data-source="#quote_vehicle_make"></span>
					<span data-source="#quote_vehicle_model"></span>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<span data-source="#quote_vehicle_year"></span>
				</div>
				<div class="col-sm-6">
					<span data-source="#quote_vehicle_body"></span>
				</div>
				<div class="col-sm-6">
					<span data-source="#quote_vehicle_trans"></span>
				</div>
				<div class="col-sm-6">
					<span data-source="#quote_vehicle_fuel"></span>
				</div>
			</div>
		</div>
	</div>
</form_new:fieldset>