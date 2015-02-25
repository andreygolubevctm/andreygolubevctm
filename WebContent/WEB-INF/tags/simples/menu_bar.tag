<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples main menu" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="bridgeToLive"	required="false"	 rtexprvalue="true"	 description="Bridge to the live system" %>

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}" />

<%--

	See framework/modules/js/simples/* for corresponding code.

--%>
<nav class="simples-menubar navbar navbar-inverse" role="navigation" data-provide="simples-tickler">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#simples-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>

			<a class="simples-homebutton navbar-brand" target="simplesiframe" href="simples/home.jsp" title="Go to home page">Home</a>
</div>

		<div class="collapse navbar-collapse" id="simples-navbar-collapse-1">
			<%-- Menu options --%>
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown">New <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li><a class="newquote needs-loadsafe" href="${assetUrl}simples/startQuote.jsp?verticalCode=HEALTH">Health quote</a></li>
					</ul>
				</li>

				<li data-provide="simples-quote-finder"><a href="javascript:void(0);">Quote details</a></li>

				<%-- Only show the Config pages if user is a supervisor role --%>
				<c:if test="${isRoleSupervisor}">
					<li class="dropdown">
						<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">Admin <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li class="dropdown-header">Reports</li>
							<li><a target="simplesiframe" href="simples/report_callstatus.jsp">Consultant call status</a></li>
							<li><a target="simplesiframe" href="simples/report_messageoverview.jsp">Message queue overview</a></li>
							<%-- DISABLED UNTIL CAN BE WORKED ON
							<li><a target="simplesiframe" href="simples/report_managerOpEnq.jsp">Manager - Operator enquires</a></li>
							--%>

					<%-- DISABLED UNTIL CAN BE WORKED ON
							<li class="divider"></li>

							<li class="dropdown-header">Configuration</li>
					<li><a target="simplesiframe" href="simples/message_dashboard.jsp">Configuration</a></li>
					--%>
						</ul>
					</li>
				</c:if>

				<li data-provide="dropdown">
					<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown">Blacklist <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li data-provide="simples-blacklist-action"><a href="javascript:void(0);" data-action="add">Add</a></li>
						<c:if test="${isRoleSupervisor}">
							<li data-provide="simples-blacklist-action"><a href="javascript:void(0);" data-action="delete">Remove</a></li>
						</c:if>
					</ul>
				</li>

				<%-- Action menu hidden by default; a module will hide/show it --%>
				<li class="dropdown hidden" data-provide="simples-quote-actions">
					<a href="javascript:void(0);" class="dropdown-toggle active" data-toggle="dropdown">Actions <b class="caret"></b></a>
					<ul class="dropdown-menu">
						<li class="dropdown-header hidden">Message ID: <span class="simples-show-messageid"></span></li>
						<li><a class="action-complete" href="javascript:void(0);">Complete</a></li>
						<li><a class="action-remove-pm" href="javascript:void(0);">Remove from PM</a></li>
						<li><a class="action-complete-pm" href="javascript:void(0);">Complete as PM</a></li>
						<li><a class="action-change-time" href="javascript:void(0);">Change Time</a></li>
						<li><a class="action-postpone" href="javascript:void(0);">Postpone</a></li>
						<li><a class="action-unsuccessful" href="javascript:void(0);">Unsuccessful</a></li>

						<li class="divider"></li>

						<li class="dropdown-header hidden">Tran ID: <span class="simples-show-transactionid"></span></li>
						<li><a class="action-comment" href="javascript:void(0);">Comments</a></li>
			</ul>
				</li>
			</ul>

			<%-- User details --%>
			<p class="navbar-text navbar-right">
				<c:out value="${authenticatedData['login/user/displayName']}" />
				<c:choose>
					<c:when test="${not empty authenticatedData['login/user/extension']}">
						on <c:out value="${authenticatedData['login/user/extension']}" />
					</c:when>
					<c:otherwise>
						(no extension)
					</c:otherwise>
				</c:choose>
				<c:out value=", " />
				<a href="${assetUrl}security/simples_logout.jsp" class="navbar-link">Log out</a>
			</p>

			<%-- Search form --%>
			<form id="simples-search-navbar" class="navbar-form navbar-right" role="search">
				<div class="form-group">
					<input type="text" name="keywords" class="form-control input-sm" placeholder="">
				</div>
				<button type="submit" class="btn btn-default btn-sm">Search</button>
			</form>
		</div>
	</div>
</nav>