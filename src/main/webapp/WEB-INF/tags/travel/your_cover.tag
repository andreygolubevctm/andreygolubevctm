<%@ tag description="Travel Single Signup Form"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<security:populateDataFromParams rootPath="travel" delete="false"/>

<%-- HTML --%>
<c:set var="fieldXpath" value="travel/policyType" />
<form_v2:row label="What type of cover are you looking for?" fieldXpath="${fieldXpath}" className="clear cover-type">
	<field_v2:array_radio xpath="${fieldXpath}" required="true"
		className="policy-type " items="S=Single Trip,A=Annual multi-Trip"
		id="${go:nameFromXpath(xpath)}" title="your cover type." />
</form_v2:row>

<div class="row-fluid">
    <div class="col-xs-12 col-sm-10 no-padding policy-info">
        <p>A <strong>single trip</strong> travel insurance policy covers you for one journey, even if it is to multiple destinations.
            An <strong>annual multi-trip</strong> policy is great when you need travel insurance for more than one journey throughout the year.</p>
    </div>
</div>
