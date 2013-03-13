<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<%-- ATTRIBUTES --%>
<%@ attribute name="show" required="false" description="Hidden by default - Set to 1 if to be Shown by default" %>


<%-- HTML --%>
	
<div class="avea_details" <c:if test="${show != null && show == '1'}">style="display:block;"</c:if>>
	<b>Underwriter:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	AVEA Insurance Limited<br />
	ABN: 18 009 129 793<br />
	AFS Licence: 238279
</div>


<%-- CSS --%>
<go:style marker="css-head">
	.avea_details{
		display:none;
		margin-top:-45px;
		margin-right:2px;
		float:right;
		width:220px;
		font-size:10px;
		color:#777;
		text-align:right;
	}
</go:style>
