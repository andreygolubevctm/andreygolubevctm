<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Other Products Renderer"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="id" required="false" rtexprvalue="true" description="id of the fieldset" %>
<%@ attribute name="heading" required="false" rtexprvalue="true" description="Heading for the popup" %>
<%@ attribute name="copy" required="false" rtexprvalue="true" description="Extra copy if required" %>
<%@ attribute name="ignore" required="false" rtexprvalue="true" description="Verticals to ignore" %>
<%@ attribute name="orderby" required="false" rtexprvalue="true" description="Define what sort order to execute" %>
<%@ attribute name="lineLimit" required="false" rtexprvalue="true" description="Define the maximum number of verticals per line" %>

<c:if test="${empty lineLimit}">
	<c:set var="lineLimit" value="5" />
</c:if>

<c:set var="fieldSetID">
	<c:choose>
		<c:when test="${not empty id}">${id}</c:when>
		<c:otherwise>confirmation-compare-options</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<fieldset id="${fieldSetID}">

	<c:set var="currentVertical" value="${pageSettings.getVerticalCode()}"/>

	<%-- To add another product, just add another item to the list and
		remember to add a new class and update the sprite sheet
		in framework\modules\less\core\relatedProducts.less --%>

	<%-- Ideally this would come from a database or config/settings to identify all verticals enabled for current brand. --%>
	<c:set var="brand" value="${applicationService.getBrandFromRequest(pageContext.getRequest())}" />

	<c:if test="${not empty heading}">
		<h3>${heading}</h3>
	</c:if>
	<c:if test="${not empty copy}">
		${copy}
	</c:if>
	<c:set var="displayedVerticalCount" value="1" />
	<div class="options-list clearfix verticalButtons">
		<c:forEach items="${brand.sortVerticalsBySeq()}" var="vertical" varStatus="loop">

			<c:set var="displayVertical">
				<c:choose>
					<c:when test="${not empty ignore and fn:contains(ignore, fn:toLowerCase(vertical.getCode()))}">${false}</c:when>
					<c:otherwise>${true}</c:otherwise>
				</c:choose>
			</c:set>

			<c:if test="${displayVertical eq true}">
				<c:set var="verticalSettings" value="${settingsService.getPageSettings(pageSettings.getBrandId(), fn:toUpperCase(vertical.getCode()))}" scope="page"  />

				<c:if test="${verticalSettings.getSetting('displayOption') eq 'Y' and currentVertical ne fn:toLowerCase(vertical.getCode())}">
					<c:if test="${displayedVerticalCount eq 1}">
						<div class="col-sm-1 hidden-xs"></div>
					</c:if>
					<div class="${spacerClass} col-sm-2 col-xs-6">
						<a href="${verticalSettings.getSetting('exitUrl')}"
						   title="${vertical.getName()}">
							<div class="icon icon-${fn:toLowerCase(vertical.getCode())}"></div>${vertical.getName()}
						</a>
					</div>
					<c:if test="${displayedVerticalCount eq lineLimit}">
						<c:set var="displayedVerticalCount" value="0" />
						<div class="col-sm-1 hidden-xs"></div>
					</c:if>
					<c:set var="displayedVerticalCount">${displayedVerticalCount + 1}</c:set>
				</c:if>
			</c:if>
		</c:forEach>
	</div>

</fieldset>