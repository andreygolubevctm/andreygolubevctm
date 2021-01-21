<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what type of cover you're after eg Combined, Hospital or Extras"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="fieldXpath" value="${xpath}/categorySelectExtras" />
<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
<c:set var="analyticsAttr"><field_v1:analytics_attr analVal="benefits categorySelectExtras" quoteChar="\"" /></c:set>

<div id="${name}-container">
	<h1 class="step-count">2.</h1>
	<h3>Need help on what to select?</h3>

	<form_v4:row hideRowBorder="true" label="You can select one of our options below to see what's typically chosen by people in each of the below categories." fieldXpath="${fieldXpath}" className="" renderLabelAboveContent="true">
		<field_v2:array_radio xpath="${fieldXpath}"
							  required="false"
							  className="health-benefits-categorySelectExtras has-icons"
							  items="SPECIFIC_COVER=Specific Cover,POPULAR=Most Popular,A_LITTLE_BIT_MORE=A few more,COMPLETE_COVER=Complete cover"
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
                <p><!-- empty -->.</p>
            </div>
        </div>
        <div class="categorySelect-artwork"></div>
    </div>
</div>