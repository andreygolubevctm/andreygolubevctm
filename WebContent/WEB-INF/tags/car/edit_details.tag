<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Edit Details Dropdown"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<form class="edit-details-form"><div class="edit-details-wrapper scrollable"></div></form>

<core:js_template id="edit-details-template">
	<p class="hidden-xs edit-details-intro-text">Use the handy links below to edit your details and update your results.</p>
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
						<li><span data-source="#quote_vehicle_redbookCode"></span></li>
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
								<li><span data-source="#quote_drivers_regular_firstname"></span> <span data-source="#quote_drivers_regular_surname"></span></li>
								<li><span data-source="#quote_contact_email"></span></li>
								<li><span data-source="#quote_contact_phoneinput"></span></li>
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