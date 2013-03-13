<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="This is the login procedure, which adds the user to the data bucket"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<%@ attribute name="bridgeToLive"	required="false"	 rtexprvalue="true"	 description="bridge to the live system" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />



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

	searchQuotes: function() {
		var search_terms = $("#quote_search").val();
		SearchQuotes.search( search_terms );
	},

	showComments: function() {
		QuoteComments.show();
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
				<c:set var="loginData" value="${data.login}" />
				<go:log>Login Data = ${loginData}</go:log>
				var URL = 'https://secure.comparethemarket.com.au/ctm/simples_health_quote.jsp?login-uid=${loginData.user.uid}&amp;?ts='+ +new Date();
				loadSafe.loader( $('#main'), 3000, URL);				
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
			commsMenuBar.searchQuotes();
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
