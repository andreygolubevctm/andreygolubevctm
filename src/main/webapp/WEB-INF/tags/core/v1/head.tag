<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to create the head tag including markers needed for the gadget object framework."%>

<% response.setHeader("Cache-Control","no-cache, max-age=0"); %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%--
	Insert Markers
	------------------------------
	css-head 			: Used to add internal style rules				&lt;br/&gt;
	css-head-ie 		: Used to add internal ie style rules			&lt;br/&gt;
	css-head-ie9 		: Used to add internal ie9 style rules			&lt;br/&gt;
	css-head-ie8 		: Used to add internal ie8 style rules			&lt;br/&gt;
	css-head-ie7 		: Used to add internal ie7 style rules			&lt;br/&gt;
	css-href 			: Used to add external stylesheets 				&lt;br/&gt;
	js-href 			: Used for external javascripts					&lt;br/&gt;
	js-head 			: Used for internal javascript code				&lt;br/&gt;
	onready 			: Executed by jQuery's "ready()" function		&lt;br/&gt;
	jquery-ui 			: Used for jQuery UI components					&lt;br/&gt;
	jquery-val-rules 	: Used for jQuery UI validation rules			&lt;br/&gt;
	jquery-val-messages	: Used for jQuery UI validation messages		&lt;br/&gt;
	jquery-val-classrules: Used for jQuery UI validation classrules		&lt;br/&gt;
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 		required="false"	 description="The vertical this quote is associated with."%>
<%@ attribute name="title" 			required="false" description="Optional window title suffix"%>
<%@ attribute name="form" 			required="false" description="The form name (defaults to mainform)"%>
<%@ attribute name="errorContainer" required="false" description="The error container (defaults to #slideErrorContainer)"%>
<%@ attribute name="mainJs" 		required="false" description="The main js File for this page"%>
<%@ attribute name="mainCss" 		required="false" description="The main css File for this page"%>
<%@ attribute name="nonQuotePage" 	required="false" description="Flag as to whether the page is a quote (requiring transaction id)"%>
<%@ attribute name="loadjQuery" 		required="false" 	description="Flag as to whether jQuery is loaded"%>
<%@ attribute name="jqueryVersion"	 	required="false" 	description="Optional jquery version to load rather than the default"%>
<%@ attribute name="loadjQueryUI" 		required="false" 	description="Flag as to whether jQueryUI is loaded"%>
<%@ attribute name="jqueryuiversion" 	required="false" 	description="Specify a jQueryUI version"%>

<c:if test="${empty loadjQuery}"><c:set var="loadjQuery">true</c:set></c:if>
<c:if test="${empty loadjQueryUI}"><c:set var="loadjQueryUI">true</c:set></c:if>
<c:if test="${empty jqueryVersion}"><c:set var="jqueryVersion">${pageSettings.getSetting('jqueryVersion')}</c:set></c:if>

<c:choose>
	<c:when test="${not empty form}">
		<c:set var="formName" value="${form}" />
	</c:when>
	<c:otherwise>
		<c:set var="formName" value="mainform" />
	</c:otherwise>
</c:choose>

<c:set var="nonQuotePage">
	<c:choose>
		<c:when test="${not empty nonQuotePage}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<head>
	<%-- Google Optimise 360 --%>
	<c:if test="${empty callCentre or not callCentre}">
		<content:get key="googleOptimise360" />
	</c:if>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache, max-age=0" />
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">	
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="format-detection" content="telephone=no">
	<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
	
<%-- PAGE TITLE --%>
	<title>
		<c:choose>
			<c:when test="${title != ''}">
				${pageSettings.getSetting('brandName')} - ${title}
			</c:when>
			<c:otherwise>
				${pageSettings.getSetting('brandName')}
			</c:otherwise>
		</c:choose>
	</title>

