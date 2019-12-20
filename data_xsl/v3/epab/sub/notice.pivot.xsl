<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Nov 22, 2019</xd:p>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p>
                <xd:ul>
                    <xd:li/>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>


    <xsl:template match="document" mode="pi">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="document-ordered-fields"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="document-ordered-fields">
        <xsl:if
            test="//SDOBI[count(child::*) &gt; 0] or //legal-status or //description[count(child::*) &gt; 0] or //claims[count(child::*) &gt; 0]//claim/claim-text or //drawings[count(child::*) &gt; 0] or //search-report-data[count(child::*) &gt; 0]">
            <xsl:if test="count(*) &gt; 0">
                <section trace="bibliography">
                    <xsl:apply-templates select="*"/>
                </section>
            </xsl:if>

            <!-- TODO
            
            <xsl:apply-templates select="//ep-patent-document/legal-status"/>
            <xsl:apply-templates select="//ep-patent-document/description"/>
            <xsl:apply-templates select="//ep-patent-document/drawings"/>
            <xsl:apply-templates select="//ep-patent-document/search-report-data-img"/>
            <xsl:apply-templates select="//ep-patent-document/search-report-data-text"/>
            
-->
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
