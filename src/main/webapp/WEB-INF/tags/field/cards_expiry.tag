<%@ tag language="java" pageEncoding="UTF-8" %>
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
<%@ attribute name="maxYears" 		required="false"	rtexprvalue="true"	description="The number of years to display"%>

<%-- VARIABLES --%>
<c:set var="cardExpiryMonth" value="${go:nameFromXpath(xpath)}_cardExpiryMonth" />
<c:set var="cardExpiryYear" value="${go:nameFromXpath(xpath)}_cardExpiryYear" />

<c:if test="${empty rule}">
	<c:set var="rule" value="ccExp" />
</c:if>
<c:if test="${empty maxYears}">
	<c:set var="maxYears" value="7" />
</c:if>

<jsp:useBean id="currentYear" class="java.util.GregorianCalendar" scope="page" />
<c:set var="year_list">
	<c:forEach var="i" begin="1" end="${maxYears}" varStatus="theCount">
		<fmt:formatDate value="${currentYear.time}" pattern="yy" var="basicYear" />
		<fmt:formatDate value="${currentYear.time}" pattern="yyyy" var="fullYear" />
		<c:out value="${basicYear}=${fullYear}"/>
		<c:if test="${theCount.count < maxYears}">
			<c:out value=","/>
		</c:if>
		<% currentYear.add(java.util.GregorianCalendar.YEAR, 1); %>
	</c:forEach>
</c:set>

<%-- HTML --%>
<div class="row">
	<div class="col-xs-6 col-md-5">
		<field_new:import_select xpath="${xpath}/cardExpiryMonth" url="/WEB-INF/option_data/month.html"	title="expiry month" required="true" omitPleaseChoose="Y" className="${className}"/>
	</div>
	<div class="col-xs-6 col-md-5">
		<field_new:array_select
			items="=,${year_list}"
			xpath="${xpath}/cardExpiryYear"
			title="expiry year"
			className="${className}"
			required="true" />
	</div>
</div>

					
<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	
	$.validator.addMethod("${rule}",
		function(value, elem, parm) {
			if ($('#${cardExpiryYear}').val() != '' && $('#${cardExpiryMonth}').val() != '') {

				var now_ym = parseInt(get_now_year() + '' + get_now_month());
				var sel_ym = parseInt('20' + $('#${cardExpiryYear}').val() + '' + $('#${cardExpiryMonth}').val());
			
				if (sel_ym >= now_ym) {
					return true;
					<%--
					Using this makes sense but breaks
					var valid = $('#${cardExpiryMonth}').valid();
					if (valid) {
						$(elem).validate().ctm_unhighlight($('#${cardExpiryYear}').get(0), this.settings.errorClass, this.settings.validClass);
					}
					console.log('${rule} valid:', valid);
					return valid;
					--%>
				}
			}
			return false;
		}, ""
	);

	$("#${cardExpiryMonth}").on('change', function(){
		var $year = $('#${cardExpiryYear}');
		if ($year.hasClass('has-error') || $year.hasClass('has-success')) {
			$('#${cardExpiryYear}').valid();
		}
	});
</go:script>

<go:script marker="js-head">
	function get_now_month() {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>, <fmt:formatDate value="${now}" type="DATE" pattern="M"/>-1, <fmt:formatDate value="${now}" type="DATE" pattern="d"/>);
		var MyDateString = MyDate.getMonth()+1;
		MyDateString = MyDateString < 10 ? "0"+MyDateString : MyDateString;
		return MyDateString;
	}
	function get_now_year() {
		var MyDate = new Date(<fmt:formatDate value="${now}" type="DATE" pattern="yyyy"/>, <fmt:formatDate value="${now}" type="DATE" pattern="M"/>-1, <fmt:formatDate value="${now}" type="DATE" pattern="d"/>);
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
