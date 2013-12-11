<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Utility tag to add resources to the bottom of the page before the closing body element via insert markers of the gadget object framework."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%--
	Insert Markers
	------------------------------
	js-closingbodyhref 	: Used for internal and external javascripts	&lt;br/&gt;
	js-closingbody 		: Used for inline javascript code				&lt;br/&gt;
--%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- SETTINGS DETERMINATION --%>
<%--
	We class things as being 'dev' level for this variable until they
	leave integration, add or remove checks here to alter this.
--%>
<c:set var="userIP" value="${pageContext.request.remoteAddr}" />
<c:set var="isDev">
	<c:choose>
		<c:when test="${( fn:startsWith(userIP, '192.168.')
			or fn:startsWith(userIP, '172.16.')
			or fn:startsWith(userIP, '10.')
			or fn:startsWith(userIP, '0') )
			and not empty data['settings/environment']
			and (
				fn:toLowerCase(data['settings/environment']) eq 'localhost'
				or fn:toLowerCase(data['settings/environment']) eq 'integration'
			)
		}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<%-- JAVASCRIPT --%>
<%--
	Things you add to the page bottom are either assuming dom is there, or handling
	their own domready. NB: meerkat modules are automatically waiting for domready.
	We should be brave and load jquery at the page bottom too.

	We should be using a CDN with local fallback for common libraries like jquery
	and underscore etc. See below for the implementation. Uncomment when ready.

	In the bottom, we'll have the meerkat init. This is a specific chunk which sets
	up settings and kicks off all other loading. It's important.
--%>

<%-- CDN JS --%>
	<%--
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script>window.jQuery && window.jQuery.each || document.write('<script src="common/js/jquery-1.8.2.min.js"><\/script>')</script>
	--%>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js"></script>
	<script>window._ || document.write('<script src="common/js/lib/underscore-1.3.3.min.js"><\/script>')</script>
<%-- /CDN JS --%>

<%-- Required Internal javascript files --%>
<%-- JS GENERAL TOOLS --%>
<%-- <go:script href="common/js/lib/laconic.js" marker="js-closingbodyhref" /> --%>

<%-- MEERKAT JS FRAMEWORK --%>
<go:script href="common/js/meerkat.js" marker="js-closingbodyhref" />
<go:script href="common/js/meerkat.logging.js" marker="js-closingbodyhref" />
<go:script href="common/js/meerkat.modules.js" marker="js-closingbodyhref" />
<%-- MEERKAT JS FRAMEWORK --%>

<%-- MEERKAT JS MODULES --%>
<%-- if under active development, wrap with ${go:AddTimestampToHref('') --%>
<go:script href="common/js/modules/polyfills.js" marker="js-closingbodyhref" />
<go:script href="common/js/modules/utilities.js" marker="js-closingbodyhref" />
<%-- /MEERKAT JS MODULES --%>

<%-- Developer helper modules --%>
<%-- Conditionally include if dev mode --%>
<c:if test="${isDev}">
	<go:script href="common/js/modules/development.js" marker="js-closingbodyhref" />
	<go:script href="common/js/modules/baconIpsum.js" marker="js-closingbodyhref" />
</c:if>
<%-- /Conditionally include if dev mode --%>

<%--
	MEERKAT:
	The important meerkat framework initialiser.
	Variable content and config which is from the template layer is served in here
--%>

<%--
	This 'could' get put into the js-closingbody insertmarker but
	i trust it more if it's part of it's own named script closure.
--%>
<script id="meerkat_init"> <%-- There can be... only one! (in the page) --%>
	;(function (meerkat) {
		//These are all filled in by tag output or template based variable output if and as required.
		var siteConfig = {
			name: '${data['settings/window-title']}',
			brand: '${fn:toLowerCase(data['settings/styleCode'])}',
			vertical: '${fn:toLowerCase(data['settings/vertical'])}',
			isDev: ${isDev}, //boolean determined from conditions above in this tag
			environment: '${fn:toLowerCase(data['settings/environment'])}',
			//could be: localhost, integration, qa, staging, prelive, prod
			logpath: '/ctm/ajax/write/register_fatal_error.jsp?uncache=',
			urls:{
				root: '${fn:toLowerCase(data['settings/root-url'])}',
				exit: '${fn:toLowerCase(data['settings/exit-url'])}',
				quote: '${fn:toLowerCase(data['settings/quote-url'])}',
				privacyPolicy: '${fn:toLowerCase(data['settings/privacy-policy-url'])}',
				websiteTerms: '${fn:toLowerCase(data['settings/website-terms-url'])}',
				fsg: '${fn:toLowerCase(data['settings/fsg-url'])}'
			}
		};
		var options = {};
		meerkat != null && meerkat.init(siteConfig, options);

	})(window.meerkat);
</script>
