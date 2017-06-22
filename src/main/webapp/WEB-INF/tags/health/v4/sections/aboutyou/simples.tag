<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples questions for about you"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<simples:dialogue id="19" vertical="health" />
<simples:dialogue id="20" vertical="health" />
<simples:dialogue id="0" vertical="health" className="red">
	<div class="row">
		<div class="col-sm-12">
			<field_v2:array_radio xpath="health/simples/contactType" items="outbound=Outbound quote,inbound=Inbound quote,followup=Follow up call,callback=Chat callback" required="true" title="contact type (outbound/inbound/followup/callback)" />
		</div>
	</div>
</simples:dialogue>
<simples:dialogue id="21" vertical="health" className="red" /> <%-- 3 Point Security Check --%>
<simples:dialogue id="36" vertical="health" className="hidden red simples-privacycheck-statement" /> <%-- Inbound --%>
<simples:dialogue id="25" vertical="health" className="hidden follow-up-call red" /> <%-- Follow up call --%>