<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="medicare_number ${className}" value="${data[xpath]}"/>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="medicareNumber" parm="${required}" message="Please enter a valid ${title}"/>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	$.validator.addMethod("medicareNumber",
			function(value, elem, parm) {
			
				var cardNumber = value.replace(/\s/g, '')  + ''; //turn into a string
    
    			<%-- Ten is the length --%>
			    if(cardNumber.length != 10){
			        return false;
			    };
			    
			    <%-- Must start between 2 and 6 --%>
			    if( (cardNumber.substring(0,1) < 2) && (cardNumber.substring(0,1) > 6) ){
			    	return false;
			    };
			
			    var sumTotal =
			      (cardNumber.substring(0,1) * 1)
			    + (cardNumber.substring(1,2) * 3)
			    + (cardNumber.substring(2,3) * 7)
			    + (cardNumber.substring(3,4) * 9)
			    + (cardNumber.substring(4,5) * 1)
			    + (cardNumber.substring(5,6) * 3)
			    + (cardNumber.substring(6,7) * 7)
			    + (cardNumber.substring(7,8) * 9);
			    
			    <%-- Remainder needs to = the 9th number --%>
			    if( sumTotal % 10 == cardNumber.substring(8,9) ){
			        return true;
			    } else {
			        return false;
			    };
			},
			$.validator.messages.medicareNumber = 'card number is not a valid Medicare number'
	);

</go:script>


<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$(':input[name=${name}]').mask("9999 99999 9",{placeholder:""});
</go:script>