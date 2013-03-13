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
		RTM_CTM_LIFE
	</xsl:param>
	<xsl:param name="env">
		_QAA
	</xsl:param>
	<xsl:param name="tranId">
		000000000
	</xsl:param>
	<xsl:param name="InsuranceType">
		Life Insurance
	</xsl:param>
	
	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL/ip"/>
	</xsl:template>
	
	<xsl:template match="/tempSQL/ip">

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
							<xsl:value-of select="contactDetails/email" />
						</EmailAddress>

						<EventVariables>
							<Variable>
								<Name>EventVar:EmailAddr</Name>
								<Value>
									<xsl:value-of select="contactDetails/email" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:FirstName</Name>
								<Value>
									<xsl:value-of select="details/primary/firstName" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:OKToCall</Name>
								<Value>
									<xsl:value-of select="contactDetails/call" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:OptIn</Name>
								<Value>
									<xsl:choose>
    									<xsl:when test="contactDetails/optIn != ''">
        									<xsl:value-of select="contactDetails/optIn"/>
    									</xsl:when>
    									<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:CalculatorURL</Name>
								<Value><![CDATA[http://www.comparethemarket.com.au/life-insurance-calculator/?sssdmh=dm14.238456 ]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:InsuranceType</Name>
								<Value>
									<xsl:if test="$InsuranceType = 'life'"><![CDATA[Life Insurance]]></xsl:if>
									<xsl:if test="$InsuranceType = 'incomeprotection'"><![CDATA[Income Protection]]></xsl:if>
								</Value>

							</Variable>
							<Variable>
								<Name>EventVar:PhoneNumber</Name>
								<Value><![CDATA[1800 204 124]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:QuoteRef</Name>
								<Value>
									<xsl:value-of select="$tranId" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading1</Name>
								<Value><![CDATA[Your gross annual income]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading2</Name>
								<Value><![CDATA[Benefit Amount]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading3</Name>
								<Value><![CDATA[Premium Frequency]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading4</Name>
								<Value><![CDATA[Premium Type]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading5</Name>
								<Value><![CDATA[Indemnity or Agreed]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading6</Name>
								<Value><![CDATA[Waiting period]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeHeading7</Name>
								<Value><![CDATA[Benefit period]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue1</Name>
								<Value>
									<xsl:value-of select="format-number(details/primary/insurance/income, '$##,###,###')" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue2</Name>
								<Value>
									<xsl:value-of select="format-number(details/primary/insurance/amount, '$##,###,###')" />
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue3</Name>
								<Value>
									<xsl:if test="details/primary/insurance/frequency = 'M'"><![CDATA[Monthly]]></xsl:if>
									<xsl:if test="details/primary/insurance/frequency = 'Y'"><![CDATA[Annually]]></xsl:if>
									<xsl:if test="details/primary/insurance/frequency = 'H'"><![CDATA[Half Yearly]]></xsl:if>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue4</Name>
								<Value>
									<xsl:if test="details/primary/insurance/type = 'S'"><![CDATA[Stepped]]></xsl:if>
									<xsl:if test="details/primary/insurance/type = 'L'"><![CDATA[Level]]></xsl:if>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue5</Name>
								<Value>
									<xsl:if test="details/primary/insurance/value = 'I'"><![CDATA[Indemnity]]></xsl:if>
									<xsl:if test="details/primary/insurance/value = 'A'"><![CDATA[Agreed]]></xsl:if>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue6</Name>
								<Value><xsl:value-of select="details/primary/insurance/waiting"/><![CDATA[ days]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:IncomeValue7</Name>
								<Value>
									<xsl:if test="details/primary/insurance/benefit = '1'"><xsl:value-of select="details/primary/insurance/benefit" /><![CDATA[ year]]></xsl:if>
									<xsl:if test="details/primary/insurance/benefit &gt; '1' and details/primary/insurance/benefit &lt; '11'"><xsl:value-of select="details/primary/insurance/benefit" /><![CDATA[ years]]></xsl:if>
									<xsl:if test="details/primary/insurance/benefit &gt; '11'"><![CDATA[to Age ]]><xsl:value-of select="details/primary/insurance/benefit" /></xsl:if>
								</Value>
							</Variable>
						</EventVariables>
					</EventEmailAddress>
				</ToEmailAddress>
			</RTMEmailToEmailAddress>
		</RTMWeblet>

	</xsl:template>
</xsl:stylesheet>
