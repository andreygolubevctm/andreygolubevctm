<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what type of cover you're after eg Combined, Hospital or Extras"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="CSS class to be applied to the parent container" %>


<%-- VARIABLES --%>
<c:set var="fieldXpath" value="${xpath}/categorySelectHospital" />
<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="benefits categorySelectHospital" quoteChar="\"" /></c:set>

<div id="${name}-container" class="${className}">
	<h1 class="step-count">2.</h1>
	<h3>Need help on what to select?</h3>

	<form_v4:row hideRowBorder="true" label="You can select one of our options below to see whats typically chosen by people in each of the below categories." fieldXpath="${fieldXpath}" className="" renderLabelAboveContent="true">
		<field_v2:array_radio xpath="${fieldXpath}"
							  required="false"
							  className="row health-benefits-categorySelectHospital has-icons"
							  items="SPECIFIC_COVER=Specific cover,NEW_TO_HEALTH_INSURANCE=New to health insurance,GROWING_FAMILY=Growing family,ESTABLISHED_FAMILY=Established family,PEACE_OF_MIND=Peace of mind,COMPREHENSIVE_COVER=Comprehensive cover,REDUCE_TAX=Reduce tax"
							  id="${name}"
							  style="radio-rounded"
							  title="help on what to select"
							  additionalLabelAttributes="${analyticsAttr}"
							  wrapCopyInSpan="true" />
	</form_v4:row>

    <div class="categorySelect-copy-container">
        <div class="categorySelect-copy-innertube">
            <div class="categorySelect-copy">
                <h4><!-- empty --></h4>
                <p><!-- empty --></p>
            </div>
        </div>
        <div class="categorySelect-artwork"></div>
    </div>
</div>