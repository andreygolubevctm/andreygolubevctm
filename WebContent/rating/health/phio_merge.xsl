<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:phio="http://admin.privatehealth.gov.au/ws/Schemas"
	xmlns="">
<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>

	<xsl:template match="/merge">
		
		<xsl:element name="Product" namespace="http://admin.privatehealth.gov.au/ws/Schemas">
			<xsl:attribute name="ProductCode">
				<xsl:for-each select="*">
					<xsl:value-of select="@ProductCode"/>
					<xsl:if test="position()=1">-</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
			<FundCode><xsl:value-of select="*[1]/phio:FundCode"/></FundCode>
			<State><xsl:value-of select="*[1]/phio:State"/></State>			
			<Category><xsl:value-of select="*[1]/phio:Category"/></Category>
			<ProductType>Combined</ProductType>
			<xsl:copy-of select="phio:Product/phio:HospitalCover" xmlns="" />
			<xsl:copy-of select="phio:Product/phio:GeneralHealthCover" xmlns="" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>