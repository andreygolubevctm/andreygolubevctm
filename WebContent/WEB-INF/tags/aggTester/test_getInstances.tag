<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for product selection for web-tools"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>


<c:set var="name"  			value="${go:nameFromXpath(xpath)}" />
<c:set var="first" 		value="${name}_first" />
<c:set var="firstFour" 		value="${name}_firstFour" />
<c:set var="productRow" 	value="${name}_productRow" />
<c:set var="categoryRow" 	value="${name}_categoryRow" />
<c:set var="providerRow"	value="${name}_providerRow" />

<%-- CSS --%>
<go:style marker="css-head">
	#frmProductSelect {
		width: 700px !important;
		min-height: 80px !important;
		border: 1px solid #e9e9e9;
		-moz-border-radius: 15px;
		border-radius: 15px;
		padding: 20px;
		margin-top: 40px;
		
	}
	.fieldrow_label {
		width: 100px !important;
	}
	.fieldrow {
		width: 600px !important;
	}
	#mform {
		margin-top: 40px;
		padding: 20px;
		border-top: 1px solid #e9e9e9;
		width: 900px;
		
	}	
	#testInstances {
		width: 700px;
		margin: 0 auto;
	}
	.button-wrapper {
		position: absolute;
		top: 152px;
		left: 700px;
	}
	.button-wrapper #runTest {
		width: 112px;
		height: 92px;
		display: block;
		text-indent: -9999px;
		background: url("common/images/test_aggregator/run_test_btn.png") no-repeat scroll left top transparent;
	}
	
	.button-wrapper #runTest:hover {
		width: 112px;
		height: 92px;
		display: block;
		text-indent: -9999px;
		background: url("common/images/test_aggregator/run_test_btn.png") no-repeat scroll left -90px transparent;
	}
	
	#testInstances li {
		margin-bottom: 20px;
		font-size: 1em;
		font-weight: bold;
		color: #3c3c3c;
	}
	
	.testDesc {
		width: 500px;
		padding: 10px 0;
		font-style:italic;
		color: #787878;
	}

</go:style>


<%-- HTML --%>
<form:form action="#" method="POST" id="frmProductSelect" name="frmProductSelect">
	<form:row label="Category" id="${categoryRow}">
		<field:category_select xpath="${xpath}/category" title="category" type="category" required="true" className="${name}_first"/>	
	</form:row>
	
	<form:row label="Provider" id="${providerRow}">
		<field:provider_select productCategories="HEALTH" xpath="${xpath}/provider" title="provider" type="provider" required="true" className="${name}_firstFour" />	
	</form:row>
	
	<form:row label="Products" id="${productRow}">
		<field:general_select xpath="${xpath}/product" title="product" type="product" required="true"/>	
	</form:row>	
</form:form>

<form:form action="#" method="POST" id="mform" name="frmM">

<ul id="testInstances">
</ul>
<div class="button-wrapper">
	<a id="runTest" class="button next" href="javascript:void(0);">run test</a>
</div>
</form:form>


<%-- CSS --%>
<go:style marker="css-head">

</go:style>

<%-- JAVASCRIPT --%>


