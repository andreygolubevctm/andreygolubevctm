<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>
<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>


<c:set var="sandpit">
	<c:import var="getTransactionID" url="get_transactionid.jsp?quoteType=${rootPath}&id_handler=increment_tranId&emailAddress=${param.email}" />
</c:set>

<go:setData dataVar="data" xpath="${rootPath}/transactionId" value="${data.current.transactionId}" />

<agg:write_quote productType="${productType}" rootPath="${rootPath}" />