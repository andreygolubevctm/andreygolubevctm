<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="How customer heard about us"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="phoneService" class="com.ctm.services.PhoneService" scope="application" />
<jsp:useBean id="quoteService" class="com.ctm.services.QuoteService" scope="application" />

<%@ attribute name="vertical"	required="true"	 	rtexprvalue="true" 	description="Vertical to associate this tracking with e.g. health" %>
<%@ attribute name="required" 	required="false"	rtexprvalue="true"	description="Is this field required?" %>
<%@ attribute name="className" 	required="false"	rtexprvalue="true"	description="Additional css class" %>
<%@ attribute name="title" 		required="false"	rtexprvalue="true"	description="Title for the form element" %>

<c:set var="xpath" value="${vertical}/tracking" />

<%--
	Callcentre-only section
--%>
<c:if test="${callCentre}">
	<c:if test="${empty required}"><c:set var="required" value="${false}" /></c:if>
	<c:if test="${empty title}"><c:set var="title" value="How did you hear about us?" /></c:if>

	<%-- If operator has an extension, get their phone call details. --%>
	<%-- NOTE: This is not ideal, as the phone details should be available from session and not specially pinged at this point. --%>
	<c:if test="${not empty authenticatedData['login/user/extension']}">
		<c:catch>
			<c:set var="phoneVdn" value="${phoneService.getVdnByExtension(pageSettings, authenticatedData['login/user/extension'])}" />
			<c:if test="${not empty phoneVdn}">
				<c:set var="xpathVDN" value="${xpath}/VDN" />
				<c:set var="ignore">${quoteService.writeSingle(data.current.transactionId, xpathVDN, phoneVdn)}</c:set>
			</c:if>
		</c:catch>
	</c:if>

	<%-- Form stuff --%>
	<c:set var="id" value="${go:nameFromXpath(xpath)}" />
	<c:set var="items" value="=None||TV Advert=TV Advert||TV Infomercial=TV Infomercial||Radio=Radio||Google=Google||Facebook=Facebook||Online Banner=Online Banner||Email=Email||Yellow Pages Books=Yellow Pages Books||Yellow Pages Online=Yellow Pages Online||Letter Box Drop=Letter Box Drop||Outdoor Poster=Outdoor Poster||Referral=Referral||Office Tower Digital Screens=Office Tower Digital Screens||Other=Other" />

	<div class="simples-dialogue ${id}">
		<form:row label="" id="${id}_divsource">
			<strong style="margin-right:5px"><c:out value="${title}" /></strong>
			<field:array_select items="${items}" required="${required}" title="${title}" xpath="${xpath}/source" className="${className}" delims="||" />
		</form:row>

		<div id="${id}_location" style="display:none; padding:0.5em 0 0">
			<form:row label="" id="${id}_divpostcodesuburb">
				<span style="margin-right:5px">Customer's postcode &amp; suburb:</span>
				<field:post_code xpath="${xpath}/postcode" required="false" title="customer's postcode" />
				<select name="${id}_suburb" id="${id}_suburb" title="customer's suburb">
					<option value="">&#8592; Enter the postcode</option>
				</select>
			</form:row>
		</div>

		<div id="${id}_moreinfowrapper">
			<form:row label="" id="${id}_divmoreinfo">
				<span>More information:</span>
				<field:input xpath="${xpath}/moreinfo" required="true" title="more information" />
			</form:row>
		</div>
	</div>

	<%-- JAVASCRIPT --%>
	<go:script marker="onready">
		$('#${id}_source').on('change', function() {
			var val = $(this).val();
			<%-- Show extra input fields when selecting Yellow Pages --%>
			if (val.length > 0 && val.indexOf('Yellow Pages') >= 0) {
				$('#${id}_moreinfowrapper').slideUp(200, function() {
					$('#${id}_moreinfo').val('');
					$('#${id}_location').slideDown(200);
				});
			} else if(val.length > 0 && val == 'Other') {

				$('#${id}_location').slideUp(200, function(){
					$('#${id}_moreinfowrapper').slideDown(200);
				});
			} else {
				$('#${id}_moreinfo').val('');
				$('#${id}_location, #${id}_moreinfowrapper').slideUp(200);
			}
		});
		$('#${id}_source').trigger('change');

		<%-- Fetch suburb list when changing postcode --%>
		$("#${id}_postcode").on('keyup', function() {
			if (/[0-9]{4}/.test($(this).val())) {
				$.getJSON("ajax/json/address/get_suburbs.jsp",
						{postCode:$("#${id}_postcode").val()},
						function(resp) {
							if (resp.suburbs && resp.suburbs.length > 0) {
								var options = '<option value="">Please select...</option>';
								for (var i = 0; i < resp.suburbs.length; i++) {
									<c:set var="suburbPath" value="${xpath}/suburb" />
									if (resp.suburbs[i].des == "<c:out value="${data[suburbPath]}" />") {
										options += '<option value="' + resp.suburbs[i].des + '" selected="">' + resp.suburbs[i].des + '</option>';
									} else {
									options += '<option value="' + resp.suburbs[i].des + '">' + resp.suburbs[i].des + '</option>';
									}
								}
								$("#${id}_suburb").html(options).removeAttr("disabled");
							} else {
								$("#${id}_suburb").html("<option value=''>Invalid Postcode</option>").attr("disabled", "disabled");
							}
						});
			}
		});
		$("#${id}_postcode").trigger('keyup');
	</go:script>
</c:if>
