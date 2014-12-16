<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="getBenefits">
		<xsl:param name="planId" />
		<xsl:choose>
			<!-- Single Trip: Plan A - Comprehensive Single/DUO-->
			<xsl:when test="$planId = 51017 or $planId = 51018">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</expenses>
					<hospitalcas>
						<label>Hospital Cash Allowance</label>
						<desc>Hospital Cash Allowance</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</hospitalcas>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>25000</value>
						<text>$25,000</text>
						<order />
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>25000</value>
						<text>$25,000</text>
						<order />
					</disability>
					<income>
						<label>Loss of Income</label>
						<desc>Loss of Income</desc>
						<value>10400</value>
						<text>$10,400</text>
						<order />
					</income>	
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</traveldocs>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</cashtheft>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>500</value>
						<text>$500</text>
						<order />
					</luggagedel>	
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldelayExp>		
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</transport>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<rentalInsExcess>
						<label>Rental Vehicle Insurance Excess</label>
						<desc>Rental Vehicle Insurance Excess</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</rentalInsExcess>
					<serviceInsolven>
						<label>Travel Services Provider Insolvency</label>
						<desc>Travel Services Provider Insolvency</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</serviceInsolven>
			</xsl:when>
			<!-- Single Trip: Plan A - Comprehensive Family -->
			<xsl:when test="$planId = 51016">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</cxdfee>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</luggage>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</luggagedel>					
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</cashtheft>					
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</disability>					
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>100000</value>
						<text>$100,000</text>
						<order />
					</expenses>
					<hospitalcas>
						<label>Hospital Cash Allowance</label>
						<desc>Hospital Cash Allowance</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</hospitalcas>
					<income>
						<label>Loss of Income</label>
						<desc>Loss of Income</desc>
						<value>20800</value>
						<text>$20,800</text>
						<order />
					</income>			
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<rentalInsExcess>
						<label>Rental Vehicle Insurance Excess</label>
						<desc>Rental Vehicle Insurance Excess</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</rentalInsExcess>
					<serviceInsolven>
						<label>Travel Services Provider Insolvency</label>
						<desc>Travel Services Provider Insolvency</desc>
						<value>20000</value>
						<text>$20,000</text>
						<order />
					</serviceInsolven>
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</transport>
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>2000</value>
						<text>$2,000</text>
						<order />
					</traveldelayExp>					
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</traveldocs>
			</xsl:when>
			<!-- Single Trip: Plan B - Essentials Single/DUO-->
			<xsl:when test="$planId = 51021 or $planId = 51020">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</medical>
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</expenses>
					<hospitalcas>
						<label>Hospital Cash Allowance</label>
						<desc>Hospital Cash Allowance</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</hospitalcas>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>15000</value>
						<text>$15,000</text>
						<order />
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>15000</value>
						<text>$15,000</text>
						<order />
					</disability>
					<income>
						<label>Loss of Income</label>
						<desc>Loss of Income</desc>
						<value>5200</value>
						<text>$5,200</text>
						<order />
					</income>
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>500</value>
						<text>$500</text>
						<order />
					</traveldocs>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</cashtheft>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>1500</value>
						<text>$1,500</text>
						<order />
					</luggage>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>300</value>
						<text>$300</text>
						<order />
					</luggagedel>
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</traveldelayExp>
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>2000</value>
						<text>$2,000</text>
						<order />
					</transport>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>2000000</value>
						<text>$2,000,000</text>
						<order />
					</liability>
					<rentalInsExcess>
						<label>Rental Vehicle Insurance Excess</label>
						<desc>Rental Vehicle Insurance Excess</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</rentalInsExcess>
					<serviceInsolven>
						<label>Travel Services Provider Insolvency</label>
						<desc>Travel Services Provider Insolvency</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</serviceInsolven>
			</xsl:when>
			<!-- Single Trip: Plan B - Essentials Family -->
			<xsl:when test="$planId = 51019">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>10000000</value>
						<text>$10,000,000</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>10000000</value>
						<text>$10,000,000</text>
						<order />
					</medical>
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</expenses>
					<hospitalcas>
						<label>Hospital Cash Allowance</label>
						<desc>Hospital Cash Allowance</desc>
						<value>2000</value>
						<text>$2,000</text>
						<order />
					</hospitalcas>
					<death>
						<label>Accidental Death</label>
						<desc>Accidental Death</desc>
						<value>30000</value>
						<text>$30,000</text>
						<order />
					</death>
					<disability>
						<label>Permanent Disability</label>
						<desc>Permanent Disability</desc>
						<value>30000</value>
						<text>$30,000</text>
						<order />
					</disability>
					<income>
						<label>Loss of Income</label>
						<desc>Loss of Income</desc>
						<value>10,400</value>
						<text>$10,400</text>
						<order />
					</income>
					<traveldocs>
						<label>Travel Documents, Transaction Cards and Travellers Cheques</label>
						<desc>Travel Documents, Transaction Cards and Travellers Cheques</desc>
						<value>1,000</value>
						<text>$1,000</text>
						<order />
					</traveldocs>
					<cashtheft>
						<label>Theft of Cash</label>
						<desc>Theft of Cash</desc>
						<value>250</value>
						<text>$250</text>
						<order />
					</cashtheft>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</luggage>
					<luggagedel>
						<label>Luggage and PE Delay</label>
						<desc>Luggage and Personal Effects Delay Expenses</desc>
						<value>600</value>
						<text>$600</text>
						<order />
					</luggagedel>
					<traveldelayExp>
						<label>Travel Delay Expenses</label>
						<desc>Travel Delay Expenses</desc>
						<value>2000</value>
						<text>$2,000</text>
						<order />
					</traveldelayExp>
					<transport>
						<label>Alternative Transport Expenses</label>
						<desc>Alternative Transport Expenses</desc>
						<value>4000</value>
						<text>$4,000</text>
						<order />
					</transport>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>2000000</value>
						<text>$2,000,000</text>
						<order />
					</liability>
					<rentalInsExcess>
						<label>Rental Vehicle Insurance Excess</label>
						<desc>Rental Vehicle Insurance Excess</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</rentalInsExcess>
					<serviceInsolven>
						<label>Travel Services Provider Insolvency</label>
						<desc>Travel Services Provider Insolvency</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</serviceInsolven>
			</xsl:when>
			<!-- Single Trip: Plan C - Medical Only Single/DUO -->
			<xsl:when test="$planId = 51024 or $planId = 51023">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>0</value>
						<text>N/A</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>0</value>
						<text>N/A</text>
						<order />
					</luggage>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
			</xsl:when>
			<!-- Single Trip: Plan C - Medical Only Family -->
			<xsl:when test="$planId = 51022">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>0</value>
						<text>N/A</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<dental>
						<label>Dental</label>
						<desc>Dental</desc>
						<value>1000</value>
						<text>$1,000</text>
						<order />
					</dental>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>0</value>
						<text>N/A</text>
						<order />
					</luggage>
					<liability>
						<label>Personal Liability</label>
						<desc>Personal Liability</desc>
						<value>5000000</value>
						<text>$5,000,000</text>
						<order />
					</liability>
			</xsl:when>
			<!-- Multi Trip: Plan D - Mutli Trip-->
			<xsl:when test="$planId = 51025">
					<cxdfee>
						<label>Cancellation Fees</label>
						<desc>Cancellation Fees and Lost Deposits</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</cxdfee>
					<medicalAssi>
						<label>Overseas Medical Assistance</label>
						<desc>Overseas Emergency Medical Assistance</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medicalAssi>
					<medical>
						<label>Overseas Medical</label>
						<desc>Overseas Emergency Medical and Hospital Expenses</desc>
						<value>9.99999999E8</value>
						<text>Unlimited</text>
						<order />
					</medical>
					<expenses>
						<label>Additional Expenses</label>
						<desc>Additional Expenses</desc>
						<value>50000</value>
						<text>$50,000</text>
						<order />
					</expenses>
					<luggage>
						<label>Luggage and PE</label>
						<desc>Luggage and Personal Effects</desc>
						<value>5000</value>
						<text>$5,000</text>
						<order />
					</luggage>
					<rentalInsExcess>
						<label>Rental Vehicle Insurance Excess</label>
						<desc>Rental Vehicle Insurance Excess</desc>
						<value>3000</value>
						<text>$3,000</text>
						<order />
					</rentalInsExcess>
					<serviceInsolven>
						<label>Travel Services Provider Insolvency</label>
						<desc>Travel Services Provider Insolvency</desc>
						<value>10000</value>
						<text>$10,000</text>
						<order />
					</serviceInsolven>
			</xsl:when>
			<!-- Single Trip: Plan E - Trip Cancellation and Luggage Protection -->
			<xsl:when test="$planId = 51026 or $planId = 51027 or $planId = 51028 or $planId = 51029 or $planId = 51030 or $planId = 51031">
				<cxdfee>
					<label>Cancellation Fees</label>
					<desc>Cancellation Fees and Lost Deposits</desc>
					<xsl:choose>
						<xsl:when test="$planId = 51026">
							<value>500</value>
							<text>$500</text>
						</xsl:when>
						<xsl:when test="$planId = 51027">
							<value>1000</value>
							<text>$1,000</text>
						</xsl:when>
						<xsl:when test="$planId = 51028">
							<value>1500</value>
							<text>$1,500</text>
						</xsl:when>
						<xsl:when test="$planId = 51029">
							<value>2000</value>
							<text>$2,000</text>
						</xsl:when>
						<xsl:when test="$planId = 51030">
							<value>2500</value>
							<text>$2,500</text>
						</xsl:when>
						<xsl:when test="$planId = 51031">
							<value>3000</value>
							<text>$3,000</text>
						</xsl:when>
					</xsl:choose>
					<order />
				</cxdfee>
				<medical>
					<label>Overseas Medical</label>
					<desc>Overseas Emergency Medical and Hospital Expenses</desc>
					<value>0</value>
					<text>N/A</text>
					<order />
				</medical>
				<luggage>
					<label>Luggage and PE</label>
					<desc>Luggage and Personal Effects</desc>
					<xsl:choose>
						<xsl:when test="$planId = 51026">
							<value>500</value>
							<text>$500</text>
						</xsl:when>
						<xsl:when test="$planId = 51027">
							<value>1000</value>
							<text>$1,000</text>
						</xsl:when>
						<xsl:when test="$planId = 51028">
							<value>1500</value>
							<text>$1,500</text>
						</xsl:when>
						<xsl:when test="$planId = 51029">
							<value>2000</value>
							<text>$2,000</text>
						</xsl:when>
						<xsl:when test="$planId = 51030">
							<value>2500</value>
							<text>$2,500</text>
						</xsl:when>
						<xsl:when test="$planId = 51031">
							<value>3000</value>
							<text>$3,000</text>
						</xsl:when>
					</xsl:choose>
					<order />
				</luggage>
			</xsl:when>
			<xsl:otherwise>
				<info></info>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>