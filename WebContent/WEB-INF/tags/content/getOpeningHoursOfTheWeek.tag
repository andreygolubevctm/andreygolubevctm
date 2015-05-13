<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<jsp:useBean id="openingHoursService" class="com.ctm.services.simples.OpeningHoursService" scope="page" />
<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<div class="all-opening-hours">
	<div class="row">
		<div class="col-md-6" data-padding-pos="all" data-hover-bg="" data-delay="0">
			<div class="row">
				<div class="col-md-12">
					<h3>Normal Opening Hours</h3>				
					<c:forEach var="hoursOfDay"
						items="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">
						<c:set var="weekendClass" value=""/>
						
						<div class="row opening-hours ">	
							<%-- <c:out value="${fn:replace(fn:replace(hoursOfDay,'[', ''),']', '')}"></c:out> <br/> --%>
					   		<div class="day-description col-md-6 col-xs-6""> ${hoursOfDay.description}</div>
					   		<div class="col-md-6 col-xs-6">
					   			<c:choose>
								    <c:when test="${empty hoursOfDay.startTime}">
								    
								        Closed
								    </c:when>
								    <c:otherwise>
								        ${hoursOfDay.startTime} - ${hoursOfDay.endTime}
								    </c:otherwise>
								</c:choose>
							</div>
						</div>
					</c:forEach>
				</div>
				<c:set var="openingHours" value="${openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),true)}"/>
				<c:if test="${not empty openingHours }">
					<div class="col-md-12 special-hours" >
						<h3>Changes To Opening Hours</h3>
						<c:forEach var="hoursOfDay"
							items="${openingHours}">
							<div class="row opening-hours">
								<%-- <c:out value="${fn:replace(fn:replace(hoursOfDay,'[', ''),']', '')}"></c:out> <br/> --%>
						   		<div class="day-description col-md-7 col-xs-7"> ${hoursOfDay.description}  (${hoursOfDay.date})</div>
						   		<div class="col-md-5 col-xs-5">
						   			<c:choose>
									    <c:when test="${empty hoursOfDay.startTime}">
									        Closed
									    </c:when>
									    <c:otherwise>
									        ${hoursOfDay.startTime} - ${hoursOfDay.endTime}
									    </c:otherwise>
									</c:choose>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:if>
			</div><br/>
			<p>All Australian based call centre hours are AEST</p>
		</div>
		<div class="call-details col-md-6" data-padding-pos="all" >
			<div class="row">
				<div class="col-md-12 call-us">
					<h4>Call us on </h4>
					<h1>
						<span class="callCentreNumber">${callCentreNumber}</span>
					</h1>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12">
					<h4>Do you need a hand?</h4>
					<div>
						Let's face it, health insurance can be complicated.<br>
						If you need a hand, here's why you should call us:<br>
						<ul class="">
						  <li>You get personal service from our experienced and friendly staff</li>
						  <li>We help you through each step of the process</li>
						  <li>We answer any questions you may have along the way</li>
						  <li>We can help you find the right cover for your needs</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
