<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical" 	required="true"	 rtexprvalue="true"	 description="vertical label" %>

<form_v1:row label="" className="clear closer">
	<c:set var="label_text"><content:get key="optinLabel" /></c:set>
	<field_v1:checkbox
			xpath="${vertical}_privacyoptin"
			value="Y"
			title="${label_text}"
			errorMsg="Please confirm you have read the privacy statement"
			required="true"
			label="true"
	/>
</form_v1:row>