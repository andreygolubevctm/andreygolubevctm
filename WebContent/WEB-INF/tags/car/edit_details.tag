<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Edit Details Dropdown"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form class="edit-details-form"><div class="edit-details-wrapper scrollable"></div></form>

<c:choose>
	<c:when test="${not empty param.action and (param.action eq 'expired' or param.action eq 'promotion')}">

		<c:set var="introPanel">
			<p class="hidden-xs edit-details-intro-text">Use the handy links below to edit your details and update your results.</p>
		</c:set>

		<%-- Load in copy for template --%>
		<c:set var="action" value="${param.action}" />
		<c:set var="contentItem" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "loadQuoteCopy")}' />
		<c:set var="copy" value="${contentItem.getSupplementaryValueByKey(action)}" />

		<%-- Additional template copy --%>
		<c:set var="expiredPanel">
			<div class="panel-group accordion accordion-xs" id="edit-details-expired-panel-group">
				<div class="panel accordion-panel expired-panel col-xs-12 col-sm-12 col-lg-24">
					<div class="accordion-collapse collapse in expired-panel">
						<div class="accordion-body">
							${copy}
							<div class="column col-xs-12 col-sm-9 col-md-7">
								<form id="modal-commencement-date-form" method="post" class="form-horizontal">
									<div class="form-group row fieldrow">
										<label for="quote_options_commencementDate_mobile" class="column col-xs-12 col-sm-7 control-label">Please select a new commencement date</label>
										<div class="column col-xs-12 col-sm-5 row-content">
											<field_new:mobile_commencement_date_dropdown xpath="quote/options/commencementDate" required="true" title="commencement" startDate="${data.quote.options.commencementDate}" />
										</div>
										<div class="fieldrow_legend" id="quote_options_commencementDate_mobile_row_legend"></div>
									</div>
								</form>
							</div>
							<div class="column col-xs-12 col-sm-3 col-md-5">
								<a id="modal-commencement-date-get-quotes" class="btn btn-success btn-block" data-slide-control="next" href="javascript:;">Get Quotes <span class="icon icon-arrow-right"></span></a>
							</div>
							<div class="clearfix"></div>
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="introPanel">
			<p class="hidden-xs edit-details-intro-text">Use the handy links below to edit your details and update your results.</p><p class="hidden-xs closeDetailsDropdown btn btn-sm btn-edit">Back to Results</p>
		</c:set>
	</c:otherwise>
</c:choose>

