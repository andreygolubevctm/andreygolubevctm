<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

		<xsl:variable name="policyType">
			<xsl:choose>
				<xsl:when test="policyType = 'A'">MULTI</xsl:when>
				<xsl:otherwise>SINGLE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="preExistingMedicalCondition">
			<xsl:choose>
				<xsl:when test="preExistingMedicalCondition = 'Y'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numberOfAdults">
			<xsl:choose>
				<xsl:when test="number(adults) = adults"><xsl:value-of select="adults"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="numberOfChildren">
			<xsl:choose>
				<xsl:when test="number(children) = children"><xsl:value-of select="children"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="oldestPerson">
			<xsl:choose>
				<xsl:when test="number(oldest) = oldest"><xsl:value-of select="oldest"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fromDate">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="dates/fromDate" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="toDate">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="dates/toDate" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="destinations">
			<!-- destination value is e.g. FJI,NZL -->
			<xsl:for-each select="destination">
				<xsl:text>"</xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="." />
					<xsl:with-param name="replace" select="','" />
					<xsl:with-param name="with" select="'&quot;,&quot;'" />
				</xsl:call-template>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="mobileUrls">
			<xsl:choose>
				<xsl:when test="renderingMode = 'sm' or renderingMode = 'xs'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <xsl:variable name="providerFilterCode">
            <xsl:if test="string-length(filter/providerFilterCode) &gt; 0">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="filter/providerFilterCode"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
        </xsl:variable>
	{
		"brandCode":"ctm",
		"transactionId":<xsl:value-of select="transactionId" />,
		"clientIp":"<xsl:value-of select="clientIpAddress" />",
		"payload": {
			"policyType":"<xsl:value-of select="$policyType"/>",
			"preExistingMedicalCondition":"<xsl:value-of select="$preExistingMedicalCondition"/>",
			"mobileUrls":<xsl:value-of select="$mobileUrls" />,
			"numberOfAdults":<xsl:value-of select="$numberOfAdults"/>,
			"numberOfChildren":<xsl:value-of select="$numberOfChildren"/>,
			"oldestPerson":<xsl:value-of select="$oldestPerson"/>,
            "providerFilter":[<xsl:value-of select="$providerFilterCode"/>]
		<xsl:if test="$policyType = 'SINGLE'">, "singleTripDetails": {
				"destinations":[<xsl:value-of select="$destinations"/>],
				"fromDate":"<xsl:value-of select="$fromDate"/>",
				"toDate":"<xsl:value-of select="$toDate"/>"
			}
		</xsl:if>
		}
	}
	</xsl:template>

	<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="util_isoDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($month, '00')" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($day, '00')" />
	</xsl:template>
</xsl:stylesheet>