<go:script marker="onready">
	var productName = '';
	$pleaseChooseOption = "<option value=''>Please choose...</option>";
	$notFoundProduct = "<option value=''> No Products Found</option>";

	<%-- Initial: Hide product if not yet selected --%>
	<c:set var="xpathProduct" value="${xpath}/product" />	
	<c:if test="${data[xpathProduct] == null || data[xpathProduct] == ''}">
		$("#${productRow}").hide();
	</c:if>
	
	
	<c:set var="category" value="${go:nameFromXpath(xpath)}_category" />
	<c:set var="provider" value="${go:nameFromXpath(xpath)}_provider" />
	<c:set var="product" value="${go:nameFromXpath(xpath)}_product" />

	$product = "${data[xpathProduct]}";
	
		
		
	<%-- Interactive: Hide model if not yet selected --%>
	$(".${first}").change(function(){
		GetInstance.getProvider();
	});
	
	$(".${firstFour}").change(function(){
		GetInstance.resetFormEl('${product}'); 
		GetInstance.conceiveForm();
	});
	
	
		

	var GetInstance = new Object(); 
	GetInstance = {
	
		getProvider : function(){
			/* clear other form fields */
			GetInstance.resetFormEl('${provider}'); 
			
			$.ajax({
				   url: "ajax/xml/providers.jsp",
				   dataType: "xml",
			       async: false,
			       timeout: 30000,
				   data: "&category=" + $("#${category}").val(),
				   success: function(data){
				   	 var options = $pleaseChooseOption;
				   	 if ($(data).find("provider").length==0) { options = $notFoundProduct; }
					     $(data).find("provider").each(function() {
					    	  
					  	  	  
							  options += "<option value='" + $(this).attr("providerId") + "'>" + $(this).text() + "</option>";
						 });
						
						$("#${provider}").html(options);
						//$("#${productRow}").slideDown('normal').removeAttr('disabled');
						//$("#${go:nameFromXpath(xpathProduct)}").rules("add", {required: true});	
						
					//	GetInstance.conceiveForm();				
				   
				  }
			});



	},
	conceiveForm : function(){
			
			
			
			$product = "";
		
			// Check if the two main functions have been selected 
			var allSelected = true;
			$("#product_select_category, #product_select_provider ").each(function(){
				if ($(this).val() == "") {
					allSelected = false;
				}
			});
			
			
			// If they are all blank, hide the model
			if (allSelected){					
				
				// Ajax: Get list of products 
				$.ajax({
				   url: "ajax/xml/products.jsp",
				   dataType: "xml",
			       async: false,
			       timeout: 30000,
				   data: "&category=" + $("#${category}").val() + 
				         "&provider=" + $("#${provider}").val(),
				
				   success: function(data){
				   
				   	 var options = $pleaseChooseOption;
					   	 if ($(data).find("product").length==0) { options = $notFoundProduct; }
						     $(data).find("product").each(function() {
						    	  
						     	  $product = "${data[xpathProduct]}";	
						     	  var sel = "";
						     	  if ($product == $(this).attr("productId")) {
									sel = " selected";
								  }			     	  
								  options += "<option value='" + $(this).attr("productId") + "'" + sel + ">" + $(this).text() + "</option>";
							 });
						 
						$("#${go:nameFromXpath(xpathProduct)}").html(options);
						$("#${productRow}").slideDown('normal').removeAttr('disabled');
						//$("#${go:nameFromXpath(xpathProduct)}").rules("add", {required: true});	
						
						$("#${productRow}").change();				
					   }
				 });
			} 
		
		},
	resetFormEl : function(id) {
		$('#'+id).empty();
		$('#'+id).html($pleaseChooseOption);
		$('#testInstances').hide();	
		$('#${productRow}').hide();
		return;
	}
	};



$("#${productRow}").change(function(){	

		if ($("#${go:nameFromXpath(xpathProduct)}").val() != "") {
			
			//$('#content').show();
			$.ajax({
			url: "ajax/xml/test_instances.jsp",
			data: "&provider=" + $("#${provider}").val() + 
			      "&product=" + $("#${product}").val(),
			dataType: "xml",
			async: true,
			success: function(data){
					Test.ajaxDataCount = 0;
			   		var i = 1;
			   		$('#testInstances').empty();
			   		function replaceStr(string ,patternArray, replacementArray) {
			   				var x= 0;
			   				$(patternArray).each(function(key, pattern){
			   					
								string = string.replace(new RegExp(pattern, "gm"), replacementArray[x]);
								x++;
			   				});
					return string;
       				}

			   		$(data).find("properties").each(function() {
	   				
			   				
			   				/* set pattern and replacement array values and convert query string using regex */
							var patternArray=["/",", ",":","{","}"];
							var replacementArray=["%2F","&","%3","",""];
			   				var query = replaceStr($(this).text(),patternArray, replacementArray);	
	
					     	var label = $(this).attr("prodTitle");
					     	var desc = $(this).attr("description");
					     	productName = label;
					     	$('#testInstances').append("<li><input id='testInstance_"+i+"' class='destcheckbox' type='checkbox' value='"+query+"' name='testInstance"+i+"' checked><label for='testInstance_"+i+"'>Test "+i+": "+label+"</label><div class='testDesc'>"+desc+"</div></li>");						     	
			   		i++;
			   	 });	
				$('#testInstances').show();
			},
			
			error: function(obj,txt){
				GetInstance.ajaxPending = false;
				//Loading.hide();
				alert("An error occurred when fetching test data :" + txt);
			},
			timeout:60000
		});
			
			
			
		}
});




	

</go:script>