<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<go:log>Writing Report</go:log>
<go:setData dataVar="data" value="*PARAMS" />
<go:log>${data.text['current/transactionId']}</go:log>
<go:call pageId="AGGTRP" transactionId="${data.text['current/transactionId']}" xmlVar="${go:getEscapedXml(data['quote'])}" />
