<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:core />
<settings:setVertical verticalCode="HEALTH" />

<!doctype html>
<html>
    <head>
        <title>Test payment gateway</title>

        <script>
            window.addEventListener('message', receivePaymentInfo, false);

            function receivePaymentInfo(event) {
                console.log('Data received was: ', event.data);
            }
        </script>
    </head>
    <body>
        <iframe src="/${pageSettings.getContextFolder()}ajax/html/salesforce/health_payment_gateway.jsp?transactionId=2659686&provider=AHM" width="800" height="600"></iframe>
    </body>
</html>