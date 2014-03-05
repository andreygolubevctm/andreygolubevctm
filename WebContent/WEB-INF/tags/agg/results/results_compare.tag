<%@ tag description="The Comparison Bar"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- CSS --%>
<go:style marker="css-href" href="brand/ctm/dynamic/compare-bar-css.jsp" />
<go:style marker="css-href" href="brand/ctm/dynamic/compare-bar-ie8-css.jsp" conditional="lte IE 8"/>

<ui:horizontal-bar-element className="compareBar" id="results_compare">
	<span class="darkGreen">Choose products below,<br />then select <em><strong>compare</strong></em></span>
	<div class="vrGreenBar"></div>
	<div class="selectedProdTxt"></div>
		<ul>
			<li id="selectedTn1" class="noneSelected compareBox"><span id="compareBoxLogo1" class="compareBoxLogo" ></span><div class="closeIcon" id="closeIcon1"></div><span id="noneSelectedText1" class="noneSelectedText" >NONE</span></li>
			<li id="selectedTn2" class="noneSelected compareBox"><span id="compareBoxLogo2" class="compareBoxLogo" ></span><div class="closeIcon" id="closeIcon2"></div><span id="noneSelectedText2" class="noneSelectedText" >NONE</span></li>
			<li id="selectedTn3" class="noneSelected compareBox"><span id="compareBoxLogo3" class="compareBoxLogo" ></span><div class="closeIcon" id="closeIcon3"></div><span id="noneSelectedText3" class="noneSelectedText" >NONE</span></li>
		</ul>
		<a href="javascript:void(0)" id="compareBtn"><div class="compareBtn compareInActive compare-selected">Compare</div></a>
		<div class="vrGreenBar"></div>
		<div class="savemsg">You can save $<span id="save_val">$$</span>!</div>

</ui:horizontal-bar-element>

<core:clear/>