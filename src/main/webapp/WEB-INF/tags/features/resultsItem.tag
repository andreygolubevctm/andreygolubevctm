<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<%@ attribute name="labelMode" required="true" rtexprvalue="true" %>
<%@ attribute name="index" required="true" rtexprvalue="true" %>
<%@ attribute name="parentShortlistKey" required="false" rtexprvalue="true" %>
<%@ attribute name="helpPopoverPosition" required="false" rtexprvalue="true" %>
<c:set var="vertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${empty helpPopoverPosition}">
	<c:set var="helpPopoverPosition" value="left" />
</c:if>
<div class="cell ${item.getClassString()}" data-index="${index}"<c:if test="${item.getShortlistKey() != ''}"> data-skey="${item.getShortlistKey()}"</c:if><c:if test="${not empty parentShortlistKey}"> data-par-skey="${parentShortlistKey}"</c:if>>
	<div class="labelInColumn ${item.getClassStringForInlineLabel()}<c:if test="${empty item.getName()}"> noLabel</c:if>">
		<div class="content" data-featureId="${item.getId()}">
			<div class="contentInner">
				<field_new:help_icon helpId="${item.getHelpId()}" position="${helpPopoverPosition}" />
				<c:out value="${item.getSafeName()}" escapeXml="false" /><c:if test="${item.getChildren().size() > 0 }"><span class="icon expander"></span></c:if>
			</div></div></div>
	<div class="${labelMode? 'h': 'c'} content ${item.getContentClassString()}" data-featureId="${item.getId()}" >
		<c:choose>
			<c:when test="${labelMode}">
				<field_new:help_icon helpId="${item.getHelpId()}" position="${helpPopoverPosition}" tooltipClassName="resultsHelpTooltips"/>
				<c:out value="${item.getSafeName()}" escapeXml="false" />
				<c:if test="${item.getExtraText() != null && item.getExtraText() != ''}"><span class="extraText">${item.getExtraText()}</span></c:if>
				<c:if test="${item.getChildren().size() > 0 }"><span class="icon expander"></span></c:if>
			</c:when>
			<c:otherwise>
				<c:choose>
                    <%-- This will be fixed/moved during the refactor. In reality this model should be complete before we need to render these items. --%>
					<c:when test="${item.getResultPath() != null && item.getResultPath() != ''}">
						<c:forTokens delims="," items="${item.getResultPath()}" var="splitPath">
							{{ var pathValue = Object.byString( obj, '${splitPath}' ), displayValue = Features.parseFeatureValue( pathValue, true ); }}
							<c:if test="${vertical eq 'car'}">
								{{ var parsedValue = '' }}

								<%-- Replace or overwrite certain values, i.e value comes from the soap response instead of the database. --%>
								<%-- Get the annual kilometers for Pay as you drive products --%>
								{{ if (obj.productId == "WOOL-01-01" || obj.productId == "REIN-01-01") { }}
									{{ if ('${splitPath}' == 'features.annKilo.extra') { }}
										{{ displayValue = obj.feature }}
									{{ } }}
								{{ } }}

								<%-- Additional excess rendering --%>
								{{ if ('${splitPath}' == 'excess.excess.value') { }}
									<%-- Default pathValue to N so we get the crosses as default. --%>
									{{ pathValue = 'N' }}
									{{ displayValue = Features.parseFeatureValue( pathValue ) }}
									{{ if(typeof excess.excess != 'undefined') { }}
										{{ displayValue = 'Additional Excess Applies' }}
									{{ } }}
								{{ } }}

								{{ if ('${splitPath}' == 'excess.excess.extra') { }}
									{{ pathValue = true }}
									{{ displayValue += '<ul>' }}
									<%-- Loop through the excess, put them in an li and put that in the displayValue --%>
									{{ if(excess.excess.hasOwnProperty("description")) { }}
										{{ displayValue += '<li>'+ excess.excess.description + (excess.excess.hasOwnProperty('amount') ? ' ' + excess.excess.amount : '') + '</li>' }}
									{{ } else { }}
										{{for(var index in excess.excess) { }}
											{{ displayValue += '<li>'+ excess.excess[index].description + ' ' + excess.excess[index].amount + '</li>' }}
										{{ } }}
									{{ } }}
									{{ displayValue += '</ul>' }}
								{{ } }}

								<%-- Call insurer direct button --%>
								{{ if ('${splitPath}' == 'action.callInsurer') { }}
									<%-- Default pathValue to N so we get the crosses as default. --%>
									{{ pathValue = 'N' }}
									{{ parsedValue = Features.parseFeatureValue( pathValue ) }}
									{{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

									{{ 	obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
									{{ if(obj.isOfflineAvailable === true) { }}
										{{  displayValue = '<div class="btnContainer"><a class="btn btn-call btn-block btn-call-actions btn-calldirect" data-callback-toggle="calldirect" href="javascript:;" data-productId="'+obj.productId+'">Call Insurer Direct</a></div>' }}
									{{ } }}
								{{ } }}

								<%-- Get a call back button --%>
								{{ if ('${splitPath}' == 'action.callBack') { }}
									<%-- Default pathValue to N so we get the crosses as default. --%>
									{{ pathValue = 'N' }}
									{{ parsedValue = Features.parseFeatureValue( pathValue ) }}
									{{ displayValue = '<div class="btnContainerNoBtn">'+parsedValue+'</div>' }}

									{{ 	obj.isOfflineAvailable = obj.offlineAvailable == "Y" }}
									{{ if(obj.isOfflineAvailable === true) { }}
										{{ 	obj.isCallbackAvailable = obj.callbackAvailable == "Y" }}
										{{ if(obj.isCallbackAvailable === true) { }}
											{{  displayValue = '<div class="btnContainer"><a class="btn btn-back btn-block btn-call-actions btn-callback" data-callback-toggle="callback" href="javascript:;" data-productId="'+obj.productId+'">Get a Call Back</a></div>' }}
										{{ } }}
									{{ } }}
								{{ } }}

								<%-- PDS buttons --%>
								{{ if ('${splitPath}' == 'action.pds') { }}
									{{ pathValue = true }}

									{{ var pdsA = '' }}
									{{ var pdsB = '' }}
									{{ var pdsC = '' }}
									{{ var width = '25' }}

									{{ if(typeof obj.pdscUrl != 'undefined') { }}
										{{ if(obj.pdscUrl != '') { }}
											{{ pdsC = '<a href="'+obj.pdscUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part C</a>' }}
										{{ } else { }}
											{{ width = '45' }}
										{{ } }}
									{{ } else { }}
										{{ width = '45' }}
									{{ } }}

									{{ if(obj.pdsbUrl != '') { }}
										{{ pdsB = '<a href="'+obj.pdsbUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part B</a>' }}
									{{ } else { }}
										{{ width = '70' }}
									{{ } }}


									{{ pdsA = '<a href="'+obj.pdsaUrl+'" target="_blank" class="showDoc btn btn-sm btn-download" style="width: '+width+'%">Part A</a>' }}

									{{ displayValue = '<div class="btnContainer">'+pdsA+pdsB+pdsC+'</div>' }}
								{{ } }}

								<%-- View more info --%>
								{{ if ('${splitPath}' == 'action.moreInfo') { }}
									{{ pathValue = true }}
									{{  displayValue = '<div class="btnContainer"><a class="btn-more-info" href="javascript:;" data-productId="'+obj.productId+'">view more info</a></div>' }}
								{{ } }}
							</c:if>{{ if( pathValue ) { }}<div>{{= displayValue }}</div>{{ } else { }}{{= "&nbsp;" }}{{ } }}
						</c:forTokens>
					</c:when>
					<c:otherwise>&nbsp;</c:otherwise>
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