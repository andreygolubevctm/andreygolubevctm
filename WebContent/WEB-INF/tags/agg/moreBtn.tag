<%@ tag description="Add info Btn"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="outerClassName" 	required="false"  rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="innerClassName" 	required="false"  rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="itemId" 	required="true"  rtexprvalue="true"	 	description="Add Id of container want to scroll too"%>
<%@ attribute name="btnTxt" 	required="false"  rtexprvalue="true"	description="text that will be displayed on button"%>
<%@ attribute name="scrollTo" 	required="true"  rtexprvalue="true"	 	description="position of that item eg: top or bottom"%>
<%@ attribute name="heightCountSelector" required="false"  rtexprvalue="true"	description="Add these elements to determine if it flows off page"%>

<c:if test="${empty heightCountClass}">
	<c:set var="heightCountSelector" value=".result-row" />
</c:if>

<%-- CSS --%>
<go:style marker="css-head">
	/* more info btn */
	#moreBtn {
		display: none;
		z-index: 2000;
		<c:if test="${empty btnTxt}">
		background: url('common/images/more_btn/more-button.png');
		</c:if>
		<%--
		<c:if test="${not empty btnTxt}">
		background: url('common/images/more_btn/more-button-bg.png');
		</c:if>
		--%>
		position: fixed;
		bottom: 0pt;
		left: 50%;
		margin-left: -75px; /* half the width of the btn */
	}
	.moreBtnInner {
		display:block;
		text-decoration: none;
		text-align: center;
		color: #FFF;
		font-weight: bold !important;
		font-size:14px;
	}
	#moreBtn .moreBtnInner {
		height: 39px;
		width: 209px;
		<c:if test="${not empty btnTxt}">
		line-height: 39px;
		</c:if>
	}
</go:style>


<go:script>
var btnInit = new Object();
btnInit = {
	_enabled : true,
	_show : function(){
		/* more btn setup */
		/* set item to be container to scroll to and the scroll to point of that container*/
		var item = '${itemId}';
		var scrollTo = ('${scrollTo}').toLowerCase(); /* added toLowerCase as safety */
		var heightCountSelector = '${heightCountSelector}';

		$("a.moreBtnInner").click(function() {
			if(scrollTo == 'top'){
				$('html, body').animate({scrollTop: ($("#"+item).offset().top)-$(window).height()}, 1000);
			} else if(scrollTo == 'bottom'){
				$('html, body').animate({scrollTop: ($("#"+item).offset().top)-$(window).height()+$("#"+item).outerHeight(true)}, 1000);
			}

			return false;
		});
		function positionBtn() {
			if(btnInit._enabled){
				var docHeight = $(document).height();
				var winHeight = $(window).height();

				var totalheight = 0;

				$(heightCountSelector).each(function(index) {
					if($(this).hasClass('unavailable') == false) {
						totalheight = totalheight+$(this).height();
					}
					if($(this).hasClass('top-result')) {
						totalheight = totalheight+($('#results-header').offset().top+$('.top-result').outerHeight(true));
					}
				});

				if (totalheight > winHeight) {
					/* fadein fadeout based distance from scrolltop*/
					if ( $(window).scrollTop() < 200) {
						$("#moreBtn").fadeIn("slow");
					} else {
						$('#moreBtn').fadeOut('slow');
					}
				} else {
					$('#moreBtn').fadeOut('slow');
				}
			} else {
				if( $('#moreBtn').is(":visible") ) {
					$('#moreBtn').fadeOut('fast');
				}
			}
		}
		positionBtn();
		$(window).scroll(positionBtn).resize(positionBtn);
	},
	disable : function() {
		btnInit._enabled = false;
		if( $('#moreBtn').is(":visible") ) {
			$('#moreBtn').fadeOut('fast');
		}
	},
	enable : function() {
		btnInit._enabled = true;
		if( $(window).scrollTop() < 200){
			$("#moreBtn").fadeIn("slow");
		}
	}
}
</go:script>

<%-- html --%>
<div id="moreBtn"<c:if test="${not empty outerClassName}"> class="${outerClassName}"</c:if> >
	<a class="moreBtnInner <c:if test="${not empty innerClassName}">${innerClassName}</c:if>" href="#"><c:if test="${not empty btnTxt}">${btnTxt}</c:if></a>
</div>
