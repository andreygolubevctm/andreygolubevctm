<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="providerId" 	required="true"	 rtexprvalue="true"	 description="Id of provider to link the promo content" %>
<%@ attribute name="healthPriceService" type="com.ctm.web.health.services.HealthPriceService" required="true" rtexprvalue="true" description="service to get tranId and application date" %>

<jsp:useBean id="specialOffersService" class="com.ctm.web.simples.admin.services.SpecialOffersService" scope="page" />
<%-- VARIABLES --%>
<c:set var="styleCodeId"><core_v1:get_stylecode_id transactionId="${healthPriceService.getTransactionId()}" /></c:set>
<c:set var="applicationDate" value="${healthPriceService.getApplicationDate()}" />
<%-- XML START --%>
<fmt:setLocale value="en_US" />
<promoData>
	<c:set var="contentItems" value='${specialOffersService.getSpecialOffers(providerId, styleCodeId, applicationDate,healthPriceService)}' />
	<c:forEach items="${contentItems}" var="item" varStatus="status">
		<c:set var="summary" value="${item.content}" />
		<c:set var="dialog" value="${item.terms}" />
		<c:if test="${not empty summary}">
			<promoText><![CDATA[
					${fn:trim(summary)}
				<c:if test="${not empty dialog}"><p><a class="dialogPop" data-content="${fn:escapeXml(fn:trim(dialog))}" title="Conditions">^ Conditions</a></p></c:if>
				]]></promoText>
		</c:if>
	</c:forEach>

	<%-- Retrieve and render the common discountText --%>
	<c:set var="discountItems" value='${contentService.getMultipleContentValuesForProvider("discountText", providerId, styleCodeId, applicationDate, true)}' />
	<c:forEach items="${discountItems}" var="item" varStatus="status">
		<c:set var="content" value="${item.getSupplementaryValueByKey('content')}" />
		<c:if test="${not empty content}">
			<discountText><c:out value="${fn:trim(content)}" /></discountText>
		</c:if>
	</c:forEach>


	<%-- Retrieve and render the product specific promo content --%>
	<c:set var="contentItems" value='${contentService.getMultipleContentValuesForProvider("promo", providerId, styleCodeId, applicationDate, true)}' />
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
			<hospitalPDF><![CDATA[<c:out value="${pageSettings.getBaseUrl()}" />health_brochure.jsp?pdf=<c:out value="${fn:trim(hospitalPDF)}"/>]]></hospitalPDF>
		</c:if>
		<c:if test="${not empty extrasPDF}">
			<extrasPDF><![CDATA[<c:out value="${pageSettings.getBaseUrl()}" />health_brochure.jsp?pdf=<c:out value="${fn:trim(extrasPDF)}"/>]]></extrasPDF>
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

<%-- Retrieve and render the provider Phone numbers --%>
	<c:set var="providerPhoneNumberList" value='${contentService.getMultipleContentValuesForProvider("providerPhoneNumber", providerId, styleCodeId, applicationDate, false)}' />
	<c:forEach items="${providerPhoneNumberList}" var="item" varStatus="status">
		<c:set var="providerPhoneNumber" value="${item.getContentValue()}" />
		<c:if test="${not empty providerPhoneNumber}">
			<providerPhoneNumber><![CDATA[<c:out value="${providerPhoneNumber}"/>]]></providerPhoneNumber>
		</c:if>
	</c:forEach>
	<c:set var="providerDirectPhoneNumberList" value='${contentService.getMultipleContentValuesForProvider("providerDirectPhoneNumber", providerId, styleCodeId, applicationDate, false)}' />
	<c:forEach items="${providerDirectPhoneNumberList}" var="item" varStatus="status">
		<c:set var="providerDirectPhoneNumber" value="${item.getContentValue()}" />
		<c:if test="${not empty providerDirectPhoneNumber}">
			<providerDirectPhoneNumber><![CDATA[<c:out value="${providerDirectPhoneNumber}"/>]]></providerDirectPhoneNumber>
		</c:if>
	</c:forEach>

</promoData>
<%-- XML END --%>