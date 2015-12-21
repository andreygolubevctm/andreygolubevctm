<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="quote" />

<layout_v1:slide formId="startForm" firstSlide="true" nextLabel="Next Step">

    <layout_v1:slide_content>
        <%-- PROVIDER TESTING --%>
        <agg:provider_testing xpath="${xpath}" displayFullWidth="true" keyLabel="authToken" filterProperty="providerList" hideSelector="${carServiceSplitTest eq false}" />

        <car:vehicle_selection_lookup xpath="${xpath}/vehicle" />

    </layout_v1:slide_content>

</layout_v1:slide>