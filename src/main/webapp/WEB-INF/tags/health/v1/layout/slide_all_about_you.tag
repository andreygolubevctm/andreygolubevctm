<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

    <layout_v3:slide_content >

        <%-- PROVIDER TESTING --%>
        <health_v1:provider_testing xpath="${pageSettings.getVerticalCode()}" />

        <%-- COVER TYPE / SITUATION --%>
        <div id="${pageSettings.getVerticalCode()}_situation">
            <health_v1:situation xpath="${pageSettings.getVerticalCode()}/situation" />
        </div>

    </layout_v3:slide_content>

</layout_v3:slide>