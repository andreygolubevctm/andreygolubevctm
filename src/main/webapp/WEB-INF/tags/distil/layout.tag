<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Generic layout for both Distil blocked and captcha pages" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="pageTitle"  required="true"	 rtexprvalue="true"	 description="Title of the page" %>
<%@ attribute name="pageType"  required="true"	 rtexprvalue="true"	 description="The type of error page - blocked or captcha" %>

<layout_v3:distil_page title="${pageTitle}">
	<jsp:attribute name="head">
		<distil:style />
	</jsp:attribute>
    <jsp:body>
        <distil:body pageType="${pageType}" />
    </jsp:body>
</layout_v3:distil_page>