<core:js_template id="edit-details-template">
	${introPanel}
	<div class="clearfix"></div>
	${expiredPanel}
	<div class="panel-group accordion accordion-xs" id="edit-details-panel-group">
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-12">
			<div class="accordion-heading visible-xs active-panel">
				<a href="#start" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick">Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#startDateAndCar"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#startDateAndCar"> 1. Your Car </a>
				</p>
			</div>
			<div id="startDateAndCar" class="accordion-collapse collapse in first-panel">
				<div class="accordion-body">
					<a href="#start" class="btn btn-sm btn-edit hidden-xs hidden-lg needsclick">Edit</a>
					<h5 class="hidden-xs hidden-lg">
						Your Car
					</h5>
					<div class="visible-lg" style="float:left;">
						<span class="icon icon-car"></span>
					</div>
					<ul class="primary-row-details">
						<li class="vehicle-details-title"><span data-source="#quote_vehicle_make"></span> <span data-source="#quote_vehicle_model"></span></li>
						<li><span data-source="#quote_vehicle_year"></span> <span data-source="#quote_vehicle_body"></span></li>
						<li class="push-right"><span data-source="#quote_vehicle_trans"></span> <span data-source="#quote_vehicle_fuel"></span></li>
						<li>
							<jsp:useBean id="splitTestService" class="com.ctm.services.tracking.SplitTestService" />
							<c:choose>
								<c:when test="${splitTestService.isActive(pageContext.getRequest(), data.current.transactionId, 8)}">
									<span data-source="#quote_vehicle_redbookCode" data-callback="meerkat.modules.carEditDetails.formatRedbookCode"></span>
								</c:when>
								<c:otherwise>
									<span data-source="#quote_vehicle_redbookCode"></span>
								</c:otherwise>
							</c:choose>
						</li>
					</ul>
					<a href="#start" class="btn btn-sm btn-edit stick-btn-left visible-lg needsclick">Edit</a>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4">
			<div class="accordion-heading visible-xs">
				<a href="#options" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick">Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#carUsageAndAccessories"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#carUsageAndAccessories"> 2. Using Your Car & Car Details </a>
				</p>
			</div>
			<div id="carUsageAndAccessories" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#options" class="btn btn-sm btn-edit hidden-xs needsclick">Edit</a>
					<h5 class="hidden-xs">
						Using Your Car & Car Details
					</h5>
					<div class="row">
						<div class="col-xs-12">
							<p class="detail-title">Using Your Car</p>
						</div>
						<div class="col-xs-12 col-sm-6">
							<ul>
								<li>Used for: <span data-source="#quote_vehicle_use"></span></li>
								<li>Finance: <span data-source="#quote_vehicle_finance"></span></li>
							</ul>
						</div>
						<div class="col-xs-12 col-sm-6">
							<ul>
								<li><span data-source="#quote_vehicle_annualKilometres"></span> km/year</li>
								<li><span data-source="#quote_damage" data-callback="meerkat.modules.carEditDetails.formatDamage"></span></li>
							</ul>
						</div>
					</div>
					<div class="row push-top-15">
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Factory / Dealer Options</p>
							<ul data-source="#quote_vehicle_factoryOptionsSelections .added-items ul" data-type="list">
							</ul>
						</div>
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Additional Accessories</p>
							<ul data-source="#quote_vehicle_accessoriesSelections .added-items ul" data-type="list">
							</ul>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
		<!-- SessionCam:Hide -->
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4 clear-left-md clear-left-sm">
			<div class="accordion-heading visible-xs">
				<a href="#details" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick">Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#driverDetailsYoungDriver"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#driverDetailsYoungDriver"> 3. Driver Details & Youngest Driver Details </a>
				</p>
			</div>
			<div id="driverDetailsYoungDriver" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#details" class="btn btn-sm btn-edit hidden-xs needsclick">Edit</a>
					<h5 class="hidden-xs">
						Regular Driver & Youngest Driver Details
					</h5>
					<div class="row">
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Regular Driver</p>
							<ul>
								<li><span data-source="#quote_drivers_regular_gender" data-type="radiogroup"></span> <span data-source="#quote_drivers_regular_dob"></span></li>
								<li><span data-source="#quote_drivers_regular_employmentStatus"></span></li>
								<li><span data-source="#quote_drivers_regular_ncd" data-callback="meerkat.modules.carEditDetails.formatNcd"></span></li>
							</ul>
						</div>
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Youngest Driver</p>
							{{ if(youngDriver == 'Y') { }}
							<ul>
								<li><span data-source="#quote_drivers_young_gender" data-type="radiogroup"></span> <span data-source="#quote_drivers_young_dob"></span></li>
								<li><span data-source="#quote_options_driverOption" data-callback="meerkat.modules.carEditDetails.driverOptin"></span></li>
							</ul>
							{{ } else { }}
								<li>None selected</li>
							{{ } }}
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4">
			<div class="accordion-heading visible-xs">
				<a href="#address" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick">Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#AddressAndContact"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#AddressAndContact"> 4. Start Date, Your Address & Contact Details </a>
				</p>
			</div>
			<div id="AddressAndContact" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#address" class="btn btn-sm btn-edit hidden-xs needsclick">Edit</a>
					<h5 class="hidden-xs">
						Start Date, Your Address & Contact Details
					</h5>
					<div class="row">
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Policy Start Date</p>
							<p>
								<span data-source="#quote_options_commencementDate"></span>
							</p>
						</div>
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Parking Your Car</p>
							<ul>
								<li><span data-source="#quote_riskAddress_fullAddressLineOne"></span></li>
								<li><span data-source="#quote_riskAddress_suburbName"></span> <span data-source="#quote_riskAddress_state"></span> <span data-source="#quote_riskAddress_postCode"></span></li>
							</ul>
						</div>
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Contact Details</p>
							<ul>
								<li><span data-source="#quote_drivers_regular_firstname" data-type="optional"></span> <span data-source="#quote_drivers_regular_surname" data-type="optional"></span></li>
								<li><span data-source="#quote_contact_email" data-type="optional"></span></li>
								<li><span data-source="#quote_contact_phoneinput" data-type="optional"></span></li>
								<li class="noDetailsEntered"><span>Not specified</span></li>
							</ul>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
		<!-- /SessionCam:Hide -->
		<div class="clearfix"></div>
	</div>

</core:js_template>