<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples Message Details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<simples:template_comments />
<simples:template_messageaudit />
<simples:template_messagedetail />
<simples:template_touches />

<div class="simples-home-buttons hidden">
	<field_v1:button xpath="loadquote" title="Get Next Message" className="btn btn-tertiary btn-lg message-getnext" />
	<a href="/${pageSettings.getContextFolder()}simples/startQuote.jsp?verticalCode=HEALTH" class="btn btn-form btn-lg message-inbound">Start New Quote <span class="icon icon-arrow-right"></span></a>
</div>

<form id="simples-transaction-search-navbar" class="navbar-form navbar-right" role="search">
	<div class="form-group">
		<input type="text" name="keywords" class="form-control input-sm" placeholder="">
	</div>
	<button type="submit" class="btn btn-default btn-sm">Search</button>
</form>

<div class="simples-message-details-container">
</div>
