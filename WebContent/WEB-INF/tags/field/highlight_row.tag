<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Highlight selected element row handler - Also triggers inline validation."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="name" required="true" rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="inlineValidate" required="false" rtexprvalue="true"	 description="False by default - otherwise set to true" %>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	<%-- TRIGGER ROW HIGHLIGHTING --%>
	$("#${name}").focus(function(){
		$(".label_radio").closest('.fieldrow').removeClass('fieldrow_active');
		$(this).closest('.fieldrow').addClass('fieldrow_active');
	});	 
	$("#${name}").blur(function(){
		$(this).closest('.fieldrow').removeClass('fieldrow_active');
	});	
	
	<c:if test="${inlineValidate=='true'}">
		<%-- TRIGGER SINGLE ROW VALIDATION --%>
		$("#${name}").change(function(){ 			<%-- && typeof($("#${name}").attr('disabled'))!='undefined' && $("#${name}").attr('disabled').length<1 --%>
			if(typeof($("#${name}").attr('id'))!='undefined' && $("#${name}").find('input:radio').length<1){
				$(this).closest("form").validate().element($(this));
			}
		});
		<%-- APPLY TICKS TO FILLED FIELDS --%>
		if(typeof($("#${name}").val())!='undefined' && $("#${name}").val()!=''){
			$("#${name}").closest('.fieldrow').addClass('row-valid');
		}
	</c:if>
	
</go:script>
<go:script marker="onready">
	$(".label_radio input").focus(function(){
		$(".label_radio").closest('.fieldrow').removeClass('fieldrow_active');
		$(".label_radio").removeClass('radio-focus');
		$(this).closest('.fieldrow label').addClass('radio-focus');
		$(this).closest('.fieldrow').addClass('fieldrow_active');
	});
	$(".label_radio input").blur(function(){
		$(".label_radio").removeClass('radio-focus');
	});
	$(".label_radio input").change(function(){
		$(this).closest('.fieldrow label').removeClass('radio-focus');
		<c:if test="${inlineValidate=='true'}">
			<%-- TRIGGER SINGLE ROW RADIO VALIDATION --%>
			$(this).closest("form").validate().element($(this));
		</c:if>
	});
</go:script>