<?xml version="1.0"?>
<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="//*[name()='channel']/*[name()='link']"/>
    </xsl:attribute>
    <xsl:value-of select="//*[name()='channel']/*[name()='title']"/>
  </a>
  <ul>
    <xsl:for-each select="//*[name()='item']">
      <li>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="./*[name()='link']"/>
          </xsl:attribute>
          <xsl:value-of select="./*[name()='title']"/>
        </a>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>
</xsl:stylesheet>
