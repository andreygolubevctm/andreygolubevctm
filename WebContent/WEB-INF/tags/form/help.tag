<%--
	Represents a collection of panels
 --%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title for the slide"%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>

<%-- HTML --%>
<div id="helpToolTip">
	<h4></h4><span></span>
	<div id="helpToolTipFooter"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	#helpToolTip {
		background:transparent url(common/images/help-tooltip.png) left top repeat-y;
		display:none;
		position:absolute;
		width:282px;
		height:auto;		
		z-index:200;
		padding:17px 10px 3px 33px;
		margin-top: -33px;
		margin-left: 17px;
		font-size:12px;
		line-height:15px;
		cursor:pointer;
	}
	#helpToolTip > h4 {
		font-size:12px;
		font-weight:bold;
		color:#EC5400;
		display:inline;
	}
	#helpToolTipFooter {
		width: 325px;
		height:7px;
		background:transparent url(common/images/help-tooltip.png) left bottom no-repeat;
		display:block;
		float:left;
		position:relative;
		top:7px;
	    left:-33px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var Help=new Object(); 
</go:script>
<go:script marker="onready">
	Help = {
		_id:0,
		_pending:false,
		_prvTarget:false,
		_init : function(){
			//$("#helpToolTip").hide();
			$("#helpToolTip").appendTo('body');
			$("#helpToolTip").click(function(){
				Help.hide();
			});
			$(".help_icon").each(function(){
				$(this).click(function(){
					var id=$(this).attr('id').substring(5); 
					Help.update(id,$(this));
				});
			});
			$(window).resize(function(){
				if (Help.isShown()){
					Help.show(Help._prvTarget);
				}
			});
			$(document).click(function(){
				if (Help.isShown()){
					Help.hide();
				}
			});
			
		}, 
		update: function(id, targetIcon){
			if (id == Help._id) {
				this.hide();
			} else {
				Help._id=id;
				Help._pending = true;
				$.ajax({
					url: "ajax/xml/help.jsp",
					data: {id: id},
					success: function(data){
						$('#helpToolTip').removeAttr('class').addClass('tip'+id);
						$(data).find("help").each(function() {
							$("#helpToolTip>h4").html($(this).attr("header")+" ");
				    		$("#helpToolTip>span").html($(this).text());
				    		Help.show(targetIcon);
						});
					},
					error: function() {
						<%-- console.log('HelpId not found:'+id); --%>
						Help._pending = false;
					}
				});
			};
		},
		show: function(targetIcon){
			this._prvTarget=targetIcon;
			var pos=$(targetIcon).offset();
			$("#helpToolTip").css({
				left:pos.left +'px',
				top: pos.top +'px'
			});
		
			if (!this.isShown()) {
				if ($.browser.msie){
					$("#helpToolTip").show();
				} else {
					$("#helpToolTip").fadeIn(100);
				};
			};
			Help._pending = false;	
		},
		hide: function(){
			if(Help._pending !== true){
				$("#helpToolTip").fadeOut(100);
				Help._id=0;
			};
		},
		isShown: function(){
			return Help._id!=0 && $("#helpToolTip").is(':visible');
		} 
	};
	Help._init();
	
	$("#next-step, #prev-step").click(function(){
		Help.hide(); 
	});	
	
</go:script>