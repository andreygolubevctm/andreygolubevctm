<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.model.results.ResultsTemplateItem" %>
<%@ attribute name="labelMode" required="true" rtexprvalue="true" %>
<%@ attribute name="index" required="true" rtexprvalue="true" %>
<%@ attribute name="parentShortlistKey" required="false" rtexprvalue="true" %>
<%@ attribute name="helpPopoverPosition" required="false" rtexprvalue="true" %>

<c:if test="${empty helpPopoverPosition}">
	<c:set var="helpPopoverPosition" value="left" />
</c:if>

<div class="cell ${item.getClassString()}" data-index="${index}"<c:if test="${item.getShortlistKey() != ''}"> data-skey="${item.getShortlistKey()}"</c:if><c:if test="${not empty parentShortlistKey}"> data-par-skey="${parentShortlistKey}"</c:if>>

	<div class="labelInColumn ${item.getClassStringForInlineLabel()}<c:if test="${empty item.getName()}"> noLabel</c:if>">
		<div class="content" data-featureId="${item.getId()}">
			<div class="contentInner">
				<field_new:help_icon helpId="${item.getHelpId()}" position="${helpPopoverPosition}" />
				<c:out value="${item.getName()}" escapeXml="false" />
				<c:if test="${item.getChildren().size() > 0 }">
					<span class="icon expander"></span>
				</c:if>
			</div>
		</div>
	</div>

	<div class="${labelMode? 'h': 'c'} content ${item.getContentClassString()}" data-featureId="${item.getId()}" >
		<c:choose>
			<c:when test="${labelMode}">
				<field_new:help_icon helpId="${item.getHelpId()}" position="${helpPopoverPosition}" tooltipClassName="resultsHelpTooltips"/>
				<c:out value="${item.getName()}" escapeXml="false" />
				<c:if test="${item.getExtraText() != null && item.getExtraText() != ''}">
					<span class="extraText">${item.getExtraText()}</span>
				</c:if>

				<c:if test="${item.getChildren().size() > 0 }">
					<span class="icon expander"></span>
				</c:if>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${item.getResultPath() != null && item.getResultPath() != ''}">

					{{ var splitPath = "${item.getResultPath()}".split(" ") }}
					{{ for( i in splitPath ) { }}
						{{ var pathValue = Object.byString( obj, splitPath[i] ) }}
						{{ if( pathValue ){ }}
							{{= Features.parseFeatureValue( pathValue ) + " " }}
						{{ } else { }}
							{{= "&nbsp;" }}
						{{ } }}
					{{ } }}
					</c:when>
					<c:otherwise>
						&nbsp;
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</div>

	<c:if test="${item.couldHaveChildren()}">
		<div class="children" data-fid="${item.getId()}">
			<c:forEach items="${item.getChildren()}" var="selectedValue" varStatus="status">
				<features:resultsItem item="${selectedValue}" labelMode="${labelMode}" index="${status.index}" parentShortlistKey="${item.getShortlistKey()}"/>
			</c:forEach>
		</div>
	</c:if>

</div>