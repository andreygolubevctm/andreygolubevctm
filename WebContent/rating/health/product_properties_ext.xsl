<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:h="http://admin.privatehealth.gov.au/ws/Schemas"
	xmlns:lookup="local-lookup-tables"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	exclude-result-prefixes="h lookup xsi"
	xmlns="">
	<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>

	<xsl:variable name="benefitLimits"
		select="h:Product/h:GeneralHealthCover/h:BenefitLimits/*" />
		

	<xsl:variable name="keywords" select="document('health_keywords.xml')" />
	<xsl:variable name="luBenefitNames" select="$keywords//benefitNames" />


	<xsl:template match="/">
		<phio>
			<info>
				<xsl:call-template name="write-attribs-as-elements" />
				<xsl:for-each select="h:Product/*[name()!='HospitalCover' and name()!='GeneralHealthCover']">
					<xsl:element name="{name()}" namespace="">
						<xsl:value-of select="." />
					</xsl:element>				
				</xsl:for-each>
			</info>
			<xsl:for-each select="h:Product/*">
				<xsl:choose>
					<xsl:when test="name()='HospitalCover'">
						<xsl:call-template name="HospitalCover" />
					</xsl:when>
					<xsl:when test="name()='GeneralHealthCover'">
						<xsl:call-template name="GeneralHealthCover" />
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</phio>
	</xsl:template>

	<xsl:template match="*">
		<xsl:element name="{name()}" namespace="">
			<xsl:copy-of select="*" xmlns=""/>
		</xsl:element>
	</xsl:template>

	<!-- HOSPITAL COVER -->
	<xsl:template name="HospitalCover">
		<hospital>
			<inclusions>
				<xsl:call-template name="write-attribs-as-elements" />				
				<xsl:apply-templates select="*[name()!='MedicalServices']" />
				
				<xsl:for-each select="h:MedicalServices/@*">
					<xsl:variable name="elementname" select="name()" />
					<xsl:element name="{$elementname}">
						<xsl:value-of select="." />
					</xsl:element>
				</xsl:for-each>
			</inclusions>
			<xsl:apply-templates select="h:MedicalServices" />
		</hospital>
	</xsl:template>

	<!-- ACCOMODATION -->
	<xsl:template match="h:Accommodation">
		<xsl:variable name="accomodation">
			<xsl:value-of select="." />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$accomodation = 'PrivateOrPublic' or 
							$accomodation = 'PrivateSharedPublic' or 
							$accomodation = 'PrivateSharedPublicShared'">
				<privateHospital>Y</privateHospital>
				<publicHospital>Y</publicHospital>
			</xsl:when>
			<xsl:when test="$accomodation = 'Public' or 
							$accomodation = 'PublicShared'">
				<privateHospital>N</privateHospital>
				<publicHospital>Y</publicHospital>
			</xsl:when>
			<xsl:otherwise>
				<privateHospital>N</privateHospital>
				<publicHospital>N</publicHospital>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- MEDICAL SERVICES -->
	<xsl:template match="h:MedicalServices">
		<benefits>
			<xsl:for-each select="h:MedicalService">
				
				<xsl:variable name="elementName">
					<xsl:choose>
						<xsl:when test="starts-with(@Title,'JointReplacement')">JointReplacement</xsl:when>
						<xsl:otherwise><xsl:value-of select="@Title" /></xsl:otherwise>					
					</xsl:choose>
				</xsl:variable>
				
				<xsl:element name="{$elementName}">
					<xsl:variable name="covered">
						<xsl:choose>
						<xsl:when test="$elementName='JointReplacement'">
							<xsl:choose>
								<xsl:when test="@Title != 'JointReplacementAll'">R</xsl:when>
								<xsl:when test="@Partial='true'">P</xsl:when>
								<xsl:when test="@Cover='Covered'">Y</xsl:when>
								<xsl:when test="@Cover='Restricted'">R</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>										
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@Partial='true'">P</xsl:when>
								<xsl:when test="@Cover='Covered'">Y</xsl:when>
								<xsl:when test="@Cover='Restricted'">R</xsl:when>
								<xsl:when test="@Cover='BLP'">R</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>				
						</xsl:otherwise>
						</xsl:choose>		
					</xsl:variable>
					<covered><xsl:value-of select="$covered" /></covered>
					
					<benefitLimitationPeriod>
						<xsl:choose>
							<xsl:when test="$covered='N'">-</xsl:when>
							<xsl:when test="h:LimitationPeriod and h:LimitationPeriod &gt; 0">
								<xsl:value-of select="h:LimitationPeriod" /><xsl:text> Months</xsl:text>
							</xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
					</benefitLimitationPeriod>
					
					<xsl:variable name="wpType">
						<xsl:choose>
							<xsl:when test="$elementName = 'Rehabilitation'">SubAcute</xsl:when>
							<xsl:when test="$elementName = 'Psychiatric'">SubAcute</xsl:when>
							<xsl:when test="$elementName = 'Palliative'">SubAcute</xsl:when>
							<xsl:when test="$elementName = 'Obstetric'">Obstetric</xsl:when>
							<xsl:when test="$elementName = 'AssistedReproductive'">Obstetric</xsl:when>
							<xsl:otherwise>Other</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<WaitingPeriodType><xsl:value-of select="$wpType" /></WaitingPeriodType>
					<WaitingPeriod>
						<xsl:choose>
							<xsl:when test="$covered='N'">-</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="wpElement" select="/h:Product/h:HospitalCover/h:WaitingPeriods/h:WaitingPeriod[@Title=$wpType]" />
								
								<xsl:variable name="wp"><xsl:value-of select="$wpElement/."/></xsl:variable>
								<xsl:variable name="unit">
									<xsl:choose>
										<xsl:when test="$wpElement/@Unit and normalize-space($wpElement/@Unit)!=''">
											<xsl:value-of select="$wpElement/@Unit" />
										</xsl:when>
										<xsl:otherwise>Month</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:choose>
									<xsl:when test="$wp = '' or $wp=0">No Waiting Period</xsl:when>
									<xsl:when test="number($wp) &gt; 1">
										<xsl:value-of select="concat(normalize-space($wp),' ',$unit,'s')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat(normalize-space($wp),' ',$unit)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>	
					</WaitingPeriod>
				</xsl:element>
			</xsl:for-each>
					
		</benefits>
	</xsl:template>

	<!-- WAITING PERIODS -->
	<xsl:template match="h:WaitingPeriods">
		<waitingPeriods>
			<xsl:for-each select="h:WaitingPeriod">
				<xsl:element name="{@Title}">
					<xsl:variable name="wp">
						<xsl:value-of select="." />
					</xsl:variable>
					<xsl:variable name="unit">
						<xsl:choose>
							<xsl:when test="@Unit and normalize-space(@Unit)!=''">
								<xsl:value-of select="@Unit" />
							</xsl:when>
							<xsl:otherwise>Month</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="number($wp) = 0">None</xsl:when>
						<xsl:when test="number($wp) &gt; 1">
							<xsl:value-of select="concat(normalize-space($wp),' ',$unit,'s')" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(normalize-space($wp),' ',$unit)" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
		</waitingPeriods>
	</xsl:template>

	<!-- EXCESSES -->
	<xsl:template match="h:Excesses">
		<xsl:variable name="excessPerPerson"><xsl:value-of select="h:ExcessPerPerson" /></xsl:variable>
		<xsl:variable name="excessPerAdmission"><xsl:value-of select="h:ExcessPerAdmission" /></xsl:variable>
		
		<excess>
			<xsl:choose>
				<xsl:when test="@ExcessType = 'None'">No Excess</xsl:when>
				<xsl:when test="@ExcessType = 'PerAdmissionOnly'">
					You will have to pay an excess of $<xsl:value-of select="h:ExcessPerAdmission" /> on admission.
				</xsl:when>
				<xsl:when test="@ExcessType = 'LimitedPerYear' and $excessPerAdmission = 0">
					You will have to pay an excess on admission.&lt;br /&gt;
					This is limited to a maximum of $<xsl:value-of select="h:ExcessPerPolicy" /> per year.
				</xsl:when>				
				<xsl:when test="@ExcessType = 'LimitedPerYear'">
					You will have to pay an excess of $<xsl:value-of select="h:ExcessPerAdmission" /> on admission.&lt;br /&gt;
					This is limited to a maximum of $<xsl:value-of select="h:ExcessPerPolicy" /> per year.
				</xsl:when>
				<xsl:when test="@ExcessType = 'LimitedPerPerson'">
					You will have to pay an excess of $<xsl:value-of select="h:ExcessPerAdmission" />	on admission.&lt;br /&gt;
					This is limited to a maximum of $<xsl:value-of select="h:ExcessPerPerson" /> per person per year.
				</xsl:when>
				<xsl:when test="@ExcessType = 'LimitedPerPersonPerPolicy' and $excessPerAdmission = 0 and $excessPerPerson != 0">
					You will have to pay an excess of $<xsl:value-of select="h:ExcessPerPerson" /> on admission.&lt;br /&gt;
					This is limited to a maximum of $<xsl:value-of select="h:ExcessPerPerson" /> per person and $<xsl:value-of select="h:ExcessPerPolicy" /> per policy per year.
				</xsl:when>
				
				<xsl:when test="@ExcessType = 'LimitedPerPersonPerPolicy'">
					You will have to pay an excess of $<xsl:value-of select="h:ExcessPerAdmission" /> on admission.&lt;br /&gt;
					This is limited to a maximum of $<xsl:value-of select="h:ExcessPerPerson" /> per person and $<xsl:value-of select="h:ExcessPerPolicy" /> per policy per year.
				</xsl:when>
			</xsl:choose>
		</excess>
		<waivers>
			<xsl:choose>
				<xsl:when test="count(h:ExcessWaivers/*)=0">
					<xsl:text>-</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="h:ExcessWaivers/*">
						<xsl:variable name="waiver">
							<xsl:value-of select="." />
						</xsl:variable>
						<xsl:variable name="waiverText">
							<xsl:choose>
								<xsl:when test="$waiver = 'DaySurgery'">Day surgery</xsl:when>
								<xsl:when test="$waiver = 'Dependents'">Dependent children</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$waiver" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>						
						
						<xsl:choose>
							<xsl:when test="position()=last()">
								<xsl:value-of select="$waiverText" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($waiverText,', ')" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</waivers>
	</xsl:template>

	<!-- COPAYMENTS -->
	<xsl:template match="h:CoPayments">
		<xsl:choose>
			<xsl:when test="@CoPaymentType = 'None'">
				<copayment>No Co-Payment</copayment>
			</xsl:when>
			<xsl:when test="@CoPaymentType = 'Limited' and h:Private != '' and h:PrivateMax != ''">
				<copayment>$<xsl:value-of select="h:Private" /> per night to a maximum of $<xsl:value-of select="h:PrivateMax" /> per admission.</copayment>
			</xsl:when>
			<xsl:otherwise>
				<copayment>TBA</copayment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- EXTRAS COVER -->
	<xsl:template name="GeneralHealthCover">
		<xsl:element name="extras">
		
			<xsl:if test="not(h:SpecialFeatures)">
				<xsl:element name="hasSpecialFeatures" namespace="">N</xsl:element>
				<xsl:element name="SpecialFeatures" namespace=""></xsl:element>
			</xsl:if>
		
			<xsl:for-each select="*">

				<xsl:choose>
					<xsl:when test="name()='GeneralHealthServices'">
						<xsl:for-each select="*">
							<xsl:call-template name="GeneralHealthService" />
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="name()='BenefitLimits'"></xsl:when>
					<xsl:when test="name()='SpecialFeatures'">
						<xsl:variable name="featureText">
							<xsl:value-of select="." />
						</xsl:variable>
						<xsl:element name="hasSpecialFeatures" namespace="">
							<xsl:choose>
								<xsl:when test="normalize-space($featureText)!=''">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="SpecialFeatures" namespace="">
							<xsl:value-of select="$featureText" />
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="{name()}" namespace="">
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>


			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- GENERAL HEALTH SERVICE -->
	<xsl:template name="GeneralHealthService">
		<xsl:element name="{@Title}">
			<covered>
				<xsl:choose>
					<xsl:when test="@Covered = '1'">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</covered>
			<hasSpecialFeatures>
				<xsl:choose>
					<xsl:when test="@HasSpecialFeatures = '1'">see special features</xsl:when>
					<xsl:otherwise>None</xsl:otherwise>
				</xsl:choose>
			</hasSpecialFeatures>
			<waitingPeriod>
				<xsl:choose>
					<xsl:when test="h:WaitingPeriod and h:WaitingPeriod != '0'">
						<xsl:value-of select="h:WaitingPeriod" />
						<xsl:text> Months</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>None</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</waitingPeriod>
			<benefits>
				<xsl:for-each select="h:BenefitsList/h:Benefit">
					<xsl:element name="{@Item}">
						<xsl:variable name="amt">
							<xsl:value-of select="." />
						</xsl:variable>
						<xsl:variable name="trimmedAmt">
							<xsl:choose>
								<xsl:when test="contains($amt,'.')">
									<xsl:value-of select="substring-before($amt,'.')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$amt" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="@Type='Dollars'">							
								<xsl:value-of select="concat('$',$trimmedAmt)" />
							</xsl:when>
							<xsl:when test="@Type='Percent'">
								<xsl:value-of select="concat($trimmedAmt,'%')" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$amt" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:for-each>
			</benefits>
			<benefitLimits>
				<xsl:call-template name="benefit-limits-group">
					<xsl:with-param name="limitName">
						<xsl:value-of select="h:BenefitLimitsGroup" />
					</xsl:with-param>
					<xsl:with-param name="benefitName"><xsl:value-of select="@Title" /></xsl:with-param>
				</xsl:call-template>
			</benefitLimits>
		</xsl:element>

	</xsl:template>

	<xsl:template name="benefit-limits-group">
		<xsl:param name="limitName">*NONE</xsl:param>
		<xsl:param name="benefitName">*NONE</xsl:param>
		
		<xsl:variable name="thisLimit" select="$benefitLimits[@Title=$limitName]" />

		<!-- TBA: Processing for NoLimitOnPreventativeDental -->

		<perPerson>
			<xsl:choose>
			<xsl:when test="$thisLimit/h:LimitPerPerson and $thisLimit/h:LimitPerPerson &gt; 0">
				$<xsl:value-of select="$thisLimit/h:LimitPerPerson" />
			</xsl:when>
			<xsl:otherwise>No limit</xsl:otherwise>
			</xsl:choose>
		</perPerson>
		<perPolicy>
			<xsl:choose>
			<xsl:when test="$thisLimit/h:LimitPerPolicy and $thisLimit/h:LimitPerPolicy &gt; 0">
				$<xsl:value-of select="$thisLimit/h:LimitPerPolicy" />
			</xsl:when>
			<xsl:otherwise>No limit</xsl:otherwise>
			</xsl:choose>
		</perPolicy>
		<annualLimit>
			<xsl:choose>	
				<xsl:when test="$thisLimit/h:AnnualLimit and $thisLimit/h:AnnualLimit != ''">No Annual Limit.</xsl:when>
				<xsl:otherwise>TBA</xsl:otherwise>
			</xsl:choose>
		</annualLimit>
		<lifetime>
			<xsl:choose>
				<xsl:when test="$thisLimit/h:ServicesCombined/h:Service[.=$benefitName and @IndLifetimeLimit!='']">
					$<xsl:value-of select="$thisLimit/h:ServicesCombined/h:Service[.=$benefitName]/@IndLifetimeLimit" />
				</xsl:when>	
				<xsl:when test="$thisLimit/h:LifetimeLimit and $thisLimit/h:LifetimeLimit &gt; 0">
					$<xsl:value-of select="$thisLimit/h:LifetimeLimit" />
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</lifetime>
		<xsl:variable name="servicesCombined" select="$thisLimit/h:ServicesCombined" />

		<xsl:variable name="includesOther">
			<xsl:choose>
				<xsl:when test="$servicesCombined/@IncludesOtherUnlisted and $servicesCombined/@IncludesOtherUnlisted='true'">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<combinedLimit>
			<xsl:choose>
				<!-- Handle most common case, a single child node with matching name 
					and not includes Other In this case - do nothing. -->
				<xsl:when test="count($servicesCombined/*) = 1 and $includesOther='N'">No group limit.&lt;br /&gt;See policy brochure</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$servicesCombined/*">
						<xsl:variable name="service">
							<xsl:value-of select="." />
						</xsl:variable>
						<xsl:variable name="serviceName">
							<xsl:value-of select="$luBenefitNames/item[@key=$service]" />
						</xsl:variable>
						<xsl:if test="position()=1">
							Group Limit:
						</xsl:if>
						<xsl:choose>
							<xsl:when test="position()=last() and $includesOther='Y'">
								<xsl:value-of select="concat($serviceName,' &amp; other services')" />
							</xsl:when>
							<xsl:when test="position()=last()">
								<xsl:value-of select="concat($serviceName,'.')" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat($serviceName,', ')" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</combinedLimit>

		<xsl:variable name="serviceLimit" select="$thisLimit/h:ServiceCountLimit" />
		<xsl:variable name="serviceCount" select="$serviceLimit/h:ServiceCount" />
		<xsl:variable name="serviceCountYears"
			select="$serviceLimit/h:ServiceCountYears" />
		<serviceLimit>
			<xsl:choose>
				<xsl:when test="$serviceLimit/@ServiceLimitType = 'Appliance'">
					<xsl:choose>
						<xsl:when test="$serviceCount = 1">
							<xsl:text>1 appliance every </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$serviceCount" />
							<xsl:text> appliances every </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$serviceCountYears = 1">year</xsl:when>
						<xsl:otherwise><xsl:value-of select="$serviceCountYears" /> years</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$serviceLimit/@ServiceLimitType = 'Service'">
					<xsl:choose>
						<xsl:when test="$serviceCount = 1">
							<xsl:text>1 every </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$serviceCount" />
							<xsl:text> every </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$serviceCountYears = 1">year</xsl:when>
						<xsl:otherwise><xsl:value-of select="$serviceCountYears" /> years</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				
				<xsl:otherwise>No service limit</xsl:otherwise>
			</xsl:choose>
		</serviceLimit>
	</xsl:template>

	<!-- UTILITY TEMPLATE: WRITE ATTRIBUTES AS ELEMENTS -->
	<xsl:template name="write-attribs-as-elements">
		<xsl:for-each select="@*">
			<xsl:element name="{name()}" namespace="">
				<xsl:value-of select="." />
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>