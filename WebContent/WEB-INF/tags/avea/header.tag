<%@ tag description="The top-most header"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>
<div id="header" class="clearfix">

	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<a href="${data['settings/root-url']}" title="AutObarn" class="aubn_logo"></a>
		<avea:head_underwriter />
	</c:if>
	
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<a href="${data['settings/root-url']}" title="Carsure" class="crsr_logo"></a>
		<avea:head_underwriter />
	</c:if>
	
	<c:if test="${param.prdId == null}">
		<h1><a href="${data['settings/root-url']}" title="Compare The Market">Compare The Market</a></h1>
	</c:if>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
</go:script>
