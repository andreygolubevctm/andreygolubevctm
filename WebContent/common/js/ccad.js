
/*
 *	JQUERY DOCUMENT READY
 *	@author	Wayne Wilson
 * 	@param none
 * 	@return none
*/
$(document).ready(function() {
	
	// Apply JQuerys
	$("#expiry_date").datepicker({ dateFormat: 'yy-mm-dd' });
	
	$('#add_ccad_btn').click(function(){
		clear_fields();
		$('#add_ccad_form').slideDown(300);
	});
	$('#cancel_ccad_btn').click(function(){
		clear_fields();
		$("#add_ccad_form").slideUp(200);
	});
	$('#save_ccad_btn').click(function(){
		remove_errors();
		$('#ccad_form').submit();
	});
	$('#toggle_deleted').change(function(){
		load_all_ccad();
	});
	$("#pass").keypress(function(event) {
		if(event.which == 13)
			$('#login_btn').click();	 
	});
	
	// Login event handler
	$('#login_btn').click(function(){
		
		$('#login_form_content').hide();
		$('#spinner').show();
		
		if(login()){
			$('#overlay').fadeOut(500);
		}else{
			$('#spinner').hide();
			$('#login_form_content').fadeIn(100);
			$('#login_message').html('Invalid username and/or password. Please check your details and try again...');
		}
	});
	
	// Apply validation rules to form
	$("#ccad_form").validate({
		submitHandler: function(){
			save_ccad();
		},
		onfocusout: false,
		focusCleanup: true,
		onkeyup: false,
		rules:{
			ccad_key:{required: true, minlength: 5},
			ccad_name:{required: true, minlength: 2},
			expiry_date:{required: true},
			placement:{required: true, minlength: 2},
			descrip:{maxlength: 255},
			created_user:{required: true, minlength: 2}
		},
		messages:{
			ccad_key:"Enter 5 Characters",
			ccad_name:"Required",
			expiry_date:"Required",
			placement:"Required",
			created_user:"Required",
			descrip:"Maximum 255 Characters"
		}
	});
	
	// Load existing CCADs into list
	load_all_ccad();
	
});


/*
 *	SAVE A NEW OR EXISTING CCAD
 *	@author	Wayne Wilson
 * 	@param string ccad_key
 * 	@return boolean
*/
function save_ccad(){
	
	var the_key_exists = key_exists($('#ccad_key').val());
	
	// Don't save if EXISTING KEY and A NEW ENTRY
	if(the_key_exists && ($('#id').val() == '0')){
		
		$("#status_message").html('The key ' + $('#ccad_key').val() + ' exists, please use a different key.');
		$('#ccad_key').focus();
		clear_message(8000);
		
	}else{
	
		// Perform the Save
		$.ajax({
			  type: "POST",
			  url: "save_ccad.jsp",
			  data: {id: 			$('#id').val(),
				  	 ccad_key: 		$('#ccad_key').val(),
				  	 ccad_name: 	$('#ccad_name').val(),
				  	 descrip: 		$('#descrip').val(), 
				 	 expiry_date: 	$('#expiry_date').val(),
				 	 created_user:	$('#created_user').val(),
				  	 placement: 	$('#placement').val(),
				  	 url: 			$('#url').val()
				  },
			  async: false,
			  success: function(data){
				 clear_fields();
				 $("#add_ccad_form").slideUp(300);
				 load_all_ccad();
				 $("#status_message").show();
				 $("#status_message").html('Saved Successfully');
				 clear_message(3000);
			  }
		});
		
	}
	
}


/*
 *	CHECK IF THE KEY EXISTS
 *	@author	Wayne Wilson
 * 	@param string ccad_key
 * 	@return boolean
*/
function key_exists(ccad_key){
	
	var result = false;
	$.ajax({
		  type: "POST",
		  url: "check_ccad.jsp",
		  dataType: 'json',
		  data: {ccad_key:ccad_key},
		  async: false,
		  success: function(data){
			  if(typeof(data.key_exists)!='undefined' && data.key_exists == '1'){
				  result = true;
			  }else{
				  result = false;
			  }
		  }
	});
	return result;
	
}


