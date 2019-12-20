<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b>convert 'pivot' to 'xsl-fo' for 'pdf' rendition.</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="../../pivot/param/params.dev.xsl"/>

    <xsl:include href="../../pivot/sub/pivot.pdf.xsl"/>
    
    <xd:doc scope="pi:h5:[dev]/main:fo">
        <xd:desc>call '../../pivot/sub/pivot.pdf.xsl' in 'fo' mode</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:apply-templates select="pivot"  mode="fo"/>
    </xsl:template>

</xsl:stylesheet>