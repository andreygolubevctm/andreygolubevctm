<%@ tag description="Travel Annual Signup Form"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<form:fieldset legend="CHoose your benefits & extras">
		<form:row label="Your Situation" className="thin_label">
			<field:general_select xpath="health/situation" type=""></field:general_select>
		</form:row>
		<div class="clear"></div>
	</form:fieldset>