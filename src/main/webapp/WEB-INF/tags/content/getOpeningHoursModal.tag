<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>
<c:set var="openingHoursTimeZone"><content:get key="openingHoursTimeZone" /></c:set>

<div class="all-opening-hours">
	<div class="row">
		<div class="col-md-6" data-padding-pos="all" data-hover-bg="" data-delay="0">
			<div class="row">
				<div class="col-md-12">
					<h3>Normal Opening Hours</h3>
					<c:forEach var="hoursOfDay"
						items="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest())}">

						<div class="row day_row">
							<div class="day-description col-md-6 col-xs-6"> ${hoursOfDay.description}</div>
							<div class="col-md-6 col-xs-6">
								<c:choose>
									<c:when test="${empty hoursOfDay.startTime}">
										<c:out value="Closed"/>
									</c:when>
									<c:otherwise>
										<c:out value="${hoursOfDay.startTime} - ${hoursOfDay.endTime}"/>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:forEach>
				</div>
				<c:set var="openingHours" value="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest())}"/>
				<c:if test="${not empty openingHours }">
					<div class="col-md-12 special-hours" >
						<h3>Changes To Opening Hours</h3>
						<c:forEach var="hoursOfDay"
							items="${openingHours}">
							<div class="row day_row">
								<div class="day-description col-md-7 col-xs-7"> ${hoursOfDay.description}  (${hoursOfDay.date})</div>
								<div class="col-md-5 col-xs-5">
									<c:choose>
										<c:when test="${empty hoursOfDay.startTime}">
											<c:out value="Closed" />
										</c:when>
										<c:otherwise>
											<c:out value="${hoursOfDay.startTime} - ${hoursOfDay.endTime}"/>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:if>
			</div><br/>
			<p>All Australian based call centre hours are ${openingHoursTimeZone}</p>
		</div>
		<div class="call-details col-md-6" data-padding-pos="all" >
			<div class="row">
				<div class="col-md-12 call-us">
					<h4>Call us on </h4>
					<h1>
						<span class="callCentreNumber">${callCentreNumber}</span><span class="callCentreAppNumber" style="display:none">${callCentreAppNumber}</span>
					</h1>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<health_v1_content:call_centre_help/>
				</div>
			</div>
		</div>
	</div>
</div>
