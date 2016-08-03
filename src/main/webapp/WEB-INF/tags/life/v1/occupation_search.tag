<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"			required="true"	 rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="hannoverXpath"	required="false" rtexprvalue="true"		description="hannover xpath (for life/ip)" %>
<%@ attribute name="required"		required="false" rtexprvalue="true"		description="is this field required?" %>
<%@ attribute name="className"		required="false" rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title"			required="false" rtexprvalue="true"		description="subject of the select box" %>
<%@ attribute name="type" 			required="false" rtexprvalue="true"		description="type code on general table" %>
<%@ attribute name="initialText"	required="false" rtexprvalue="true"		description="Text used to invite selection" %>
<%@ attribute name="comboBox"		required="false" rtexprvalue="true"		description="If the select should be a combobox or not" %>
<%@ attribute name="tabIndex"		required="false" rtexprvalue="true"		description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


	<input type="text" name="${name}_search-occupation" id="${name}_search-occupation" class="${name}_search" /><input type="button" value="Search" class="${name}_search-btn" />
	<div id="${name}_occupationPanel">
	</div>

	<go:script marker="js-href" href="common/js/pagination.min.js" />
	<go:script marker="onready">

	$('.${name}_search-btn').on('click', function() {
		var searchText = $(this).siblings('.${name}_search').val();
		$.ajax({
			url: "./rest/life/occupation/search.json",
			data: {"search":searchText},
			dataType: "json",
			cache: false,
			success: function(json){
				if(json) {
				    var output = ''
				    var style = '';
			        for (var i = 0, len = json.length; i < len; i++) {
   			            if(i % 10 === 0 && i > 0) {
   			            	style = 'style="display:none" ';
							output += '</ul>';
			            }

   			            if(i % 10 === 0 && i > 0) {
			               output += '<a href="javascript:void(0);" class="prev-occupation">< prev</a>';

			            }

	   			        if(i % 10 === 0 && i > 0) {
							output += '<span>Page ' + i/10 + ' of ' + Math.ceil(json.length/10) + '</span>';
				        }

	   			        if(i % 10 === 0 && i > 0 && i < json.length) {
							output += '<a href="javascript:void(0);" class="next-occupation">next ></a>';
				        }

   			            if(i % 10 === 0 && i > 0) {
							output += '</div>';
			            }

			            if(i % 10 === 0) {
			               output += '<div '+style+'class="page-'+(i/10)+'"><ul>';
			            }
                        
			            output +='<li><label><input type="radio" name="${name}" value="'+ json[i].id + '" />' + json[i].title + '</label></li>';
			        }
			        $('#${name}_occupationPanel').html(output);

					$('#${name}_occupationPanel .prev-occupation').on('click', function(e) {
						e.preventDefault();
						$(this).parent().hide().prev().show();
					});
					$('#${name}_occupationPanel .next-occupation').on('click', function(e) {
						e.preventDefault();
						$(this).parent().hide().next().show();
					});
				}

				return false;
			},
			error: function(obj,txt){
			},
			timeout:30000
		});

	});
	</go:script>

<%-- VALIDATION --%>
<c:set var="validationSelector">
	<c:choose>
		<c:when test="${comboBox}">${name}_input</c:when>
		<c:otherwise>${name}</c:otherwise>
	</c:choose>
</c:set>
<go:validate selector="${validationSelector}" rule="required" parm="${required}" message="Please enter the ${title}"/>
