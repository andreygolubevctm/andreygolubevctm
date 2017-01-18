<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />

<c:if test="${item.isShortlistable()}">

    <c:set var="benefitsContentBlurbs" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "benefitsCopy_v4")}' />
    <c:set var="benefitsContent" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "healthbenefits_v4")}' />
    <%-- Get the correct cell width for sections v. categories --%>
    <c:choose>
        <c:when test="${item.getType() == 'section'}">
            <c:choose>
                <c:when test="${item.getClassName() == 'hospitalCover'}">
                    <c:set var="colContent">${benefitsContent.getSupplementaryValueByKey('hospitalText')}</c:set>
                    <c:set var="coverType">Hospital</c:set>
                </c:when>
                <c:otherwise>
                    <c:set var="colContent">${benefitsContent.getSupplementaryValueByKey('extrasText')}</c:set>
                    <c:set var="coverType">Extras</c:set>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <c:set var="colWidthValue" value="categoriesCell" />
        </c:otherwise>
    </c:choose>

    <c:if test="${callCentre}">
        <c:set var="colContent" value="" />
    </c:if>

    <c:set var="category">Extras</c:set>
    <c:if test="${item.getShortlistKey() eq 'Hospital'}"><c:set var="category">Hospital</c:set></c:if>
    <form_v2:fieldset legend="" postLegend="" className="tieredHospitalCover ${category}BenefitsContainer">
        <div class="scrollable">
            <c:set var="overlayName">hospital</c:set>
            <c:if test="${category != 'Hospital'}"><c:set var="overlayName">extras</c:set></c:if>
            <div class="${colWidthValue} short-list-item ${item.getClassString()} ${item.getShortlistKey()}_container">
                    <%-- ======================= --%>
                    <%-- HEADING SECTION START --%>
                    <%-- ======================= --%>

                <c:if test="${category != 'Hospital'}">
                    <div class="title <c:if test="${category eq 'Hospital'}">hidden-xs</c:if>">
                        <h2 class="ignore">Extras</h2>
                        <p>${colContent}</p>
                        <health_v4_insuranceprefs:quick_select options="Dental:dental|Sports:sports|Peace of Mind:peace" />
                    </div>
                </c:if>
                <c:if test="${category eq 'Hospital'}">
                <div class="title">
                    <h2 class="ignore">Hospital</h2>
                    <p class="hospital-content-toggle">${colContent}</p>
                </div>
                <div id="tabs" class="benefitsTab">
                    <ul class="nav nav-tabs tab-count-2">
                        <li class="active"><a data-toggle="tab" href=".comprehensive-pane" data-benefit-cover-type="customise"><h2 class="ignore">Comprehensive</h2></a></li>
                        <li><a data-toggle="tab" href=".limited-pane" data-benefit-cover-type="limited"><h2 class="ignore">Limited Cover</h2></a></li>
                    </ul>
                    <div class="tab-content">
                        <div class="tab-pane comprehensive-pane active in">
                            <health_v4_insuranceprefs:quick_select options="Start a Family:family|Ageing Gracefully:ageing" />
                 </c:if>

                                <%-- ======================= --%>
                                <%-- HEADING SECTION END --%>
                                <%-- ======================= --%>
                            <div class="${category}-wrapper">

                                <c:choose>
                                    <c:when test="${item.getType() == 'section'}">
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="resultPath" value="${item.getResultPath()}" />
                                        <c:set var="benefitGroup">
                                            <c:choose>
                                                <c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
                                                <c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
                                            </c:choose>
                                        </c:set>
                                        <c:set var="analyticsLabelAttr"><field_v1:analytics_attr analVal="benefit ${benefitGroup}" quoteChar="\"" /></c:set>
                                        <c:set var="analyticsHelpAttr"><field_v1:analytics_attr analVal="qtip ${item.getShortlistKey()}" quoteChar="\"" /></c:set>
                                        <field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${item.getShortlistKey()}" value="Y" required="false" label="true"
                                                           title="${item.getName()}" helpId="${item.getHelpId()}" errorMsg="Please tick" additionalLabelAttributes="${analyticsLabelAttr}"
                                                           additionalHelpAttributes="${analyticsHelpAttr}" />
                                    </c:otherwise>
                                </c:choose>

                                    <%-- ======================= --%>
                                    <%-- ACTUAL BENEFITS SECTION START --%>
                                    <%-- ======================= --%>
                                <c:if test="${item.hasShortlistableChildren()}">
                                <div class="children healthBenefits">
                                    <div class="hasIcons">
                                        <c:forEach items="${item.getChildren()}" var="selectedValue">
                                            <c:if test="${selectedValue.isShortlistable()}">

                                                <%--<health_v3:benefitsItem item="${selectedValue}" />--%>
                                                <div class="categoriesCell ${colWidthValue} short-list-item ${selectedValue.getClassString()} ${selectedValue.getShortlistKey()}_container">
                                                    <c:set var="resultPath" value="${selectedValue.getResultPath()}" />
                                                    <c:set var="benefitGroup">
                                                        <c:choose>
                                                            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'hospital')}">hospital</c:when>
                                                            <c:when test="${not empty resultPath and fn:startsWith(resultPath,'extras')}">extras</c:when>
                                                        </c:choose>
                                                    </c:set>
                                                    <c:set var="analyticsLabelAttr"><field_v1:analytics_attr analVal="benefit ${benefitGroup}" quoteChar="\"" /></c:set>
                                                    <c:set var="analyticsHelpAttr"><field_v1:analytics_attr analVal="qtip ${selectedValue.getShortlistKey()}" quoteChar="\"" /></c:set>
                                                        <%-- This is a duplicate of the row above and needs to be cleaned up in the .less--%>
                                                    <c:set var="benefitLabel">
													<span class="benefitContent">
														<div class="benefitTitle">${selectedValue.getName()}</div>
														<span class="benefitSummary">${benefitsContentBlurbs.getSupplementaryValueByKey(selectedValue.getId())} <a href="javascript:;"
                                                                                                                                                                   class="help_icon floatLeft"
                                                                                                                                                                   data-content="helpid:${selectedValue.getHelpId()}"
                                                                                                                                                                   data-toggle="popover">more</a></span>
													</span>
                                                    </c:set>
                                                    <field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/benefits/benefitsExtras/${selectedValue.getShortlistKey()}" value="Y" required="false"
                                                                       label="true" title="${benefitLabel}" errorMsg="Please tick"
                                                                       customAttribute=" data-attach=true data-benefit-id='${selectedValue.getId()}' " additionalLabelAttributes="${analyticsLabelAttr}"
                                                                       additionalHelpAttributes="${analyticsHelpAttr}" />
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>

                                <c:if test="${category eq 'Hospital'}">
                            </div>
                        </div>
                        <div class="tab-pane limited-pane">
                                ${benefitsContent.getSupplementaryValueByKey('limitedText')}
                        </div>
                    </div>
                    </c:if>
                    </c:if>
                        <%-- ======================= --%>
                        <%-- ACTUAL BENEFITS SECTION END --%>
                        <%-- ======================= --%>
                </div>
            </div>
        </div>
    </form_v2:fieldset>

    <c:choose>
        <c:when test="${coverType == 'Hospital'}">
            <simples:dialogue id="45" className="simples-dialogue-hospital-cover" vertical="health" />
            <simples:dialogue id="50" className="simples-dialogue-extras-cover" vertical="health" />
        </c:when>
        <c:otherwise>
            <simples:dialogue id="51" className="simples-dialogue-extras-cover" vertical="health" />
        </c:otherwise>
    </c:choose>
</c:if>