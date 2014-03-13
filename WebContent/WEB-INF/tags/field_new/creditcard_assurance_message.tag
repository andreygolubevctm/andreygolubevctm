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
	
	<table class="external" width="135" border="0" cellpadding="2" cellspacing="0" title="Click to Verify - This site chose Symantec SSL for secure e-commerce and confidential communications.">
		<tr>
		<td width="135" align="center" valign="top"><script type="text/javascript" src="https://seal.verisign.com/getseal?host_name=secure.comparethemarket.com.au&amp;size=XS&amp;use_flash=NO&amp;use_transparent=NO&amp;lang=en"></script><br />
			<a href="http://www.symantec.com/verisign/ssl-certificates" target="_blank"  style="color:#000000; text-decoration:none; font:bold 7px verdana,sans-serif; letter-spacing:.5px; text-align:center; margin:0px; padding:0px;">ABOUT SSL CERTIFICATES</a></td>
		</tr>
	</table>
	
	<div class="message">
		<h5>Secure transaction</h5>
		<small>This is a secure 128-bit encrypted transaction</small>
	</div>
</div>