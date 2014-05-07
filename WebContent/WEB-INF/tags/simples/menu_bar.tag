<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="This is the login procedure, which adds the user to the data bucket"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%@ attribute name="bridgeToLive"	required="false"	 rtexprvalue="true"	 description="bridge to the live system" %>



<div id="comms-menuBar">
	<div style="float:left;width:210px;height:65px;clear:both;">
	<%--<img src="common/images/dashboard/aleksandr-small.png" style="position:relative;top:3px;"/>--%>
	<span style="float:left;font-size:30px;color:white;font-weight:bold;margin:15px 0 0 15px;">Simples</span>
	<span style="float:left;font-size:14px;color:white;font-weight:bold;margin:28px 0 0 5px;">v1.0</span>
	</div>

	<ul class="new"><li><span>New</span>
			<ul>
				<li class="quote health">Health Quote</li>
				<!-- li class="quote life">Life Insurance Quote</li
				<li class="quote ip">Income Protection Quote</li  -->
				<li class="quote car">Car Quote</li>
				<li class="quote fuel">Fuel Quote</li>
				<li class="quote roadside">Roadside Quote</li>
				<li class="quote travel">Travel Quote</li>
				<!-- li class="new message">Call-back</li -->
			</ul>
		</li>
	</ul>
	<ul class="dashboard">
		<%--<li class="view messages">Call-backs</li>
		<li class="view diary">Diary</li>--%>
		<li class="view stats">Statistics</li>
		<li class="view comments">Comment</li>

		<c:if test="${fn:length(data.array['login/security/branch_leader']) > 0}">
			<li class="asim">Assimilate User: <field:user_select xpath="login/user/uid" title="list of users" required="false" className=""/></li>
		</c:if>
		<li class="view details">User Details</li>
		<li class="view findquote">Find Quote</li>
		<li class="view logout">Log Out</li>
	</ul>
	<ul class="quoteSystem">
		<li>
			<field:input xpath="quote_search" title="search keywords" required="false" />
			<field:button xpath="quote_go" title="Search">Go</field:button>
		</li>
	</ul>
</div>

