<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Radio buttons built from search request."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"			required="true"	 rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="required"		required="false" rtexprvalue="true"		description="is this field required?" %>
<%@ attribute name="className"		required="false" rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title"			required="false" rtexprvalue="true"		description="subject of the select box" %>
<%@ attribute name="type" 			required="false" rtexprvalue="true"		description="type code on general table" %>
<%@ attribute name="initialText"	required="false" rtexprvalue="true"		description="Text used to invite selection" %>
<%@ attribute name="tabIndex"		required="false" rtexprvalue="true"		description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


	<input type="text" name="${name}_search-occupation" id="${name}_search-occupation" class="${name}_search" /><input type="button" value="Search" class="${name}_search-btn standardButton greenButton" />
	<div id="${name}_occupationPanel">
	</div>

	<go:style marker="css-href">
	<style>
		.next-occupation,
		.prev-occupation,
		.page-occupation {
			color: #0c4da2;
			display: inline-block;
			width: 33%;
			padding: 8px 0;
		}
		.page-occupation {
			text-align: center;
		}
		.next-occupation {
			text-align: right;
		}
		label input {
		    margin-right: 8px !important;
		}
	</style>
	</go:style>
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
							output += '<span class="page-occupation">Page ' + i/10 + ' of ' + Math.ceil(json.length/10) + '</span>';
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
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>
