<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<settings:setVertical verticalCode="HEALTH" />

<c:set var="provider"><c:out escapeXml="true" value="${param.provider}"/></c:set>
<c:set var="popup"><c:out escapeXml="true" value="${param.popup ? param.popup : false}"/></c:set>

<!doctype html>
<html>
    <head>
        <title>Test payment gateway</title>

        <script>
            window.addEventListener('message', receivePaymentInfo, false);

            function receivePaymentInfo(event) {
                console.log('Data received was: ', event.data);
            }

            <c:if test="${popup eq 'true'}">
                var popup = window.open(
                    '/${pageSettings.getContextFolder()}ajax/html/salesforce/health_payment_gateway.jsp?transactionId=2659686&provider=${provider}',
                    '_blank',
                    'width=800,height=600'
                );
            </c:if>
        </script>
    </head>
    <body>
        <c:if test="${popup ne 'true'}">
            <iframe src="/${pageSettings.getContextFolder()}ajax/html/salesforce/health_payment_gateway.jsp?transactionId=2659686&provider=${provider}" width="800" height="600"></iframe>
        </c:if>
    </body>
</html>