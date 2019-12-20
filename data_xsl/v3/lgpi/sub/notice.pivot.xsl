<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exch="http://www.epo.org/exchange" exclude-result-prefixes="xs xd exch" version="3.0">
    <!-- DOCTYPE xsl:stylesheet [
 <!ENTITY % docdb-entities SYSTEM "docdb-entities.dtd">
 %docdb-entities;
 ] -->

    <xd:doc scope="stylesheet/lgpi">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> convert to 'pivot'</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/notice.html5.xsl</xd:p>
            <xd:p><xd:b>Move:</xd:b>standalone templates to {collections}/lgpi/sub/notice.standalone.xsl</xd:p>
        </xd:desc>
    </xd:doc>


    <!-- ==== xsl:key ====  -->

    <xsl:key name="keyIpcr" match="//document[@type = 'notice']/notice/field/content//exch:exchange-document/exch:bibliographic-data/exch:classifications-ipcr/classification-ipcr" use="concat(substring(./text, 28, 1), substring(./text, 30, 1))"/>



    <!-- ==== main ====  -->

    <xsl:template match="document[@type = 'notice']" mode="pi">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="document-ordered-fields"/>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="document-ordered-fields">
        <xsl:choose>
            <xsl:when test="$pHtmlType = 'standalone'">
                <xsl:call-template name="pageStandalone"/>
            </xsl:when>
            <xsl:when test="$pHtmlType = 'embedded'">
                <xsl:if test="*[1]">
                    <!-- has one or more child -->
                    <docSection type="bibliography">
                        <!--<div debug="pivot_CHKME"> debug pivot.xsl cc</div>-->
                        <xsl:apply-templates/>
                    </docSection>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- ======== Contenu Textuel  ================ -->
    <xsl:template match="exch:p">
        <p>

            <xsl:choose>
                <xsl:when test="'exch:abstract' = name(..)">
                    <xsl:call-template name="attBiblioBlockPara">
                        <xsl:with-param name="att_lang" select="../@lang"/>
                    </xsl:call-template>

                    <xsl:if test="../@lang = 'en' and not(preceding-sibling::exch:p) and (../@country or ../@doc-number or ../@kind)">
                        <xsl:text>[origin: </xsl:text>
                        <xsl:for-each select="..">
                            <xsl:call-template name="tpl-LnkInt">
                                <xsl:with-param name="pStyle" select="'cInternalLnk'"/>
                                <xsl:with-param name="pCtry" select="@country"/>
                                <xsl:with-param name="pDocNum" select="@doc-number"/>
                                <xsl:with-param name="pKind" select="@kind"/>
                                <xsl:with-param name="pType">document</xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                        <xsl:text>] </xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="../@lang">
                        <xsl:attribute name="lang">
                            <xsl:value-of select="../@lang"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </p>
    </xsl:template>



    <xsl:template match="HIT">
        <span class="cHit" id="hitmimosa_{generate-id()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="exch:abstract | country | doc-number | kind | text">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="b | u | i | sup | sub | smallcaps">
        <xsl:element name="{name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="ul | ol">
        <xsl:element name="{name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="li">
        <xsl:element name="{name()}">
            <span lang="{$pLang}">
                <xsl:apply-templates/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test="(name(preceding-sibling::*[1]) = 'ol') or (name(preceding-sibling::*[1]) = 'ul')">
                <p lang="{$pLang}">
                    <xsl:value-of select="."/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="date">
        <xsl:call-template name="formatDate">
            <xsl:with-param name="pDate" select="."/>
        </xsl:call-template>
    </xsl:template>



</xsl:stylesheet>
