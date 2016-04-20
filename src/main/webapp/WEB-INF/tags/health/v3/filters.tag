<%@ tag description="The Health Filters" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="col-sm-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters">

    <div class="sidebar-title">Filter Results</div>
    
    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="heading-text">Payment frequency</span>
            </div>
            <div id="filter-frequency" class="filter-frequency" data-filter-type="radio">
                <%-- Redo to a template --%>
                <field_v2:array_radio xpath="health/show-price" title="Repayments" items="F=Fortnightly,M=Monthly,A=Annually" required="false"/>
            </div>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Hospital cover level</span>
            </div>
            <div class="filter-frequency" data-filter-type="radio">
                    <field_v2:checkbox
                            required="false"
                            value="T"
                            xpath="health/filters/coverType/top"
                            label="Top"
                            title='Top' theme="none" />
                    <field_v2:checkbox
                            required="false"
                            value="M"
                            xpath="health/filters/coverType/mid"
                            label="Mid"
                            title='Mid' theme="none" />
                    <field_v2:checkbox
                            required="false"
                            value="B"
                            xpath="health/filters/coverType/basic"
                            label="Basic"
                            title='Basic' theme="none" />
                    <field_v2:checkbox
                            required="false"
                            value="C"
                            xpath="health/filters/customise"
                            label="Customise"
                            title='Customise' theme="none" />
                    <field_v2:checkbox
                            required="false"
                            value="L"
                            xpath="health/filters/limited"
                            label="Limited Cover"
                            title='Limited Cover' theme="none" />
            </div>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Hospital excess</span>
            </div>
            <%-- Redo to a template --%>
            <div class="filter-slider" data-filter-type="slider" data-filter-serverside="true">
                <health_v1:filter_excess/>
            </div>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Government rebate</span>
            </div>
            <%-- Redo to a template --%>
            <div data-filter-type="select" data-filter-serverside="true">
                <field_v2:array_select xpath="health/filters/income" title="your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3"
                                       delims="||"/>
            </div>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text">select <a>all</a>/<a>none</a></span>
                <span class="heading-text">Brands</span>
            </div>
            <%-- Redo to a template --%>
            <jsp:useBean id="healthApplicationService" class="com.ctm.web.health.services.HealthApplicationService" scope="page"/>
            <c:set var="providerList" value="${healthApplicationService.getAllProviders(pageSettings.getBrandId())}" scope="request"/>
            <div class="provider-list" data-filter-type="select" data-filter-serverside="true">
                <health_v3:filters_provider xpath="health/brandFilter" providersList="${providerList}"/>
            </div>
        </div>
    </div>

</div>