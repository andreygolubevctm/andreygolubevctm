<%@ tag description="The Health Set To Pending"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="errorMessage" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="transactionId" required="true" rtexprvalue="true" description="Id for this panel"%>
<%@ attribute name="resultXml" required="true" rtexprvalue="true" description="Additional css class attribute"%>
<%@ attribute name="productId" required="true" rtexprvalue="true" description="Additional css class attribute"%>

<c:set var="ignore">
	<jsp:useBean id="joinService" class="com.ctm.services.confirmation.JoinService" scope="page" />
	<c:set var="errorMessage" value="Application failed: ${errorMessage}" />
	<core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}" />

	<%-- Application unsuccessful, provide PendingID --%>
	<c:set var="pendingID">${pageContext.session.id}-${transactionId}</c:set>
	<c:set var="pendingXml"><pendingID>${pendingID}</pendingID></result></c:set>
	<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', pendingXml)}" />
	<go:setData dataVar="data" xpath="health/pendingID" value="${pendingID}" />

	<%-- Save to store error and pendingID --%>
	<c:set var="sandbox">
		<agg:write_quote rootPath="health" productType="HEALTH" triggeredsave="pending" triggeredsavereason="Pending: ${errorMessage}" />
	</c:set>
	${joinService.writeJoin(transactionId,productId)}
</c:set>
<c:if test="${not empty callCentre}">
	<c:set var="resultXml" value="${fn:replace(resultXml, '</result>', '<callcentre>true</callcentre></result>')}" />
</c:if>
${go:XMLtoJSON(resultXml)}