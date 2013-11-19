<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="errorPool" value="" />
 
<%-- 1] First get the list of Switchwise providers --%>
<%-- ============================================= --%>

<c:set var="providers"><utilities:utilities_get_providers></utilities:utilities_get_providers></c:set>
							 
<%-- Test for DB issue and handle - otherwise move on --%>
<c:choose>
	<c:when test="${empty providers}">
		<go:log>Failed to retrieve providers: ${error.rootCause}</go:log>
		<c:set var="errorPool">${errorPool}<error>Failed to retrieve providers: ${error.rootCause}</error></c:set>
	</c:when>
	<c:otherwise>

		<sql:setDataSource dataSource="jdbc/ctm"/>
		
		<%-- 2] Get a list of states applicable to each provider --%>
		<%-- =================================================== --%>
		
		<go:log>Have providers...</go:log>
		<x:parse doc="${providers}" var="providersOBJ" />
		<x:forEach select="$providersOBJ//*[local-name()='providers']//row" var="provider">
			<c:set var="ourProviderId"><x:out select="$provider/ourProviderId" /></c:set>
			<c:set var="providerName"><x:out select="$provider/providerName" /></c:set>
			<c:set var="providerId"><x:out select="$provider/providerId" /></c:set>
			<c:set var="providerCode"><x:out select="$provider/providerCode" /></c:set>
			<c:set var="statesXML">
				<utilities:utilities_get_providerstates providerCode="${providerCode}"></utilities:utilities_get_providerstates>
			</c:set>
			<c:choose>
				<c:when test="${empty statesXML}">
					<go:log>Failed to retrieve provider states: ${providerCode}</go:log>
					<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
					<c:set var="errorPool">${errorPool}<error>Failed to retrieve provider states: ${providerCode}</error></c:set>
				</c:when>
				<c:otherwise>
					<x:parse doc="${statesXML}" var="statesOBJ" />
					<c:set var="statecounter" value="${1}" />
					<x:forEach select="$statesOBJ//*[local-name()='string']" var="state">
						<c:set var="state"><x:out select="$state" /></c:set>
						<c:if test="${not empty state}">
							<c:set var="postcode">
								<utilities:utilities_get_postcode state="${state}"></utilities:utilities_get_postcode>
							</c:set>
							
							<%-- 3] Append/Update state property records for providers --%>
							<%-- ===================================================== --%>
									
							<c:catch var="error">
								<sql:update var="addProps">
									INSERT INTO ctm.provider_properties (ProviderId, PropertyId, SequenceNo, Text, EffectiveStart, EffectiveEnd, Status)
									VALUES ('${ourProviderId}', 'SwitchwiseState', '${statecounter}', '${state}', Now(), Now() + INTERVAL 30 DAY, '1')
									ON DUPLICATE KEY UPDATE
										Text = '${state}',
										EffectiveStart = Now(),
										EffectiveEnd = Now() + INTERVAL 30 DAY;
								</sql:update>
							</c:catch>
							<c:choose>
								<c:when test="${not empty error}">
									<go:log>Failed to insert/update provider properties: ${error.rootCause}</go:log>
									<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
									<c:set var="errorPool">${errorPool}<error>Failed to insert/update provider properties: ${error.rootCause}</error></c:set>
								</c:when>
								<c:otherwise>
								
									<%-- 4] Get the providers plans for every state - grouped by package/class --%>
									<%-- ===================================================================== --%>
											
									<go:log>Getting provider plans: ${postcode} ${providerId}</go:log>
									<c:set var="plansXML">
										<utilities:utilities_get_providerplans postcode="${postcode}" providerid="${providerId}"></utilities:utilities_get_providerplans>
									</c:set>
									
									<c:choose>
										<c:when test="${empty plansXML}">
											<go:log>Failed to locate any plans for postcode: ${postcode} and retailerid: ${providerid}</go:log>
											<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
											<c:set var="errorPool">${errorPool}<error>Failed to locate any plans for postcode: ${postcode} and retailerid: ${providerid}</error></c:set>
										</c:when>
										<c:otherwise>									
											<c:set var="groupings" value="Electricity,Gas" />	
											<x:parse doc="${plansXML}" var="plansOBJ" />
											<c:forEach var="group" items="${groupings}">
											
												<c:set var="packageType" value="${group}" />
												<c:set var="classType" value="${group}" />

												<x:set var="theNode" select="$plansOBJ//*[local-name()=$group]/*" />
												<x:forEach select="$theNode" var="plan">
													<c:set var="ProductCode"><x:out select="$plan/value" /></c:set>
													<c:set var="ShortTitle"><x:out select="$plan/description" /></c:set>
													<c:set var="ShortTitle" value="${fn:substring(ShortTitle, 0, 50)}" />
													<c:set var="LongTitle"><x:out select="$plan/description" /></c:set>
													
													<%-- 5] Find existing products and update or append as new --%>
													<%-- ===================================================== --%>		
													
													<c:set var="ProductId" value="${0}" />
													
													<c:catch var="error">
														<sql:query var="getProds">
															SELECT * FROM ctm.product_master
															WHERE ProductCat = ? AND
																  ProductCode = ? AND 
																  ProviderId = ?
																  ORDER BY ProductId DESC
																  LIMIT 1;
															<sql:param value="UTILITIES" />
															<sql:param value="${ProductCode}" />
															<sql:param value="${ourProviderId}" />
														</sql:query>
													</c:catch>
													<c:choose>
														<c:when test="${not empty error}">
															<go:log>DB Error searching for product: ${error.rootCause}</go:log>
															<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
															<c:set var="errorPool">${errorPool}<error>DB Error searching for product: ${error.rootCause}</error></c:set>
														</c:when>
														<c:otherwise>
															<c:choose>
																<%-- Exists so update the product --%>
																<c:when test="${not empty getProds and getProds.rowCount > 0}">
																	<c:catch var="error">
																		<sql:update var="updateProd">
																			UPDATE ctm.product_master
																			SET ShortTitle = ?, LongTitle = ?, EffectiveStart = Now(), EffectiveEnd = Now() + INTERVAL 30 DAY
																			WHERE ProductCat = ? AND
																				  ProductCode = ? AND 
																				  ProviderId = ?;
																			<sql:param value="${ShortTitle}" />
																			<sql:param value="${LongTitle}" />
																			<sql:param value="UTILITIES" />
																			<sql:param value="${ProductCode}" />
																			<sql:param value="${ourProviderId}" />
																		</sql:update>
																	</c:catch>																	
																	<c:choose>
																		<c:when test="${not empty error}">
																			<go:log>DB Error updating product master: ${error.rootCause}</go:log>
																			<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
																			<c:set var="errorPool">${errorPool}<error>DB Error updating product master: ${error.rootCause}</error></c:set>
																		</c:when>
																		<c:otherwise>
																			<%-- Store the ProductId so properties can be added later --%>
																			<c:set var="ProductId" value="${getProds.rows[0].ProductId}" />
																		</c:otherwise>
																	</c:choose>
																</c:when>																
																<%-- Otherwise create the product as new --%>
																<c:otherwise>
																	<c:catch var="error">
																		<sql:update var="insertProd">
																			INSERT INTO ctm.product_master
																			(ProductId, ProductCat, ProductCode, ProviderId, ShortTitle, LongTitle, EffectiveStart, EffectiveEnd, Status)
																			VALUES (0, ?, ?, ?, ? ,?, Now(), Now()  + INTERVAL 30 DAY, 1);
																			<sql:param value="UTILITIES" />
																			<sql:param value="${ProductCode}" />
																			<sql:param value="${ourProviderId}" />
																			<sql:param value="${ShortTitle}" />
																			<sql:param value="${LongTitle}" />
																		</sql:update>
																	</c:catch>																
																	<c:choose>
																		<c:when test="${not empty error}">
																			<go:log>DB Error appending product master: ${error.rootCause}</go:log>
																			<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
																			<c:set var="errorPool">${errorPool}<error>DB Error appending product master: ${error.rootCause}</error></c:set>
																		</c:when>
																		<c:otherwise>
																			<c:catch var="error">
																				<sql:query var="getInsertId">
																					SELECT LAST_INSERT_ID() AS pid;
																				</sql:query>
																				<%-- Store the ProductId so properties can be added later --%>
																				<c:set var="ProductId" value="${getInsertId.rows[0].pid}" />
																			</c:catch>
																		</c:otherwise>
																	</c:choose>
																</c:otherwise>
															</c:choose>
														</c:otherwise>
													</c:choose>
													
													<%-- 6] Append/Update properties for each product found --%>
													<%-- ================================================== --%>		
													
													<%-- Update the individual product properties --%>
													<c:choose>
														<c:when test="${ProductId eq 0}">
															<go:log>No ProductId available to added product properties: ourProviderId: ${ourProviderId}, ProductCode: ${ProductCode}</go:log>
															<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
															<c:set var="errorPool">${errorPool}<error>No ProductId available to added product properties: ourProviderId: ${ourProviderId}, ProductCode: ${ProductCode}</error></c:set>
														</c:when>
														<c:otherwise>
															<c:catch var="error">
															
																<%-- ADD STATE --%>
																
																<sql:update var="insertProdState">
																	INSERT INTO ctm.product_properties
																	(ProductId, PropertyId, SequenceNo, Value, Text, Date, EffectiveStart, EffectiveEnd, Status, benefitOrder)
																	VALUES (?, ?, ?, 0, ? , Now(), Now(), Now() + INTERVAL 30 DAY, 1, 0)
																	ON DUPLICATE KEY UPDATE
																		Text = ?,
																		Date = Now(),
																		EffectiveStart = Now(),
																		EffectiveEnd = Now()  + INTERVAL 30 DAY;
																	<sql:param value="${ProductId}" />
																	<sql:param value="SwitchwiseState" />
																	<sql:param value="${statecounter}" />
																	<sql:param value="${state}" />
																	<sql:param value="${state}" />
																</sql:update>
															</c:catch>	
															<c:if test="${not empty error}">
																<go:log>DB Error appending/updating product property [STATE]: ${error.rootCause}</go:log>
																<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
																<c:set var="errorPool">${errorPool}<error>DB Error appending/updating product property [STATE]: ${error.rootCause}</error></c:set>
															</c:if>
															
															<%-- ADD CLASS TYPE --%>
															
															<c:set var="error" value="" />
															<c:catch var="error">
																<sql:update var="insertProdState">
																	INSERT INTO ctm.product_properties
																	(ProductId, PropertyId, SequenceNo, Value, Text, Date, EffectiveStart, EffectiveEnd, Status, benefitOrder)
																	VALUES (?, ?, ?, 0, ? , Now(), Now(), Now() + INTERVAL 30 DAY, 1, 0)
																	ON DUPLICATE KEY UPDATE
																		Text = ?,
																		Date = Now(),
																		EffectiveStart = Now(),
																		EffectiveEnd = Now()  + INTERVAL 30 DAY;
																	<sql:param value="${ProductId}" />
																	<sql:param value="SwitchwiseClassType" />
																	<sql:param value="${statecounter}" />
																	<sql:param value="${classType}" />
																	<sql:param value="${classType}" />
																</sql:update>
															</c:catch>	
															<c:if test="${not empty error}">
																<go:log>DB Error appending/updating product property [CLASS TYPE]: ${error.rootCause}</go:log>
																<c:if test="${not empty errorPool}"><c:set var="errorPool">${errorPool},</c:set></c:if>
																<c:set var="errorPool">${errorPool}<error>DB Error appending/updating product property [CLASS TYPE]: ${error.rootCause}</error></c:set>
															</c:if>
														</c:otherwise>
													</c:choose>
													
												</x:forEach>
											</c:forEach>
										</c:otherwise>						
									</c:choose>
									
								</c:otherwise>
							</c:choose>
						</c:if>
						
						<c:set var="statecounter" value="${statecounter + 1}" />
					</x:forEach>
				</c:otherwise>
			</c:choose>
		</x:forEach>
	</c:otherwise>
</c:choose>

<%-- XML Output --%>
<c:set var="output">
	<?xml version="1.0" encoding="UTF-8"?>
	<results>
	<c:choose>
		<c:when test="${not empty errorPool}"><result>FAIL</result><errors>${errorPool}</errors></c:when>
		<c:otherwise><result>OK</result></c:otherwise>
	</c:choose>
	
	</results>
</c:set>

<go:log>${output}</go:log>
${output}