<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form_v2:fieldset_columns sideHidden="false">

    <jsp:attribute name="rightColumn"></jsp:attribute>

    <jsp:body>
        <layout_v1:slide_content>
            <car:snapshot asBubble="true" className="quoteSnapshotV2"/>
        </layout_v1:slide_content>
    </jsp:body>

</form_v2:fieldset_columns>