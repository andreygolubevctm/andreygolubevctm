<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/xml; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<c:set var="error_pool"		value="" />
<c:set var="proceed"		value="${false}" />
<c:set var="alt_table"		value = "" />
<c:set var="record_expiry"	value = "30" />
 
<%-- 1] First get the list of Switchwise providers --%>
<%-- ============================================= --%>
<c:set var="providers"><utilities:utilities_get_providers></utilities:utilities_get_providers></c:set>
							 
<c:choose>
	<c:when test="${not empty providers}">

		<sql:setDataSource dataSource="jdbc/ctm"/>
		
		<c:set var="updated_providers" value="" />
		<c:set var="updated_products" value="" />
		
		<x:parse doc="${providers}" var="providers_obj" />
		<x:forEach select="$providers_obj//*[local-name()='providers']//provider" var="provider">
			<c:set var="provider_id"><x:out select="$provider/id" /></c:set>
			<c:set var="provider_code"><x:out select="$provider/code" /></c:set>
			<c:set var="provider_name"><x:out select="$provider/name" /></c:set>
			<c:set var="our_provider_id" value="" />

<%-- 2] Store each provider found --%>
<%-- =============================--%>
			<c:set var="our_provider_id">
				<utilities:utilities_update_provider provider_id="${provider_id}" provider_code="${provider_code}" provider_name="${provider_name}" record_expiry="${record_expiry}" />
			</c:set>

			<c:choose>
				<c:when test="${not empty our_provider_id}">

					<%-- Add our_provider_id to a list to use to remove providers no longer supported --%>
					<c:set var="updated_providers">${updated_providers}<c:if test="${not empty updated_providers}">,</c:if>${our_provider_id}</c:set>

					<c:forEach items="QLD,NSW,ACT,VIC,TAS,SA,WA,NT" var="state" varStatus="count">

							<c:set var="postcode">
								<utilities:utilities_get_postcode state="${state}"></utilities:utilities_get_postcode>
							</c:set>
							
<%-- 3] Get each providers plans for a state (by postcode) --%>
							<%-- ===================================================== --%>
						<go:log>Getting provider plans: ${postcode} ${provider_id}</go:log>
									<c:set var="plansXML">
							<utilities:utilities_get_providerplans postcode="${postcode}" providerid="${provider_id}"></utilities:utilities_get_providerplans>
									</c:set>
									
									<c:choose>
							<c:when test="${not empty plansXML}">
								<c:set var="groupings" value="Electricity,Gas" />
											<x:parse doc="${plansXML}" var="plansOBJ" />
											<c:forEach var="group" items="${groupings}">
											
									<c:set var="our_product_id" value="" />
									<c:set var="class_type" value="${group}" />

									<x:set var="the_node" select="$plansOBJ//*[local-name()=$group]/*" />
									<x:forEach select="$the_node" var="plan">
										<c:set var="product_code"><x:out select="$plan/value" /></c:set>
										<c:set var="product_short_title"><x:out select="$plan/description" /></c:set>
										<c:set var="product_short_title" value="${fn:substring(product_short_title, 0, 50)}" />
										<c:set var="product_long_title"><x:out select="$plan/description" /></c:set>
													
