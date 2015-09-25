<%@ tag description="Layout for a slide"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="formId" required="false"	description="The ID of the form for this slide"%>

<%@ attribute name="firstSlide" required="false"	description="Is this slide the first slide?"%>
<%@ attribute name="lastSlide" 	required="false"	description="Is this slide the last slide?"%>
<%@ attribute name="className" 	required="false"	description="Additional classes to add to the slide"%>

<%@ attribute name="nextLabel" 		required="false"	description="Whether to hide prev and next buttons or not on this slide"%>

<%@ attribute name="prevStepId" 	required="false"	description="Step ID that the previous button should point to"%>
<%@ attribute name="nextStepId" 	required="false"	description="Step ID that the next button should point to"%>
<%@ attribute name="offsetRight" 	required="false"	description="Full width slide offset button to right"%>

<c:choose>
<c:when test="${offsetRight == true}">
	<c:set var="offset" value="col-sm-offset-1 col-md-offset-4 " />
</c:when>
<c:otherwise>
	<c:set var="offset" value="" />
</c:otherwise>
</c:choose>

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionSecret"><content:get key="competitionSecret"/></c:set>
<c:set var="competitionEnabled" value="${false}" />
<c:if test="${competitionEnabledSetting == 'Y' && (competitionSecret == 'kSdRdpu5bdM5UkKQ8gsK')}"> <%--Split test needs to allow previous competition ($1000 promo) to remain active. TODO: Cleanup--%>
	<c:set var="competitionEnabled" value="${true}" />
</c:if>

<c:if test="${empty prevStepId}"><c:set var="prevStepId" value="previous" /></c:if>
<c:if test="${empty nextStepId}"><c:set var="nextStepId" value="next" /></c:if>

<div role="form" class="journeyEngineSlide<c:if test='${firstSlide eq true}'><c:out value=' first' /></c:if><c:if test='${lastSlide eq true}'><c:out value=' last' /></c:if><c:out value=' ${className}' />">

<c:if test="${not empty formId}">
	<form  id="${formId}" autocomplete="off" class="form-horizontal" role="form">
</c:if>
		<jsp:doBody />
<c:if test="${not empty formId}">
	</form>
</c:if>

	<c:if test="${not empty nextLabel}">
		<div class="row">
			<div class="${offset}col-sm-8">
				<div class="row slideAction">
					<div class="col-sm-offset-4 col-xs-12 col-sm-6 col-md-4">
						<a class="btn btn-next btn-block nav-next-btn show-loading journeyNavButton" data-slide-control="${nextStepId}" href="javascript:;" ><c:out value='${nextLabel} ' /> <span class="icon icon-arrow-right"></span></a>
					</div>
				</div>
				<%-- COMPETITION START --%>
				<c:if test="${competitionEnabled == true and pageSettings.getVerticalCode() eq 'health'}">
					<c:set var="competitionPromoImage"><content:get key="competitionPromoImage"/></c:set>
					<c:if test="${fn:contains(competitionPromoImage, 'health1000promoImage')}">
						<c:set var="offset_class" value="col-md-offset-4"/>
					</c:if>
					<c:if test="${not empty competitionPromoImage && firstSlide eq true}">
						<div class="row">
							<div class="col-xs-12 ${offset_class} col-md-8">
								<c:out value="${competitionPromoImage}" escapeXml="false" />
							</div>
						</div>
					</c:if>
				</c:if>
			</div>
		</div>
	</c:if>
</div>