<%-- CSS --%>
<go:style marker="css-head">
.comms-messages {
	display:none;
}
.comms-diary {
	display:none;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var commsMenuBar = new Object();
commsMenuBar = {
	_target : null,

	init : function( target ) {
		commsMenuBar._target = target;
		commsMenuBar.addListeners();
		<%-- Agent ID is required for advanced features #whitelabel --%>
		<c:if test="${empty authenticatedData.login.user.agentId or authenticatedData.login.user.agentId eq ''}">
			commsMenuBar.noAgentDialog();
		</c:if>
	},

	noAgentDialog : function(){
		$('body').remove("#dialog-noAgent").append("<div id='dialog-noAgent'></div>");
		$("#dialog-noAgent").html('<p>Your Agent ID was not supplied during Log In.</p><p>An Agent ID is required to sell products. Please <strong>do not begin</strong> consulting without it.</p><p>Contact your supervisor for further I.T. assistance.</p>');

		$("#dialog-noAgent").dialog({
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.message-noAgent-dialog").first().center();
				}
			},
			hide: 'clip',
			position: 'center',
			resizable: false,
			height:270,
			width:520,
			modal: true,
			dialogClass:'message-noAgent-dialog',
			title:'Warning: Agent ID',
			buttons: {
				"OK": function() {
					$( this ).dialog( "close" );
				}
			}
			});
	},

	transactionid: function(transid){
		_tranID = transid;
	},
	asim: function(uid) {
		//calling the ajax form with the SQL
		$.ajax({
			type: 'GET',
			async: false,
			timeout: 30000,
			url: "ajax/load/asim.jsp?uid=" + uid,
			dataType: "text",
			async: false,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			error: function(){ FatalErrorDialog.display('Apologies: There was an error getting the messages') },
			success: function(data){
				if(data != undefined && data == 'OK') {
					commsMenuBar.populate();
				} else {
					FatalErrorDialog.display('Apologies: there was an error seeing the user. Error: ' + data, data);
				};
			}
		});
	},

	populate: function() {
		commsMessages.update();
		commsDiary.update();
	},

	forceLogin: function() {
		document.location.href = "simples.jsp?r=" + Math.floor(Math.random()*10001);
	},

	authenticateUser: function(callback) {

		if(typeof callback == "function") {

			$.ajax({
				type: 		'GET',
				async: 		false,
				timeout: 	5000,
				url: 		"ajax/json/simples_authenticate_user.jsp",
				data:		null,
				dataType: 	"json",
				cache: 		false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				error: 		commsMenuBar.forceLogin,
				success: 	function(json) {
					if(json.authenticated === true) {
						callback();
					} else {
						commsMenuBar.forceLogin();
					}
				}
			});
		} else {
			<%-- ignore --%>
		}
	},

	searchQuotes: function() {
		commsMenuBar.authenticateUser(function(){
		var search_terms = $("#quote_search").val();
		SearchQuotes.search( search_terms );
		});
	},

	showComments: function() {
		commsMenuBar.authenticateUser(QuoteComments.show);
	},

	addListeners: function() {

		commsMenuBar._target.find('li.view.stats').click( function(){
			var URL = 'simples_stats_user.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.car').click( function(){
			var URL = 'car_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.health').click( function(){
			<c:choose>
			<c:when test="${bridgeToLive == 'Y'}">
				<c:set var="loginData" value="${authenticatedData.login}" />
				<go:log>Login Data = ${loginData}</go:log>
				var URL = 'https://secure.comparethemarket.com.au/ctm/simples_health_quote.jsp?login-uid=${loginData.user.uid}&amp;?ts='+ +new Date();
				loadSafe.loader( $('#main'), 3000, URL); <%-- #WHITELABEL CX --%>
			</c:when>
			<c:otherwise>
				var URL = 'health_quote.jsp?ts='+ +new Date();
				loadSafe.loader( $('#main'), 3000, URL);
			</c:otherwise>
			</c:choose>
		});

		commsMenuBar._target.find('li.quote.life').click( function(){
			var URL = 'life_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.ip').click( function(){
			var URL = 'ip_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.fuel').click( function(){
			var URL = 'fuel_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.roadside').click( function(){
			var URL = 'roadside_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.quote.travel').click( function(){
			var URL = 'travel_quote.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.view.messages').click( function(){
			$('.comms-messages').dialog({ width:637, height:480, modal: true } );
		});

		commsMenuBar._target.find('li.view.diary').click( function(){
			$('.comms-diary').dialog({ width:637, height:480,modal: true } );
			$('.comms-diary').fullCalendar('render');
		});

		commsMenuBar._target.find('li.view.comments').click( function(){
			commsMenuBar.showComments();
		});

		$('#login_user_uid').change( function(){
			if($(this).val() != ''){
				commsMenuBar.asim($(this).val());
			};
		});

		commsMenuBar._target.find('li.view.details').click( function(){
			var URL = 'security/simples_userDetails.jsp?ts='+ +new Date();
			loadSafe.loader( $('#main'), 2000, URL);
		});

		commsMenuBar._target.find('li.view.logout').click( function(){
			window.top.document.location = "${pageContext.servletContext.contextPath}/security/simples_logout.jsp";
		});

		$("#quote_go").click( function(){
			commsMenuBar.authenticateUser(commsMenuBar.searchQuotes);
		});

		commsMenuBar._target.find('li.view.findquote').click( function(){
			commsMenuBar.authenticateUser(quoteFinder.open);
		});
	}
};
</go:script>

<go:script marker="onready">
commsMenuBar.init( $('#comms-menuBar') );
<%-- Make sure a simples user doesn't lose the menu bar due to session expiry --%>
loadSafe.keepAlive();
</go:script>
<simples:diary xpath="calendar" title="Diary" />
<simples:search_quotes />
<simples:quote_comments />
<simples:quote_finder />