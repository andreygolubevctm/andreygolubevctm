<%--
	Landing page for split test redirections from the brochure site
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="redirectURL" value="" />

<c:choose>
	<c:when test="${not empty param.vert}">
		<c:catch var="error">
			<settings:setVertical verticalCode="${param.vert}" />
			<c:set var="redirectURL" value="${pageSettings.getRootUrl()}${pageSettings.getBrandCode()}/${pageSettings.getSetting('landingPage')}.jsp?" />
		</c:catch>
	</c:when>
	<c:otherwise>
		<settings:setVertical verticalCode="GENERIC" />
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<c:catch var="error">
<layout:generic_page title="Secure Landing Page" skipJSCSS="true" incSuperTag="true">

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
					$('body').attr("STYLE", "background-color:transparent");
					<c:if test="${not empty redirectURL}">
						window.setTimeout(function(){
							document.location.href = "${redirectURL}" + qsArr.join('&');
						},10000);
					</c:if>
				});
			})();
		</script>
		<style type="text/css">
			body {
				display: none !important;
			}
			#copyright,#footer,header,#page>h2 {
				display: none;
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
	</jsp:body>

</layout:generic_page>
</c:catch>