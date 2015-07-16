<%@ tag description="Login Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="loginForm">
    <layout:slide_columns>
        <jsp:attribute name="rightColumn">

        </jsp:attribute>
        <jsp:body>
            <layout:slide_center xsWidth="12" mdWidth="10" className="roundedContainer">
                <c:if test="${isLoggedIn eq 'false'}">
                    <retrievequotes:login_form />
                    <retrievequotes:failed_login />
                </c:if>
            </layout:slide_center>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>