<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="How customer heard about us"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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

	<c:set var="id" value="${go:nameFromXpath(xpath)}" />
	<c:set var="items" value="=None||TV Advert=TV Advert||TV Infomercial=TV Infomercial||Radio=Radio||Google=Google||Facebook=Facebook||Online Banner=Online Banner||Email=Email||Yellow Pages Books=Yellow Pages Books||Yellow Pages Online=Yellow Pages Online||Letter Box Drop=Letter Box Drop||Outdoor Poster=Outdoor Poster||Referral=Referral||Other=Other" />

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

			<field:hidden xpath="${xpath}/TelephoneNumber" defaultValue="" />
			<field:hidden xpath="${xpath}/VDN" defaultValue="" />
		</div>
	</div>

	<go:style marker="css-head">
		.${id} .fieldrow_label {
			display: none;
		}
	</go:style>

	<%-- JAVASCRIPT --%>
	<go:script marker="onready">
		$('#${id}_source').on('change', function() {
			var val = $(this).val();
			<%-- Show extra input fields when selecting Yellow Pages --%>
			if (val.length > 0 && val.indexOf('Yellow Pages') >= 0) {
				$('#${id}_location').slideDown(200);

				switch(val) {
					case 'Yellow Pages Books':
						$('#${id}_TelephoneNumber').val('1800 427 702');
						$('#${id}_VDN').val('7404');
						break;
					case 'Yellow Pages Online':
						$('#${id}_TelephoneNumber').val('1800 427 641');
						$('#${id}_VDN').val('7403');
						break;
				}
			}
			else {
				$('#${id}_TelephoneNumber').val('');
				$('#${id}_VDN').val('');
				$('#${id}_location').slideUp(200);
			}
		});
		$('#${id}_source').trigger('change');

		<%-- Fetch suburb list when changing postcode --%>
		$("#${id}_postcode").on('input', function() {
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
		$("#${id}_postcode").trigger('input');
	</go:script>
</c:if>
