<%@ tag description="Travel Annual Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

	<form:fieldset legend="Choose your benefits &amp; extras">
		<c:set var="fieldXpath" value="health/situation" />
		<form_new:row fieldXpath="${fieldXpath}" label="Your Situation" className="thin_label">
			<field:general_select xpath="${fieldXpath}" type=""></field:general_select>
		</form_new:row>
	</form:fieldset>