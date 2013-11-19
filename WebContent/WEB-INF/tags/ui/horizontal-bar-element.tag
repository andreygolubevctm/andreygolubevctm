<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="" %>
<%@ attribute name="id" required="false" rtexprvalue="true" description="" %>

<%-- CSS --%>
<go:style marker="css-head">
	.outer-horizontal-bar {
		width: 100%;
		overflow: auto;
		<css:box_shadow horizontalOffset="0" verticalOffset="2" spread="1" blurRadius="10" color="0,0,0,0.3" inset="false" />
	}

	.inner-horizontal-bar {
		position: relative;
		max-width: 980px;
		margin: 0 auto;
	}
</go:style>

<%-- HTML --%>
<div id="${id}" class="outer-horizontal-bar ${className}">
	<div class="inner-horizontal-bar">
		<jsp:doBody />
		<core:clear />
	</div>
</div>
<core:clear />
