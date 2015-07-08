<%@ tag description="No results popup content" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:set var="brochurewareUrl" value="${fn:substringBefore(pageSettings.getSetting('exitUrl'), '.au/')}.au/" />

<div id="no-results-content">

	<h2>Sorry, we were unable to get a quote</h2>

	<c:choose>
		<c:when test="${vertical == 'home'}">
			<p>Unfortunately our providers were unable to provide a quote based on the information you have entered. This could be due to a variety of factors depending upon individual circumstances, such as property location, the age of the property, body corporate membership or running a business from the home.</p>
			<p>If you are unable to get a quote from one of our providers, you may want to refer to the Insurance Council of Australia's "Find an Insurer" website at <a href="http://www.findaninsurer.com.au/">www.findaninsurer.com.au</a> and they may be able to provide you with a list of companies who can assist you with cover.</p>
			<p><strong>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</strong></p>
		</c:when>

		<c:when test="${vertical == 'car'}">
			<p>Unfortunately our providers were unable to provide a quote based on the information you have entered. This could be due to a variety of factors such as the age of the driver/s and the vehicle make and/or type etc, depending upon individual circumstances.</p>
			<p>If you are unable to get a quote from one of our providers, you may want to refer to the Insurance Council of Australia's "Find an Insurer" website at <a href="http://www.findaninsurer.com.au/" target="_blank">www.findaninsurer.com.au</a> and they may be able to provide you with a list of companies who can assist you with cover.</p>
			<p><strong>In the meantime, why not compare your other insurances and utilities to see if you can find a better deal.</strong></p>
		</c:when>

		<c:otherwise>
			<p>Unfortunately our providers were unable to supply a quote based on the details you entered... sorry about that!</p>
			<p><strong>If you'd like to compare something else, just choose from the below to start comparing.</strong></p>
		</c:otherwise>
	</c:choose>

	<div class="row verticalButtons">
		<div class="col-xs-6 col-sm-3">
			<a  href="${brochurewareUrl}health-insurance/"><span class="icon icon-health"></span>Health Insurance</a>
		</div>

		<c:if test="${vertical != 'car'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}car-insurance"><span class="icon icon-car"></span>Car Insurance</a>
			</div>
		</c:if>

		<c:if test="${vertical != 'home'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}home-contents-insurance"><span class="icon icon-home-contents"></span>Home &amp; Contents Insurance</a>
			</div>
		</c:if>

		<c:if test="${vertical != 'homeloan'}">
			<div class="col-xs-6 col-sm-3">
				<a href="${brochurewareUrl}home-loans"><span class="icon icon-homeloan"></span>Home Loans</a>
			</div>
		</c:if>

		<div class="col-xs-6 col-sm-3">
			<a  href="${brochurewareUrl}life-insurance/"><span class="icon icon-life"></span>Life Insurance</a>
		</div>

		<c:if test="${vertical != 'travel'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}travel-insurance/"><span class="icon icon-travel"></span>Travel Insurance</a>
			</div>
		</c:if>

		<div class="col-xs-6 col-sm-3">
			<a  href="${brochurewareUrl}income-protection/"><span class="icon icon-ip"></span>Income Protection</a>
		</div>

		<c:if test="${vertical != 'roadside'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}roadside-assistance/"><span class="icon icon-roadside"></span>Roadside Assistance</a>
			</div>
		</c:if>

		<c:if test="${vertical != 'utilities'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}energy/"><span class="icon icon-energy"></span>Energy Comparison</a>
			</div>
		</c:if>

		<c:if test="${vertical != 'fuel'}">
			<div class="col-xs-6 col-sm-3">
				<a  href="${brochurewareUrl}fuel/"><span class="icon icon-fuel"></span>Fuel Prices</a>
			</div>
		</c:if>
	</div>

</div>
