<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="type" 	required="true"  rtexprvalue="true"	 description="Type to supply to supertag (car/travel etc)" %>
<%@ attribute name="initialPageName" 	required="false"  rtexprvalue="true"	 description="Initial Page Name" %>
<%@ attribute name="initVertical" 		required="false"  rtexprvalue="true"	 description="Pass the vertical to the Tranck.init() or not" %>
<%@ attribute name="loadExternalJs" 	required="false"  rtexprvalue="true"	 description="Whether to load external JavaScript File" %>
<%@ attribute name="useCustomJs" 		required="false"  rtexprvalue="true"	 description="Legacy value, when false, no tracking js files are loaded or called" %>
<!-- #1: BEGIN SUPERTAG TOP CODE v2.0.20 --> <script type="text/javascript"> var superT_dcd=new Date(); document.write("\x3Cscr"+"ipt type=\"text/javascript\" src=\"//c.supert.ag/compare-the-market/compare-the-market/supertag.js?_dc="+Math.ceil(superT_dcd.getUTCMinutes()/5,0)*5+superT_dcd.getUTCHours().toString()+superT_dcd.getUTCDate()+superT_dcd.getUTCMonth()+superT_dcd.getUTCFullYear()+"\"\x3E\x3C/scr"+"ipt\x3E"); </script> <!-- Do NOT remove the following <script>...</script> tag: SuperTag requires the following as a separate <script> block --> <script type="text/javascript"> if(typeof superT!="undefined"){if(typeof superT.t=="function"){superT.t();}} </script> <!-- #1: END SUPERTAG TOP CODE -->

<c:if test="${empty initVertical}">
	<c:set var="initVertical" value="false" />
</c:if>

<c:if test="${empty useCustomJs}">
	<c:set var="useCustomJs" value="true" />
</c:if>

<c:if test="${useCustomJs eq true}">

	<c:if test="${empty loadExternalJs}">
		<c:set var="loadExternalJs" value="true" />
	</c:if>

	<go:script href="common/js/supertag/Track.js" marker="js-href" />

	<c:if test="${loadExternalJs}">
	<go:script href="common/js/supertag/Track_${type}.js" marker="js-href" />
	</c:if>
	<go:script marker="onready">
		<c:choose>
			<c:when test="${initVertical eq false}">
				Track_${type}.init();
			</c:when>
			<c:otherwise>
				Track_${type}.init('${initVertical}');
			</c:otherwise>
		</c:choose>

		<c:set var="loginData" value="${authenticatedData.login}" />
		<c:if test="${loginData.user.uid != ''}">
			Track.trackUser('${loginData.user.uid}');
		</c:if>
	</go:script>

	<c:set var="pageName">
		<c:choose>
			<c:when test="${not empty initialPageName}">${initialPageName}</c:when>
			<c:otherwise>Your Car</c:otherwise>
		</c:choose>
	</c:set>
	<script type="text/javascript">
		if (!typeof s === 'undefined'){
			s.pageName='${pageName}';
		}
	</script>

</c:if>
