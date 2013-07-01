<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Builds a CSS button" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="mainClass" 			required="false"		rtexprvalue="true"	 description="main identifying css class attribute" %>
<%@ attribute name="classNames"			required="false"	rtexprvalue="true"	 description="additional css classes attribute" %>
<%@ attribute name="id"					required="false"	rtexprvalue="true"	 description="additional css ID attribute" %>

<%@ attribute name="href" 				required="false"	rtexprvalue="true"	 description="URL the button should point to" %>
<%@ attribute name="title" 				required="false"	rtexprvalue="true"	 description="title of the button" %>

<%-- Only green or skyblue are available options for the themes at the moment (more can be added in style.css) --%>
<%@ attribute name="theme" 				required="false"	rtexprvalue="true"	 description="optional theme to use (will override other apperance options)" %>
<%@ attribute name="topColor"			required="false"	rtexprvalue="true"	 description="top color of the gradient on the button" %>
<%@ attribute name="topColorAlpha"		required="false"	rtexprvalue="true"	 description="top color of the gradient's alpha transparency (0 to 1)" %>
<%@ attribute name="bottomColor"		required="false"	rtexprvalue="true"	 description="bottom color of the gradient on the button" %>
<%@ attribute name="bottomColorAlpha"	required="false"	rtexprvalue="true"	 description="bottom color of the gradient's alpha transparency (0 to 1)" %>
<%@ attribute name="borderColor"		required="false"	rtexprvalue="true"	 description="border color of the button" %>
<%@ attribute name="borderColorHover"	required="false"	rtexprvalue="true"	 description="border color when hovering the button" %>
<%@ attribute name="borders"			required="false"	rtexprvalue="true"	 description="list of the border sides to display" %>
<%@ attribute name="borderSize"			required="false"	rtexprvalue="true"	 description="size of the border" %>
<%@ attribute name="topShadowColor"		required="false"	rtexprvalue="true"	 description="top shadow color of the button" %>
<%@ attribute name="roundedCorners"		required="false"	rtexprvalue="true"	 description="number of pixels the corners of the button should be rounded" %>

<%-- VARIABLES --%>
<c:if test="${empty href}"><c:set var="href" value="javascript:void(0);" /></c:if>

<c:choose>
	<%-- if there is a theme, add its css class --%>
	<c:when test="${not empty theme}"><c:set var="classes">${theme}Button ${mainClass} ${classNames}</c:set></c:when>
	<%-- if no theme and no colors set manually, default to green theme --%>
	<c:when test="${empty theme and empty topColor and empty bottomColor and empty borderColor}"><c:set var="classes" value="greenButton ${mainClass} ${classNames}" /></c:when>
	<c:otherwise><c:set var="classes" value="${mainClass} ${classNames}" /></c:otherwise>
</c:choose>
<c:if test="${empty topColor}"><c:set var="topColor" value="#0FBE58" /></c:if>
<c:if test="${empty topColorAlpha}"><c:set var="topColorAlpha" value="1" /></c:if>
<c:if test="${empty bottomColor}"><c:set var="bottomColor" value="#0FBE58" /></c:if>
<c:if test="${empty bottomColorAlpha}"><c:set var="bottomColorAlpha" value="1" /></c:if>
<c:if test="${empty borderColor}"><c:set var="borderColor" value="#17DF86" /></c:if>
<c:if test="${empty borders}"><c:set var="borders" value="top,left" /></c:if>
<c:if test="${empty borderSize}"><c:set var="borderSize" value="1" /></c:if>

<c:if test="${empty roundedCorners}"><c:set var="roundedCorners" value="5" /></c:if>

<%-- HTML --%>
<a href="${href}" id="${id}" title="${title}" class="standardButton ${classes}"><jsp:doBody/></a>

<%-- CSS --%>
<go:style marker="css-head">

	<c:if test="${empty theme and not empty mainClass}">
		<c:if test="${not empty roundedCorners}">
			.${mainClass} {
				/* ROUNDED CORNERS */
				<css:rounded_corners value="${roundedCorners}" />
			}
		</c:if>
		
		.${mainClass} {
			<c:if test="${not empty borderColor}">
				/* BORDERS */
				<c:choose>
					<c:when test="${borders eq 'all'}">
						border: ${borderSize}px solid ${borderColor};
					</c:when>
					<c:otherwise>
						<c:forTokens items="${borders}" delims="," var="borderSide">
							border-${border}: ${borderSize}px solid ${borderColor};
						</c:forTokens>
					</c:otherwise>
				</c:choose>
			</c:if>
			
			<c:if test="${not empty topShadowColor}">
				/* TOP SHADOW */
				-moz-box-shadow: 0 -1px 0 ${topShadowColor};
				-webkit-box-shadow: 0 -1px 0 ${topShadowColor};
				box-shadow: 0 -1px 0 ${topShadowColor};
			</c:if>
			
			<c:if test="${not empty topColor and not empty bottomColor}">
				<css:gradient bottomColor="${bottomColor}" topColor="${topColor}" bottomColorAlpha="${bottomColorAlpha}" topColorAlpha="${topColorAlpha}" />
			</c:if>
		}
		
			.${mainClass}:hover {
				<c:if test="${not empty borderColorHover}">
					border-top: 1px solid ${borderColorHover};
					border-left: 1px solid ${borderColorHover};
				</c:if>
				
				<c:if test="${not empty topColor and not empty bottomColor}">
					<css:gradient bottomColor="${bottomColor}" topColor="${topColor}" bottomColorAlpha="${bottomColorAlpha - 0.1}" topColorAlpha="${topColorAlpha - 0.1}" />
				</c:if>
			}
			
			.${mainClass}:active {
				<c:if test="${not empty topColor and not empty bottomColor}">
					<css:gradient bottomColor="${bottomColor}" topColor="${topColor}" bottomColorAlpha="${bottomColorAlpha - 0.2}" topColorAlpha="${topColorAlpha - 0.2}" />
				</c:if>
			}
	</c:if>
</go:style>