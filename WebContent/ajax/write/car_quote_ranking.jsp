<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%-- 
	car_quote_ranking.jsp
	
	Used to send the values chosen on the toggles back to the iSeries. 
	Called whenever the user changes the "importance" of any of the toggles. 
 --%>
<go:log>Writing Ranking</go:log>
<go:setData dataVar="data" xpath="ranking" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />
<go:log>${data.xml['ranking']}</go:log>
<go:log>${data.text['current/transactionId']}</go:log>
<go:call pageId="AGGTRK" transactionId="${data.text['current/transactionId']}" xmlVar="${data.xml['ranking']}" />
