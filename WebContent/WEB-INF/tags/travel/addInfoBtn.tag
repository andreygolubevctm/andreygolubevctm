<%@ tag description="Add info Btn"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="itemId" required="true"  rtexprvalue="true"	 	 description="Add Id of container want to scroll too"%>
<%@ attribute name="btnTxt" required="false"  rtexprvalue="true"	 	 description="text that will be displayed on button"%>

<%-- CSS --%>
<go:style marker="css-head">

    /* more info btn */
    
    #moreInfoBtn {
    	display: none;
    	z-index: 9999;
    	background: url('common/images/add_info_btn/add-info-button.png');
    	
    }
    
    
    .moreInfoBtnInner {
    	display:block;
    	text-decoration: none;
    	text-align: center;
    	color: #FFF;
    	font-weight: bold !important;
    	font-size:14px;
    }

</go:style>


<go:script>
/* more info btn setup */


$(window).load(function() { 

	var btnHeight = 55;
	var btnWidth = 150;
	

    /* set item to be container to scroll to */   
    var item = '${itemId}';  
  	var btnTop = '';
    

    /* set width and height of btnInner */
    $("a.moreInfoBtnInner").css({'height':btnHeight+'px','width':btnWidth+'px', 'line-height':btnHeight+'px'});
   
    /* get the distance from the item to the top of the document  */   
		
	$("a.moreInfoBtnInner").click(function() {
		$('html, body').animate({scrollTop: ($("#"+item).offset().top)-100}, 1000);
		return false;
	});
	
	
       function positionBtn() {
      		var docHeight = $(document).height();
			var winHeight = $(window).height();
			var btnHoriz = ($(window).width()-btnWidth)/2;
       				
	       		  	
	       	/* set vertical location */
			btnTop = ($(window).scrollTop()+$(window).height()-btnHeight-96)+"px";
					
			/* set width and height of btn */
			$("#moreInfoBtn").css({'height':btnHeight+'px','width':btnWidth+'px','margin-left':'-'+(btnWidth/2)+'px'});
				
			/* set horz location */
			$("#moreInfoBtn").css({ 'position':'absolute','top':btnTop,"left":"50%"})

			if(docHeight > winHeight){
					/* fadein fadeout based distance from scrolltop*/
					if( $(window).scrollTop() < 400){
							
						$("#moreInfoBtn").fadeIn("slow");
					}else{			
						$('#moreInfoBtn').fadeOut('slow');
					}
			}
       }
	setInterval(positionBtn,100); 
     	
	$(window)
               .scroll(positionBtn)
               .resize(positionBtn)

});




</go:script>


<%-- html --%>

<div id="moreInfoBtn"><a class="moreInfoBtnInner" href="#"></a></div>


