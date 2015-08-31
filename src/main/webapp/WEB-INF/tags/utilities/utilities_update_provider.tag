<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Updates Utilities provider master and properties records."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('utilities:utilities_update_provider')}" />

<%@ attribute name="provider_id" 	required="true"	 rtexprvalue="true"	 description="The Switchwise Provider ID" %>
<%@ attribute name="provider_code" 	required="true"	 rtexprvalue="true"	 description="The Switchwise Provider Code" %>
<%@ attribute name="provider_name" 	required="true"	 rtexprvalue="true"	 description="The Provider's Name" %>
<%@ attribute name="record_expiry" 	required="true"	 rtexprvalue="true"	 description="Number of days a record is to be current for" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="alt_table" value="" />
${logger.info('provider_id={},provider_code={},provider_name={}', provider_id,provider_code,provider_name)}

<%-- 1] First - get the ID of the provider (either an existing one or a new ID from the range) --%>
<%-- ========================================================================================= --%>
<c:catch var="error">
	<sql:query var="find_provider">
		SELECT pm.ProviderId AS id
		FROM ctm.provider_master${alt_table} AS pm
		LEFT JOIN ctm.provider_properties${alt_table} AS pp ON pp.ProviderId = pm.ProviderId AND pp.PropertyId = 'SwitchwiseId'
		WHERE pm.ProviderId >= 82 AND pm.ProviderId <= 282 AND pm.Status != 'X' AND pp.ProviderId IS NOT NULL AND pp.Text = ?;
		<sql:param value="${provider_id}" />
	</sql:query>
</c:catch>

<c:choose>
	<c:when test="${empty error}">
		<c:set var="ctm_provider_id">
			<c:choose>
				<%-- Use the ID found with the original select --%>
				<c:when test="${find_provider.rowCount > 0}">
					<c:out value="${find_provider.rows[0].id}" />
				</c:when>
				<%-- Otherwise locate the next available ID from the range --%>
				<c:otherwise>
					<c:catch var="error">
						<sql:query var="find_available">
							SELECT pm.ProviderId AS id
							FROM ctm.provider_master${alt_table} AS pm
							WHERE
								pm.ProviderId >= 82 AND pm.ProviderId <= 281 AND
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
									${logger.info('There are no empty provider records to store ({})', provider_id)}
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							${logger.warn('Database error locating empty provider record ({})', provider_id, error)}
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</c:set>

<%-- 2] Store the provider in the database including required properties --%>
<%-- =================================================================== --%>
		<c:if test="${not empty ctm_provider_id}">
			<sql:transaction dataSource="jdbc/ctm" isolation="repeatable_read">

				<%-- Update the provider_master record located in the previous section --%>
				<sql:update>
					UPDATE ctm.provider_master${alt_table}
					SET Name = ?, EffectiveStart = CURDATE(), EffectiveEnd = CURDATE() + INTERVAL ${record_expiry} DAY, Status = ''
					WHERE ProviderId = ?
					LIMIT 1;
					<sql:param value="${provider_name}" />
					<sql:param value="${ctm_provider_id}" />
				</sql:update>

				<%-- Delete existing properties (happens in transaction... don't panic) --%>
				<sql:update>
					DELETE FROM ctm.provider_properties${alt_table}
					WHERE ProviderId = ?
					LIMIT 30;
					<sql:param value="${ctm_provider_id}" />
				</sql:update>

				<%-- Store SwitchwiseId property --%>
				<sql:update>
					INSERT INTO ctm.provider_properties${alt_table}
					(ProviderId, PropertyId, SequenceNo, Text, EffectiveStart, EffectiveEnd, Status)
					VALUES (?, ?, ?, ?, CURDATE(), CURDATE() + INTERVAL ${record_expiry} DAY, '')
					ON DUPLICATE KEY UPDATE
						Text = VALUES(Text),
						EffectiveStart = VALUES(EffectiveStart),
						EffectiveEnd = VALUES(EffectiveEnd),
						Status = VALUES(Status);
					<sql:param value="${ctm_provider_id}" />
					<sql:param value="SwitchwiseId" />
					<sql:param value="0" />
					<sql:param value="${provider_id}" />
				</sql:update>

				<%-- Store SwitchwiseCode property --%>
				<sql:update>
					INSERT INTO ctm.provider_properties${alt_table}
					(ProviderId, PropertyId, SequenceNo, Text, EffectiveStart, EffectiveEnd, Status)
					VALUES (?, ?, ?, ?, CURDATE(), CURDATE() + INTERVAL ${record_expiry} DAY, '')
					ON DUPLICATE KEY UPDATE
						Text = VALUES(Text),
						EffectiveStart = VALUES(EffectiveStart),
						EffectiveEnd = VALUES(EffectiveEnd),
						Status = VALUES(Status);
					<sql:param value="${ctm_provider_id}" />
					<sql:param value="SwitchwiseCode" />
					<sql:param value="0" />
					<sql:param value="${provider_code}" />
				</sql:update>

				<%-- Store SwitchwiseState property --%>
				<c:forEach items="QLD,NSW,ACT,VIC,TAS,SA,WA,NT" var="state" varStatus="count">
					<sql:update>
						INSERT INTO ctm.provider_properties${alt_table}
						(ProviderId, PropertyId, SequenceNo, Text, EffectiveStart, EffectiveEnd, Status)
						VALUES (?, ?, ?, ?, CURDATE(), CURDATE() + INTERVAL ${record_expiry} DAY, '')
						ON DUPLICATE KEY UPDATE
							Text = VALUES(Text),
							EffectiveStart = VALUES(EffectiveStart),
							EffectiveEnd = VALUES(EffectiveEnd),
							Status = VALUES(Status);
						<sql:param value="${ctm_provider_id}" />
						<sql:param value="SwitchwiseState" />
						<sql:param value="${count.count}" />
						<sql:param value="${state}" />
					</sql:update>
				</c:forEach>
			</sql:transaction>
		</c:if>
	</c:when>
	<c:otherwise>
		${logger.warn('Database error selecting provider ({})', provider_id, error)}
	</c:otherwise>
</c:choose>
${logger.debug('PROVIDER ID: ${ctm_provider_id}', ctm_provider_id)}
<c:out value="${ctm_provider_id}" />