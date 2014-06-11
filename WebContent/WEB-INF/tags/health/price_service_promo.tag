<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="contentService" class="com.ctm.services.ContentService" scope="request" />

<%-- ATTRIBUTES --%>
<%@ attribute name="providerId" 		required="true"	 rtexprvalue="true"	 description="Id of provider to link the promo content" %>

<%-- XML START --%>
<fmt:setLocale value="en_US" />
<promoData>
<%-- Retrieve and render the common promotext --%>
<c:set var="contentItems" value='${contentService.getMultipleContentValuesForProvider(pageContext, "promoText", providerId)}' />
<c:forEach items="${contentItems}" var="item" varStatus="status">
	<c:set var="summary" value="${item.getSupplementaryValueByKey('summary')}" />
	<c:set var="dialog" value="${item.getSupplementaryValueByKey('dialog')}" />
	<c:if test="${not empty summary}">
	<promoText><![CDATA[
		${fn:trim(summary)}
		<c:if test="${not empty dialog}"><p><a class="dialogPop" data-content="${fn:trim(dialog)}" title="Conditions">^ Conditions</a></p></c:if>
	]]></promoText>
	</c:if>
</c:forEach>
<%-- Retrieve and render the common discountText --%>
<c:set var="contentItems" value='${contentService.getMultipleContentValuesForProvider(pageContext, "discountText", providerId)}' />
<c:forEach items="${contentItems}" var="item" varStatus="status">
	<c:set var="content" value="${item.getSupplementaryValueByKey('content')}" />
	<c:if test="${not empty content}">
	<discountText><c:out value="${fn:trim(content)}" /></discountText>
	</c:if>
</c:forEach>
<%-- Retrieve and render the product specific promo content --%>
<c:set var="contentItems" value='${contentService.getMultipleContentValuesForProvider(pageContext, "promo", providerId)}' />
<c:forEach items="${contentItems}" var="item" varStatus="status">
	<c:set var="hospitalAttr" value="${item.getSupplementaryValueByKey('@hospital')}" />
	<c:set var="hospitalPDF" value="${item.getSupplementaryValueByKey('hospitalPDF')}" />
	<c:set var="extrasAttr" value="${item.getSupplementaryValueByKey('@extras')}" />
	<c:set var="extrasPDF" value="${item.getSupplementaryValueByKey('extrasPDF')}" />
	<c:set var="discountText" value="${item.getSupplementaryValueByKey('discountText')}" />
	<c:set var="promoTextSummary" value="${item.getSupplementaryValueByKey('promoTextSummary')}" />
	<c:set var="promoTextDialog" value="${item.getSupplementaryValueByKey('promoTextDialog')}" />
	<promo <c:if test="${not empty hospitalAttr}">hospital="${fn:trim(hospitalAttr)}"</c:if><c:out value=" " /><c:if test="${not empty extrasAttr}">extras="${fn:trim(extrasAttr)}"</c:if>>
	<c:if test="${not empty hospitalPDF}">
		<hospitalPDF><c:out value="${fn:trim(hospitalPDF)}"/></hospitalPDF>
	</c:if>
	<c:if test="${not empty extrasPDF}">
		<extrasPDF><c:out value="${fn:trim(extrasPDF)}"/></extrasPDF>
	</c:if>
	<c:if test="${not empty discountText}">
		<discountText>${discountText}</discountText>
	</c:if>
	<c:if test="${not empty promoTextSummary}">
		<promoText><![CDATA[
			${promoTextSummary}
			<c:if test="${not empty promoTextDialog}">
			<p><a class="dialogPop" data-content="${promoTextDialog}" title="Conditions">^ Conditions</a></p>
			</c:if>
		]]></promoText>
	</c:if>
	</promo>
</c:forEach>
<%-- XML END --%>
</promoData>