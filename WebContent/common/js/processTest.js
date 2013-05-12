

var TestAdd = new Object();
TestAdd = {
	ajaxPending : false,
	insertData: function(){		
		if (TestAdd.ajaxPending){
			// we're still waiting for the results.
			return; 
		}
		TestAdd.ajaxPending = true;
		this.ajaxReq = 
		$.ajax({
			   url: "ajax/json/test_process.jsp",
			   dataType: "json",
		       async: false,
		       timeout: 30000,
			   data: $("#mainform").serialize(),
			   success: function(data){
				    TestAdd.showBanner();
					TestAdd.ajaxPending = false;	
					TestAdd.formReset('mainform');
			   
			  }, error: function(e, xhr, errorThrown){
				    
			  }

		});
		
		
	},
	setDescription: function(){
		$('#desc-popup').show();
		

		
	},
	showBanner: function() {
		$('.engine').append('<div id="addedTest">You have added a Test Instance</div>');
		$('#addedTest').fadeIn('slow', function() { $(this).delay(1500).fadeOut("slow"); });

	},
	
	formReset: function(frmName){
		window.location.reload(true);
	}

};