<%-- STYLESHEETS --%>

	<%-- WHITELABEL: HERE LIES A GREAT BIG DIRTY IF STATEMENT!, ...allowing us to brand our Generic verticals like retrieve quote and unsubscribe. We are doing this here temporarily because we have little choice as we can't yet put those vertical pages onto the new framework due to time constraints. If the brandCode isn't CTM, we'll replace the css with one we're building with grunt out of the framework's generic vertical less directory. --%>
	<c:choose>
		<c:when test="${pageSettings.getBrandCode() != 'ctm'}">
			<%-- WHITELABEL The overriding head inclusions --%>

			<go:style marker="css-href" href="brand/${pageSettings.getBrandCode()}/css/${pageSettings.getVerticalCode()}.${pageSettings.getBrandCode()}${pageSettings.getSetting('minifiedFileString')}.css"></go:style>
		</c:when>
		<c:otherwise>
			<%-- The normal CTM based head inclusions --%>
	<link rel="shortcut icon" type="image/x-icon" href="common/images/favicon.ico?new">

	<go:style marker="css-href" href='common/reset.css'></go:style>
	<go:style marker="css-href" href='common/base.css'></go:style>
	<c:if test="${loadjQueryUI == true}">
		<c:if test="${pageSettings.getSetting('jqueryStylesheet') != ''}">
			<go:style marker="css-href" href="brand/${pageSettings.getSetting('jqueryStylesheet')}"></go:style>
		</c:if>
	</c:if>
	<c:if test="${pageSettings.getSetting('stylesheet') != ''}">
		<go:style marker="css-href" href="brand/${pageSettings.getSetting('stylesheet')}"></go:style>
	</c:if>
		
		</c:otherwise>
	</c:choose>
	<%-- WHITELABEL: END OF HORRIBLE IF STATEMENT CHECK --%>

	<%-- WHITELABEL: MAINCSS is only for real, non generic pages AFAICT --%>
	<c:if test="${not empty mainCss}">
		<go:style marker="css-href" href="${mainCss}"></go:style>
	</c:if>

	<%-- WHITELABEL: IN THE DATABASE, WE POINT THE ieXStyleSheet References at the fallback of brand/ctm --%>
	<go:insertmarker format="HTML" name="css-href" />
	<c:if test="${pageSettings.getSetting('ieStylesheet') != ''}">
		<go:style marker="css-href-ie" href="brand/${pageSettings.getSetting('ieStylesheet')}" conditional='(lte IE 9) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${pageSettings.getSetting('ie9Stylesheet') != ''}">
		<go:style marker="css-href-ie9" href="brand/${pageSettings.getSetting('ie9Stylesheet')}" conditional='(IE 9) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${pageSettings.getSetting('ie8Stylesheet') != ''}">
		<go:style marker="css-href-ie8" href="brand/${pageSettings.getSetting('ie8Stylesheet')}" conditional='(IE 8) & (!IEMobile)'></go:style>
	</c:if>
	<c:if test="${pageSettings.getSetting('ie7Stylesheet') != ''}">
		<go:style marker="css-href-ie7" href="brand/${pageSettings.getSetting('ie7Stylesheet')}" conditional='(IE 7) & (!IEMobile)'></go:style>
	</c:if>

	<go:insertmarker format="STYLE" name="css-href-ie" />
	<go:insertmarker format="STYLE" name="css-href-ie9" />
	<go:insertmarker format="STYLE" name="css-href-ie8" />
	<go:insertmarker format="STYLE" name="css-href-ie7" />

	<%-- Inline css included with tags --%>
	<style type="text/css">
		<go:insertmarker format="STYLE" name="css-head" />
	</style>


