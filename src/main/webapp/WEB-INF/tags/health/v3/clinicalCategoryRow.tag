<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		    required="true"     rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="code" 		    required="true"     rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="groups" 		required="false"    rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="title" 		    required="true"     rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="caption" 		required="true"     rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="description" 	required="false"    rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="id" 		    required="true"     rtexprvalue="true"	 description="field group's xpath" %>

<c:set var="xpathval"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="checked" value="" />
<c:set var="activeClass" value="" />
<c:if test="${xpathval=='Y'}">
    <c:set var="checked" value=" checked='checked'" />
    <c:set var="activeClass" value=" active" />
</c:if>

<div class="categoriesCell_v2 short-list-item category collapsed ClinicalCategoryIcon-${code} ${code}_container ${activeClass}" data-groups="${groups}" data-sortable-key="${title}">
    <div class=" checkbox">
        <input type="checkbox" name="health_benefits_benefitsExtras_${code}" id="health_benefits_benefitsExtras_${code}" class="checkbox-custom  checkbox" value="Y" data-attach="true" data-benefit-id="${id}" data-benefit-code="${code}" ${checked}>

        <label for="health_benefits_benefitsExtras_${code}" data-analytics="benefit hospital">
            <div class="benefit-label-container">
                <div class="benefit-group-row">
                    <div class="benefit-image">
                        <span class="benefit-icon">
                            <label></label>
                        </span>
                    </div>
                    <div class="benefit-title hidden-xs">${title}</div>
                    <div class="benefit-copy">
                        <div class="copy-innertube">
                            <div class="benefit-title visible-xs">${title}</div>
                            <div class="benefit-caption">${caption}</div>
                            <div class="benefit-description collapse">${description}</div>
                        </div>
                    </div>
                    <div class="benefit-toggle">
                        <a href="javascript:;" class="">
                            <span class="health-icon icon-health-chevron"></span>
                        </a>
                    </div>
                </div>
            </div>
        </label>
    </div>
    <div class="benefit-categories"></div>
</div>