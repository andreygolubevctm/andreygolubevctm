<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Home & Contents Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:choose>
	<c:when test="${octoberComp}">
		<competition:snapshot vertical="home and/or contents" additionalClass="--home" />
	</c:when>
	<c:otherwise>
		<form_v2:fieldset legend="Snapshot of Your Quote" className="hidden quoteSnapshot">

			<div class="row snapshot cover-snapshot">
				<div class="col-sm-2">
					<div class="icon icon-house-solid"></div>
				</div>
				<div class="col-sm-10">
		            <p><strong>Cover: </strong><span data-source="#home_coverType"></span></p>
		            <p><strong>Address: </strong><span data-source="#home_property_address_fullAddress" data-callback="meerkat.modules.homeSnapshot.getAddressFirstLine"></span><br /><span data-source="#home_property_address_suburbName"></span> <span data-source="#home_property_address_state"></span> <span data-source="#home_property_address_postCode"></span></p>
				</div>
			</div>
		    <div class="row snapshot amount-snapshot">
		        <div class="col-sm-2">
		            <div class="icon icon-dollar"></div>
		        </div>
		        <div class="col-sm-10">
		            <p><strong>Home cover: </strong><span data-source="#home_coverAmounts_rebuildCostentry" data-callback="meerkat.modules.homeSnapshot.getHomeAmount"></span></p>
								<div class="notLandlord">
								    <p><strong>Contents cover: </strong><span data-source="#home_coverAmounts_replaceContentsCostentry" data-callback="meerkat.modules.homeSnapshot.getContentAmount"></span></p>
								</div>
		        		<div class="isLandlord">
										<p><strong>Contents cover: </strong><span data-source="#home_coverAmounts_replaceContentsCostLandlordentry" data-callback="meerkat.modules.homeSnapshot.getContentAmount"></span></p>
								</div>
		        </div>
		    </div>
		    <div class="row snapshot holder-snapshot">
		        <div class="col-sm-2">
		            <div class="icon icon-single"></div>
		        </div>
		        <div class="col-sm-10">
		            <p><strong>Policy holder: </strong><span data-source="#home_policyHolder_title"></span> <span data-source="#home_policyHolder_firstName"></span> <span data-source="#home_policyHolder_lastName"></span></p>
		            <p><strong>DOB: </strong><span data-source="#home_policyHolder_dob"></span></p>
		            <p><strong>Joint Policy holder: </strong><span data-source="#home_policyHolder_jointTitle" data-callback="meerkat.modules.homeSnapshot.getJointHolderName"></span></p>
		            <p><strong>DOB: </strong><span data-source="#home_policyHolder_jointDob" data-callback="meerkat.modules.homeSnapshot.getJointHolderDob"></span></p>
		        </div>
		    </div>
		</form_v2:fieldset>

	</c:otherwise>
</c:choose>
