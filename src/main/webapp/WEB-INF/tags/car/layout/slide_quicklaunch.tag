<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote/vehicle" />

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<form_v2:fieldset legend="Your Car" id="${name}_selection">

	<form_v2:row label="Make" id="${name}_makeRow" className="initial">
		<field_v2:general_select xpath="${xpath}/make" title="vehicle manufacturer" required="false" initialText="&nbsp;" />
	</form_v2:row>

	<form_v2:row label="Model" id="${name}_modelRow">
		<field_v2:general_select xpath="${xpath}/model" title="vehicle model" required="false" initialText="&nbsp;" />
	</form_v2:row>

	<form_v2:row label="Year" id="${name}_yearRow">
		<field_v2:general_select xpath="${xpath}/year" title="vehicle year" required="false" initialText="&nbsp;" />
	</form_v2:row>

	<form_v2:row label="Button" id="${name}_buttonRow">
		<a href="javascript:;" class="btn btn-primary" id="${name}_button" title="Edit Selections">Compare Now</a>
	</form_v2:row>

</form_v2:fieldset>