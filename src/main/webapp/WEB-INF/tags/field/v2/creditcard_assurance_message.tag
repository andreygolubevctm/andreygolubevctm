<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Credit Card details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="showCreditCards" required="true" rtexprvalue="true"	%>

<div class="form-group row fieldrow ">
    <div class="payment_assurance_message col-sm-12 col-xs-1">
        <div class="cards col-sm-4">
            <c:if test="${showCreditCards == true}">
                <div class="amex"></div>
                <div class="visa"></div>
                <div class="mastercard"></div>
            </c:if>
        </div>
        <div class="col-sm-6 col-xs-1">
            <content:get key="sslCertificateBadge" />
        </div>
    </div>
</div>
