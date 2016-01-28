<%@ tag description="Login Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v1:slide formId="quotesForm">
    <layout_v1:slide_columns colSize="8">
        <jsp:attribute name="rightColumn">

        </jsp:attribute>
        <jsp:body>
            <layout_v1:slide_content>
                <form_v2:fieldset legend="Your Recent Quotes" className="recentQuotesFieldset">
                    <retrievequotes_template:parent />
                </form_v2:fieldset>
            </layout_v1:slide_content>
        </jsp:body>
    </layout_v1:slide_columns>
</layout_v1:slide>