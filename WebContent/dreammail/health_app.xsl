<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:param name="ClientName">
		BudgetDirect
	</xsl:param>
	<xsl:param name="SiteName">
		Compare_Market
	</xsl:param>
	<xsl:param name="CampaignName">
		CompareTheMarket
	</xsl:param>
	<xsl:param name="MailingName">
		RTM_CTM_HEALTH_APP
	</xsl:param>
	<xsl:param name="env">
		_PRO
	</xsl:param>
	<xsl:param name="tranId">
		000000000
	</xsl:param>
	<xsl:param name="SessionId">
		000000000
	</xsl:param>
	<xsl:param name="InsuranceType">
		Quote
	</xsl:param>
	
	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL"/>
	</xsl:template>
	
	<xsl:template match="/tempSQL">
	
		<RTMWeblet>
			<RTMEmailToEmailAddress>
				<AcknowledgementsTo>
					<EmailAddress>shaun.stephenson@aihco.com.au</EmailAddress>
					<Option>2</Option>
				</AcknowledgementsTo>
				<ClientName>
					<xsl:value-of select="$ClientName" />
				</ClientName>
				<SiteName>
					<xsl:value-of select="$SiteName" />
				</SiteName>
				<CampaignName>
					<xsl:value-of select="$CampaignName" />
					<xsl:value-of select="$env" />
				</CampaignName>
				<MailingName>
					<xsl:value-of select="$MailingName" />
					<xsl:value-of select="$env" />
				</MailingName>
				<ToEmailAddress>
					<EventEmailAddress>
						<EmailAddress>
							<xsl:choose>
    							<xsl:when test="health/application/email != ''">
									<xsl:value-of select="health/application/email" />
								</xsl:when>
								<xsl:when test="save/email != ''">
        							<xsl:value-of select="save/email" />
    							</xsl:when>
    							<xsl:when test="health/contactDetails/email != ''">
        							<xsl:value-of select="health/contactDetails/email" />
    							</xsl:when>    							
    							<xsl:otherwise>shaun.stephenson@aihco.com.au</xsl:otherwise>
							</xsl:choose>
						</EmailAddress>

						<EventVariables>
							<Variable>
								<Name>EventVar:EmailAddr</Name>
								<Value>
									<xsl:choose>
    									<xsl:when test="health/application/email != ''">
											<xsl:value-of select="health/application/email" />
										</xsl:when>
										<xsl:when test="save/email != ''">
        									<xsl:value-of select="save/email" />
    									</xsl:when>
    									<xsl:when test="health/contactDetails/email != ''">
        									<xsl:value-of select="health/contactDetails/email" />
    									</xsl:when>    									
    									<xsl:otherwise>shaun.stephenson@aihco.com.au</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:FirstName</Name>
								<Value>
									<xsl:value-of select="health/contactDetails/firstName" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:OKToCall</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="health/contactDetails/call != ''">
									<xsl:value-of select="health/contactDetails/call" />
										</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:OptIn</Name>
								<Value>
									<xsl:choose>
    									<xsl:when test="health/application/optInEmail != ''">
        									<xsl:value-of select="health/application/optInEmail"/>
    									</xsl:when>
    									<xsl:when test="health/save/marketing != ''">
        									<xsl:value-of select="health/save/marketing"/>
    									</xsl:when>
    									<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:PhoneNumber</Name>
								<Value><![CDATA[1800 77 77 12]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:CTAUrl</Name>
								<Value>
									<xsl:choose>
    									<xsl:when test="$env = '_PRO'"><![CDATA[https://secure.comparethemarket.com.au/ctm/health_quote.jsp?action=confirmation&ConfirmationID=]]><xsl:value-of select="$SessionId" /><xsl:if test="$env = '_QAA'"><![CDATA[&sssdmh=dm14.240016]]></xsl:if><xsl:if test="$env = '_PRO'"><![CDATA[&sssdmh=dm14.240054]]></xsl:if><![CDATA[&cid=em:em:health:101911&utm_source=email&utm_medium=email&utm_campaign=email_|_health_|_confirmation&utm_content=review_your_details]]></xsl:when>
    									<xsl:otherwise><![CDATA[https://qa.secure.comparethemarket.com.au/ctm/health_quote.jsp?action=confirmation&ConfirmationID=]]><xsl:value-of select="$SessionId" /><xsl:if test="$env = '_QAA'"><![CDATA[&sssdmh=dm14.240016]]></xsl:if><xsl:if test="$env = '_PRO'"><![CDATA[&sssdmh=dm14.240054]]></xsl:if><![CDATA[&cid=em:em:health:101911&utm_source=email&utm_medium=email&utm_campaign=email_|_health_|_confirmation&utm_content=review_your_details]]></xsl:otherwise></xsl:choose>	
    							</Value>

							</Variable>
							<Variable>
								<Name>EventVar:QuoteRef</Name>
								<Value>
									<xsl:value-of select="$tranId" />
								</Value>
							</Variable>
						</EventVariables>
					</EventEmailAddress>
				</ToEmailAddress>
			</RTMEmailToEmailAddress>
		</RTMWeblet>

	</xsl:template>
</xsl:stylesheet>


