<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />


<c:if test="${item.isShortlistable()}">

    <%-- SETUP VARIABLES --%>
    <c:set var="category" scope="request"><c:choose><c:when test="${item.getShortlistKey() eq 'Hospital'}">Hospital</c:when><c:otherwise>Extras</c:otherwise></c:choose></c:set>
    <c:set var="overlayName" value="${fn:toLowerCase(category)}" scope="request" />
    <c:set var="isSection" value="${item.getType() == 'section'}" scope="request" />
    <c:set var="resultPath" value="${item.getResultPath()}" scope="request" />
    <c:set var="benefitGroup" scope="request">
        <c:choose>
            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
        </c:choose>
    </c:set>
    <c:set var="hasShortlistableChildren" value="${item.hasShortlistableChildren()}" scope="request" />

    <form_v2:fieldset legend="" postLegend="" className="tieredHospitalCover_v2 ${category}BenefitsContainer${' '}">

        <div class="scrollable">
            <div class="short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">


                <div id="${category}-wrapper" class="${category}-wrapper">

<%-- ============================================================= --%>
<%-- ---------- HEADING SECTION START --%>
<%-- ============================================================= --%>

                    <c:if test="${category eq 'Hospital'}">
                        <health_v5_insuranceprefs:category_select_hospital xpath="health/benefits" />
                        <div class="section-title">
                            <h1 class="step-count">3.</h1>
                            <h3 class="ignore">Hospital cover <span class="benefit-selections-count hospital"></span></h3>
                            <p>Review the hospital service and treatment options below and adjust to your needs.</p>
                        </div>
                        <health_v5_insuranceprefs:quick_select_hospital xpath="health/benefits" />
                        <health_v5_insuranceprefs:toggle_and_jump xpath="health/benefits" type="${category}" />
                    </c:if>
                    <c:if test="${category != 'Hospital'}">
                        <div class="section-title">
                            <h1 class="step-count">4.</h1>
                            <h3 class="ignore">Extras cover <span class="benefit-selections-count extras"></span></h3>
                        </div>
                        <div class="section-title-alt">
                            <h1 class="step-count">2.</h1>
                            <h3 class="ignore">Extras cover <span class="benefit-selections-count extras"></span></h3>
                        </div>
                        <health_v5_insuranceprefs:category_select_extras xpath="health/benefits" />
                        <health_v5_insuranceprefs:toggle_and_jump xpath="health/benefits" type="${category}" />
                    </c:if>

<%-- ============================================================= --%>
<%-- <<<<<<<<<< HEADING SECTION END --%>
<%-- ============================================================= --%>

<%-- ============================================================= --%>
<%-- ---------- ACTUAL BENEFITS SECTION START --%>
<%-- ============================================================= --%>

                <c:if test="${hasShortlistableChildren eq true}">
                    <div id="benefits-list-${overlayName}" class="children healthBenefits hasIcons">
                        <div id="sortable-${overlayName}">
                        <c:forEach items="${item.getChildren()}" var="selectedValue">
                            <c:if test="${selectedValue.isShortlistable()}">

                                <div class="categoriesCell_v2 ${colWidthValue} short-list-item ${selectedValue.getClassString()} ${selectedValue.getShortlistKey()}_container" data-groups="${selectedValue.getGroups()}" data-sortable-key="${selectedValue.getName()}">
                                    <c:set var="resultPath" value="${selectedValue.getResultPath()}" />
                                    <c:set var="benefitGroup">
                                        <c:choose>
                                            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
                                            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
                                        </c:choose>
                                    </c:set>
                                    <c:set var="analyticsLabelAttr"><field_v1:analytics_attr analVal="benefit ${benefitGroup}" quoteChar="\"" /></c:set>
                                    <c:set var="analyticsHelpAttr"><field_v1:analytics_attr analVal="qtip ${selectedValue.getShortlistKey()}" quoteChar="\"" /></c:set>
                                    <c:set var="descriptionCopy" value="${selectedValue.getDescription()}" />
                                    <c:set var="benefitLabel">
                                        <div class="benefit-label-container">
                                            <div class="benefit-group-row">
                                                <div class="benefit-image">
                                                    <span class="benefit-icon">
                                                        <label></label>
                                                    </span>
                                                </div>
                                                <div class="benefit-title hidden-xs">${selectedValue.getName()}</div>
                                                <div class="benefit-copy">
                                                    <div class="copy-innertube">
                                                        <div class="benefit-title visible-xs">${selectedValue.getName()}</div>
                                                        <div class="benefit-caption">${selectedValue.getCaption()}</div>
                                                        <div class="benefit-description collapse">${descriptionCopy}</div>
                                                    </div>
                                                </div>
                                                <div class="benefit-toggle">
                                                    <a href="javascript:;" class="<c:if test="${empty descriptionCopy}">hidden</c:if>">
                                                        <span class="health-icon icon-health-chevron"></span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:set>
                                    <c:set var="formatedXpath" value="${fn:replace(selectedValue.getShortlistKey(), '_','/')}" />
                                    <field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${formatedXpath}" value="Y" required="false"
                                                label="true" title="${benefitLabel}" errorMsg="Please tick"
                                                customAttribute=" data-attach=true data-benefit-id='${selectedValue.getId()}' data-benefit-code='${selectedValue.getShortlistKey()}' " additionalLabelAttributes="${analyticsLabelAttr}"
                                                additionalHelpAttributes="${analyticsHelpAttr}" />
                                    <div class="benefit-categories"></div>
                                </div>
                            </c:if>
                        </c:forEach>
                        </div>
                        <health_v5_insuranceprefs:benefits_loader xpath="health/benefits" type="${category}" />
                    </div>
                </c:if>

<%-- ============================================================= --%>
<%-- <<<<<<<<<< ACTUAL BENEFITS SECTION END --%>
<%-- ============================================================= --%>

                </div>
            </div>
        </div>
    </form_v2:fieldset>
</c:if>