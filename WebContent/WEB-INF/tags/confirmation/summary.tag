<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"		required="true"		rtexprvalue="true"	description="The label for the vertical" %>
<%@ attribute name="transaction_id"	required="false"	rtexprvalue="true"	description="The quote's transaction id" %>
<%@ attribute name="first_name"	required="false"	rtexprvalue="true"	description="First Name if Required" %>

<%-- HTML --%>
<div class='bubble_row'>
<ui:speechbubble colour="blue" arrowPosition="left" >

<c:choose>
	<c:when test="${vertical eq 'homeloan'}">
		<homeloan:confirmation_summary flex_opportunity_id="${flex_opportunity_id}" first_name="${first_name}" />
	</c:when>
	<c:when test="${vertical eq 'homelmi'}">
		<homelmi:confirmation_summary first_name="${first_name}" />
	</c:when>

	<c:otherwise>
		<go:log>Undefined confirmation vertical (${vertical})</go:log>
	</c:otherwise>
</c:choose>
</ui:speechbubble>
</div>
<go:style marker="css-head">
#confirmation-summary {
	margin: 20px 0;
	padding: 10px 35px;
	background: #113594;
	<css:rounded_corners value="5" />
}

#confirmation-summary p {
	font-size: 15px;
	line-height: 15px;
	color: #fff;
	margin: 10px 0;
}

.bubble_row{
		margin-bottom:30px;
		margin-top:10px;
		position:relative;}

</go:style>