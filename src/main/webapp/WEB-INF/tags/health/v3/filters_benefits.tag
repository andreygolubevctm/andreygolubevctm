<%@ tag description="The Health Cover Selections Filter" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="col-xs-12 sidebar-widget sidebar-widget-contained sidebar-widget-padded results-filters">

    <div class="sidebar-title">Cover Selections</div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Hospital cover</span>
            </div>
            <div data-filter-type="checkbox">
                    <c:forEach items="${resultTemplateItems}" var="selectedValue">
                        <health_v3:benefit_checkbox_label item="${selectedValue}" category="Hospital" />
                    </c:forEach>
            </div>
        </div>
    </div>

    <div class="row filter">
        <div class="col-xs-12">
            <div class="sidebar-subtitle-container">
                <span class="helper-text"><a>Help ?</a></span>
                <span class="heading-text">Extras cover</span>
            </div>
            <div data-filter-type="checkbox">
                    <c:forEach items="${resultTemplateItems}" var="selectedValue">
                        <health_v3:benefit_checkbox_label item="${selectedValue}" category="GeneralHealth" />
                    </c:forEach>
            </div>
        </div>
    </div>
</div>