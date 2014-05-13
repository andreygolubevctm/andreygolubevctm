<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the select box"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<%-- CSS --%>
<go:style marker="css-head">
	.fieldfullrow .fieldrow_value{
		max-width: 100%;
	}
	input[type=checkbox].customCheckbox.replicaLargeCheckbox{
		width: 30px;
		height: 30px;
	}
	.terms_row .fieldrow_value label {
		height: 30px;
		line-height: 30px;
	}
</go:style>

<%-- HTML --%>
<div class="${className}">


	<form:fieldset legend="Website Terms and Conditions" className="${className} no-background-color" id="${name}">

		<form:fullrow className="terms_row">
			<c:set var="termsOfUse">
				Please confirm you</br>
				<ul>
					<li>are accessing this service to obtain an insurance quote as (or on behalf of) a genuine customer, and not for commercial or competitive purposes (as further detailed in the Website Terms of Use), and</li>
					<li>accept the <a href="javascript:void(0);" class="showDoc" data-url="/ctm/legal/website_terms_of_use.pdf" data-title="Website Terms of Use">Website Terms of Use</a>.</li>
				</ul>
			</c:set>
			<field:customisable-checkbox
				xpath="${xpath}/termsAccepted"
				theme="replicaLarge"
				value="Y"
				className="validate"
				required="true"
				label="${true}"
				title="${termsOfUse}"
				errorMsg="Please agree to the website terms of use" />
		</form:fullrow>

		<form:fullrow className="terms_row">
			<c:set var="fsg">
				<a href="javascript:void(0);" class="showDoc" data-url="/ctm/legal/FSG.pdf" data-title="Financial Services Guide">Financial Services Guide</a>.
			</c:set>
			<field:customisable-checkbox
				xpath="${xpath}/fsg"
				theme="replicaLarge"
				value="Y"
				className="validate"
				required="true"
				label="${true}"
				title="Please confirm you have read the ${fsg}"
				errorMsg="Please confirm you have read the Financial Services Guide" />
		</form:fullrow>

		<core:clear />

	</form:fieldset>




</div>
<%-- JAVASCRIPT --%>

<%-- CSS --%>
