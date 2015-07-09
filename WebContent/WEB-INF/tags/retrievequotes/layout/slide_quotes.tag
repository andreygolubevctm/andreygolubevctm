<%@ tag description="Login Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="quotesForm">
    <layout:slide_columns>
        <jsp:attribute name="rightColumn">

        </jsp:attribute>
        <jsp:body>
            <layout:slide_content>
                <form_new:fieldset legend="Your Recent Quotes" className="recentQuotesFieldset">
                    <retrievequotes_template:parent />
                </form_new:fieldset>
            </layout:slide_content>
        </jsp:body>
    </layout:slide_columns>
</layout:slide>