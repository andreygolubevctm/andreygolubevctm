<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds an accordion container"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 				required="true"		rtexprvalue="true"	 description="css id attribute" %>
<%@ attribute name="className" 			required="false"	rtexprvalue="true"	 description="additional css class attribute" %>

<%@ attribute name="headingIcon"		required="false"	rtexprvalue="true"	 description="which icon to use for the heading
													cheatsheet of icon classes to be used: http://www.petefreitag.com/cheatsheets/jqueryui-icons/" %>
<%@ attribute name="activeHeadingIcon"	required="false"	rtexprvalue="true"	 description="which icon to use for the active heading
													cheatsheet of icon classes to be used: http://www.petefreitag.com/cheatsheets/jqueryui-icons/" %>

<%@ attribute name="collapsible"		required="false"	rtexprvalue="true"	 description="whether panels can be collapsed" %>
<%@ attribute name="animated"			required="false"	rtexprvalue="true"	 description="whether the opening of a panel should be animated (and which kind of animation)" %>
					
<%@ attribute name="autoHeight"			required="false"	rtexprvalue="true"	 description="whether to resize the height of panels automatically" %>
<%@ attribute name="fillSpace"			required="false"	rtexprvalue="true"	 description="whether the accordion should fill up the space from its container" %>
<%@ attribute name="clearStyle"			required="false"	rtexprvalue="true"	 description="If set, clears height and overflow styles after finishing animations. This enables accordions to work with dynamic content. Won't work together with autoHeight." %>
					
<%@ attribute name="openPanel"			required="false"	rtexprvalue="true"	 description="whether to open a panel by default (expects either false or the number of the panel 0 based)" %>
<%@ attribute name="disabled"			required="false"	rtexprvalue="true"	 description="whether the accordion should be disabled" %>
<%@ attribute name="sortable"			required="false"	rtexprvalue="true"	 description="whether panels can be sorted" %>

<%-- VARIABLES --%>
<c:if test="${empty collapsible}"><c:set var="collapsible" value="true" /></c:if>
<c:choose>
	<c:when test="${empty animated}"><c:set var="animated" value="\"slide\"" /></c:when>
	<c:when test="${animated != 'false'}"><c:set var="animated">"${animated}"</c:set></c:when>
</c:choose>

<c:if test="${empty autoHeight}"><c:set var="autoHeight" value="true" /></c:if>
<c:if test="${empty fillSpace}"><c:set var="fillSpace" value="false" /></c:if>
<c:if test="${empty clearStyle}"><c:set var="clearStyle" value="false" /></c:if>

<c:if test="${empty openPanel}"><c:set var="openPanel" value="0" /></c:if>
<c:if test="${empty disabled}"><c:set var="disabled" value="false" /></c:if>
<c:if test="${sortable == true}">
	<c:set var="sortable">
	    .sortable({
			axis: "y",
			handle: "h3",
			stop: function( event, ui ) {
				// IE doesn't register the blur when sorting
				// so trigger focusout handlers to remove .ui-state-focus
				ui.item.children( "h3" ).triggerHandler( "focusout" );
			}
		});
	</c:set>
</c:if>

<%-- HTML --%>
<div id="${id}" class="${className}">
	<jsp:doBody />
</div>

<%-- JavaScript --%>
<go:script marker="jquery-ui">
    $( "#${id}" ).accordion({
    	<c:choose>
    		<c:when test="${not empty headingIcon and not empty activeHeadingIcon}">
    			icons: {
				  header: "${headingIcon}",
				  headerSelected: "${activeHeadingIcon}"
				},
    		</c:when>
    		<c:when test="${not empty headingIcon}">
    			icons: {
				  header: "${headingIcon}",
				},
    		</c:when>
    		<c:when test="${not empty activeHeadingIcon}">
    			icons: {
				  headerSelected: "${activeHeadingIcon}"
				},
    		</c:when>
    	</c:choose>
		collapsible: ${collapsible},
		animated: ${animated},
		autoHeight: ${autoHeight},
		fillSpace: ${fillSpace},
		clearStyle: ${clearStyle},
		active: ${openPanel},
		disabled: ${disabled}
    })${sortable}
    
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	
</go:style>