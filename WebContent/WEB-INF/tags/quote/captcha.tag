<%--
	Represents a collection of panels
--%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>
<%-- VARIABLES --%>

<%-- <c:set var="currentProviderSplitTest"> --%>
<%-- 	<core:split_test codes="A,B" dataVar="quote/currentProviderSplitTest" forceNew="false" supertagName="currentProviderSplitTest" paramName="curr"/> --%>
<%-- </c:set> --%>

<%-- HTML --%>
<form:fieldset legend="Your preferred date to start the insurance">
	<form:row label="Commencement date">
		<field:commencement_date xpath="quote/options/commencementDate"
								required="true" />
	</form:row>
</form:fieldset>
<%--<form:fieldset legend="Inspiration">
	<form:row label="What inspired you to quote with us today?">
	<field:import_select xpath="quote/linkChdId"
					url="/WEB-INF/option_data/hear_about_us.html"
					title="what prompted you to quote with us today"
					className="linkChdId"
					required="true" />
	</form:row>
</form:fieldset>
--%>
<%-- <c:if test="${empty currentProviderSplitTest or currentProviderSplitTest == 'A'}"> --%>
	<quote:existing-insurer productCategories="CAR" xpath="quote" />
<%-- </c:if> --%>
<form:fieldset legend="Website Terms of Use &amp; Financial Services Guide">

	<form:row id="termsRow" label="">
		<div>Please confirm you</div>
		<p>are accessing this service to obtain an insurance quote as (or on behalf of) a genuine customer, and not for commercial or competitive purposes (as further detailed in the Website Terms of Use), and</p>
		<p>accept the <a href="javascript:showDoc('${data['settings/website-terms-url']}','Website Terms of Use')" class="termsLink">Website Terms of Use</a>.</p>

		<field:array_radio xpath="quote/terms"
			required="true" className="terms" id="terms"
			items="Y=Yes,N=No" title="You must agree to the Website Terms of Use before we can proceed with a quote" />
	</form:row>
	<form:row id="fsgRow" label=" ">
		<p>Please confirm you have read the <a href="javascript:showDoc('${data['settings/fsg-url']}','Financial Services Guide')" class="termsLink">Financial Services Guide</a>.</p>
		<field:array_radio xpath="quote/fsg"
			required="true" className="fsg" id="fsg"
			items="Y=Yes,N=No" title="You must confirm that you have read the Financial Services Guide before we can proceed with a quote" />
	</form:row>

</form:fieldset>

<go:script marker="onready">
	$(function() {
		$("#terms, #fsg").buttonset();
	});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="quote_terms" rule="agree" parm="true" message="In order to continue, you must agree to the Website Terms of Use."/>
<go:validate selector="quote_fsg" rule="agree" parm="true" message="In order to continue, you must acknowledge you have read the Financial Services Guide."/>

<%-- CSS --%>
<go:style marker="css-head">
	#terms {
		/*display:inline-block;*/
		zoom:1;
		*display:inline;
	}
	.termsLink {
		font-size: 12px;
	}
	#termsRow {
		margin-bottom: 11px;
		margin-top: 24px;
	}
	#termsRow p {
		display:inline-block;
		zoom:1;
		*display:inline;
		background: url("common/images/bullet_dot.png") no-repeat left 3px;
		padding-left:13px;
		margin-bottom:3px;
	}
	#fsgRow .fieldrow_value,
	#termsRow .fieldrow_value {
		width:400px;
	}
	#termsText {

	}
	#fsgRow {
		*margin-top: -15px;
		margin-bottom:-1px;
	}
	#fsgRow p{
		display:inline-block;
		zoom:1;
		*display:inline;
	}
	#fsg {
		/*display:inline-block;*/
		zoom:1;
		*display:inline;
	}
</go:style>





