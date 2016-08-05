<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Radio buttons built from search request."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"			required="true"	 rtexprvalue="true"		description="variable's xpath" %>
<%@ attribute name="hannoverXpath"	required="false" rtexprvalue="true"		description="hannover xpath (for life/ip)" %>
<%@ attribute name="required"		required="false" rtexprvalue="true"		description="is this field required?" %>
<%@ attribute name="className"		required="false" rtexprvalue="true"		description="additional css class attribute" %>
<%@ attribute name="title"			required="false" rtexprvalue="true"		description="subject of the select box" %>
<%@ attribute name="type" 			required="false" rtexprvalue="true"		description="type code on general table" %>
<%@ attribute name="initialText"	required="false" rtexprvalue="true"		description="Text used to invite selection" %>
<%@ attribute name="tabIndex"		required="false" rtexprvalue="true"		description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>


	<input type="text" name="${name}Search" id="${name}Search" class="${name}_search" /><input type="button" value="Search" class="${name}_search-btn greenButton" />
	<c:set var="hannoverName" value="${go:nameFromXpath(hannoverXpath)}" />
	<input type="hidden" value="${hannoverDefault}" name="${hannoverName}" id="${hannoverName}" />

	<c:set var="occupationTitle" value="${name}Title" />
	<input type="hidden" value="${occupationTitleDefault}" name="${occupationTitle}" id="${occupationTitle}" />

	<div id="${name}_occupationPanel">
	</div>

	<go:style marker="css-href">
	<style>
		.${name}Group .help_icon {
			position:absolute;
			right:190px;
		}
		#${name}_occupationPanel li {
			margin-top:3px;
			clear:both;
		}
		#${name}_occupationPanel li label input,
		#${name}_occupationPanel li label span{
			float:left;
		}
		#${name}_occupationPanel li label span{
			width:375px;
			padding-top:3px;
		}
		.next-occupation,
		.prev-occupation,
		.page-occupation {
			color: #0c4da2;
			display: inline-block;
			width: 120px;
			padding: 8px 0;
			text-decoration: none;
		}
		.page-occupation {
			text-align: center;
			color:rgb(51, 51, 51);
		}
		.next-occupation {
			text-align: right;
		}
		body .greenButton {
		    color: #ffffff;
    		font-weight: 400;
    	}
		label input {
		    margin-right: 8px !important;
		}
	</style>
	</go:style>
	<go:script marker="onready">
	window.${name}SearchData = {
		lastSearch : false,
		searching : false,
		searchObj : null
	};
	$('#${name}Search').on('focus',function(){
		$(this).removeClass('error');
	});
	$('.${name}_search-btn').on('click', function() {
		var flushOccupationSearch = function() {
			${name}SearchData.searching = false;
			${name}SearchData.searchObj = null;
			$('#${name}Search').prop("disabled",false).removeClass("disabled");
			$('.${name}_search-btn').removeClass("disabled");
		};
		var searchText = $.trim($(this).siblings('.${name}_search').val());
		if(searchText == "") {
			// Empty searches return everything and make browser too sluggish
			$('#${name}Search').addClass('error');
		} else {
			if(${name}SearchData.lastSearch !== searchText) {
				${name}SearchData.lastSearch = searchText;
				if(${name}SearchData.searching === true) {
					try{
						${name}SearchData.searchObj.abort();
						flushOccupationSearch();
					} catch(e) {
						// ignore
					}
				}
				${name}SearchData.searching = true;
				$('#${name}Search').prop("disabled",true).addClass("disabled");
				$('.${name}_search-btn').addClass("disabled");
				${name}SearchData.searchObj = $.ajax({
					url: "./rest/life/occupation/search.json",
					data: {"search":searchText},
					dataType: "json",
					cache: false,
					success: function(json){
						if(json) {
							var output = ''
							var style = '';
							var len = json.length;
							var pageSize = 10;
							var pageCount = Math.ceil(len/pageSize);
							var currentPage = false;
							var pageStart = false;
							for (var i = 0; i < len; i++) {
								var item = json[i];
								var page = Math.floor(i/pageSize);
								var islastForPage = i % pageSize === pageSize - 1;

								if(currentPage !== page) {
									pageStart = true;
									currentPage = page;
								} else {
									pageStart = false;
								}

								if(pageStart) {
									output += '<div '+(currentPage > 0 ? 'style="display:none"' : '')+'class="page-'+(i/pageSize)+'"><ul>';
								}

								output +='<li><label><input type="radio" id="${name}_input_' + i + '" name="${name}" data-hannovercode="'+ item.talCode + '" value="'+ item.id + '" /><span>' + item.title + '</span><div class="clear"></div></label></li>';

								if(islastForPage) {
									output += '</ul>';
								}

								if(islastForPage) {
									output += '<a href="javascript:void(0);" class="prev-occupation" style="visibility:' + (currentPage > 0 ? 'visible' : 'hidden') + '">< prev</a>';
									output += '<span class="page-occupation" style="visibility:' + (pageCount > 0 ? 'visible' : 'hidden') + '">Page ' + (currentPage + 1) + ' of ' + pageCount + '</span>';
									output += '<a href="javascript:void(0);" class="next-occupation" style="visibility:' + (currentPage < pageCount - 1 ? 'visible' : 'hidden') + '">next ></a>';
								}

								if(islastForPage) {
									output += '</div>';
								}
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
							$('#${name}_occupationPanel input').on('click', function(e) {
								hannover = $(this).attr('data-hannovercode');
								title = $(this).siblings('span').text();
								$('#${hannoverName}').val(hannover);
								$('#${occupationTitle}').val(title);
							});
						}
						return false;
					},
					complete:flushOccupationSearch,
					error: flushOccupationSearch,
					timeout:30000
				});
			}
		}

	});
	</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}Search" rule="required" parm="${required}" message="Please search your ${title}"/>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>
