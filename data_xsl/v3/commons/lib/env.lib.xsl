<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="3.0">

<xsl:template name="xsltEngineInfo">
    <engine>

        <vendor><xsl:value-of select="system-property('xsl:vendor')"/></vendor>
        <product-name><xsl:value-of select="system-property('xsl:product-name')"/></product-name>
        <product-version><xsl:value-of select="system-property('xsl:product-version')"/></product-version>

        <isSaxHE><xsl:value-of select="starts-with(system-property('xsl:product-version'),'HE')"/></isSaxHE>


    </engine> 
</xsl:template>


</xsl:stylesheet>
