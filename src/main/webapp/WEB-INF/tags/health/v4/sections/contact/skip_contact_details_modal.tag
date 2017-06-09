<%@ tag description="Container for various input fields used by dialogs" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<core_v1:js_template id="skip-contact-details-template">

	<%-- consider putting this content into the database --%>

	<div class="skip-contact-details-modal-content">
		<div class="row">
			<div class="col-xs-12">
				<h1>Continue without contact details?</h1>
				<h4>We just need to know which state you live in so that we can get you the best prices</h4>
				<p class="offer-text">Please select your state to show the correct range of products</p>
			</div>
		</div>
		<div class="row">
			<div class="btn-center">

			<field_v2:array_radio xpath="${xpath}/state"
								  className="health-situation-state"
								  required="true"
								  items="NSW=NSW,VIC=VIC,QLD=QLD,ACT=ACT,WA=WA,SA=SA,TAS=TAS,NT=NT"
								  title="you're living in"
								  style="radio-rounded"
								  wrapCopyInSpan="${true}"
								  additionalLabelAttributes="${labelAttributes}" />


        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 col-sm-4 push-top-15 centerRowContents">
            <a href="javascript:;" class="btn btn-block btn-success btn-skip-contact-dtls">Get Prices Now&nbsp;<span class="icon-arrow-right" /></a>
        </div>
    </div>
</div>
</core_v1:js_template>