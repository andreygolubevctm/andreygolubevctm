<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:template match="/utilities">
	<SearchProducts xmlns='http://switchwise.com.au/' xmlns:i='http://www.w3.org/2001/XMLSchema-instance'>
		<ConnectionType><xsl:choose><xsl:when test="householdDetails/movingIn = 'Y'">MoveIn</xsl:when><xsl:otherwise>Transfer</xsl:otherwise></xsl:choose></ConnectionType>
		<CurrentUsage>
			<CurrentRetailers>
			<xsl:if test="householdDetails/howToEstimate = 'U'
					or (householdDetails/howToEstimate = 'S' and householdDetails/movingIn = 'N')
					or (householdDetails/howToEstimate = 'H' and householdDetails/movingIn = 'N')">
				<xsl:if test="householdDetails/whatToCompare = 'E' or householdDetails/whatToCompare = 'EG'">
				<CurrentRetailer>
				    <ProductClass>Electricity</ProductClass>
				    <ProductID><xsl:choose><xsl:when test="estimateDetails/usage/electricity/currentPlan = 'ignore'">0</xsl:when><xsl:otherwise><xsl:value-of select="estimateDetails/usage/electricity/currentPlan"/></xsl:otherwise></xsl:choose></ProductID>
				    <RetailerID><xsl:choose><xsl:when test="estimateDetails/usage/electricity/currentSupplier = 'ignore'">0</xsl:when><xsl:otherwise><xsl:value-of select="estimateDetails/usage/electricity/currentSupplier"/></xsl:otherwise></xsl:choose></RetailerID>
				</CurrentRetailer>
				</xsl:if>    
				<xsl:if test="householdDetails/whatToCompare = 'G' or householdDetails/whatToCompare = 'EG'">
				<CurrentRetailer>
				    <ProductClass>Gas</ProductClass>
				    <ProductID><xsl:choose><xsl:when test="estimateDetails/usage/gas/currentPlan = 'ignore'">0</xsl:when><xsl:otherwise><xsl:value-of select="estimateDetails/usage/gas/currentPlan"/></xsl:otherwise></xsl:choose></ProductID>
				    <RetailerID><xsl:choose><xsl:when test="estimateDetails/usage/gas/currentSupplier = 'ignore'">0</xsl:when><xsl:otherwise><xsl:value-of select="estimateDetails/usage/gas/currentSupplier"/></xsl:otherwise></xsl:choose></RetailerID>
				</CurrentRetailer>
				</xsl:if>			
			</xsl:if>			
			</CurrentRetailers>
			<EstimationType><xsl:choose>
			    <xsl:when test="householdDetails/howToEstimate = 'U'">Usage</xsl:when>
			    <xsl:when test="householdDetails/howToEstimate = 'H'">HouseholdSize</xsl:when>
			    <xsl:otherwise>Spend</xsl:otherwise>
			</xsl:choose></EstimationType>

			<HouseHold>
		    <xsl:if test="householdDetails/howToEstimate = 'H'">
				<NumberOfBedrooms><xsl:value-of select="estimateDetails/household/bedrooms" /></NumberOfBedrooms> 
  				<NumberOfPeople><xsl:value-of select="estimateDetails/household/people" /></NumberOfPeople> 
  				<PropertyType><xsl:choose>
			    <xsl:when test="estimateDetails/household/propertyType = 'U'">Unit</xsl:when>
			    <xsl:otherwise>House</xsl:otherwise>
			</xsl:choose></PropertyType>
			</xsl:if>
			</HouseHold>

			<MeterClassUsages>
			<xsl:if test="householdDetails/howToEstimate = 'U'">
				<xsl:if test="householdDetails/whatToCompare = 'E' or householdDetails/whatToCompare = 'EG'">
				<MeterClassUsage>
					<MeterUsages>
						<MeterUsage>
							<MeterType>Peak</MeterType> 
		  					<PeriodType><xsl:choose>
							    <xsl:when test="estimateDetails/usage/electricity/peak/period = 'M'">PerMonth</xsl:when>
							    <xsl:when test="estimateDetails/usage/electricity/peak/period = 'Q'">PerQuarter</xsl:when>
							    <xsl:otherwise>PerYear</xsl:otherwise>
							</xsl:choose></PeriodType> 
		  					<Quantity><xsl:value-of select="estimateDetails/usage/electricity/peak/amount" /></Quantity>
						</MeterUsage>
						<MeterUsage>
							<MeterType>OffPeak</MeterType> 
		  					<PeriodType><xsl:choose>
							    <xsl:when test="estimateDetails/usage/electricity/offpeak/period = 'M'">PerMonth</xsl:when>
							    <xsl:when test="estimateDetails/usage/electricity/offpeak/period = 'Q'">PerQuarter</xsl:when>
							    <xsl:otherwise>PerYear</xsl:otherwise>
							</xsl:choose></PeriodType> 
		  					<Quantity>
		  						<xsl:choose>
		  							<xsl:when test="estimateDetails/usage/electricity/offpeak/amount = ''">
		  								0
		  							</xsl:when>
		  							<xsl:otherwise>
		  								<xsl:value-of select="estimateDetails/usage/electricity/offpeak/amount" />
		  							</xsl:otherwise>
		  						</xsl:choose>
		  					</Quantity>
						</MeterUsage>
						<xsl:if test="estimateDetails/usage/electricity/shoulder/amount != '' and householdDetails/state = 'NSW'">
							<MeterUsage>
								<MeterType>Shoulder</MeterType> 
			  					<PeriodType><xsl:choose>
								    <xsl:when test="estimateDetails/usage/electricity/shoulder/period = 'M'">PerMonth</xsl:when>
								    <xsl:when test="estimateDetails/usage/electricity/shoulder/period = 'Q'">PerQuarter</xsl:when>
								    <xsl:otherwise>PerYear</xsl:otherwise>
								</xsl:choose></PeriodType> 
			  					<Quantity><xsl:value-of select="estimateDetails/usage/electricity/shoulder/amount" /></Quantity>
							</MeterUsage>
						</xsl:if>
					</MeterUsages>
	  				<ProductClass>Electricity</ProductClass>
				</MeterClassUsage>
				</xsl:if>
				<xsl:if test="householdDetails/whatToCompare = 'G' or householdDetails/whatToCompare = 'EG'">
				<MeterClassUsage>
					<MeterUsages>
						<MeterUsage>
							<MeterType>Peak</MeterType> 
		  					<PeriodType><xsl:choose>
							    <xsl:when test="estimateDetails/usage/gas/peak/period = 'M'">PerMonth</xsl:when>
							    <xsl:when test="estimateDetails/usage/gas/peak/period = '2'">Per2Month</xsl:when>
							    <xsl:when test="estimateDetails/usage/gas/peak/period = 'Q'">PerQuarter</xsl:when>
							    <xsl:otherwise>PerYear</xsl:otherwise>
							</xsl:choose></PeriodType> 
		  					<Quantity><xsl:value-of select="estimateDetails/usage/gas/peak/amount" /></Quantity>
						</MeterUsage>
						<MeterUsage>
							<MeterType>OffPeak</MeterType> 
		  					<PeriodType><xsl:choose>
							    <xsl:when test="estimateDetails/usage/gas/offpeak/period = 'M'">PerMonth</xsl:when>
							    <xsl:when test="estimateDetails/usage/gas/offpeak/period = '2'">Per2Month</xsl:when>
							    <xsl:when test="estimateDetails/usage/gas/offpeak/period = 'Q'">PerQuarter</xsl:when>
							    <xsl:otherwise>PerYear</xsl:otherwise>
							</xsl:choose></PeriodType> 
		  					<Quantity>
		  						<xsl:choose>
		  							<xsl:when test="estimateDetails/usage/gas/offpeak/amount = ''">
		  								0
		  							</xsl:when>
		  							<xsl:otherwise>
		  								<xsl:value-of select="estimateDetails/usage/gas/offpeak/amount" />
		  							</xsl:otherwise>
		  						</xsl:choose>
		  					</Quantity>
						</MeterUsage>
					</MeterUsages> 
	  				<ProductClass>Gas</ProductClass>
				</MeterClassUsage>
				</xsl:if>
			</xsl:if>
			</MeterClassUsages>
			<PlanSpends>
			<xsl:if test="householdDetails/howToEstimate = 'S'">
				<xsl:if test="householdDetails/whatToCompare = 'E' or householdDetails/whatToCompare = 'EG'">
				<SpendUsage>
					<Period><xsl:choose>
					    <xsl:when test="estimateDetails/spend/electricity/period = 'M'">PerMonth</xsl:when>
					    <xsl:when test="estimateDetails/spend/electricity/period = 'Q'">PerQuarter</xsl:when>
					    <xsl:otherwise>PerYear</xsl:otherwise>
					</xsl:choose></Period>
					<ProductClass>Electricity</ProductClass>
					<Quantity><xsl:value-of select="estimateDetails/spend/electricity/amount"/></Quantity>
				</SpendUsage>
				</xsl:if>
				<xsl:if test="householdDetails/whatToCompare = 'G' or householdDetails/whatToCompare = 'EG'">
				<SpendUsage>
					<Period><xsl:choose>
					    <xsl:when test="estimateDetails/spend/gas/period = 'M'">PerMonth</xsl:when>
					    <xsl:when test="estimateDetails/spend/gas/period = '2'">Per2Month</xsl:when>
					    <xsl:when test="estimateDetails/spend/gas/period = 'Q'">PerQuarter</xsl:when>
					    <xsl:otherwise>PerYear</xsl:otherwise>
					</xsl:choose></Period>
					<ProductClass>Gas</ProductClass>
					<Quantity><xsl:value-of select="estimateDetails/spend/gas/amount"/></Quantity>
				</SpendUsage>
				</xsl:if>
			</xsl:if>
			</PlanSpends>
			<MeterClassUsageDiscounts />
		</CurrentUsage>
		<Postcode><xsl:value-of select="householdDetails/postcode" /></Postcode>
		<ProductClassPackage><xsl:choose>
			    <xsl:when test="householdDetails/whatToCompare = 'E'">Electricity</xsl:when>
			    <xsl:when test="householdDetails/whatToCompare = 'G'">Gas</xsl:when>
			    <xsl:otherwise>ElectricityGas</xsl:otherwise>
			</xsl:choose>
		</ProductClassPackage>
		<SearchID>0</SearchID>
		<ShowResultType><xsl:choose>
				<xsl:when test="resultsDisplayed/resultsFor = 'GP'">Only green plans</xsl:when>
				<!-- [UTL-32] The fix in line below was commited against UTL-31 in error -->
				<xsl:when test="resultsDisplayed/resultsFor = 'NC'">No contract</xsl:when>
				<!-- End fix for [UTL-32] -->
				<xsl:otherwise>All</xsl:otherwise>
			</xsl:choose></ShowResultType>
		<State><xsl:value-of select="householdDetails/state" /></State>
		<RetailerIds i:nil='true' xmlns:a='http://schemas.microsoft.com/2003/10/Serialization/Arrays'/>
	</SearchProducts>
</xsl:template>
</xsl:stylesheet>