<%-- 4] Store each plan found --%>
<%-- ======================== --%>
										<c:set var="our_product_id"><utilities:utilities_update_plan provider_id="${our_provider_id}" product_state="${state}" product_class="${class_type}" product_code="${product_code}" product_short_title="${product_short_title}" product_long_title="${product_long_title}" record_expiry="${record_expiry}" /></c:set>
													
													<c:choose>
											<c:when test="${not empty our_product_id}">
												<%-- Add our_provider_id to a list to use to remove providers no longer supported --%>
												<c:set var="updated_products">${updated_products}<c:if test="${not empty updated_products}">,</c:if>${our_product_id}</c:set>
														</c:when>
														<c:otherwise>
												<go:log>NO Product ID returned for use</go:log>
											</c:otherwise>
										</c:choose>
									</x:forEach>
								</c:forEach>
																		</c:when>
																		<c:otherwise>
								<go:log>Failed to locate any plans for postcode: ${postcode} and providerid: ${our_provider_id}</go:log>
								<c:set var="error_pool">${error_pool}<c:if test="${not empty error_pool}">,</c:if><error>Failed to locate any plans for postcode: ${postcode} and retailerid: ${provider_id}</error></c:set>
																		</c:otherwise>
																	</c:choose>
					</c:forEach>
				</c:when>
																<c:otherwise>
					<go:log>NO Provider ID returned for use</go:log>
																		</c:otherwise>
																	</c:choose>
		</x:forEach>
													
<%-- 5] Clean up legacy provider/plan data in the database --%>
<%-- ===================================================== --%>
													
															
		<%-- Deactivate products not updated (including their properties) --%>
		<c:if test="${proceed eq true and not empty updated_products}">
			<sql:transaction dataSource="jdbc/ctm" isolation="repeatable_read">
				<sql:update>
					UPDATE ctm.product_master${alt_table}
					SET ProductCat = 'UTILITIES', ProviderId = '0', ShortTitle = 'reserved for utilities',
						LongTitle = 'reserved for utilities', Status = 'X'
					WHERE
						<%-- Only look at records in Utilities range AND --%>
						<%-- Active Products that are not in list --%>
						ProductId >= 435000 AND ProductId <= 475000 AND
						Status != 'X' AND
						ProductId NOT IN (${updated_products})
					LIMIT 40001;
																</sql:update>
				<sql:update>
					DELETE FROM ctm.product_properties${alt_table}
					WHERE
						<%-- Only look at records in Utilities range AND --%>
						<%-- Products not in list --%>
						ProductId >= 435000 AND ProductId <= 475000 AND
						ProductId NOT IN (${updated_products})
					LIMIT 9999999;
				</sql:update>
			</sql:transaction>
															</c:if>
															
		<%-- Deactivate providers not updated (including their properties) --%>
		<c:if test="${not empty updated_providers}">
			<sql:transaction dataSource="jdbc/ctm" isolation="repeatable_read">
				<sql:update>
					UPDATE ctm.provider_master${alt_table}
					SET Name = 'reserved for utilities', Status = 'X'
					WHERE
						<%-- Only look at records in Utilities range AND --%>
						<%-- Active Providers that are not in list --%>
						ProviderId >= 82 AND ProviderId <= 281 AND
						Status != 'X' AND
						ProviderId NOT IN (${updated_providers})
					LIMIT 200;
																</sql:update>
				<sql:update>
					DELETE FROM ctm.provider_properties${alt_table}
					WHERE
						<%-- Only look at records in Utilities range AND --%>
						<%-- Providers not in list --%>
						ProviderId >= 82 AND ProviderId <= 281 AND
						ProviderId NOT IN (${updated_providers})
					LIMIT 9999999;
				</sql:update>
			</sql:transaction>
															</c:if>
	</c:when>
	<c:otherwise>
		<go:log>Failed to retrieve providers: ${error.rootCause}</go:log>
		<c:set var="error_pool">${error_pool}<error>Failed to retrieve providers from Switchwise.</error></c:set>
														</c:otherwise>
													</c:choose>
													
<%-- XML Output --%>
<c:set var="output">
	<?xml version="1.0" encoding="UTF-8"?>
	<results>
	<c:choose>
		<c:when test="${not empty error_pool}"><result>FAIL</result><errors>${error_pool}</errors></c:when>
		<c:otherwise><result>OK</result></c:otherwise>
	</c:choose>
		<updatedProviders>${updated_providers}</updatedProviders>
		<updatedProducts>${updated_products}</updatedProducts>
	</results>
</c:set>

<go:log>${output}</go:log>
${output}