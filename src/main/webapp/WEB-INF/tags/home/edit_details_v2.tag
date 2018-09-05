<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="H&C Edit Details Dropdown"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<form class="edit-details-form"><div class="edit-details-wrapper"></div></form>

<c:set var="introPanelStart">
	<div class="visible-lg edit-details-intro-icon" style="float:left;">
		<span class="icon {{= icon }}"></span>
	</div>
	<p class="hidden-xs edit-details-intro-text">Use the handy links below to edit your details and update your results.</p>
</c:set>

<c:set var="introPanelEnd">
	<div class="clearfix"></div>
</c:set>

<c:set var="introPanel">${introPanelStart}${introPanelEnd}</c:set>

<c:if test="${not empty param.action and (param.action eq 'expired' or param.action eq 'promotion')}">
	<%-- Additional template copy --%>
	<c:set var="expiredPanel">
		<form_v2:expired_quote_summary xpath="home/startDate" action="${param.action}" />
	</c:set>
</c:if>

<core_v1:js_template id="edit-details-template">
	${introPanel}
	<div class="clearfix"></div>
	${expiredPanel}
	<div class="panel-group accordion accordion-xs scrollable" id="edit-details-panel-group">
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Edit Details - Cover" quoteChar="\"" /></c:set>
			<div class="accordion-heading visible-xs active-panel">
				<a href="#start" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick" ${analyticsAttr}>Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step1"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step1"> 1. Cover </a>
				</p>
			</div>
			<div id="step1" class="accordion-collapse collapse in first-panel">
				<div class="accordion-body">
					<a href="#start" class="btn btn-sm btn-edit hidden-xs needsclick" ${analyticsAttr}>Edit</a>
					<h5 class="hidden-xs">
						Step 1. Cover
					</h5>
					<div class="row">
						<div class="col-xs-12">
							<p class="detail-title">Cover</p>
							<ul>
								<li><span data-source="#home_coverType"></span></li>
							</ul>
						</div>
						<div class="col-xs-12 push-top-15">
							<p class="detail-title">Address</p>
							<ul>
								<li><span data-source="#home_property_address_fullAddress"></span></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Edit Details - Occupancy" quoteChar="\"" /></c:set>
			<div class="accordion-heading visible-xs">
				<a href="#occupancy" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick" ${analyticsAttr}>Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step2"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step2"> 2. Occupancy </a>
				</p>
			</div>
			<div id="step2" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#occupancy" class="btn btn-sm btn-edit hidden-xs needsclick" ${analyticsAttr}>Edit</a>
					<h5 class="hidden-xs">
						Step 2. Occupancy
					</h5>
					<div class="row">
						<div class="col-xs-12">
							<p class="detail-title">Occupancy</p>
							<ul>
								<li>{{ if(ownsHome) { }}Owns home{{ } else { }}Does not own home{{ } }}</li>
								{{ if(isPrincipalResidence) { }}
									<li>Principal place of residence</li>
									{{ if (ownsHome) { }}
										<li><span data-source="#home_occupancy_howOccupied"></span></li>
									{{ } }}
								{{ } else { }}
									{{ if (ownsHome) { }}
										<li><span data-source="#home_occupancy_howOccupied"></span></li>
									{{ } }}
								{{ } }}
								{{ if(businessActivity) { }}
								<li>Business activity conducted from home</li>
								{{ } else { }}
								<li>Business activity not conducted from home</li>
								{{ } }}
							</ul>
						</div>
					</div>

					<div class="row push-top-15">
						<div class="col-xs-12">
							<p class="detail-title">Previous Cover</p>
							<ul>
								{{ if(previousClaims) { }}
								<li>Has made home and/or contents claims in the last 5 years</li>
								{{ } else { }}
								<li>Has not made home and/or contents claims in the last 5 years</li>
								{{ } }}
							</ul>

						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4 col-r pull-lg-right clear-sm-both">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Edit Details - Property Description" quoteChar="\"" /></c:set>
			<div class="accordion-heading visible-xs">
				<a href="#property" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick" ${analyticsAttr}>Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step3"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step3"> 3. Property Description</a>
				</p>
			</div>
			<div id="step3" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#property" class="btn btn-sm btn-edit hidden-xs needsclick" ${analyticsAttr}>Edit</a>
					<h5 class="hidden-xs">
						Step 3. Property Description
					</h5>
					<div class="row">
						<div class="col-xs-12">
							<p class="detail-title">Type of Property</p>
							<ul>
								<li> <span data-source="#home_property_propertyType"></span></li>
								<li>Home Built: <span data-source="#home_property_yearBuilt"></span></li>
								{{ if(isBodyCorp) { }}
									<li>Body Corporate/Strata Title Complex</li>
								{{ } else { }}
									<li>Is Not Body Corporate/Strata Title Complex</li>
								{{ } }}
							</ul>
						</div>
					</div>
					<div class="row push-top-15">
						<div class="col-xs-12">
							<p class="detail-title">Construction Materials</p>
							<ul>
								<li><span data-source="#home_property_wallMaterial"></span></li>
								<li><span data-source="#home_property_roofMaterial"></span></li>
							</ul>
						</div>
					</div>
					<div class="row push-top-15">
						<div class="col-xs-12">
							<p class="detail-title">Property Features</p>
							<ul class="col-2-list">
								{{if(hasInternalSiren) { }}
									<li><span data-source="#home_property_securityFeatures_internalSiren" data-type="checkboxgroup"></span></li>
								{{ } }}
								{{ if(hasExternalSiren) { }}
									<li><span data-source="#home_property_securityFeatures_externalSiren" data-type="checkboxgroup"></span></li>
								{{ } }}
								{{ if(hasExternalStrobe) { }}
									<li><span data-source="#home_property_securityFeatures_strobeLight" data-type="checkboxgroup"></span></li>
								{{ } }}
								{{ if(hasBackToBase) { }}
									<li><span data-source="#home_property_securityFeatures_backToBase" data-type="checkboxgroup"></span></li>
								{{ } }}
							</ul>
						</div>
					</div>
					<div class="row push-top-15">
						<div class="col-xs-12">
							<p class="detail-title">Cover Amounts</p>
							<ul>
								{{ if(coverType == 'Home Cover Only' || coverType == 'Home & Contents Cover') { }}
									<li>Home Value: <span data-source="#home_coverAmounts_rebuildCostentry"></span></li>
								{{ } }}
								{{ if(coverType == 'Contents Cover Only' || coverType == 'Home & Contents Cover') { }}
									<li>Contents Value: <span data-source="#home_coverAmounts_replaceContentsCostentry"></span></li>
									{{ if(isSpecifyingPersonalEffects && isPrincipalResidence) { }}
										<li>Unspecified Personal Effects <span data-source="#home_coverAmounts_unspecifiedCoverAmount"></span></li>
										{{ if(specifiedPersonalEffects) { }}
											{{ if(bicycles) { }}
												<li>Bicycles: <span data-source="#home_coverAmounts_specifiedPersonalEffects_bicycleentry"></span></li>
											{{ } }}
											{{ if(musical) { }}
												<li>Musical Instruments: <span data-source="#home_coverAmounts_specifiedPersonalEffects_musicalentry"></span></li>
											{{ } }}
											{{ if(clothing) { }}
												<li>Clothing: <span data-source="#home_coverAmounts_specifiedPersonalEffects_clothingentry"></span></li>
											{{ } }}
											{{ if(jewellery) { }}
												<li>Jewellery: <span data-source="#home_coverAmounts_specifiedPersonalEffects_jewelleryentry"></span></li>
											{{ } }}
											{{ if(sporting) { }}
												<li>Sporting Equipment: <span data-source="#home_coverAmounts_specifiedPersonalEffects_sportingentry"></span></li>
											{{ } }}
											{{ if(photography) { }}
												<li>Photographic Equipment: <span data-source="#home_coverAmounts_specifiedPersonalEffects_photoentry"></span></li>
											{{ } }}
										{{ } }}
									{{ } }}
								{{ } }}
							</ul>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
		</div>

		<!-- SessionCam:Hide -->
		<div class="panel accordion-panel col-xs-12 col-sm-6 col-lg-4 clear-lg-left">
			<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="Edit Details - Policy Holders" quoteChar="\"" /></c:set>
			<div class="accordion-heading visible-xs">
				<a href="#policyHolder" class="btn btn-sm btn-edit btn-accordion-control btn-hollow-inverse needsclick" ${analyticsAttr}>Edit</a>
				<span class="icon icon-arrow-down" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step4"></span>
				<p class="accordion-title">
					<a class="needsclick" data-toggle="collapse" data-parent="#edit-details-panel-group" href="#step4"> 4. Policy Holders </a>
				</p>
			</div>
			<div id="step4" class="accordion-collapse collapse">
				<div class="accordion-body">
					<a href="#policyHolder" class="btn btn-sm btn-edit hidden-xs needsclick" ${analyticsAttr}>Edit</a>
					<h5 class="hidden-xs">
						Step 4. Policy Holders
					</h5>
					<div class="row">
						<div class="col-xs-12 col-sm-6">
							<p class="detail-title">Policy Holders</p>
							<ul>
								<li><span data-source="#home_policyHolder_title"></span> <span data-source="#home_policyHolder_firstName"></span> <span data-source="#home_policyHolder_lastName"></span></li>
								<li><span data-source="#home_policyHolder_dob"></span></li>

							</ul>
						</div>
					</div>
					<div class="row push-top-15">
						<div class="col-xs-12">
							<p class="detail-title">Policy Start Date</p>
							<ul class="col-2-list">
								<li><span data-source="#home_startDate"></span></li>
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

</core_v1:js_template>
