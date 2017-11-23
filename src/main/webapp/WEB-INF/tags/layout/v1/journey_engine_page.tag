<%@ tag description="Journey Engine Page" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="webUtils" class="com.ctm.web.core.web.Utils" scope="request" />

<%@ attribute name="title" required="false" rtexprvalue="true" description="Page title" %>
<%@ attribute required="false" name="body_class_name" description="Allow extra styles to be added to the rendered body tag" %>
<%@ attribute name="ignore_journey_tracking" required="false" rtexprvalue="true" description="Ignore Journey Tracking" %>
<%@ attribute name="bundleFileName" required="false" rtexprvalue="true" description="Pass in an alternate file name" %>
<%@ attribute name="displayNavigationBar" required="false" rtexprvalue="true" description="Pass false to remove the navigation bar" %>

<%@ attribute fragment="true" required="true" name="head" %>
<%@ attribute fragment="true" required="true" name="head_meta" %>
<%@ attribute fragment="true" required="true" name="form_bottom" %>
<%@ attribute fragment="true" required="true" name="footer" %>
<%@ attribute fragment="true" required="true" name="body_end" %>
<%@ attribute fragment="true" required="false" name="additional_meerkat_scripts" %>

<%@ attribute fragment="true" required="false" name="header" %>
<%@ attribute fragment="true" required="false" name="header_button_left" %>

<%@ attribute fragment="true" required="false" name="navbar" %>
<%@ attribute fragment="true" required="false" name="navbar_additional" %>
<%@ attribute fragment="true" required="false" name="navbar_outer" %>
<%@ attribute fragment="true" required="false" name="progress_bar" %>
<%@ attribute fragment="true" required="false" name="xs_results_pagination" %>
<%@ attribute fragment="true" required="true" name="vertical_settings" %>

<%@ attribute fragment="true" required="false" name="results_loading_message" %>
<%@ attribute fragment="true" required="false" name="before_close_body" %>

<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />
<c:set var="verticalCode" value="${pageSettings.getVerticalCode()}" />
<c:if test="${verticalCode eq 'car'}">
    <c:set var="verticalCode" value="quote" />
</c:if>

<c:if test="${empty sessionPop}"><c:set var="sessionPop" value="true" /></c:if>

<layout_v1:page title="${title}" body_class_name="${body_class_name}" bundleFileName="${bundleFileName}" displayNavigationBar="${displayNavigationBar}">

	<jsp:attribute name="head">
		<jsp:invoke fragment="head" />
        <c:set var="isDev" value="${environmentService.getEnvironmentAsString() eq 'localhost' || environmentService.getEnvironmentAsString() eq 'NXI' || environmentService.getEnvironmentAsString() eq 'NXQ'}" />

        <c:if test="${isDev eq true && !param['automated-test']}">
            <%-- <script src="https://cdn.logrocket.com/LogRocket.min.js"></script>
            <script>window.LogRocket && window.LogRocket.init('compare-the-market/web-ctm');</script> --%>
        </c:if>
	</jsp:attribute>

    <jsp:attribute name="head_meta">
		<jsp:invoke fragment="head_meta" />
	</jsp:attribute>

    <jsp:attribute name="header">
		<jsp:invoke fragment="header" />
	</jsp:attribute>

    <jsp:attribute name="header_button_left"><jsp:invoke fragment="header_button_left" /></jsp:attribute>

    <jsp:attribute name="navbar">
		<jsp:invoke fragment="navbar" />
	</jsp:attribute>

    <jsp:attribute name="navbar_additional">
		<jsp:invoke fragment="navbar_additional" />
	</jsp:attribute>

    <jsp:attribute name="navbar_outer">
		<jsp:invoke fragment="navbar_outer" />
	</jsp:attribute>

    <jsp:attribute name="progress_bar">
		<jsp:invoke fragment="progress_bar" />
	</jsp:attribute>

    <jsp:attribute name="xs_results_pagination">
        <jsp:invoke fragment="xs_results_pagination" />
	</jsp:attribute>

    <jsp:attribute name="vertical_settings">
		<jsp:invoke fragment="vertical_settings" />
	</jsp:attribute>

    <jsp:attribute name="body_end">
		<jsp:invoke fragment="body_end" />
	</jsp:attribute>

    <jsp:attribute name="additional_meerkat_scripts">
		<jsp:invoke fragment="additional_meerkat_scripts" />
	</jsp:attribute>

    <jsp:attribute name="before_close_body">
		<content:get key="beforeCloseBody" suppKey="journey" />
		<jsp:invoke fragment="before_close_body" />
	</jsp:attribute>

    <jsp:body>


        <div id="pageContent">
          <c:set var="octoberCompRender" value="${false}"></c:set>
          <c:if test="${octoberComp && (pageSettings.getVerticalCode() eq 'home' || pageSettings.getVerticalCode() eq 'health' || pageSettings.getVerticalCode() eq 'car')}">
            <c:set var="octoberCompRender" value="${true}"></c:set>
          </c:if >
                <%-- <div id="pageContentTop"></div> --%>
            
            <article class="container">
              <c:set var="octoberCompClass" value=""></c:set>
              <c:if test="${pageSettings.getBrandCode() eq 'ctm' && octoberCompRender}">
                <c:set var="octoberCompClass" value="octoberComp" />
              </c:if>

                <c:set var="additionalLoadingHtml"><content:get key='additionalWaitMessageHtml'/></c:set>
                <c:set var="additionalLoadingCss"><content:get key='additionalLoadingCss'/></c:set>

                <div id="journeyEngineContainer" class="${octoberCompClass} ${additionalLoadingCss}">
                  
                    <div id="journeyEngineLoading" class="journeyEngineLoader opacityTransitionQuick">

                        <div class="loading-logo"></div>
                        
                        <p class="message">Please wait...</p>
                        <c:choose>
                          <c:when test="${octoberCompRender && !callCentre}">
                            <competition:loading vertical="${pageSettings.getVerticalCode()}"/>
                          </c:when >
                          <c:otherwise>
                            <jsp:invoke fragment="results_loading_message" />
                            <c:if test="${fn:length(additionalLoadingHtml) > 0}">
                                <div id="additionalWaitMessage">${additionalLoadingHtml}</div>
                            </c:if>
                          </c:otherwise>
                        </c:choose>          
                    </div>

                    <div id="mainform" class="form-horizontal">
                        <c:if test="${ignore_journey_tracking != 'true'}">
                            <core_v2:journey_tracking />
                        </c:if>

                        <core_v2:tracking_key />
	                    <core_v2:gaClientId />
	                    <core_v2:affiliateProperties />

                        <div id="journeyEngineSlidesContainer">
                            <jsp:doBody />
                        </div>

                        <input
                                type="hidden"
                                id="${verticalCode}_journey_stage"
                                name="${verticalCode}_journey_stage"
                                value="${data[verticalCode]['journey/stage']}"
                                class="journey_stage"
                        />

                        <jsp:invoke fragment="form_bottom" />

                        <c:if test="${pageSettings.hasSetting('sendBestPriceSplitTestingEnabled')}">
                            <c:if test="${pageSettings.getSetting('sendBestPriceSplitTestingEnabled') eq 'Y' && not empty param.splitEmail }">
                                <field_v1:hidden xpath="${verticalCode}/bestPriceSplitTest" defaultValue="${param.splitEmail eq 2 ? 2 : 1 }" />
                            </c:if>
                        </c:if>
                    </div>
                </div>

            </article>

        </div>

        <agg_v1:footer_outer>
            <jsp:invoke fragment="footer" />
        </agg_v1:footer_outer>

    </jsp:body>

</layout_v1:page>