<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Updates Utilities provider master and properties records."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="provider_id" 			required="true"	 rtexprvalue="true"	 description="CTM's internal ID for the provider" %>
<%@ attribute name="product_state" 			required="true"	 rtexprvalue="true"	 description="The State this product is associated with" %>
<%@ attribute name="product_class" 			required="true"	 rtexprvalue="true"	 description="The Switchwise Product Class - Electricity or Gas" %>
<%@ attribute name="product_code" 			required="true"	 rtexprvalue="true"	 description="The Switchwise Product Code" %>
<%@ attribute name="product_short_title" 	required="true"	 rtexprvalue="true"	 description="The short title for the product" %>
<%@ attribute name="product_long_title" 	required="true"	 rtexprvalue="true"	 description="The looong title for the product" %>
<%@ attribute name="record_expiry" 			required="true"	 rtexprvalue="true"	 description="Number of days a record is to be current for" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<%-- VARIABLES --%>
<c:set var="alt_table" value="" />

<go:log>PI: ${provider_id}</go:log>
<go:log>PC: ${product_class}</go:log>
<go:log>PC: ${product_code}</go:log>
<go:log>PT: ${product_short_title}</go:log>
<go:log>PD: ${product_long_title}</go:log>

<%-- 1] First - get the ID of the product (either an existing one or a new ID from the range) --%>
<%-- ======================================================================================== --%>
<c:set var="ctm_product_id" value="" />

<c:catch var="error">
    <%-- #WHITELABEL Assuming this does not need to go through product validation per style --%>
				
	<sql:query var="find_product">
		SELECT ProductId AS id FROM ctm.product_master
		WHERE
			ProductId >= 435000 AND ProductId <= 475000 AND
			ProductCat = 'UTILITIES' AND
			ProductCode = ? AND
			ProviderId = ? AND
			Status != 'X'
		ORDER BY ProductId DESC
		LIMIT 1;
		<sql:param value="${product_code}" />
		<sql:param value="${provider_id}" />
	</sql:query>
</c:catch>

<c:choose>
	<c:when test="${empty error}">

		<c:set var="ctm_product_id">
			<c:choose>
				<%-- Use the ID found with the original select --%>
				<c:when test="${find_product.rowCount > 0}">
					<c:out value="${find_product.rows[0].id}" />
				</c:when>
				<%-- Otherwise locate the next available ID from the range --%>
				<c:otherwise>
					<c:catch var="error">
						<sql:query var="find_available">
							SELECT pm.ProductId AS id
							FROM ctm.product_master${alt_table} AS pm
							WHERE
								pm.ProductId >= 435000 AND pm.ProductId <= 475000 AND
								(pm.Status = 'X' OR pm.Status IS NULL)
							LIMIT 1;
						</sql:query>
					</c:catch>
					<c:choose>
						<c:when test="${empty error}">
							<c:choose>
								<c:when test="${find_available.rowCount > 0}">
									<c:out value="${find_available.rows[0].id}" />
								</c:when>
								<c:otherwise>
									<go:log>There are no empty product records to store (${product_code})</go:log>
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<go:log>Database error locating empty product record (${provider_id}): ${error.rootCause}</go:log>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</c:set>

<%-- 2] Store the product in the database including required properties --%>
<%-- ================================================================== --%>
		<c:if test="${not empty ctm_product_id}">
			<sql:transaction dataSource="jdbc/ctm" isolation="repeatable_read">

				<%-- Update the product_master record located in the previous section --%>
				<sql:update>
					UPDATE ctm.product_master${alt_table}
					SET
						ProductCat = 'UTILITIES', ProductCode = ?, ProviderId = ?, ShortTitle = ?, LongTitle = ?,
						EffectiveStart = CURDATE(), EffectiveEnd = CURDATE() + INTERVAL ${record_expiry} DAY,
						Status = ''
					WHERE
						ProductId = ?
					LIMIT 1;
					<sql:param value="${product_code}" />
					<sql:param value="${provider_id}" />
					<sql:param value="${product_short_title}" />
					<sql:param value="${product_long_title}" />
					<sql:param value="${ctm_product_id}" />
				</sql:update>

				<%-- Delete existing properties (happens in transaction... don't panic) --%>
				<sql:update>
					DELETE FROM ctm.product_properties${alt_table}
					WHERE ProductId = ?
					LIMIT 30;
					<sql:param value="${ctm_product_id}" />
				</sql:update>

				<%-- Store SwitchwiseState property --%>
				<sql:update>
					INSERT INTO ctm.product_properties${alt_table}
					(ProductId, PropertyId, SequenceNo, Value, Text, Date, EffectiveStart, EffectiveEnd, Status, benefitOrder)
					VALUES (?, ?, 0, 0, ? , CURDATE(), CURDATE(), CURDATE() + INTERVAL ${record_expiry} DAY, '', 0)
					ON DUPLICATE KEY UPDATE
						Text = VALUES(Text),
						Date = VALUES(Date),
						EffectiveStart = VALUES(EffectiveStart),
						EffectiveEnd = VALUES(EffectiveEnd),
						Status = VALUES(Status);
					<sql:param value="${ctm_product_id}" />
					<sql:param value="SwitchwiseState" />
					<sql:param value="${product_state}" />
				</sql:update>

				<%-- Store SwitchiseClassType property (Electricity or Gas) --%>
				<sql:update>
					INSERT INTO ctm.product_properties${alt_table}
					(ProductId, PropertyId, SequenceNo, Value, Text, Date, EffectiveStart, EffectiveEnd, Status, benefitOrder)
					VALUES (?, ?, 1, 0, ? , CURDATE(), CURDATE(), CURDATE() + INTERVAL ${record_expiry} DAY, '', 0)
					ON DUPLICATE KEY UPDATE
						Text = VALUES(Text),
						Date = VALUES(Date),
						EffectiveStart = VALUES(EffectiveStart),
						EffectiveEnd = VALUES(EffectiveEnd),
						Status = VALUES(Status);
					<sql:param value="${ctm_product_id}" />
					<sql:param value="SwitchwiseClassType" />
					<sql:param value="${product_class}" />
				</sql:update>
			</sql:transaction>
		</c:if>
	</c:when>
	<c:otherwise>
		<go:log>DB Error searching for existing product: ${error.rootCause}</go:log>
	</c:otherwise>
</c:choose>
<go:log>######## PRODUCT ID: ${ctm_product_id} ########</go:log>
<c:out value="${ctm_product_id}" />