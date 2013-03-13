<%@ tag description="Avea Footer Links"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
 


<%-- HTML --%>
<div class="avea_foot_links">
	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<a href="javascript:showDoc('http://www.avea.com.au/Autobarn/Autobarn_Terms_And_Conditions.pdf');">AutObarn Terms and Conditions</a>
		<a href="javascript:showDoc('http://www.avea.com.au/Autobarn/Autobarn_Privacy_Policy.pdf');">AutObarn Privacy Policy</a>
		<a href="javascript:showDoc('http://www.avea.com.au/PDS/MOT_Unbranded.pdf');">AutObarn PDS</a>
	</c:if>
	
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<a href="javascript:;" class="avea_cst">Carsure Terms and Conditions</a>
		<a href="javascript:;" class="avea_cpp">Carsure Privacy Policy</a>
		<a href="javascript:showDoc('http://www.avea.com.au/PDS/MOT_Unbranded.pdf');">Carsure PDS</a>
	</c:if>
	<core:clear/>
</div>


<%-- CSS --%>
<go:style marker="css-head">
	.avea_foot_links{
		text-align:center;
		margin-bottom:20px;
	}
	.avea_foot_links a{
		margin-right:10px;
		color:#aaa;
	}
</go:style>

