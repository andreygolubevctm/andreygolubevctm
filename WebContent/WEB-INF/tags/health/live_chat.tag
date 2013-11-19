<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Include the core LIVE CHAT tag --%>
<core:live_chat />

<go:script marker="js-head">
var live_chat = new LiveChat({
		brand	: 'ctm',
		vertical: 'Health',
		unit	: 'health-insurance-sales',
		button	: 'chat-health-insurance-sales',
		journey	: {
			1	: 'health situation',	// Situation
			2	: 'health details',		// Details
			3	: 'health results',		// Results
			4	: 'health application',	// Application
			5	: 'health payment',		// Payment
			6	: 'health confirmation'	// Confirmation
		}
});
</go:script>