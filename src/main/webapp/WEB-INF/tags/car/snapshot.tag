<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" required="false" rtexprvalue="true" description="The label displayed above the element"%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional classes to be added to the partent element"%>
<%@ attribute name="asBubble" required="false" rtexprvalue="true" description="Render style for content"%>
<%@ attribute name="isHeader" required="false" rtexprvalue="true" description="Render placement for content"%>
<c:set var="hideDiv" value=""/>
<c:if test="${octoberComp && !isHeader}">
	<c:set var="hideDiv" value="hidden"/>
	<competition:snapshot vertical="car" />
</c:if>

<div class="${hideDiv}">
	<c:if test="${empty label}">
		<c:set var="label" value="Snapshot of Your Quote" />
	</c:if>

	<c:choose>
		<c:when test="${not empty className}"><c:set var="className" value="${className}" /></c:when>
		<c:otherwise><c:set var="className" value="hidden-sm" /></c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${not empty asBubble}"><c:set var="asBubble" value="true" /></c:when>
		<c:otherwise><c:set var="asBubble" value="false" /></c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${asBubble eq true}">
			<ui:bubble variant="chatty" className="quoteSnapshot ${className}">
				<div class="row snapshot bubble">
					<div class="col-xs-3 col-sm-2 col-md-2 col-lg-1">
						<div class="icon icon-car"></div>
					</div>
					<div class="col-xs-9 col-sm-6 col-md-7 col-lg-8">
						<div class="row">
							<div class="col-sm-12">
								<span class="snapshot-title">
									<span data-source="#quote_vehicle_make"></span>
									<span data-source="#quote_vehicle_model"></span>
								</span>
								<span class="snapshot-items hidden-xs hidden-sm">
									<span data-source="#quote_vehicle_year"></span>
									<span data-source="#quote_vehicle_body"></span>
									<span data-source="#quote_vehicle_trans"></span>
									<span data-source="#quote_vehicle_fuel"></span>
								</span>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<span data-source="#quote_vehicle_variant"></span>
							</div>
						</div>
					</div>
					<div class="col-xs-12 col-sm-4 col-md-3 change-car-button-row">
						<a href="#start" class="btn btn-next">Change Car ?</a>
					</div>
				</div>
			</ui:bubble>
		</c:when>
	    <c:when test="${isHeader eq true}">
	        <form_v2:fieldset legend="${label}" className="hidden quoteSnapshot ${className}">
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
	        </form_v2:fieldset>
	    </c:when>
		<c:otherwise>
			<form_v2:fieldset legend="${label}" className="hidden quoteSnapshot ${className}">
				<div class="row snapshot car-snapshot">
					<div class="col-sm-2">
						<div class="icon icon-car-solid"></div>
					</div>
					<div class="col-sm-10">
	                    <p><strong>Make &amp; Model: </strong><span data-source="#quote_vehicle_make"> </span> <span data-source="#quote_vehicle_model"></span></p>
	                    <p><strong>Year: </strong><span data-source="#quote_vehicle_year"></span></p>
	                    <p><strong>Body: </strong><span data-source="#quote_vehicle_body"></span></p>
	                    <p><strong>Transmission: </strong><span data-source="#quote_vehicle_trans"></span></p>
	                    <p><strong>Fuel: </strong><span data-source="#quote_vehicle_fuel"></span></p>
	                    <p><strong>Color: </strong><span data-source="#quote_vehicle_colour"></span></p>
	                    <p><strong>Use: </strong><span data-source="#quote_vehicle_use"></span></p>
					</div>
				</div>
	            <div class="row snapshot driver-snapshot">
	                <div class="col-sm-2">
	                    <div class="icon icon-single"></div>
	                </div>
	                <div class="col-sm-10">
	                    <p><strong>Regular Driver Gender: </strong><span data-source="#quote_drivers_regular_gender" data-type="radiogroup"></span></p>
	                    <p><strong>Date of Birth: </strong><span data-source="#quote_drivers_regular_dob"></span></p>
	                    <p><strong>NCD / Rating: </strong><span data-source="#quote_drivers_regular_ncd"></span></p>
	                </div>
	            </div>
	            <div class="row snapshot parking-snapshot">
	                <div class="col-sm-2">
	                    <div class="icon icon-house-solid"></div>
	                </div>
	                <div class="col-sm-10">
	                    <p><strong>Suburb: </strong><span data-source="#quote_riskAddress_suburbName"></span> <span data-source="#quote_riskAddress_postCode"></span></p>
	                    <p><strong>Overnight Parking: </strong><span data-source="#quote_vehicle_parking"></span></p>
	                </div>
	            </div>
			</form_v2:fieldset>
		</c:otherwise>
	</c:choose>

</div>
