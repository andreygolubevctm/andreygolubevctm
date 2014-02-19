<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- DIALOG --%>
<ui:dialog
		id="altpremium_moreinfo"
		title="${currentYear} Rate Rise Information"
		titleDisplay="true"
		contentBorder="true"
		width="650"
		>
		<p>Each year, most health funds review and adjust their rates to keep up with the rising cost of medical services. The increases are reviewed and approved by the Minister for Health and Ageing and come into effect on 1st April.</p>
		<p>Where accurate 2014 rates have been supplied to us by the health funds, we will present the true price for each policy.</p>
		<p>Where the fund has not yet supplied their 2014 rates to us, we will use their prices from 2013 and will apply the relevant funds average percentage increase from the Department of Health&#39;s Website (see link <a href='http://www.health.gov.au/internet/main/publishing.nsf/Content/privatehealth-average-premium-round' target='_blank'>here</a>). The end premium may vary slightly in this case as the increase applied is a health fund average and is not policy specific. Some policies may increase more than others to form the overall average increase.</p>
		<p>Additionally, changes have been proposed to the way the Government intends to calculate the rebate percentage for Private Health Insurance.</p>
		<p>From April 1 2014, each of the rebate tiers percentages will be proportionally reduced (by a factor as yet to be communicated). For example, in 2013 a customer may have been entitled to a 30% rebate and in 2014 this rebate may be 29.5%.</p>
		<p>The rebate will still apply to the whole premium paid by the customer.</p>
		<p>Currently, we are using the 2013 rebate percentages for calculating the 2014 rates. Once the reduction factor has been announced, we will endeavour to update this as quickly as possible to improve the accuracy of the 2014 prices. This may mean the end premium varies slightly.</p>
</ui:dialog>

<%-- CSS --%>
<go:style marker="css-head">
.altpremium_moreinfoDialogContainer .ui-dialog-titlebar {
	height:					22px !important;
}

#altpremium_moreinfoDialog p {
	margin: 				8px;
}
</go:style>