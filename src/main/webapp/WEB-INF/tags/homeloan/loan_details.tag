<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Homeloan details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="purchasePrice" value="${data[purchasePrice]}" />
<c:if test="${purchasePrice != ''}">
	<c:set var="displayPurchasePrice"><c:out value="Y" escapeXml="true"/></c:set>
</c:if>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />



<%-- HTML --%>
<form_new:fieldset_columns sideAbove="true">
	<jsp:attribute name="rightColumn">
			<ui:bubble variant="info" className="yourLoanDetails-bubble">
				<h4>Your Loan Details</h4>
				<p>If you're unsure about the purchase price or the amount you would like to borrow, please enter an estimate. You'll then be able to chat to your broker who will help you confirm these details.</p>
			</ui:bubble>
	</jsp:attribute>
	<jsp:body>

		<form_new:fieldset legend="Your New Home Loan" >
			<div id="${name}_purchasePriceToggleArea" class="${name}_purchasePriceToggleArea show_${displayPurchasePrice}">
			<form_new:row label="What is the purchase price of the new property?">
				<field_new:currency xpath="${xpath}/purchasePrice" title="Purchase price" decimal="${false}" required="true" maxValue="1000000000" pattern="[0-9]*" />
			</form_new:row>
			</div>
			<form_new:row label="How much would you like to borrow?">
				<field_new:currency xpath="${xpath}/loanAmount" title="Amount to borrow" decimal="${false}" required="true" maxValue="1000000000" pattern="[0-9]*" />
			</form_new:row>
			<form_new:row label="Product type" className="product-type-container" helpId="532">
				<field_new:checkbox xpath="${xpath}/productVariable" value="Y" title="Variable" required="false" label="true"  />
				<field_new:checkbox xpath="${xpath}/productFixed" value="Y" title="Fixed" required="false" label="true"/>
			</form_new:row>
			<form_new:row label="Interest Rate Type" helpId="534">
				<field_new:array_radio id="${name}_interestRate" xpath="${xpath}/interestRate" required="true" items="P=Principal & Interest,I=Interest Only" title="${title} the interest rate type" />
			</form_new:row>

		</form_new:fieldset>

	</jsp:body>
</form_new:fieldset_columns>

<go:validate selector="${name}_loanAmountentry" rule="validateLoanAmount" parm="true" message="The amount you wish to borrow exceeds the value of the property. Please review the amounts before continuing." />