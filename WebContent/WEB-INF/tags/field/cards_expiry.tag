<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 	required="true"		rtexprvalue="true"	description="is this field required?" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	description="The subject of the field (e.g. 'regular driver')"%>
<%@ attribute name="rule" 		required="false"	rtexprvalue="true"	description="Create a new rule name in case of conflict"%>

<%-- VARIABLES --%>
<c:set var="cardExpiryMonth" value="${go:nameFromXpath(xpath)}_cardExpiryMonth" />
<c:set var="cardExpiryYear" value="${go:nameFromXpath(xpath)}_cardExpiryYear" />

<c:if test="${empty rule}">
	<c:set var="rule" value="ccExp" />
</c:if>

<%-- HTML --%>

<field:import_select xpath="${xpath}/cardExpiryMonth" url="/WEB-INF/option_data/month.html"	title=" expiry month" required="true" omitPleaseChoose="Y" className="${className}"/>
					
<field:import_select xpath="${xpath}/cardExpiryYear" url="/WEB-INF/option_data/creditcard_year.html" title=" expiry year " required="true" omitPleaseChoose="Y" className="${className}"/>


<go:script marker="js-href" href="common/js/utils.js" />

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	
	$.validator.addMethod("${rule}",
		function(value, elem, parm) {
		
			if($('#${cardExpiryYear}').val() != '' && $('#${cardExpiryMonth}').val() != ''){
			
				var now_ym = parseInt(get_now_year() + '' + get_now_month());
				var sel_ym = parseInt('20' + $('#${cardExpiryYear}').val() + '' + $('#${cardExpiryMonth}').val());
			
				if(sel_ym >= now_ym){
					$('#${cardExpiryMonth}').removeClass("error");
					$('#${cardExpiryYear}').removeClass("error");
					$(".${className}").closest(".fieldrow").removeClass("errorGroup");
				}else{
					$('#${cardExpiryMonth}').addClass("error");
					$('#${cardExpiryYear}').addClass("error");
					$(".${className}").closest(".fieldrow").addClass("errorGroup");
					return false;
				}
				
			}
			
			return true;
			
		}, ""
	);

	$("#${cardExpiryMonth}").on("change", function(){
		if($("#${cardExpiryMonth}").closest(".fieldrow").hasClass("errorGroup")){
			$('#${cardExpiryYear}').valid();
		}
	});
</go:script>

<go:script marker="js-head">
	function get_now_month() {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="MM"/>-1,
								<fmt:formatDate value="${now}" type="DATE" pattern="dd"/>);
		var MyDateString;
		MyDateString = twoDigits(MyDate.getMonth()+1);
		return MyDateString;
	}
	function get_now_year() {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>,
								<fmt:formatDate value="${now}" type="DATE" pattern="MM"/>-1,
								<fmt:formatDate value="${now}" type="DATE" pattern="dd"/>);
		var MyDateString;
		MyDateString = MyDate.getFullYear();
		return MyDateString;
	}
</go:script>

<c:if test="${rule == 'ccExp'}">
	<go:validate selector="${cardExpiryYear}" rule="${rule}" parm="true" message="Please choose a valid credit card expiry date" />
</c:if>
<c:if test="${rule == 'mcExp'}">
	<go:validate selector="${cardExpiryYear}" rule="${rule}" parm="true" message="Please choose a valid Medicare card expiry date" />
</c:if>