/*
 *	DELETE (SET AS DELETED) CCAD
 *	@author	Wayne Wilson
 * 	@param int id
 * 	@return none
*/
function del_ccad(id){
	
	var answer = confirm("Are you sure you want to delete this?");
	
	if(answer){
		$.ajax({
			  type: "POST",
			  url: "del_ccad.jsp",
			  data: {id:id},
			  async: false,
			  success: function(){
				  load_all_ccad();
				  $("#status_message").show();
				  $("#status_message").html('Deleted Successfully');
				  clear_message(3000);
			  }
		});
	}
	
}


/*
 *	ACTIVATE/UNDELETE (SET AS ACTIVE) CCAD
 *	@author	Wayne Wilson
 * 	@param int id
 * 	@return none
*/
function act_ccad(id){
	
	var answer = confirm("Are you sure you want to activate this?");
	
	if(answer){
		$.ajax({
			  type: "POST",
			  url: "act_ccad.jsp",
			  data: {id:id},
			  async: false,
			  success: function(){
				  load_all_ccad();
				  $("#status_message").show();
				  $("#status_message").html('Activated Successfully');
				  clear_message(3000);
			  }
		});
	}
	
}


/*
 *	LOAD EXISITNG CCAD
 *	@author	Wayne Wilson
 * 	@param int id
 * 	@return none
*/
function load_ccad(id){
	
	// Check ID
	if(typeof(id)=='undefined' || id<1) id=0;
	
	$.ajax({
		  type: "POST",
		  url: "load_ccad.jsp",
		  data: {id:id},
		  dataType: 'json',
		  success: function(data){
			  
			  	// Clear any errors
			  	remove_errors();
			  
			  	// Populate fields
			 	$('#id').val(data.id); 
			 	$('#ccad_key').val(data.ccad_key); 
			  	$('#ccad_name').val(data.ccad_name); 
			  	$('#descrip').val(data.descrip);
			  	$('#expiry_date').val(data.expiry_date);
			  	$('#created_user').val(data.created_user);
			  	$('#placement').val(data.placement);
			  	$('#url').val(data.url);
			  	$("#add_ccad_form").slideDown(300);
			  	
			  	// Disable non-editable fields
			  	$('#ccad_key').attr('disabled','disabled');
			  	$('#created_user').attr('disabled','disabled');

		  }
	});
}


/*
 *	LOAD ALL CCADS INTO LIST
 *	@author	Wayne Wilson
 * 	@param none
 * 	@return none
*/
function load_all_ccad(){
	
	// Check show_deleted checkbox state
	var show_deleted = $('#toggle_deleted').is(':checked');
	$('#all_ccad').load('load_all_ccad.jsp', {show_deleted:show_deleted});
	
}

/*
 *	USER LOGIN AUTHENTICATION
 *	@author	Wayne Wilson
 * 	@param none
 * 	@return boolean
*/
function login(){

	var result = false;
	$.ajax({
		  type: "POST",
		  url: "ccad_login.jsp?user=" + $('#user').val() + "&pass=" + $('#pass').val(),
		  dataType: 'xml',
		  async: false,
		  success: function(xml){
			 var response = $.xml2json(xml);

			  if(response.password == 'VALID' && response.auth.code == '001' && response.auth.text == 'Y'){
				  result = true;
			  }else{
				  $('#login_message').html('Invalid login details - please try again...');
				  result = false;
			  }
			  
		  },
		  error: function(xml){
			  result = false;
		  }
	});
	return result;
	
}


/*
 *	CLEAR THE FORM
 *	@author	Wayne Wilson
 * 	@param none
 * 	@return none
*/
function clear_fields(){
	$('#ccad_key').removeAttr('disabled');
	$('#created_user').removeAttr('disabled');
	remove_errors();
	$('#id').val('0');
	$('#ccad_key').val('');
	$('#ccad_name').val('');
	$('#descrip').val('');
	$('#expiry_date').val('');
	$('#created_user').val('');
	$('#placement').val('');
	$('#url').val('');
}


function clear_message(delay){
	setTimeout("clear_message_do()",delay);
}


function clear_message_do(){
	$("#status_message").fadeOut(1500, function(){
		$("#status_message").show();
		$("#status_message").html('&nbsp;');
	});
}


function remove_errors(){
	$('.error').removeClass('error');
	$('label[generated]').remove();
}



