<%@ tag description="Login Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="loginForm">
    <layout_v1:slide_columns>
        <jsp:attribute name="rightColumn">

        </jsp:attribute>
        <jsp:body>
            <layout_v1:slide_center xsWidth="12" mdWidth="10" className="roundedContainer">
                <c:if test="${isLoggedIn eq 'false'}">
                    <retrievequotes:login_form />
                    <retrievequotes:failed_login />
                </c:if>
                <confirmation:other_products heading="${otherProductsTitle}" lineLimit="7" maxVerticals="7" />
            </layout_v1:slide_center>
        </jsp:body>
    </layout_v1:slide_columns>
</layout_v1:slide>