<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showCreditCards" required="true" rtexprvalue="true"	%>

<div class="payment_assurance_message col-lg-4 col-sm-2 col-xs-1 fieldrow">
	<c:if test="${showCreditCards == true}">
		<div class="cards">
			<div class="amex"></div>
			<div class="visa"></div>
			<div class="mastercard"></div>
		</div>
	</c:if>
	
	<img src="brand/${data.settings.styleCode}/images/logo_verisign.png" alt="VeriSign secured" class="verisign" />
	
	<div class="message">
		<h5>Secure transaction</h5>
		<small>This is a secure 128-bit encrypted transaction</small>
	</div>
</div>