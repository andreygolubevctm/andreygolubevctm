<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Medicare details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 					required="true"		rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="placeholder" 			required="false"	rtexprvalue="true"	 description="Placeholder text" %>
<%@ attribute name="id" 					required="false"	rtexprvalue="true"	 description="id of the main container" %>
<%@ attribute name="source" 				required="false"	rtexprvalue="true"	 description="auto complete source" %>
<%@ attribute name="select" 				required="false"	rtexprvalue="true"	 description="auto complete source" %>
<%@ attribute name="title"					required="false"	rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="required"				required="false"	rtexprvalue="true"	 description="subject of the select box" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<c:choose>
	<c:when test="${empty placeholder}">
		<c:set var="placeholder" value="Postcode/Suburb"/>
	</c:when>
	<c:otherwise>
		<c:set var="placeholder"><c:out value="${placeholder}" escapeXml="true" /></c:set>
	</c:otherwise>
</c:choose>

<c:set var="id"><c:out value="${id}" escapeXml="true" /></c:set>

<c:if test="${empty source}" >
	<c:set var="source">
		function( request, response ) {
			var appendId = ${not empty id};
			var locationField = $('#${name}');

			// format is something like "Toowong Bc 4066 QLD"
			format = /^.*\s\d{4}\s(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)$/;

			// don't search if the value matches the format we aim for
			if( !format.test( locationField.val() ) ){

				$.ajax({
					url: "ajax/json/get_suburbs.jsp",
					jsonpCallback: 'get_suburbs_callback',
					dataType: "jsonp",
					jsonp: 'callback',
					type: "GET",
					data: {
							term: request.term
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
								if(appendId) {
									$('.ui-autocomplete').appendTo('#${id}_div');
								}

								if( data.length == 1 ) {
									locationField.val(item);
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
				locationField.autocomplete("close");
			}

		}
	</c:set>
</c:if>

<%-- HTML --%>
<field_v1:autocomplete xpath="${xpath}" title="${title}"
			required="${required}" source="${source}" select="${select}" min="2" className="short" placeholder="${placeholder}" />