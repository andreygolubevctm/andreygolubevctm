<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get />

<%-- 
	get_ai_refno.jsp

	Makes a call to AI's SSUploadQuote70 webservice to obtain AI's reference number for the quote. 
	
	@param PremiumQuoted	- AI's premium
	@param ExcessQuoted		- Excess selected
	
 --%>
 
<%-- Delete the AI section of the quote xml doc --%>
<go:setData dataVar="data" xpath="quote/ai" value="*DELETE" />

<%-- Recreate the section using the passed params --%>
<go:setData dataVar="data" xpath="quote/ai/PremiumQuoted" value="${param.PremiumQuoted}" />
<go:setData dataVar="data" xpath="quote/ai/ExcessQuoted" value="${param.ExcessQuoted}" />

<%-- Add the vehicle details --%>
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<sql:query var="result">
	SELECT make, model, des
	   FROM aggregator.vehicles
	   WHERE redbookCode = ?
	   LIMIT 1
	<sql:param value="${data['quote/vehicle/redbookCode']}"/>
</sql:query> 

<%-- Make --%>
<go:setData dataVar="data" xpath="quote/ai/Vehicle/Make" value="${result.rows[0].make}" />

<%-- Model --%>
<go:setData dataVar="data" xpath="quote/ai/Vehicle/Model" value="${result.rows[0].model}" />

<%-- Series --%>
<go:setData dataVar="data" xpath="quote/ai/Vehicle/Series" value="${result.rows[0].des}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<jsp:useBean id="configResolver" class="com.ctm.utils.ConfigResolver" scope="application" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/get_ai_refno/config.xml')}" />
<go:soapAggregator config = "${config}"
					transactionId = "${data.text['current/transactionId']}" 
					xml = "${go:getEscapedXml(data['quote'])}" 
					var = "resultXml"
					debugVar="debugXml" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="ai" value="*DELETE" />
<go:setData dataVar="data" xpath="ai" xml="${resultXml}" />

<%-- Was a refno supplied? --%>
<c:out value="${data['ai/ai-response/refno']}" />
