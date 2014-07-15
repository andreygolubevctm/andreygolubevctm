<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Simples Message Details"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="tranID"	required="true"	 rtexprvalue="true"	 description="TranID" %>
<%@ attribute name="messageID"	required="true"	 rtexprvalue="true"	 description="Message ID" %>



<core:loadsafe />

<div class="simples-home">
	<field:button xpath="loadquote" title="Get next message" className="btn btn-cta btn-xlarge message-getnext"></field:button>
	<a href="${pageSettings.getBaseUrl()}simples/startQuote.jsp" class="btn btn-form btn-xlarge message-inbound">Inbound call</a>
</div>
