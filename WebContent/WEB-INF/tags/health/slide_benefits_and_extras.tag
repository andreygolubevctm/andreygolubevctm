<%@ tag description="Travel Annual Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<form:fieldset legend="Choose your benefits &amp; extras">
		<form:row label="Your Situation" className="thin_label">
			<field:general_select xpath="health/situation" type=""></field:general_select>
		</form:row>
		<div class="clear"></div>
	</form:fieldset>