<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="lpSettings" required="false" rtexprvalue="true"	description="A json object contain implementation settings" %>

<%-- VARIABLES --%>
<c:set var="LP_OBJ" value="lpMTagConfig" />

<%-- JAVASCRIPT --%>
<script>
<%-- The mtagconfig script - we want this to be one of the last things the page loads --%>
var ${LP_OBJ}=${LP_OBJ}||{};${LP_OBJ}.vars=${LP_OBJ}.vars||[];${LP_OBJ}.dynButton=${LP_OBJ}.dynButton||[];${LP_OBJ}.lpProtocol=document.location.toString().indexOf("https:")==0?"https":"http";${LP_OBJ}.pageStartTime=(new Date).getTime();if(!${LP_OBJ}.pluginsLoaded)${LP_OBJ}.pluginsLoaded=!1;
${LP_OBJ}.loadTag=function(){for(var a=document.cookie.split(";"),b={},c=0;c<a.length;c++){var d=a[c].substring(0,a[c].indexOf("="));b[d.replace(/^\s+|\s+$/g,"")]=a[c].substring(a[c].indexOf("=")+1)}for(var a=b.HumanClickRedirectOrgSite,b=b.HumanClickRedirectDestSite,c=["lpTagSrv","lpServer","lpNumber","deploymentID"],d=!0,e=0;e<c.length;e++)${LP_OBJ}[c[e]]||(d=!1,typeof console!="undefined"&&console.log&&console.log("LivePerson : ${LP_OBJ}."+c[e]+" is required and has not been defined before ${LP_OBJ}.loadTag()."));
if(!${LP_OBJ}.pluginsLoaded&&d)${LP_OBJ}.pageLoadTime=(new Date).getTime()-${LP_OBJ}.pageStartTime,a="?site="+(a==${LP_OBJ}.lpNumber?b:${LP_OBJ}.lpNumber)+"&d_id="+${LP_OBJ}.deploymentID+"&default=simpleDeploy",lpAddMonitorTag(${LP_OBJ}.deploymentConfigPath!=null?${LP_OBJ}.lpProtocol+"://"+${LP_OBJ}.deploymentConfigPath+a:${LP_OBJ}.lpProtocol+"://"+${LP_OBJ}.lpTagSrv+"/visitor/addons/deploy2.asp"+a),${LP_OBJ}.pluginsLoaded=!0};
function lpAddMonitorTag(a){if(!${LP_OBJ}.lpTagLoaded){if(typeof a=="undefined"||typeof a=="object")a=${LP_OBJ}.lpMTagSrc?${LP_OBJ}.lpMTagSrc:${LP_OBJ}.lpTagSrv?${LP_OBJ}.lpProtocol+"://"+${LP_OBJ}.lpTagSrv+"/hcp/html/mTag.js":"/hcp/html/mTag.js";a.indexOf("http")!=0?a=${LP_OBJ}.lpProtocol+"://"+${LP_OBJ}.lpServer+a+"?site="+${LP_OBJ}.lpNumber:a.indexOf("site=")<0&&(a+=a.indexOf("?")<0?"?":"&",a=a+"site="+${LP_OBJ}.lpNumber);var b=document.createElement("script");b.setAttribute("type",
"text/javascript");b.setAttribute("charset","iso-8859-1");b.setAttribute("src",a);document.getElementsByTagName("head").item(0).appendChild(b)}}window.attachEvent?window.attachEvent("onload",function(){${LP_OBJ}.disableOnLoad||${LP_OBJ}.loadTag()}):window.addEventListener("load",function(){${LP_OBJ}.disableOnLoad||${LP_OBJ}.loadTag()},!1);
function lpSendData(a,b,c){if(arguments.length>0)${LP_OBJ}.vars=${LP_OBJ}.vars||[],${LP_OBJ}.vars.push([a,b,c]);if(typeof lpMTag!="undefined"&&typeof ${LP_OBJ}.pluginCode!="undefined"&&typeof ${LP_OBJ}.pluginCode.simpleDeploy!="undefined"){var d=${LP_OBJ}.pluginCode.simpleDeploy.processVars();lpMTag.lpSendData(d,!0)}}function lpAddVars(a,b,c){${LP_OBJ}.vars=${LP_OBJ}.vars||[];${LP_OBJ}.vars.push([a,b,c])};
</script>

