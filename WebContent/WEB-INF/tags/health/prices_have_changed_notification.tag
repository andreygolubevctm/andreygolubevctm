<%@ tag description="Terms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="quick-note" class="displayNone" >
	<p>
		There have been some updates to our products since you last visited us.
		Here's the latest products based on your previously entered preferences.
		Hurry, buy now and don't miss out.
	</p>
	<p>
	Call our friendly team on <b class="text-primary callCentreNumber">${callCentreNumber}</b> for
	professional help on selecting the right health policy for you or
		<a href="${pageSettings.getBaseUrl()}health_quote.jsp">start a new quote</a>.
	</p>
</div>