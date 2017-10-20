<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simples Message Details" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<simples:template_comments />
<simples:template_messageaudit />
<simples:template_messagedetail />
<simples:template_touches />

<div class="simples-home-buttons simples-splashpage-item hidden">
<c:choose>
	<c:when test="${pageSettings.getSetting('inInEnabled')}">
		<%-- <p>InInInteractionId: <c:out value="${sessionScope.ininInteractionId}" /></p> --%>

		<form id="simples-transaction-search-navbar" class="navbar-form text-center" role="search">
			<div class="form-group">
				<input type="number" name="keywords" class="form-control input-lg" min="0" />
			</div>
			<button type="submit" class="btn btn-default btn-lg">Find transaction ID</button>
		</form>
	</c:when>
	<c:otherwise>
		<field_v1:button xpath="loadquote" title="Get Next Message" className="btn btn-tertiary btn-lg message-getnext" />
	</c:otherwise>
</c:choose>
	<a href="/${pageSettings.getContextFolder()}simples/startQuote.jsp?verticalCode=HEALTH" class="btn btn-form btn-lg message-inbound">Start New Quote <span class="icon icon-arrow-right"></span></a>
</div>

<div class="simples-remaining-sales-container simples-splashpage-item hidden">
	<div class="remaining-sales-container">
		<div class="row">
			<div>
				<h1>Remaining Sales</h1>
			</div>
		</div>
		<div id="remaining-sales-row" class="row">
			<div>
				<table id="remaining-sales-table" class="remaining-sales-table table table-hover">
					<thead>
					<tr>
						<th>Fund</th>
						<th>Remaining Sales</th>
						<th>Estimated end</th>
					</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		<div class="row">
			<div>
				<b>If a fund is not shown above, there is no monthly sale limit</b>
			</div>
		</div>
	</div>
</div>

<div class="simples-splashpage-item hidden">
	<div class="simples-dialogue">
		<simples:dialogue id="77" vertical="health" className="simples-dialog-inbound" />
		<simples:clifilter_add filterStyleCodeId="1"/>
	</div>
	<div class="simples-dialogue">
		<simples:dialogue id="87" vertical="health" className="simples-dialog-inbound wfdd" />
		<simples:clifilter_add filterStyleCodeId="9"/>
	</div>
</div>
<div class="simples-message-details-container">

</div>
