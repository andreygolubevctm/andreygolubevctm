<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 			required="true" rtexprvalue="true"	 	description="The vertical the quote is associated with" %>
<%@ attribute name="id" 				required="false" rtexprvalue="true"	 	description="ID for the element - defaults to 'reference_number'" %>
<%@ attribute name="className" 			required="false" rtexprvalue="true"	 	description="additional css class attribute" %>
<%@ attribute name="label" 				required="false" rtexprvalue="true"	 	description="Label for the field - defaults to 'Reference Number'" %>
<%@ attribute name="showReferenceNo" 	required="false" rtexprvalue="true"		description="Flag whether to display the reference number" %>

<go:script href="common/js/referenceNumber.js" marker="js-href" />

<c:if test="${empty id}">
	<c:set var="id" value="reference_number" />
</c:if>

<c:if test="${empty label}">
	<c:set var="label" value="Reference No. " />
</c:if>

<c:choose>
	<c:when test="${empty showReferenceNo}">
	<c:set var="showReferenceNo" value="true" />
	</c:when>
	<c:otherwise>
		<c:set var="showReferenceNo" value="${showReferenceNo eq 'true'}" />
	</c:otherwise>
</c:choose>
<c:choose>
	<c:when test="${fn:contains('car,ip,life', quoteType)}">
		<c:set var="saveQuoteText">Save Quote</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="saveQuoteText">Email Quote</c:set>
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<div id="${id}" class="${className}">
	<h4>${label}<span>${data.current.transactionId}</span></h4>
	<a href="javascript:void(0);" id="header-save-your-quote" class="bigbtn"><span>${saveQuoteText}</span></a>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#${id} {
	display:			none;
	position:			relative;
	width: 				230px;
	height: 			80px;
	float: 				right;
	top:				177px;
	z-index:			11;
	background: 		transparent url(brand/ctm/images/bg_reference_no_tall.png) center center no-repeat;
}

#${id} h4 {
	font-size:			14px;
	color: 				#1C3F94;
	text-align:			center;
	margin-top:			10px;
	line-height:		20px;
	font-weight:		normal;
}

#${id} h4 span {
	font-size:			150%;
}

#${id} a {
	position:			absolute;
	top:				38px;
	left:				60px;
	width: 				98px;
	cursor: 			pointer;
}

#${id} a span {
	width: 				100%;
}
.privacyOptinNotChecked{
	display:none;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var referenceNo = new ReferenceNo('${id}', ${showReferenceNo},'${quoteType}');
</go:script>

<go:script marker="onready">
	referenceNo.init();

	var emailQuoteBtn = $("#header-save-your-quote");

	// if the privacy policy checkbox is hidden, then it's checked (ie. retrieve quote)
	if($("#health_privacyoptin[type=hidden]").length === 1){
			emailQuoteBtn.addClass("privacyOptinNotChecked");
	}

	if(!$("#health_privacyoptin").is(":checked")){
		emailQuoteBtn.addClass("privacyOptinNotChecked");
	}


	$("#health_privacyoptin").on("change", function(event){
			if( $(this).is(":checked") ){
				emailQuoteBtn.removeClass("privacyOptinNotChecked");
			} else {
				emailQuoteBtn.addClass("privacyOptinNotChecked");
			}
	});

	if(typeof SaveQuote !== 'undefined') {
		$(document).on(SaveQuote.confirmedEvent, function(event) {
			$('#header-save-your-quote span').text(SaveQuote.resaveText);
		});
		}
	referenceNo.setTransactionId(${data.current.transactionId});
</go:script>
