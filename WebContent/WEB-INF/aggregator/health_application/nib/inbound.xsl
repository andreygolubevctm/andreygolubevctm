<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:nib="http://www.nib.com.au/Broker/Gateway"
	exclude-result-prefixes="xsl">	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template match="/soap:Envelope/soap:Body/nib:EnrolResponse/nib:EnrolResult">
		<result>
			<xsl:variable name="errorStatus"><xsl:value-of select="nib:Status" /></xsl:variable>
			
			<xsl:variable name="hasRealErrors">
				<xsl:for-each select="nib:Errors/*">
					<xsl:choose>
						<xsl:when test="nib:Message='EnrolMember: Campaign code is invalid for member&quot;s cover'"></xsl:when>
						<xsl:when test="nib:Message='Matching member name / sex / birthdate found - Please check'"></xsl:when>
						<xsl:when test="nib:Message='EnrolMember: Client already registered'"></xsl:when>
						<xsl:when test="nib:Message='EnrolMember: Database Error -'"></xsl:when>
						<xsl:when test="nib:Message='Member selected previous nib Member'"></xsl:when>
						<xsl:when test="nib:Message='FetchDirectHist: No Health Policy associated with this Client'"></xsl:when>
						<xsl:when test="nib:Parameter='WDD1'"></xsl:when>
						<xsl:when test="nib:Parameter='WDD2'"></xsl:when>
						<xsl:when test="nib:Parameter='WDD3'"></xsl:when>
						<xsl:when test="nib:Parameter='WDD4'"></xsl:when>
						<xsl:when test="nib:Parameter='352'"></xsl:when>
						<xsl:when test="nib:Parameter='C04'"></xsl:when>
						<xsl:when test="nib:Parameter='47'"></xsl:when>
						<xsl:when test="nib:Parameter='H25'"></xsl:when>
						<xsl:when test="nib:Parameter='D62'"></xsl:when>						
						<xsl:otherwise>Y</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$errorStatus = 'Errors' and $hasRealErrors != ''">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</success>			
			<policyNo>
				<xsl:value-of select="nib:Member/nib:MemberNo" />
			</policyNo>

			<xsl:if test="$errorStatus = 'Errors'">
			<errors>
				<xsl:for-each select="nib:Errors/*">
				<error>
					<code><xsl:value-of select="nib:Parameter" /></code>
					<text><xsl:value-of select="nib:Message" /></text>
				</error>
				</xsl:for-each>
			</errors>
			</xsl:if>
		</result>
	</xsl:template>
	</xsl:stylesheet>