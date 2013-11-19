<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:p21ns="http://networklogic.com.au/p21online/version-1"
	exclude-result-prefixes="xsl p21ns"
>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">cbh</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="status"><xsl:value-of select="/p21ns:membershipApplicationResult/@memshipStatus" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$status='P'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>

			<xsl:if test="$status='P'">
				<policyNo>
					<xsl:value-of select="/p21ns:membershipApplicationResult/@membership_id" />
				</policyNo>
			</xsl:if>

			<errors>
				<!-- Error returned by SOAP aggregator -->
				<xsl:if test="local-name(/*) = 'error'">
					<error>
						<code><xsl:value-of select="/error/code" /></code>
						<text><xsl:value-of select="/error/message" /></text>
					</error>
				</xsl:if>

				<!-- CBHS returned failed but they don't provide error reasons -->
				<xsl:if test="$status='F'">
					<error>
						<code>999</code>
						<text>CBHS webservice returned with failed.</text>
					</error>
				</xsl:if>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>