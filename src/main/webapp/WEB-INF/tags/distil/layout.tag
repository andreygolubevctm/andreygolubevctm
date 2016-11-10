<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Generic layout for both Distil blocked and captcha pages" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Attributes --%>
<%@ attribute name="brandCode"  required="true"	 rtexprvalue="true"	 description="The brand code applicable to the page" %>
<%@ attribute name="pageTitle"  required="true"	 rtexprvalue="true"	 description="Title of the page" %>
<%@ attribute name="pageType"  required="true"	 rtexprvalue="true"	 description="The type of error page - blocked or captcha" %>

<%-- Content --%>
<layout_v3:distil_page brandCode="${brandCode}" title="${pageTitle}">
	<jsp:attribute name="head">
		<distil:style brandCode="${brandCode}" />
	</jsp:attribute>
    <jsp:body>
        <distil:body pageType="${pageType}" />
    </jsp:body>
</layout_v3:distil_page>