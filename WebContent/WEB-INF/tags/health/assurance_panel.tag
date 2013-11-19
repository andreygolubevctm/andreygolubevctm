<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="The assurrance messaging panel" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div class="health-assurance-message side-message">
	<div class="header">&nbsp;</div>
	<div class="middle">
		<div class="panel-message">
			<h3>Why buy from us</h3>
			<ul>
				<li class="message-secure">Secure transaction</li>
				<li class="message-cooling">30 day cooling off period</li>
				<li class="message-call">Australian call centre</li>
				<li class="message-no-charge">No hidden charges, no added fees</li>
			</ul>
		</div>
	</div>
	<div class="footer">&nbsp;</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	.health-assurance-message {
		display:none;
	}
</go:style>