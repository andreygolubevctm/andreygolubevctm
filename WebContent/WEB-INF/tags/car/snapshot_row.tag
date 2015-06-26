<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form_new:fieldset_columns sideHidden="false">

    <jsp:attribute name="rightColumn"></jsp:attribute>

    <jsp:body>
        <layout:slide_content>
            <car:snapshot asBubble="true" />
        </layout:slide_content>
    </jsp:body>

</form_new:fieldset_columns>