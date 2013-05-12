

//This dialog controller is used in the car selection process.
//It provides the user with a tabbed dialog window which they can switch between
//standard accessories, factory options and non standard accessories


$(document).ready(function() {

	// Dialog controller
	$('#dialog_info').tabs();
	$('#dialog').dialog({ 'modal':true, 
		'width':637, 'height':500, 
		'minWidth':637, 'minHeight':440, 
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		'buttons': { Ok: function() { $(this).dialog('close'); } }

	}).parent().appendTo(jQuery("form:first"));


	
	//steal the close button
	$('#ui-tab-dialog-close').append($('a.ui-dialog-titlebar-close'));

	//move the tabs out of the content and make them draggable
	$('.ui-dialog').addClass('ui-tabs')
	.prepend($('#dialog_tabs'));
	//.draggable('option','handle','#dialog_tabs'); 

	//switch the titlebar class
	$('.ui-dialog-titlebar').remove();
	$('#dialog_tabs').addClass('ui-dialog-titlebar');

});