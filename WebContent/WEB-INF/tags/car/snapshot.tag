<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="asBubble" required="false" rtexprvalue="true" description="Render style for content"%>

<c:choose>
	<c:when test="${not empty asBubble}"><c:set var="asBubble" value="true" /></c:when>
	<c:otherwise><c:set var="asBubble" value="false" /></c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${asBubble eq true}">
		<ui:bubble variant="chatty" className="quoteSnapshot hidden">
			<div class="row snapshot bubble">
				<div class="col-xs-3 col-sm-3 col-md-2">
					<div class="icon icon-car"></div>
				</div>
				<div class="col-xs-9 col-sm-5 col-md-7">
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
	<c:otherwise>
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
	</c:otherwise>
</c:choose>