<go:script marker="js-head">
<%-- Provide settings for mtagconfig --%>
var ${LP_OBJ} = ${LP_OBJ} || {}; ${LP_OBJ}.vars = ${LP_OBJ}.vars || [];
${LP_OBJ} = $.extend({
		<%-- Defaults taken from original supertag implementation --%>
		lpServer		: "server.lon.liveperson.net",
		lpTagSrv		: "sr1.liveperson.net",
		lpNumber		: "1563103",
		deploymentID	: "1"
	},
<c:choose>
	<c:when test="${not empty lpSettings}">
	${lpSettings}
	</c:when>
	<c:otherwise>
	{}
	</c:otherwise>
</c:choose>
);
</go:script>

<go:script marker="js-head">
<%--

LiveChat provides an interface to trigger journey stage calls
to Live Person.

Constructor receives 2 params:
		1: options - an object containing brand, vertical, unit and journey arguments
					journey - an object listing the page names for each step in the
					user journey using the slide Id as the key (starting at 1)

Instantiated as follow:

		var live_chat = new LiveChat({
				brand	: 'ctm',
				vertical: 'Health',
				unit	: 'health-insurance-sales',
				button	: 'chat-health-insurance-sales',
				journey	: {
					1	: 'Situation',		// Situation
					2	: 'Details',		// Details
					3	: 'Results',		// Results
					4	: 'Application',	// Application
					5	: 'Payment',		// Payment
					6	: 'Confirmation'	// Confirmation
				}
		);

--%>
var LiveChat = function(options) {

	var that		= this,
		journey_end	= 1,
		options		= $.extend({}, options); <%-- Ensure we have an object --%>

	<%-- Retrieve the full page name (as currently done by supertag --%>
	var getPageName = function() {
		var page = 'undefined';
		var index = QuoteEngine._options.currentSlide + 1;
		if( options.journey.hasOwnProperty(index) ) {
			page = options.journey[index];
		}
		return [options.brand, 'quote-form', options.vertical, page].join(':');
	};

	<%-- --%>
	var fire =  function() {
		<%-- Add the conversion stage --%>
		${LP_OBJ}.vars.push(['page', 'ConversionStage', (QuoteEngine._options.currentSlide + 1)]);

		<%-- Add the current transaction ID --%>
		var tran_id = false;
		if( typeof referenceNo == "object" && referenceNo.hasOwnProperty("getTransactionID") ) {
			tran_id = referenceNo.getTransactionID(false);
			${LP_OBJ}.vars.push(['visitor','transactionID',tran_id]);
		}

		<%-- Add UNIT param if defined --%>
		if( options.hasOwnProperty('unit') ) {
			${LP_OBJ}.vars.push(['page', 'unit', options.unit]);
			${LP_OBJ}.vars.push(['unit', options.unit]);
		}

		<%-- Add the current page --%>
		${LP_OBJ}.vars.push(['page', 'PageName', getPageName()]);

		<%-- If at the confirmation page then also call this --%>
		if( !options.journey.hasOwnProperty(QuoteEngine._options.currentSlide + 2) ) { // No slide after the current one
			if( tran_id === false ) {
				tran_id = referenceNo.getTransactionID(false);
			}
			${LP_OBJ}.vars.push(['page', 'OrderNumber', tran_id]);
			${LP_OBJ}.loadTag();
		}
		<%-- Send data to live person --%>
		lpSendData();
	};

	<%-- Reload the MTag (aka Monitor Tag). Implemented to be called from the confirmation page once when sold. --%>
	var reloadMonitorTag = function() {
		${LP_OBJ}.loadTag();
	};

	<%-- Fire event for first slide and add listener for balance of journey --%>
	$(document).ready(function(){

		<%-- Set the index of the last journey slide --%>
		if( options.hasOwnProperty('journey') && typeof options.journey == "object" ) {
			for(var i in options.journey) {
				journey_end = i;
			}
		}

		slide_callbacks.register({
			mode:		"after",
			slide_id:	-1,
			callback: 	function() {
				<%--Test if on the confirmation page and reload mTag --%>
				if( journey_end == (QuoteEngine._options.currentSlide + 1) ) {
					reloadMonitorTag();
				}

				fire();
			}
		});


		fire();

		<%-- As we're overriding the default button for health let's
			give the img click event to its parent --%>
		if( options.hasOwnProperty('button') ) {
			$("#" + options.button).on("click", "a", function() {
				${LP_OBJ}.dynButton0.actionHook();
			});
		}
	});
};
</go:script>