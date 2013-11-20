<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 			required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="id" 			required="true"	 rtexprvalue="true"	 description="id of the main container" %>
<%@ attribute name="placeholder" 	required="true"	 rtexprvalue="true"	 description="Placeholder text" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:if test="${empty placeholder }">
	<c:set var="placeholder" value="Postcode/Suburb"/>
</c:if>

<c:set var="autocompleteSource">
	function( request, response ) {

		// format is something like "Toowong Bc 4066 QLD"
		format = /^.*\s\d{4}\s(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)$/;

		// don't search if the value matches the format we aim for
		if( !format.test( $('#${name}_location').val() ) ){

			$.ajax({
				url: "ajax/json/get_suburbs.jsp",
				jsonpCallback: 'get_suburbs_callback',
				dataType: "jsonp",
				jsonp: 'callback',
				type: "GET",
				data: {
						term: request.term,
						fields: 'postcode, suburb, state'
				},
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function( data ) {
					response( $.map( data, function( item ) {
						if( item.length != undefined ){
							$('.ui-autocomplete').appendTo('#${id}_div');

							if( data.length == 1 ) {
								$('#${name}_location').val(item);
							}

							return {
								label: item,
								value: item
							}
						} else {
							return data;
						}
					}));
				}
			});

		} else {
			$('#${name}_location').autocomplete("close");
		}

	}
</c:set>

<%-- HTML --%>
<field:autocomplete xpath="location" title="Postcode/Suburb" required="true" source="${autocompleteSource}" min="2" width="200" placeholder="${placeholder}"/>

<go:style marker="css-head">
ul.ui-autocomplete.ui-menu  {
	max-height:200px;
	overflow:hidden;
}
</go:style>