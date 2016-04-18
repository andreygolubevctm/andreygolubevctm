<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath"       required="true"     rtexprvalue="true"       description="variable's xpath" %>
<%@ attribute name="list"        required="true"     rtexprvalue="true"       description="the list of occupation" type="java.util.List" %>
<%@ attribute name="required"     required="false" rtexprvalue="true"       description="is this field required?" %>
<%@ attribute name="className"    required="false" rtexprvalue="true"       description="additional css class attribute" %>
<%@ attribute name="title"       required="false" rtexprvalue="true"       description="subject of the select box" %>
<%@ attribute name="comboBox"     required="false" rtexprvalue="true"       description="If the select should be a combobox or not" %>
<%@ attribute name="tabIndex"     required="false" rtexprvalue="true"       description="additional tab index specification" %>

<%-- VARIABLES --%>
<c:set var="occupationxpath" value="${xpath}/occupation" />
<c:set var="name" value="${go:nameFromXpath(occupationxpath)}" />
<c:set var="value"><c:out value="${data[occupationxpath]}" escapeXml="true"/></c:set>

<c:if test="${empty comboBox}">
   <c:set var="comboBox" value="false" />
</c:if>

<c:if test="${value == ''}">
   <c:set var="sel" value="selected" />
</c:if>

<c:if test="${comboBox}">
   <input type="text" value="${value}" name="${name}" id="${name}_input" <c:if test="${required}">required data-msg-required="Please enter the ${title}"</c:if> />
</c:if>
${list}
<c:set var="hannoverDefault" value="" />
<select <c:if test="${!comboBox}">name="${name}"</c:if> id="${name}" class="form-control ${className}"<c:if test="${not empty tabIndex}"> tabindex="${tabIndex}"</c:if>>
   <%-- Write the initial "please choose" option --%>
   <option value="">Please choose&hellip;</option>

   <%-- Write the options for each row --%>
   <c:forEach var="row" items="${list}">
      <option value="${row.code}"
         <c:if test="${row.code == value}"> selected="selected" </c:if>
         <c:if test="${row.code == value && not empty row.groupId}"><c:set var="hannoverDefault" value="${row.groupId}" /><c:set var="occupationTitleDefault" value="${row.description}" /></c:if>
         <c:if test="${not empty row.groupId}"> data-hannovercode="${row.groupId}" </c:if>
      >
         ${row.description}
      </option>
   </c:forEach>
</select>

<c:set var="hannoverxpath" value="${xpath}/hannover" />
<c:set var="hannoverName" value="${go:nameFromXpath(hannoverxpath)}" />
<input type="hidden" value="${hannoverDefault}" name="${hannoverName}" id="${hannoverName}" />

<c:set var="occupationTitle" value="${go:nameFromXpath(occupationxpath)}Title" />
<input type="hidden" value="${occupationTitleDefault}" name="${occupationTitle}" id="${occupationTitle}" />

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
            text: $this.text(),
            hannoverCode: $this.data("hannovercode")
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
      }).on('select2-selecting', function(e) {
         $('#${hannoverName}').val(e.choice.hannoverCode);
         $('#${occupationTitle}').val($.trim(e.choice.text));
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