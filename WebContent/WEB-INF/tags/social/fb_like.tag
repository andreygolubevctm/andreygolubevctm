<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Builds a FB button" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="type"			required="false"	rtexprvalue="true"	 description="How to display the like button [html5|iframe]. Default:iframe. (html5 requires social:fb_root to be included after the body tag." %>
<%@ attribute name="href"			required="true"		rtexprvalue="true"	 description="The URL to like" %>
<%@ attribute name="send"			required="false"	rtexprvalue="true"	 description="Whether to display the Send button (to a friend) or not" %>
<%@ attribute name="layout"			required="false"	rtexprvalue="true"	 description="Which display layout to use (standard, button_count or box_count)" %>
<%@ attribute name="show_faces"		required="false"	rtexprvalue="true"	 description="Whether to show the people who like the page under the button" %>
<%@ attribute name="width"			required="false"	rtexprvalue="true"	 description="The width" %>
<%@ attribute name="action"			required="false"	rtexprvalue="true"	 description="Which verb to display on the button (like or recommend)" %>
<%@ attribute name="font"			required="false"	rtexprvalue="true"	 description="Which font to use (arial, lucida grande, segoe ui, tahoma, trebuchet ms, verdana)" %>
<%@ attribute name="colorscheme"	required="false"	rtexprvalue="true"	 description="Which color scheme to use (light or dark)" %>
<%@ attribute name="ref"			required="false"	rtexprvalue="true"	 description="which button to display (page, like)" %>

<%-- Href --%>
<c:set var="optionsHtml5"> data-href="${href}"</c:set>
<c:set var="optionsIframe">href=${go:urlEncode(href)}</c:set>

<%-- Send --%>
<c:choose>
	<c:when test="${send eq 'true'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-send="true"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;send=false</c:set> <%-- send button is not compatible with iframe --%>
	</c:when>
	<c:otherwise>
		<c:set var="optionsIframe">${optionsIframe}&amp;send=false</c:set>
	</c:otherwise>
</c:choose>

<%-- Layout --%>
<c:choose>
	<c:when test="${layout eq 'button_count' or layout eq 'box_count'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-layout="${layout}"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;layout=${layout}</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsIframe">${optionsIframe}&amp;layout=standard</c:set>
	</c:otherwise>
</c:choose>

<%-- Show Faces --%>
<c:choose>
	<c:when test="${show_faces eq 'true'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-show-faces="true"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;show_faces=true</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsHtml5">${optionsHtml5} data-show-faces="false"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;show_faces=false</c:set>
	</c:otherwise>
</c:choose>


<%-- Width --%>
<c:choose>
	<c:when test="${empty width}">
		<c:set var="optionsHtml5">${optionsHtml5} data-width="450"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;width=450</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsHtml5">${optionsHtml5} data-width="${width}"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;width=${width}</c:set>
	</c:otherwise>
</c:choose>

<%-- Height --%>
<c:choose>
	<c:when test="${layout eq 'button_count'}">
		<c:set var="height" value="21" />
	</c:when>
	<c:when test="${layout eq 'box_count'}">
		<c:set var="height" value="65" />
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${show_faces eq 'true'}">
				<c:set var="height" value="80" />
			</c:when>
			<c:otherwise>
				<c:set var="height" value="35" />
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<c:set var="optionsIframe">${optionsIframe}&amp;height=${height}</c:set>

<%-- Action --%>
<c:choose>
	<c:when test="${action eq 'recommend'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-action="recommend"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;action=recommend</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsIframe">${optionsIframe}&amp;action=like</c:set>
	</c:otherwise>
</c:choose>

<%-- Font --%>
<c:choose>
	<c:when test="${font eq 'arial' or font eq 'lucida grande' or font eq 'segoe ui' or font eq 'tahoma' or font eq 'trebuchet ms' or font eq 'verdana'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-font="${font}"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;font=${font}</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsIframe">${optionsIframe}&amp;font</c:set>
	</c:otherwise>
</c:choose>

<%-- Color Scheme --%>
<c:choose>
	<c:when test="${colorscheme eq 'dark'}">
		<c:set var="optionsHtml5">${optionsHtml5} data-colorscheme="dark"</c:set>
		<c:set var="optionsIframe">${optionsIframe}&amp;colorscheme=dark</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="optionsIframe">${optionsIframe}&amp;colorscheme=light</c:set>
	</c:otherwise>
</c:choose>

<%-- Ref --%>
<%-- @todo add ref params, used to track the source of the like --%>

<%-- HTML --%>
<c:choose>
	<c:when test="${type eq 'html5'}">
		<div class="fb-like" ${optionsHtml5}></div>
	</c:when>
	<c:otherwise>
		<iframe src="//www.facebook.com/plugins/like.php?${optionsIframe}" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:${width}px; height:${height}px;" allowTransparency="true"></iframe>
	</c:otherwise>
</c:choose>


