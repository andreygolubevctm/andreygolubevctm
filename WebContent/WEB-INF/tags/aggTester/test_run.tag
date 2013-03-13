<%@ tag description="Get Test Instances"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- css --%>
<go:style marker="css-head">
	.results {
		width: 100%;
		margin: 10px 0;
		color: #4c4c4c;
		font-style:italic;
		border-top: 1px solid #E9E9E9;
		border-bottom: 1px solid #E9E9E9;
		padding: 10px 0; 
	}
	
	#no-result {
		color: #e20909;
		
	}
	
	.results-sub {
		padding-right: 20px;
		font-style:normal;
	}
	
	.results-sub span{
		color: #e20909;
	}
	
</go:style>


<%-- Javascript --%>
<go:script marker="onready">
var Test = new Object();
Test = {
	ajaxPending : false,
	ajaxDataCount : 0,
	el_ID : [],
	dataArray : [],
	/* get data to Form*/
	getData: function(){
		
		var i = 0;
		Test.dataArray= [];
		$('input').each(function(index) {
			
			// check to see which check boxes have checked
			if($("#"+this.id).is(':checked')){
				Test.el_ID[i] = $("#"+this.id);
				Test.dataArray[i] = $("#"+this.id).val();
				i++
			}
			
		});
		if(Test.dataArray.length > 0){
			Test.sendData();
		}
		
	},
	/* send data to Ajax*/
	sendData: function(){
			
		if(Test.ajaxDataCount < Test.dataArray.length){
		
			if (!Test.ajaxPending){
				
				Test.fetchPrices(Test.dataArray[Test.ajaxDataCount]); 
			}
		}
	},
	/* Ajax call to get prices */
	fetchPrices: function(dat){	
		if (Test.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		//Loading.show("Fetching Your<br>Travel Insurance Quotes...");
		
		Test.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			url: "ajax/json/test_getResults.jsp",
			data: dat,
			type: "POST",
			async: true,
			success: function(jsonResult){
				Test.ajaxPending = false;	
				Test.showPrices(jsonResult.results.price);
				Test.ajaxDataCount = Test.ajaxDataCount+1;
				Test.sendData();
				
				return false;
				
			},
			dataType: "json",
			error: function(obj,txt){
				Test.ajaxPending = false;
				//Loading.hide();
				alert("An error occurred when fetching prices :" + txt);
			},
			timeout:60000
		});
		
	},
	showPrices: function(prices){
		prices=[].concat(prices);
		var tmp_elID = Test.el_ID[Test.ajaxDataCount];
		if(prices != "undefined"){

			result = false;
			$.each(prices, function() {
				if($.trim(this.des) == $.trim(productName)){
					(tmp_elID).parent().append('<div class="results"><span id="name" class="results-sub">Name: <span>'+this.des+'</span></span><span id="price" class="results-sub">Price: <span>$'+this.price.toFixed(2)+'</span></span></div>');
					result = true;
				};
			})
			if(result == false){
					(tmp_elID).parent().append('<div class="results"><span id="no-result">Sorry No Result</span></div>');
			}	
		}
		return;
	}
}



	$("#runTest").click(function(){
	 	Test.getData(); 
	 });
</go:script>