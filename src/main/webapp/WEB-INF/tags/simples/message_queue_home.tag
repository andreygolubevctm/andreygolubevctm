<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples Message Details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<simples:template_comments />
<simples:template_messageaudit />
<simples:template_messagedetail />
<simples:template_touches />

<div class="simples-home-buttons hidden">
<c:choose>
	<c:when test="${pageSettings.getSetting('inInEnabled')}">
		<p>InInInteractionId: <c:out value="${sessionScope.ininInteractionId}" /></p>

		<form id="simples-transaction-search-navbar" class="navbar-form text-center" role="search">
			<div class="form-group">
				<input type="number" name="keywords" class="form-control input-lg" min="0" />
			</div>
			<button type="submit" class="btn btn-default btn-lg">Find transaction ID</button>
		</form>
	</c:when>
	<c:otherwise>
		<field_v1:button xpath="loadquote" title="Get Next Message" className="btn btn-tertiary btn-lg message-getnext" />
	</c:otherwise>
</c:choose>
	<a href="/${pageSettings.getContextFolder()}simples/startQuote.jsp?verticalCode=HEALTH" class="btn btn-form btn-lg message-inbound">Start New Quote <span class="icon icon-arrow-right"></span></a>
</div>

<div class="simples-message-details-container">
</div>