<%-- JAVASCRIPT --%>

	<%-- DTM --%>
	<c:set var="DTMEnabled" value="${pageSettings.getSetting('DTMEnabled') eq 'Y'}" />
	<c:if test="${DTMEnabled eq true and not empty pageSettings and pageSettings.hasSetting('DTMSourceUrl')}">
		<c:if test="${fn:length(pageSettings.getSetting('DTMSourceUrl')) > 0}">
			<script src="${pageSettings.getSetting('DTMSourceUrl')}"></script>
		</c:if>
	</c:if>

	<%-- jQuery, jQuery UI and plugins --%>

	<c:if test="${loadjQuery == true}">
		<go:script href="common/js/jquery-${jqueryVersion}.js" marker="js-href" />
		<go:script href="common/js/jquery.address-1.3.2.min.js" marker="js-href" />
		<go:script href="common/js/jquery.corner-2.11.js" marker="js-href" />
		<go:script href="common/js/jquery.numeric.pack.js" marker="js-href" />
		<go:script href="common/js/jquery.scrollTo.min.js" marker="js-href" />
		<go:script href="common/js/jquery.maxlength.js" marker="js-href" />
		<go:script href="common/js/jquery.number.format.js" marker="js-href" />
		<go:script href="common/js/jquery.aihcustom.js" marker="js-href" />
		<go:script href="common/js/jquery.pngFix.pack.js" marker="js-href" />
	</c:if>

	<c:if test="${loadjQueryUI == true}">
		<c:if test="${empty jqueryuiversion}">
			<c:set var="jqueryuiversion" value="1.8.22" />
		</c:if>
		<go:script href="common/js/jquery-ui-${jqueryuiversion}.custom.min.js" marker="js-href" />
	</c:if>

	<go:script href="common/js/modernizr-2.7.1.min.js" marker="js-href" />
	<go:script href="common/js/underscore-1.5.2.min.js" marker="js-href" />
	<c:if test="${empty nonQuotePage or nonQuotePage eq false}">
	<go:script href="bundles/shared/journeyEngine/v1/quote-engine.js" marker="js-href" />
	<go:script href="common/js/scrollable.js" marker="js-href" />
	</c:if>
	<go:script marker="js-href" href="common/js/fields/fields.js" />
	<go:script marker="js-href" href="common/js/fields/jquery.mask.min.js" />


	<%-- 	Adds global isNewQuote var to session and creates JS object to test if new quote.
			Needs to be included before the verticals main JS 
	--%>
	<c:if test="${empty nonQuotePage or nonQuotePage eq false}">
		<core_v1:quote_check quoteType="${quoteType}" />
	</c:if>

	<c:if test="${not empty mainJs}">
		<go:script href="${mainJs}" marker="js-href" />
	</c:if>

	<%-- External (href) javascript files included with tags --%>
	<go:script marker="js-href" href="common/js/template.js" />
	<go:insertmarker format="HTML" name="js-href" />

	<%-- Remove any pre-existing hashes from the URL unless --%>
	<go:script marker="onready">
		<c:if test="${empty nonQuotePage || nonQuotePage eq false && (empty param.latest && empty param.amend && empty param.ConfirmationID)}">
			$.address.parameter("stage", QuoteEngine.getCurrentSlide() == 0 ? "start" : QuoteEngine.getCurrentSlide(), false );
		</c:if>
		//IE7 and IE8 support
		setUpPlaceHolders();
	</go:script>

	<%-- Inline Javascript included with tags --%>
	<go:script>

		$(document).on('click','.showDoc',function(){

			var title = $(this).data('title');
			var url = $(this).data('url');

			if (title) {
				title=title.replace(/ /g,"_");
			}
			window.open(url,title,"width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,copyhistory=no,resizable=no");

		});

		function aihObj(){ }
		aih = new aihObj;

		// Head javascript
		<go:insertmarker format="SCRIPT" name="js-head" />
		<c:set var="env" value="${environmentService.getEnvironmentAsString()}" />
		var Settings =  new Object();
		Settings.vertical = '${pageSettings.getVerticalCode()}';
		Settings.brand = '${pageSettings.getBrandCode()}';
		Settings.superTagEnabled = <c:out value="${pageSettings.getSetting('superTagEnabled') eq 'Y'}" />;
		Settings.DTMEnabled = <c:out value="${pageSettings.getSetting('DTMEnabled') eq 'Y'}" />;
		Settings.GTMEnabled = <c:out value="${pageSettings.getSetting('GTMEnabled') eq 'Y'}" />;
		<c:choose><c:when test="${env eq 'localhost' or env eq 'NXI'}">Settings.environment = '<c:out value="${env}" />';</c:when><c:otherwise>Settings.environment = null;</c:otherwise></c:choose>

		var UserData =  new Object();
		<c:choose>
			<c:when test="${empty callCentre}">
				UserData.callCentre = false;
			</c:when>
			<c:otherwise>
				UserData.callCentre = true;
				UserData.callCentreID = '${authenticatedData.login.user.uid}';
			</c:otherwise>
		</c:choose>

		<c:if test="${loadjQueryUI == true}">
		// jQuery UI
		$(function() {
			<go:insertmarker format="SCRIPT" name="jquery-ui" />
		});
		</c:if>

		<%-- Inserts the jquery-val-rules and jquery-val-messages markers --%>
		<form_v1:validation formName="${formName}" errorContainer="${errorContainer}" />

		// jQuery document.onready
		$(document).ready(function() {

			$(document).pngFix();

			$(window).load(function() {
				$("[data-defer-src]").each(function allDelayedSrcLoadLoop(){
					$this = $(this);
					$this.attr('src', $this.attr('data-defer-src')).removeAttr('data-defer-src');
				})
			});

			$('.flexiphone' ).each( function() {
				setPhoneMask($(this));
				$(this).keyup(function(event) {
					setPhoneMask($(this));
				});
			});
			$('input.landline' ).inputMask('(00) 0000 0000');
			$('input.mobile' ).inputMask('(0000) 000 000');

			$('input.phone' ).on('blur', function(event) {
				var id = $(this).attr('id');
				var hiddenFieldName = id.substr(0, id.indexOf('input'));
				var hiddenField = $('#' + hiddenFieldName);
				triggerContactDetailsEvent($(this), hiddenField);
			});

			<go:insertmarker format="SCRIPT" name="onready" />

			<c:if test="${loadjQueryUI == true}">
				// fix for jquery UI 1.8.22 which does not allow any mouse
				// movement to trigger the click event on buttons
				// can be removed once jQuery UI is updated to 1.9 or above
				$('label.ui-button').click(function() {
					var chkOrRadio = $(this);
					var inputField = chkOrRadio.prev();

					if(inputField.prop("tagName") == 'INPUT'){
						inputFieldType = inputField.attr('type');

						if(inputFieldType == 'radio'){
							if(!inputField[0].checked){
								inputField[0].checked = !inputField[0].checked;
								inputField.button("refresh");
								inputField.change();
							}
						}
					}

					return false;
				});
			</c:if>
		});

		function is_mobile_device() {
			if( navigator.userAgent.match(/Android/i)
			|| navigator.userAgent.match(/iPhone/i)
			|| navigator.userAgent.match(/iPod/i)
			|| navigator.userAgent.match(/BlackBerry/i)
			|| navigator.userAgent.match(/Windows Phone/i)){
				return true;
			}else{
				return false;
			}
		}

		<c:if test="${loadjQuery == true}">
			//Clear IE placeholder so that it isn't included in validation
			if (!Modernizr.input['placeholder']) {
				(function ($) {
					$.each($.validator.methods, function (key, value) {
						$.validator.methods[key] = function () {
							if(arguments.length > 1) {
								var inputElement = $(arguments[1]);
								if(inputElement.hasClass('placeholder')) {
								clearPlaceholder(inputElement);
								}
								arguments[0] = inputElement.val();
								if(inputElement.hasClass('placeholder')) {
								setPlaceholder(inputElement);
								}
							}
							return value.apply(this, arguments);
						};
					});
				} (jQuery));
			}
		</c:if>
	</go:script>

	<c:if test="${not empty quoteType}">
		<%-- AGG-1331: Add JS object to call when needing to write transaction data  --%>
		<agg_v1:write_quote_ajax quoteType="${quoteType}" />
	</c:if>

	<%-- ADDITIONAL CONTENT --%>
	<jsp:doBody />
</head>