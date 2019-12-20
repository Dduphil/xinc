<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i_f="http://internalXslt/function" exclude-result-prefixes="xd xs i_f" version="3.0">
    <xd:doc scope="stylesheet/libXsl">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> 'pivot' functions or templates</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201812 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>[uosss new file]</xd:p>
        </xd:desc>
    </xd:doc>


    <!-- ==== add attributes for 'pivot' ====  -->
    <xsl:template name="attBiblioBlock">
        <xsl:param name="extra_class"/>

        <xsl:attribute name="class" select="concat('mt skiptranslate ', $extra_class)"/>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>

    <xsl:template name="attBiblioBlockTitle">
        <xsl:param name="extra_class"/>

        <xsl:attribute name="class" select="concat('coGrey skiptranslate ', $extra_class)"/>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>

    <xsl:template name="attBiblioBlockPara">
        <xsl:param name="att_lang"/>
        <xsl:if test="'' != $att_lang">
            <xsl:attribute name="lang">
                <xsl:value-of select="$att_lang"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="class">ml2 skiptranslate</xsl:attribute>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>

</xsl:stylesheet>
