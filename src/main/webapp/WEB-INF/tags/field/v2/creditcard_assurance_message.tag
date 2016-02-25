<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showCreditCards" required="true" rtexprvalue="true"	%>
<form_v3:row_with_empty_column>
    <div class="payment_assurance_message col-sm-7 col-xs-1 fieldrow">
		<c:if test="${showCreditCards == true}">
			<div class="cards col-sm-3">
				<div class="amex"></div>
				<div class="visa"></div>
				<div class="mastercard"></div>
			</div>
		</c:if>
        <div class="col-sm-3 col-xs-1">
            <content:get key="sslCertificateBadge" />
        </div>
	</div>
</form_v3:row_with_empty_column>