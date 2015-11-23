<%--
	Landing page for split test redirections from the brochure site
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger('jsp.landing')}" />

<c:set var="redirectURL" value="" />
<c:set var="verticalName" value="" />
<c:choose>
	<c:when test="${not empty param.vert}">
		<c:catch var="error">
			<settings:setVertical verticalCode="${param.vert}" />
			<c:set var="redirectURL" value="${pageSettings.getRootUrl()}${pageSettings.getBrandCode()}/${pageSettings.getSetting('landingPage')}.jsp?" />
			<c:set var="verticalName" value="${pageSettings.getVertical().getName()}" />

			<%-- Generally referred to as Health Insurance (not Private Health Insurance) --%>
			<c:if test="${pageSettings.getVerticalCode() eq 'health'}">
				<c:set var="verticalName" value="Health Insurance" />
			</c:if>

		</c:catch>
		<c:if test="${not empty error}">
			<settings:setVertical verticalCode="GENERIC" />
			${logger.warn('Error setting vertical. {}', log:kv('vert',param.vert ), error)}
		</c:if>
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
	</c:otherwise>
</c:choose>


<%-- HTML --%>
<layout:generic_page title="Secure Landing Page" skipJSCSS="true">

	<jsp:attribute name="head">
		<script type="text/javascript">
			(function(){
				var qs = document.location.search.substring(1);
				qs = qs.split("&");
				var qsArr = [];
				for(var i = 0; i < qs.length; i++) {
					var pieces = qs[i].split('=');
					if(pieces.length == 2) {
						if(pieces[0] != 'vert') {
							qsArr.push(qs[i]);
						}
					}
				}
				$(document).ready(function(){
					<c:if test="${pageSettings.getVerticalCode() eq 'generic'}">
						$('#loading p').html('Oops, something seems to have gone wrong! Let\'s try that again...');
						window.setTimeout(function(){
							history.go(-1);
						},5000);
					</c:if>
					$('body').attr("style", "background-color:transparent");
					<c:if test="${not empty redirectURL}">
						window.setTimeout(function(){
							document.location.href = "${redirectURL}" + qsArr.join('&');
						},5000);
					</c:if>
				});
			})();
		</script>
		<style type="text/css">

			@font-face {
				font-family: SourceSansProRegular;
				src:url('${pageSettings.getBaseUrl()}/framework/fonts/SourceSansPro-Regular.eot');
				src:url('${pageSettings.getBaseUrl()}/framework/fonts/SourceSansPro-Regular.eot?#iefix') format('embedded-opentype'),
					url('${pageSettings.getBaseUrl()}/framework/fonts/SourceSansPro-Regular.woff') format('woff'),
					url('${pageSettings.getBaseUrl()}/framework/fonts/SourceSansPro-Regular.ttf') format('truetype'),
					url('${pageSettings.getBaseUrl()}/framework/fonts/SourceSansPro-Regular.svg#SourceSansProRegular') format('svg');
				font-weight: normal;
				font-style: normal;
			}

			body {
				margin: 0;
				font-family: SourceSansProRegular;
				color: #1c3e93;
			}
			body > div > div, #copyright,#footer,header,h2,.fixedDevEnvDialog {
				display: none;
			}
			#loading {
				display: block;
				position:absolute;
				top: 10%;
				width: 100%;
				text-align: center;
			}
		</style>
	</jsp:attribute>

	<jsp:attribute name="head_meta">
		<meta name="robots" content="noindex, nofollow">
	</jsp:attribute>

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer" />

	<jsp:attribute name="body_end" />

	<jsp:body>

	<div id="loading">
		<p>Please wait while we load your <c:out value="${verticalName}" /> comparison</p>
		<img src="brand/ctm/graphics/spinner-burp.gif" alt="Loading" />
	</div>
	</jsp:body>

</layout:generic_page>
