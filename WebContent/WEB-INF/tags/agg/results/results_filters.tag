<%@ tag description="The Comparison Popup"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-href" href="brand/ctm/dynamic/results_filter_css.jsp" />
<go:style marker="css-href" href="brand/ctm/dynamic/results_filter_ie8_css.jsp" conditional="lte IE 8"/>

<%-- HTML --%>
<ui:horizontal-bar-element className="ResultsFilters">
	<div class="filterColOne">
		<span class="quickFilterTitle" >Quick Filters</span>
		<span class="filter-arrow"></span>
			<core:clear />
	</div>

	<div class="filterColThree mHide">
			<div class="selectBoxCont">
				<div class="selectTxt">Payment:</div>
				<field:payment_type xpath="quote/paymentType" title="Payment Type" className="selectBox update-payment" />
				<div class="selectTxt">Excess*:</div>
				<field:additional_excess increment="100" minVal="500" xpath="quote/excess"
								maxCount="6" title="optional additional excess" required="true"
								omitPleaseChoose="Y"
								className="selectBox update-excess" />
				<input type="hidden" name="quote_baseExcess" id="quote_baseExcess">
				<div class="updateDisc">*Updated quotes will use the individual provider's closest available excess</div>
			</div>
	</div>
</ui:horizontal-bar-element>