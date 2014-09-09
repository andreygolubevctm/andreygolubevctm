<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"			required="true"	 rtexprvalue="true"		description="variable's xpath" %>
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

<c:if test="${empty type}">
	<c:set var="type" value="emptyset" />
</c:if>
<c:if test="${empty initialText}">
	<c:set var="initialText" value="Please choose&hellip;" />
</c:if>
<c:if test="${empty comboBox}">
	<c:set var="comboBox" value="false" />
</c:if>

<%-- HTML --%>
<sql:setDataSource dataSource="jdbc/aggregator"/>

<sql:query var="result">
	SELECT code, description FROM aggregator.general WHERE type = ?  AND (status IS NULL OR status != 0) ORDER BY orderSeq
	<sql:param>${type}</sql:param>
</sql:query>

<c:if test="${value == ''}">
	<c:set var="sel" value="selected" />
</c:if>

<c:if test="${disabled == 'true'}">
	<c:set var="disabled" value="selected" />
</c:if>

<c:if test="${comboBox}">
	<input type="text" value="${value}" name="${name}" id="${name}_input" <c:if test="${required}">required data-msg-required="Please enter the ${title}"</c:if> />
</c:if>
<select <c:if test="${!comboBox}">name="${name}"</c:if> id="${name}" class="form-control ${className}"<c:if test="${not empty tabIndex}"> tabindex="${tabIndex}"</c:if>>
	<%-- Write the initial "please choose" option --%>
	<option value="">${initialText}</option>

	<%-- Write the options for each row --%>
	<c:forEach var="row" items="${result.rows}">
		<c:choose>
			<c:when test="${row.code == value}">
				<option value="${row.code}" selected="selected">${row.description}</option>
			</c:when>
			<c:otherwise>
				<option value="${row.code}">${row.description}</option>
			</c:otherwise>
		</c:choose>
	</c:forEach>
</select>
		
<c:if test="${comboBox}">
	<go:style marker="css-href" href='common/js/select2/select2.css'></go:style>
	<go:script marker="js-href" href="common/js/select2/select2.min.js" />

	<go:script marker="onready">
		var ${name}SelectData = [];
		var ${name}SelectPageSize = 100;

		$('#${name} option').each(function(){ 
			var $this = $(this);

			${name}SelectData.push({
				id: $this.val(),
				text: $this.text()
			}); 
		});

		$('#${name}_input').select2({
			initSelection: function(element, callback) {
				var selection = _.find(${name}SelectData, function(metric){
					return metric.id === element.val();
				});

				<%-- Remove the original select because we ain't gonna use it no more. --%>
				$('#${name}').remove();

				callback(selection);
			},
			query: function(options){
				var startIndex  = (options.page - 1) * ${name}SelectPageSize;
				var filteredData = ${name}SelectData;

				if(options.term && options.term.length > 0){
					if(!options.context){
						var term = options.term.toLowerCase();
							options.context = ${name}SelectData.filter(function(metric){
							return (metric.text.toLowerCase().indexOf(term) !== -1);
						});
					}

					filteredData = options.context;
				}

				options.callback({
					context: filteredData,
					results: filteredData.slice(startIndex, startIndex + ${name}SelectPageSize),
					more: (startIndex + ${name}SelectPageSize) < filteredData.length
				});
			},
			dropdownAutoWidth: false,
			matcher: function(term, text, opt) {
				<%-- 
					We call to uppercase to do a case insensitive match
					We replace every group of whitespace characters with a .+
					matching any number of characters
				--%>
				return text.toUpperCase().match(term.toUpperCase().replace(/\s+/g, '.+'));
			}
		}).on('select2-close', function(e) {
			$("#mainform").validate().element('#${name}_input');
		});
	</go:script>
</c:if>

<%-- VALIDATION --%>
<c:set var="validationSelector">
	<c:choose>
		<c:when test="${comboBox}">${name}_input</c:when>
		<c:otherwise>${name}</c:otherwise>
	</c:choose>
</c:set>
<go:validate selector="${validationSelector}" rule="required" parm="${required}" message="Please enter the ${title}"/>
