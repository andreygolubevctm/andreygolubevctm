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
	<xsl:param name="unsubscribeToken"></xsl:param>

	<xsl:template match="/">
			<xsl:apply-templates select="/tempSQL/life"/>
	</xsl:template>

	<xsl:template match="/tempSQL/life">

<xsl:variable name="EmailAddress">
	<xsl:value-of select="contactDetails/email" />
</xsl:variable>

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
							<xsl:value-of select="$EmailAddress"/>
						</EmailAddress>

						<EventVariables>
							<Variable>
								<Name>EventVar:EmailAddr</Name>
								<Value>
									<xsl:value-of select="$EmailAddress"/>
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
								<Value><![CDATA[http://www.comparethemarket.com.au/life-insurance-calculator/?sssdmh=dm14.238456]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:InsuranceType</Name>
								<Value>
									<xsl:if test="$InsuranceType = 'life'"><![CDATA[Life Insurance]]></xsl:if>
									<xsl:if test="$InsuranceType = 'income'"><![CDATA[Income Protection]]></xsl:if>
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
								<Name>EventVar:LifeHeading1</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/term != '0'"><![CDATA[Term Life Cover]]></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeHeading2</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/tpd != '0'"><![CDATA[Total and Permanent Disability (TPD)]]></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeHeading3</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/trauma != '0'"><![CDATA[Trauma Cover]]></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeHeading4</Name>
								<Value><![CDATA[Premium Frequency]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeHeading5</Name>
								<Value><![CDATA[Premium Type]]></Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeValue1</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/term != '0'"><xsl:value-of select="format-number(details/primary/insurance/term, '$###,###,###')" /></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeValue2</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/tpd != '0'"><xsl:value-of select="format-number(details/primary/insurance/tpd, '$###,###,###')" /></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeValue3</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="details/primary/insurance/trauma != '0'"><xsl:value-of select="format-number(details/primary/insurance/trauma, '$###,###,###')" /></xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeValue4</Name>
								<Value>
									<xsl:if test="details/primary/insurance/frequency = 'M'"><![CDATA[Monthly]]></xsl:if>
									<xsl:if test="details/primary/insurance/frequency = 'Y'"><![CDATA[Annually]]></xsl:if>
									<xsl:if test="details/primary/insurance/frequency = 'H'"><![CDATA[Half Yearly]]></xsl:if>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:LifeValue5</Name>
								<Value>
									<xsl:if test="details/primary/insurance/type = 'S'"><![CDATA[Stepped]]></xsl:if>
									<xsl:if test="details/primary/insurance/type = 'L'"><![CDATA[Level]]></xsl:if>
								</Value>
							</Variable>
							<Variable>
								<Name>EventVar:UnsubscribeURL</Name>
								<Value>
									<xsl:choose>
										<xsl:when test="$env = '_PRO'">
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[https://secure.comparethemarket.com.au/ctm/unsubscribe.jsp?DISC=true&amp;token=',$unsubscribeToken,']]&gt;')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;![CDATA[https://nxq.secure.comparethemarket.com.au/ctm/unsubscribe.jsp?DISC=true&amp;token=',$unsubscribeToken,']]&gt;')" />
										</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Variable>
						</EventVariables>
					</EventEmailAddress>
				</ToEmailAddress>
			</RTMEmailToEmailAddress>
		</RTMWeblet>

	</xsl:template>
</xsl:stylesheet>