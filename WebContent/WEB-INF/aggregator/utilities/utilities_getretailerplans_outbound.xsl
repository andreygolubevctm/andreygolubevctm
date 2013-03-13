<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="packagetype" />
	<xsl:param name="classtype" />

<!-- VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/request">
		
		<SearchRetailer xmlns="http://switchwise.com.au/">
			<Postcode><xsl:value-of select="Postcode" /></Postcode>
			<ProductClassPackageType><xsl:value-of select="$packagetype"/></ProductClassPackageType>
			<ProductClassType><xsl:value-of select="$classtype"/></ProductClassType>
			<RetailerID><xsl:value-of select="RetailerID" /></RetailerID>
		</SearchRetailer>	
		
	</xsl:template>	

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

</xsl:stylesheet>