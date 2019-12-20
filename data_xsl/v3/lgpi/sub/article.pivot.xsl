<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exch="http://www.epo.org/exchange" exclude-result-prefixes="xs xd exch" version="3.0">

    <?xslDoc his="201608, Xsl GPI Legal Status (xgl)"?>

    <xd:doc scope="stylesheet/LGPI">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> convert to 'pivot'</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/notice-article.xsl</xd:p>
        </xd:desc>
    </xd:doc>

    <xd:doc scope="template/lgpi/biblio" id="tpl_BiblioTitle">
        <xd:desc>
            <xd:p>get biblio title for $level</xd:p>
            <xd:p><xd:b>$level</xd:b> title level</xd:p>
            <xd:p><xd:b>$att_lang</xd:b> overwrite @lang </xd:p>
            <xd:p><xd:b>$extra_class</xd:b> add extra class (to suppress ??)</xd:p>
            <xd:p><xd:b>$val_label</xd:b> replace contextual(local-name()) label resolution</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="tpl_BiblioTitle">
        <xsl:param name="level" as="xs:integer">1</xsl:param>
        <xsl:param name="att_lang"/>
        <xsl:param name="extra_class"/>
        <xsl:param name="val_label"/>

        <xsl:variable name="tagTile">
            <xsl:choose>
                <xsl:when test="2 = $level">divTitle2</xsl:when>
                <xsl:otherwise>divTitle</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$tagTile}">
            <xsl:if test="'' != $att_lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="$att_lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="attBiblioBlockTitle">
                <xsl:with-param name="extra_class" select="$extra_class"/>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="'' != $val_label">
                    <xsl:value-of select="$val_label"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="tpl-LabelTxt"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>


    <!--=== document global variable ===-->
    <xsl:variable name="docPubCountry">
        <xsl:choose>
            <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'docdb']">
                <xsl:value-of select="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'docdb']/document-id/country"/>
            </xsl:when>
            <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'epodoc']">
                <xsl:value-of select="substring(//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'epodoc1400']/document-id/doc-number, 1, 2)"/>
            </xsl:when>
            <!-- TODO : complete $docPubCountry with 'docdba', 'original' -->
        </xsl:choose>
    </xsl:variable>



    <!-- ==== HIT ====  -->

    <xsl:template match="exch:previously-filed-app/HIT | exch:previously-filed-app/hit">
        <?xslCmt msg="MANTIS#99903"?>
        <span class="cHit" id="hitmimosa_{generate-id()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <xsl:template name="tpl-hasHit">
        <!--# @ 'exch:publication-reference|classification-scheme|exch:...|' level -->
        <xsl:choose>
            <xsl:when test="document-id/HIT | HIT">
                <span class="cHit" id="hitmimosa_{generate-id()}">
                    <xsl:apply-templates select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--=== templates ===-->

    <xsl:template match="TIEN | TIDE | TIFR">
        <xsl:variable name="vCodeLang">
            <xsl:call-template name="lib-lower">
                <xsl:with-param name="val" select="substring(name(), 3)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$vTitleFormat != 'none' and //document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[@lang = $vCodeLang and @data-format = $vTitleFormat]">
            <div class="skiptranslate">
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[@lang = $vCodeLang and @data-format = $vTitleFormat]">
                    <!--# change context -->
                    <p>
                        <xsl:call-template name="attBiblioBlockPara"/>
                        <xsl:attribute name="lang">
                            <xsl:value-of select="$vCodeLang"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="."/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="TIXX">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'original']">original</xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$vDataFormat != 'none'">
            <div class="skiptranslate">
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = $vDataFormat]">
                    <!--# change context -->
                    <p>
                        <xsl:call-template name="attBiblioBlockPara">
                            <xsl:with-param name="att_lang" select="@lang"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="."/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="exch:invention-title">
        <xsl:apply-templates/>
    </xsl:template>




    <xsl:template match="PU">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = 'original']">original</xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$vDataFormat != 'none'">

            <!--<div debug="pivot_CHKME"> debug article.pivot.xsl cc</div>-->

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = $vDataFormat][1]">
                    <!--# change context -->
                    <p>
                        <xsl:call-template name="attBiblioBlockPara"/>
                        <xsl:call-template name="tpl-hasHit"/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="tpl-body-exch-publication-reference">
        <!--# @ 'exch:publication-reference' level -->
        <xsl:call-template name="tpl-DocId-full"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:if test="../exch:language-of-publication">
            <xsl:value-of select="concat('(', upper-case(../exch:language-of-publication), ')')"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="exch:publication-reference">
        <xsl:variable name="vDataLinkTypeAndUrl">
            <xsl:call-template name="tpl-TypUrlEspacenet">
                <xsl:with-param name="fLang" select="$pLang"/>
                <xsl:with-param name="fLinkFormat" select="'GPI'"/>
                <xsl:with-param name="fKind" select="./document-id//kind"/>
                <xsl:with-param name="fPubCountry" select="./document-id//country"/>
                <xsl:with-param name="fPubNumber" select="./document-id//doc-number"/>
                <xsl:with-param name="fDocPart" select="'biblio'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$vDataLinkTypeAndUrl != '_'">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="substring-after($vDataLinkTypeAndUrl, '!')"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-link-type">
                        <xsl:value-of select="substring-before($vDataLinkTypeAndUrl, '!')"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:attribute name="class">cPubNumber cExternalLnk</xsl:attribute>
                    <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_PN</xsl:with-param></xsl:call-template></xsl:attribute-->
                    <xsl:call-template name="tpl-body-exch-publication-reference"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tpl-body-exch-publication-reference"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="AP">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:application-reference[@data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:application-reference[@data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:application-reference[@data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:application-reference[@data-format = 'original']">original</xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$vDataFormat != 'none'">
            <div class="skiptranslate">
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:application-reference[@data-format = $vDataFormat][1]">
                    <!--# change context -->
                    <p>
                        <xsl:call-template name="attBiblioBlockPara"/>
                        <xsl:call-template name="tpl-hasHit"/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>



    <xsl:template name="tpl-appBody">
        <!-- xx IN(exch:application-reference) -->
        <xsl:call-template name="tpl-DocId-full"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:if test="../exch:language-of-filing">
            <xsl:text>(</xsl:text>
            <xsl:call-template name="lib-upper">
                <xsl:with-param name="val" select="../exch:language-of-filing"/>
            </xsl:call-template>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>



    <xsl:template match="exch:application-reference">
        <xsl:variable name="vDataLinkTypeAndUrl">
            <xsl:call-template name="tpl-TypUrlRegisterLink">
                <xsl:with-param name="fLang" select="$pLang"/>
                <!-- xx pLang=uiLang, not $vLang -->
                <xsl:with-param name="fLinkFormat" select="'GPI'"/>
                <xsl:with-param name="fCountry" select="./document-id//country"/>
                <xsl:with-param name="fAppNumber" select="./document-id//doc-number"/>
                <xsl:with-param name="fAppDate" select="./document-id//date"/>
                <xsl:with-param name="fKind" select="./document-id//kind"/>
                <xsl:with-param name="fPubCountry" select="$docPubCountry"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- [DBG/]
        <xsl:value-of select="concat('DBG:AAAAAAAA',$vDataLinkTypeAndUrl)"/>
         -->

        <xsl:choose>
            <xsl:when test="$vDataLinkTypeAndUrl != '_'">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="substring-after($vDataLinkTypeAndUrl, '!')"/>
                    </xsl:attribute>
                    <xsl:attribute name="data-link-type">
                        <xsl:value-of select="substring-before($vDataLinkTypeAndUrl, '!')"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:attribute name="class">cAppNumber cExternalLnk</xsl:attribute>
                    <xsl:call-template name="tpl-appBody"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tpl-appBody"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="PR">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = 'original']">original</xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$vDataFormat != 'none'">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:variable name="vNumOcc" select="count(//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = $vDataFormat])"/>
                <xsl:choose>
                    <xsl:when test="$vNumOcc > 1">
                        <ul>
                            <!-- muti-occurent -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = $vDataFormat]">
                                <!--# change context -->
                                <li>
                                    <xsl:call-template name="tpl-hasHit"/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- mono-occurent -->
                        <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:priority-claims/exch:priority-claim[@data-format = $vDataFormat]">
                            <!--# change context -->
                            <p>
                                <xsl:call-template name="attBiblioBlockPara"/>
                                <xsl:call-template name="tpl-hasHit"/>
                            </p>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="exch:priority-claim">
        <xsl:call-template name="tpl-DocId-full"/>
    </xsl:template>

    <xsl:template match="ABEN | ABDE | ABFR">
        <xsl:variable name="vCodeLang" select="lower-case(substring(local-name(), 3))"/>
        <xsl:choose>
            <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang]">
                <xsl:variable name="vDataFormat">
                    <xsl:choose>
                        <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang and @data-format = 'docdb']">docdb</xsl:when>
                        <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang and @data-format = 'docdba']">docdba</xsl:when>
                        <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang and @data-format = 'epodoc']">epodoc</xsl:when>
                        <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang and @data-format = 'original']">original</xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$vDataFormat != 'none'">
                    <div data-part="abstract">
                        <xsl:call-template name="attBiblioBlock"/>
                        <xsl:call-template name="tpl_BiblioTitle"/>
                        <xsl:apply-templates select="//document[@type = 'notice']//exch:exchange-document/exch:abstract[@lang = $vCodeLang and @data-format = $vDataFormat]"/>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- WARNING!! code mort à supprimé car pas de "exch:abstract[@lang = $vCodeLang]" --> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ABXX">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:exchange-document/exch:abstract[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = 'original']">original</xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$vDataFormat != 'none'">
            <div data-part="abstract">
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:exchange-document/exch:abstract[not(@lang = 'de' or @lang = 'en' or @lang = 'fr') and @data-format = $vDataFormat]">
                    <!--# change context -->
                    <p>
                        <xsl:call-template name="attBiblioBlockPara"/>
                        <xsl:apply-templates select="."/>
                    </p>
                </xsl:for-each>

            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="INVE">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <!-- ATT!! on considere que toutes la liste est au @data-format -->
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = 'original']">original</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$vDataFormat != ''">


            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:choose>
                    <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = $vDataFormat and @sequence = 2]">
                        <ul>
                            <!-- muti-occurent -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = $vDataFormat]">
                                <li>
                                    <xsl:call-template name="INV_01"/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- mono-occurent -->
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:inventors/exch:inventor[@data-format = $vDataFormat]">
                                <xsl:call-template name="INV_01"/>
                            </xsl:for-each>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- parties name -->
    <xsl:template name="name">
        <xsl:apply-templates select="."/>
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <xsl:template name="INV_01">
        <xsl:variable name="vSeq" select="@sequence"/>
        <xsl:for-each select="./exch:inventor-name/*">
            <xsl:apply-templates/>
        </xsl:for-each>
        <!-- 20080821 Avant deux cas :
      1/ test="string-length(./residence/country) &gt; 0"
      d'ou <country>
      puis test="../exch:inventor[@data-format ='docdba' and @sequence = $vSeq]/address/text"
      alors  "- " + <tex>t
      2/  test="../exch:inventor[@data-format ='docdba' and @sequence = $vSeq]/address/text"
      d'ou "- " +  <xsl:value-of select="./following-sibling::exch:inventor[@data-format ='docdba' and @sequence = $vSeq]/address/text">
    -->
        <xsl:if test="string-length(./residence/country) &gt; 0">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="./residence/country"/>
            <xsl:text>) </xsl:text>
        </xsl:if>
        <!--[20140417 anonymisation]xsl:if test="../exch:inventor[@data-format ='docdba' and @sequence = $vSeq]/address/text">
            <xsl:text>- </xsl:text>
            <xsl:apply-templates
                select="../exch:inventor[@data-format ='docdba' and @sequence = $vSeq]/address/text"/>
        </xsl:if-->
    </xsl:template>

    <xsl:template match="APPL">
        <xsl:variable name="vDataFormat">
            <xsl:choose>
                <!-- ATT!! on considere que toutes la liste est au @data-format -->
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = 'docdb']">docdb</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = 'docdba']">docdba</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = 'epodoc']">epodoc</xsl:when>
                <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = 'original']">original</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!--[DVP]><dd>dbg: vDataFormat</dd><dl>'<xsl:value-of select="$vDataFormat"/>'</dl><![/DVP]-->
        <xsl:if test="$vDataFormat != ''">


            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:choose>
                    <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = $vDataFormat and @sequence = 2]">
                        <ul>
                            <!-- muti-occurent -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = $vDataFormat]">
                                <li>
                                    <xsl:call-template name="APP_01"/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <!-- mono-occurent -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:parties/exch:applicants/exch:applicant[@data-format = $vDataFormat]">
                                <xsl:call-template name="APP_01"/>
                            </xsl:for-each>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="APP_01">
        <xsl:variable name="vSeq" select="@sequence"/>
        <xsl:for-each select="./exch:applicant-name/*">
            <xsl:apply-templates/>
        </xsl:for-each>
        <xsl:if test="string-length(./residence/country) &gt; 0">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="./residence/country"/>
            <xsl:text>) </xsl:text>
        </xsl:if>
        <!--[20140417 anonymisation]xsl:if test="../exch:applicant[@data-format ='docdba' and @sequence = $vSeq]/address/text">
            <xsl:text>- </xsl:text>
            <xsl:apply-templates select="../exch:applicant[@data-format ='docdba' and @sequence = $vSeq]/address/text"/>
        </xsl:if-->
    </xsl:template>

    <xsl:template match="IC17">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc">


            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/main-classification">
                        <xsl:call-template name="tpl-Ipc7">
                            <!-- Une Seule classification principale -->
                            <xsl:with-param name="ipc" select="."/>
                            <xsl:with-param name="edition" select="../edition"/>
                            <xsl:with-param name="style" select="'cClassIpc17Main'"/>
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/further-classification">
                        <xsl:text>; </xsl:text>
                        <!-- plusieurs classification secondaire -->
                        <xsl:call-template name="tpl-Ipc7">
                            <xsl:with-param name="ipc" select="."/>
                            <xsl:with-param name="edition" select="../edition"/>
                            <xsl:with-param name="style" select="'cClassIpc17Further'"/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:if
                        test="
                            (//document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/main-classification
                            or
                            //document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/further-classification)
                            and
                            //document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/text">
                        <xsl:text>; </xsl:text>
                    </xsl:if>

                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:classification-ipc/text">
                        <!-- exch:classification-ipc/text -->
                        <xsl:variable name="ipc-text">
                            <!-- [ori]
                            <xsl:choose>
                                <xsl:when test="../edition">
                                    <xsl:value-of select="concat(' ',../edition,normalize-space(.))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat(' ',' ',normalize-space(.))"/>
                                </xsl:otherwise>
                            </xsl:choose>
-->
                            <!-- [uoss] -->
                            <xsl:value-of select="concat(../edition, normalize-space(.))"/>
                        </xsl:variable>
                        <xsl:call-template name="tpl-Ipc7">
                            <xsl:with-param name="ipc" select="$ipc-text"/>
                            <xsl:with-param name="style" select="'cClassIpc17Text'"/>
                            <!--[uoss] with-param name="pOutput">html5</x.l:with-param-->
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ICM | ICF">
        <xsl:choose>
            <xsl:when test="name() = 'ICM'">
                <xsl:if test="(count(key('keyIpcr', 'CI')) + count(key('keyIpcr', 'CN')) &gt; 0) or (count(key('keyIpcr', 'SI')) + count(key('keyIpcr', 'SN')) &gt; 0)">
                    <div>
                        <xsl:call-template name="attBiblioBlock"/>

                        <!-- xsl:when test="name() = 'ICC'" -->
                        <xsl:if test="count(key('keyIpcr', 'CI')) + count(key('keyIpcr', 'CN')) &gt; 0">
                            <!-- classifications C -->
                            <xsl:call-template name="tpl_BiblioTitle"/>
                            <p>
                                <xsl:call-template name="attBiblioBlockPara"/>
                                <xsl:for-each select="key('keyIpcr', 'CI')">
                                    <xsl:call-template name="tpl-Ipc8">
                                        <xsl:with-param name="ipc" select="./text"/>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="count(key('keyIpcr', 'CI')) &gt; 0 and count(key('keyIpcr', 'CN')) &gt; 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                                <xsl:for-each select="key('keyIpcr', 'CN')">
                                    <xsl:call-template name="tpl-Ipc8">
                                        <xsl:with-param name="ipc" select="./text"/>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </p>
                        </xsl:if>

                        <xsl:if test="count(key('keyIpcr', 'SI')) + count(key('keyIpcr', 'SN')) &gt; 0">
                            <!-- classifications S -->
                            <xsl:call-template name="tpl_BiblioTitle"/>
                            <p>
                                <xsl:call-template name="attBiblioBlockPara"/>
                                <xsl:for-each select="key('keyIpcr', 'SI')">
                                    <xsl:call-template name="tpl-Ipc8">
                                        <xsl:with-param name="ipc" select="./text"/>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if test="count(key('keyIpcr', 'SI')) &gt; 0 and count(key('keyIpcr', 'SN')) &gt; 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                                <xsl:for-each select="key('keyIpcr', 'SN')">
                                    <xsl:call-template name="tpl-Ipc8">
                                        <xsl:with-param name="ipc" select="./text"/>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </p>
                        </xsl:if>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="count(key('keyIpcr', 'AI')) + count(key('keyIpcr', 'AN')) &gt; 0">
                    <!-- classifications A -->
                    <div>
                        <xsl:call-template name="attBiblioBlock"/>
                        <xsl:call-template name="tpl_BiblioTitle"/>
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:for-each select="key('keyIpcr', 'AI')">
                                <xsl:call-template name="tpl-Ipc8">
                                    <xsl:with-param name="ipc" select="./text"/>
                                </xsl:call-template>
                                <xsl:if test="position() != last()">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:if test="count(key('keyIpcr', 'AI')) &gt; 0 and count(key('keyIpcr', 'AN')) &gt; 0">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                            <xsl:for-each select="key('keyIpcr', 'AN')">
                                <xsl:call-template name="tpl-Ipc8">
                                    <xsl:with-param name="ipc" select="./text"/>
                                </xsl:call-template>
                                <xsl:if test="position() != last()">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </p>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="CPC">
        <xsl:choose>
            <xsl:when test="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/patent-classification[classification-scheme/@scheme = 'CPC']">
                <div>
                    <xsl:call-template name="attBiblioBlock"/>
                    <xsl:call-template name="tpl_BiblioTitle"/>
                    <xsl:for-each select="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications">
                        <!-- change context -->
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="type">CPC</xsl:with-param>
                            </xsl:apply-templates>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:when>
            <xsl:when test="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme/@scheme = 'CPCI'">
                <!--cmt for 'CPCI' -->


                <div>
                    <xsl:call-template name="attBiblioBlock"/>
                    <xsl:call-template name="tpl_BiblioTitle"/>
                    <xsl:for-each select="exch:exchange-document/exch:bibliographic-data/exch:patent-classifications">
                        <!-- change context -->
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="type">CPC</xsl:with-param>
                            </xsl:apply-templates>
                        </p>
                    </xsl:for-each>
                </div>

                <div>
                    <xsl:for-each select="//exch:exchange-document[1]/exch:bibliographic-data[1]/exch:patent-classifications[1]">
                        <!--# change context -->
                        <xsl:variable name="vLabel">
                            <xsl:call-template name="get-label">
                                <xsl:with-param name="id" select="'CPC_CPCI'"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="concat(./@cpc-generating-office, ')')"/>
                        </xsl:variable>

                        <xsl:call-template name="tpl_BiblioTitle">
                            <xsl:with-param name="val_label" select="$vLabel"/>
                        </xsl:call-template>

                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:variable name="vhasMutilpleGenOffice" select="contains(@cpc-generating-office, ' ')"/>

                            <xsl:for-each select="patent-classification[classification-scheme/@scheme = 'CPCI']">
                                <xsl:call-template name="tpl-classif-cpc">
                                    <xsl:with-param name="current-cla" select="string(./classification-symbol)"/>
                                    <xsl:with-param name="hit">
                                        <xsl:if test="./classification-symbol/HIT">yes</xsl:if>
                                    </xsl:with-param>
                                    <xsl:with-param name="vLang" select="$vLang"/>
                                    <xsl:with-param name="type">CPC</xsl:with-param>
                                    <xsl:with-param name="value" select="./classification-value"/>
                                    <xsl:with-param name="pType">cpc</xsl:with-param>
                                    <xsl:with-param name="hasMutilpleGenOffice" select="$vhasMutilpleGenOffice"/>
                                </xsl:call-template>
                                <xsl:if test="(position() != last())">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </p>
                    </xsl:for-each>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="CNO">
        <xsl:if test="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/patent-classification[classification-scheme/@scheme = 'CPCNO']">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:apply-templates select="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications">
                        <xsl:with-param name="type">CPCNO</xsl:with-param>
                    </xsl:apply-templates>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="CSC | CSO">
        <xsl:variable name="vField" select="name()"/>
        <xsl:choose>
            <xsl:when
                test="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/combination-set/combination-rank/patent-classification[(classification-scheme/@scheme = 'CPC' and $vField = 'CSC') or (classification-scheme/@scheme = 'CPCNO' and $vField = 'CSO')]">
                <div>
                    <xsl:call-template name="attBiblioBlock"/>
                    <xsl:call-template name="tpl_BiblioTitle"/>
                    <xsl:variable name="vCheckType">
                        <xsl:choose>
                            <xsl:when test="$vField = 'CSC'">CPC</xsl:when>
                            <xsl:otherwise>CPCNO</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="vNumOcc" select="count(//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/combination-set[(combination-rank/patent-classification/classification-scheme/@scheme = $vCheckType)])"/>
                    <xsl:choose>
                        <xsl:when test="$vNumOcc &gt; 1">
                            <!-- muti-occurent -->
                            <ol>
                                <xsl:for-each select="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/combination-set[(combination-rank/patent-classification/classification-scheme/@scheme = $vCheckType)]">
                                    <xsl:element name="li">
                                        <xsl:apply-templates select="combination-rank[(patent-classification/classification-scheme/@scheme = $vCheckType)]">
                                            <xsl:with-param name="type" select="$vCheckType"/>
                                        </xsl:apply-templates>
                                    </xsl:element>
                                </xsl:for-each>
                            </ol>
                        </xsl:when>
                        <xsl:otherwise>
                            <p>
                                <xsl:call-template name="attBiblioBlockPara"/>
                                <xsl:apply-templates select="//exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/combination-set/combination-rank[(patent-classification/classification-scheme/@scheme = $vCheckType)]">
                                    <xsl:with-param name="type" select="$vCheckType"/>
                                </xsl:apply-templates>
                            </p>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:when>
            <xsl:when test="'CSC' = local-name() and //exch:exchange-document/exch:bibliographic-data/exch:patent-classifications/combination-set//classification-scheme/@scheme = 'CPCI'">
                <!--cmt for 'CPCI' -->
                <div>
                    <xsl:call-template name="attBiblioBlock"/>
                    <xsl:for-each select="//exch:exchange-document[1]/exch:bibliographic-data[1]/exch:patent-classifications[1]">
                        <!--cmt for-each just to change the context to 'exch:patent-classifications' -->
                        <xsl:variable name="vLabel">
                            <xsl:call-template name="get-label">
                                <xsl:with-param name="id" select="'CSC_CPCI'"/>
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="concat(@cset-generating-office, ')')"/>
                        </xsl:variable>
                        <!-- tpl-Label-format -->
                        <xsl:call-template name="tpl_BiblioTitle">
                            <xsl:with-param name="val_label" select="$vLabel"/>
                        </xsl:call-template>

                        <xsl:for-each select="./combination-set[group-number[1] = 1][./combination-rank[1]/patent-classification[1]/classification-scheme[1]/@scheme = 'CPCI']">

                            <xsl:variable name="vGenOffice" select="./combination-rank[1]/patent-classification[1]/generating-office[1]"/>

                            <!-- if only one 'C-set GrpNbr 1' implies no 'office title' -->
                            <xsl:if test="last() &gt; 1">
                                <p class="subLevelTitle">
                                    <xsl:value-of select="$vGenOffice"/>
                                </p>
                            </xsl:if>

                            <!-- if multiple 'cset/group-number' use list, otherwise use para-->
                            <xsl:variable name="vNbCsetByOffice"
                                select="count(../combination-set[./combination-rank[1]/patent-classification[1]/generating-office[1] = $vGenOffice][./combination-rank[1]/patent-classification[1]/classification-scheme[1]/@scheme = 'CPCI'])"/>

                            <xsl:if test="contains($vDbgXslt, '_d_msg_')">
                                <xsl:message>
                                    <xsl:value-of select="concat('cc=', $vGenOffice, ' nbCset=', $vNbCsetByOffice)"/>
                                </xsl:message>
                            </xsl:if>
                            <xsl:choose>
                                <xsl:when test="$vNbCsetByOffice = 1">
                                    <xsl:for-each select="../combination-set[./combination-rank[1]/patent-classification[1]/generating-office[1] = $vGenOffice][./combination-rank[1]/patent-classification[1]/classification-scheme[1]/@scheme = 'CPCI']">
                                        <!-- chg context -->
                                        <p class="subLevelData">
                                            <xsl:apply-templates select="./combination-rank">
                                                <xsl:with-param name="type">CPCI</xsl:with-param>
                                            </xsl:apply-templates>
                                        </p>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ol class="subLevelData">
                                        <xsl:for-each
                                            select="../combination-set[./combination-rank[1]/patent-classification[1]/generating-office[1] = $vGenOffice][./combination-rank[1]/patent-classification[1]/classification-scheme[1]/@scheme = 'CPCI']">
                                            <li>
                                                <xsl:apply-templates select="combination-rank">
                                                    <xsl:with-param name="type">CPCI</xsl:with-param>
                                                </xsl:apply-templates>
                                            </li>
                                        </xsl:for-each>
                                    </ol>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                    <p class="subLevelData">&#160;</p>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="combination-rank">
        <xsl:param name="type"/>
        <xsl:apply-templates select="patent-classification[classification-scheme/@scheme = $type and (contains(./classification-symbol, ':') or contains(./classification-symbol, '/'))]">
            <xsl:sort select="classification-value" order="descending"/>
            <xsl:with-param name="type">CS</xsl:with-param>
        </xsl:apply-templates>
        <xsl:if test="following-sibling::combination-rank[patent-classification/classification-scheme/@scheme = $type and (contains(./patent-classification/classification-symbol, ':') or contains(./patent-classification/classification-symbol, '/'))]">
            <xsl:text> + </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="exch:patent-classifications">
        <xsl:param name="type"/>
        <xsl:apply-templates select="patent-classification[classification-scheme/@scheme = $type and (contains(./classification-symbol, ':') or contains(./classification-symbol, '/'))]">
            <xsl:sort select="classification-value" order="descending"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="patent-classification">
        <xsl:param name="type"/>
        <xsl:variable name="classification">
            <xsl:choose>
                <xsl:when test="./classification-symbol/HIT">
                    <xsl:value-of select="./classification-symbol/HIT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./classification-symbol"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="./classification-scheme/@scheme = 'CPCNO'">
                <xsl:variable name="classif">
                    <xsl:choose>
                        <xsl:when test="contains($classification, '(')">
                            <xsl:value-of select="normalize-space(substring-before($classification, '('))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$classification"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="vclassifP1" select="substring($classif, 1, 4)"/>
                <xsl:variable name="vclassifP2" select="substring-after($classif, $vclassifP1)"/>
                <xsl:variable name="vclassifOK" select="concat($vclassifP1, ' ', $vclassifP2)"/>
                <span>
                    <xsl:attribute name="class">
                        <xsl:if test="./classification-value = 'I'">cClassCpcNo</xsl:if>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="./classification-symbol/HIT">
                            <span class="cHit" id="hitmimosa_{generate-id()}">
                                <xsl:call-template name="set-non-beaking-spaces">
                                    <xsl:with-param name="data" select="normalize-space($vclassifOK)"/>
                                </xsl:call-template>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="set-non-beaking-spaces">
                                <xsl:with-param name="data" select="normalize-space($vclassifOK)"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:if test="$type != 'CS'">
                    <span>
                        <xsl:call-template name="carNbsp"/>
                        <xsl:value-of select="normalize-space(substring-after($classification, '('))"/>
                    </span>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tpl-classif-cpc">
                    <xsl:with-param name="current-cla" select="$classification"/>
                    <xsl:with-param name="hit">
                        <xsl:if test="./classification-symbol/HIT">yes</xsl:if>
                    </xsl:with-param>
                    <xsl:with-param name="vLang" select="$vLang"/>
                    <xsl:with-param name="type">
                        <xsl:choose>
                            <xsl:when test="'' != $type">
                                <xsl:value-of select="$type"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./classification-scheme/@scheme"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="value" select="./classification-value"/>
                    <xsl:with-param name="pType">cpc</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="(position() != last()) and ($type != 'CS')">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="USC">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'US' and @scheme = 'DOCUS']">


            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'US' and @scheme = 'DOCUS']/../classification-symbol">
                        <xsl:variable name="classification" select="string(.)"/>
                        <xsl:element name="a">
                            <xsl:attribute name="data-link-type">usc</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('http://www.uspto.gov/web/patents/classification/uspc', substring($classification, 1, 3), '/sched', substring($classification, 1, 3), '.htm#C', substring($classification, 1, 3), 'S', substring($classification, 4, 6))"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">_blank</xsl:attribute>
                            <xsl:attribute name="class">cCassCpcDocUs cExternalLnk</xsl:attribute>
                            <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_USPC</xsl:with-param></xsl:call-template></xsl:attribute-->
                            <xsl:call-template name="tpl-hasHit"/>
                        </xsl:element>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="classification-symbol">
        <xsl:variable name="classification" select="string(.)"/>
        <xsl:value-of select="translate(normalize-space(concat(substring($classification, 1, 3), '/', substring($classification, 4))), ' ', '&#160;')"/>
    </xsl:template>


    <xsl:template match="JPFI">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'JP' and @scheme = 'FI']">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'JP' and @scheme = 'FI']/../classification-symbol">
                        <xsl:variable name="classification" select="string(.)"/>
                        <xsl:variable name="separateur">
                            <xsl:choose>
                                <xsl:when test="contains($classification, ':')">:</xsl:when>
                                <xsl:otherwise>/</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="vP1" select="normalize-space(substring($classification, 2, 4))"/>
                        <xsl:variable name="vP2" select="normalize-space(substring-before(substring($classification, 6), $separateur))"/>
                        <xsl:variable name="vP3" select="normalize-space(substring-after($classification, $separateur))"/>
                        <xsl:variable name="vP4">
                            <xsl:choose>
                                <xsl:when test="substring-before($vP3, ' ') = ''">
                                    <xsl:value-of select="normalize-space(substring-after($classification, $separateur))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="substring-before($vP3, ' ')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <!-- example: http://www5.ipdl.inpit.go.jp/pmgs1/pmgs1/!frame_E?hs=1&gb=1&dep=4&sec=A&cls=61&scls=K&mgrp=&idx=&sgrp=&sf=&bs=&dt=0&wrd=&nm= -->
                        <xsl:element name="a">
                            <xsl:attribute name="data-link-type">jpfi</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('http://www5.ipdl.inpit.go.jp/pmgs1/pmgs1/!frame_E?hs=1&amp;gb=1&amp;dep=5&amp;sec=',substring(.,2,1),'&amp;cls=',substring(.,3,2),'&amp;scls=',substring(.,5,1),'&amp;mgrp=',$vP2,'&amp;idx=/&amp;sgrp=',$vP4,'&amp;sf=&amp;bs=&amp;dt=0&amp;wrd=&amp;nm=',$vP4)"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">_blank</xsl:attribute>
                            <xsl:attribute name="class">cCassCpcFiJp cExternalLnk</xsl:attribute>
                            <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_FI</xsl:with-param></xsl:call-template></xsl:attribute-->
                            <xsl:choose>
                                <xsl:when test="./HIT">
                                    <span class="cHit" id="hitmimosa_{generate-id()}">
                                        <xsl:value-of select="translate(normalize-space(concat($vP1, ' ', $vP2, $separateur, $vP3)), ' ', '&#160;')"/>
                                    </span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="translate(normalize-space(concat($vP1, ' ', $vP2, $separateur, $vP3)), ' ', '&#160;')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="JPFT">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'JP' and @scheme = 'FTERM']">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:patent-classifications/patent-classification/classification-scheme[@office = 'JP' and @scheme = 'FTERM']/../classification-symbol">
                        <xsl:variable name="classification">
                            <xsl:choose>
                                <xsl:when test="HIT">
                                    <xsl:value-of select="HIT"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="separateur">
                            <xsl:choose>
                                <xsl:when test="contains($classification, ':')">:</xsl:when>
                                <xsl:otherwise>/</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- example: http://www5.ipdl.inpit.go.jp/pmgs1/pmgs1/!frame_E?hs=1&gb=2&dep=3&sec=2B&cls=396&scls=&mgrp=&idx=&sgrp=&sf=&bs=&dt=0&wrd=&nm= -->
                        <xsl:element name="a">
                            <xsl:attribute name="data-link-type">jpfi</xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('http://www5.ipdl.inpit.go.jp/pmgs1/pmgs1/!frame_E?hs=1&amp;gb=2&amp;dep=3&amp;sec=',normalize-space(substring($classification,1,2)),'&amp;cls=',normalize-space(substring-before(substring($classification,3),$separateur)),'&amp;scls=&amp;mgrp=&amp;idx=&amp;sgrp=&amp;sf=&amp;bs=&amp;dt=0&amp;wrd=&amp;nm=')"
                                />
                            </xsl:attribute>
                            <xsl:attribute name="target">_blank</xsl:attribute>
                            <xsl:attribute name="class">cCassCpcFtermJp cExternalLnk</xsl:attribute>
                            <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_FT</xsl:with-param></xsl:call-template></xsl:attribute-->
                            <xsl:choose>
                                <xsl:when test="./HIT">
                                    <span class="cHit" id="hitmimosa_{generate-id()}">
                                        <xsl:value-of select="translate(normalize-space(./HIT), ' ', '&#160;')"/>
                                    </span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="translate(normalize-space(.), ' ', '&#160;')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="NAT">
        <xsl:if test="($vRefCtry != 'JP') and ($vRefCtry != 'US') and //document[@type = 'notice']//exch:bibliographic-data/exch:classification-national">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:classification-national/text">
                        <xsl:apply-templates/>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="CIBY">
        <xsl:if test="//document[@type = 'notice']/cited-by/patcit and $pHtmlType = 'embedded'">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']/cited-by/patcit">
                        <xsl:call-template name="tpl-LnkInt">
                            <xsl:with-param name="pStyle" select="''"/>
                            <xsl:with-param name="pCtry" select="./document-id/country"/>
                            <xsl:with-param name="pDocNum" select="./document-id/doc-number"/>
                            <xsl:with-param name="pKind" select="./document-id/kind"/>
                            <xsl:with-param name="pType">document</xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="PFA">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:previously-filed-app">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:previously-filed-app">
                        <?xslCmt msg="MANTIS#99903"?>
                        <xsl:apply-templates/>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <?H4 citation by name ?>
    <xsl:variable name="gTagUl4multi" select="'ul'"/>

    <?H5 citation by name / common ?>

    <xsl:template name="tplCitationPatCitContent">
        <?c at level 'exch:citation' ?>
        <xsl:choose>
            <xsl:when test="patcit/document-id/doc-number/HIT">
                <span class="cHit" id="hitmimosa_{generate-id()}" skip="false">
                    <xsl:apply-templates select="patcit">
                        <xsl:with-param name="hit">yes</xsl:with-param>
                    </xsl:apply-templates>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="patcit"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
    </xsl:template>


    <xsl:template name="tplCitationPatCit">
        <xsl:param name="aMultipe"/>
        <?c at level 'exch:citation' ?>
        <xsl:choose>
            <xsl:when test="$gTagUl4multi = $aMultipe">
                <li>
                    <xsl:call-template name="tplCitationPatCitContent"/>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tplCitationPatCitContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tplCitationPatNplContent">
        <?c at level 'exch:citation' ?>
        <xsl:if test="category">
            <xsl:value-of select="concat('[', category, ']&#160;')"/>
        </xsl:if>
        <xsl:apply-templates select="nplcit/text" mode="citation"/>
        <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
    </xsl:template>

    <xsl:template name="tplCitationNplCit">
        <xsl:param name="aMultipe"/>
        <?c at level 'exch:citation' ?>
        <xsl:choose>
            <xsl:when test="$gTagUl4multi = $aMultipe">
                <li>
                    <xsl:call-template name="tplCitationPatNplContent"/>
                </li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tplCitationPatNplContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tplCitationByName">
        <xsl:param name="aLabel"/>
        <xsl:param name="aName"/>
        <xsl:param name="aList"/>
        <!--article-->

        <xsl:call-template name="tpl_BiblioTitle">
            <xsl:with-param name="level">2</xsl:with-param>
            <xsl:with-param name="extra_class">pCitationByName</xsl:with-param>
            <xsl:with-param name="val_label"><xsl:value-of select="$aLabel"/> : <span class="cName"><xsl:value-of select="$aName"/></span></xsl:with-param>
        </xsl:call-template>

        <xsl:variable name="rootTagName">
            <xsl:choose>
                <xsl:when test="1 &lt; count($aList)">
                    <xsl:value-of select="$gTagUl4multi"/>
                </xsl:when>
                <xsl:otherwise>p</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$rootTagName}">
            <!-- [uoss] TODO -->
            <xsl:attribute name="class">pCitationByName</xsl:attribute>
            <?C Pattent Citation ?>
            <xsl:for-each select="$aList[patcit]">
                <xsl:call-template name="tplCitationPatCit">
                    <xsl:with-param name="aMultipe" select="$rootTagName"/>
                </xsl:call-template>
            </xsl:for-each>
            <?C Non Pattent Citation ?>
            <xsl:for-each select="$aList[nplcit]">
                <xsl:call-template name="tplCitationNplCit">
                    <xsl:with-param name="aMultipe" select="$rootTagName"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
        <!--/article-->
    </xsl:template>


    <?H5 citation by name / CIOP /OPP (old FOP) ?>
    <?xd msg="xpath test condition for OPP with old value" val="(@cited-phase='OPP' or @cited-phase='FOP')" ?>
    <xsl:key name="kOpp_name" match="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'OPP' or @cited-phase = 'FOP') and @name]" use="@name"/>
    <xsl:template match="CIOP">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'OPP' or @cited-phase = 'FOP')]">
            <xsl:variable name="vLabel">
                <xsl:call-template name="get-label">
                    <xsl:with-param name="id" select="'OPP'"/>
                </xsl:call-template>
            </xsl:variable>

            <div>
                <xsl:call-template name="attBiblioBlock">
                    <xsl:with-param name="extra_class">pCitationByName</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tpl_BiblioTitle">
                    <xsl:with-param name="val_label" select="$vLabel"/>
                </xsl:call-template>
                <!--[v1 sort by @name ant not @name ]-->
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'OPP' or @cited-phase = 'FOP') and @name][generate-id(.) = generate-id(key('kOpp_name', @name)[1])]">
                    <?c thp with @name ?>
                    <?c for-each : select distinct key : select xsl:key@match[generate-id(.)=generate-id(key('kOpp_name', @name)[1])] ?>
                    <!-- 
                        <x.l:sort select="@name"/>
                    -->
                    <xsl:call-template name="tplCitationByName">
                        <xsl:with-param name="aLabel" select="$vLabel"/>
                        <xsl:with-param name="aName" select="@name"/>
                        <xsl:with-param name="aList" select="key('kOpp_name', @name)"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'OPP' or @cited-phase = 'FOP') and not(@name)]">
                    <?c thp not @name ?>
                    <xsl:call-template name="tplCitationByName">
                        <xsl:with-param name="aLabel" select="$vLabel"/>
                        <xsl:with-param name="aName"/>
                        <?a empty name ?>
                        <xsl:with-param name="aList" select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'OPP' or @cited-phase = 'FOP') and not(@name)]"/>
                    </xsl:call-template>
                </xsl:if>
                <!-- [/v1] -->
                <!--[v2 keep original order with mutilple 'exch:references-cited' ]-->
            </div>
        </xsl:if>
    </xsl:template>


    <?H5 citation by name / CITP / THP (old TPO) ?>
    <?xd msg="xpath test condition for THP with old value" val="(@cited-phase='THP' or @cited-phase='TPO')" ?>
    <xsl:key name="kThp_name" match="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'THP' or @cited-phase = 'TPO') and @name]" use="@name"/>

    <xsl:template match="CITP">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'THP' or @cited-phase = 'TPO')]">
            <xsl:variable name="vLabel">
                <xsl:call-template name="get-label">
                    <xsl:with-param name="id" select="'THP'"/>
                </xsl:call-template>
            </xsl:variable>
            <div>
                <xsl:call-template name="attBiblioBlock">
                    <xsl:with-param name="extra_class">pCitationByName</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tpl_BiblioTitle">
                    <xsl:with-param name="val_label" select="$vLabel"/>
                </xsl:call-template>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'THP' or @cited-phase = 'TPO') and @name][generate-id(.) = generate-id(key('kThp_name', @name)[1])]">
                    <?c thp @name ?>
                    <!-- 
                        <x.l:sort select="@name"/>
                    -->
                    <xsl:call-template name="tplCitationByName">
                        <xsl:with-param name="aLabel" select="$vLabel"/>
                        <xsl:with-param name="aName" select="@name"/>
                        <xsl:with-param name="aList" select="key('kThp_name', @name)"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'THP' or @cited-phase = 'TPO') and not(@name)]">
                    <?c thp not @name ?>
                    <xsl:call-template name="tplCitationByName">
                        <xsl:with-param name="aLabel" select="$vLabel"/>
                        <xsl:with-param name="aName"/>
                        <?a empty name ?>
                        <xsl:with-param name="aList" select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@cited-phase = 'THP' or @cited-phase = 'TPO') and not(@name)]"/>
                    </xsl:call-template>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>


    <?H4 citation  ?>

    <xsl:template match="CIAP | CISR | CIEP | CIAL | CIIS | CISS | CIPE">
        <?xslDoc msg="citation mode mixte : @srep-phase and @cited-phase except @cited-phase=[FOP(=>OPP)|TPO(=>THP)] "?>
        <xsl:variable name="vSel">
            <xsl:choose>
                <xsl:when test="name() = 'CIAP'">APP</xsl:when>
                <xsl:when test="name() = 'CISR'">SEA</xsl:when>
                <xsl:when test="name() = 'CIEP'">EXA</xsl:when>
                <xsl:when test="name() = 'CIAL'">APL</xsl:when>
                <xsl:when test="name() = 'CISS'">SUP</xsl:when>
                <xsl:when test="name() = 'CIPE'">CH2</xsl:when>
                <!-- [OLD] ## [CIOP]:OPP ## [CITP]:115 -->
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="vSelOr">
            <xsl:choose>
                <xsl:when test="name() = 'CIAP'">APP</xsl:when>
                <xsl:when test="name() = 'CISR'">PRS</xsl:when>
                <xsl:when test="name() = 'CIEP'">EXA</xsl:when>
                <xsl:when test="name() = 'CIAL'">APL</xsl:when>
                <xsl:when test="name() = 'CIIS'">ISR</xsl:when>
                <xsl:when test="name() = 'CISS'">SUP</xsl:when>
                <xsl:when test="name() = 'CIPE'">CH2</xsl:when>
                <!-- [OLD] ## [CIOP]:FOP ## [CITP]:TPO -->
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]">

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:variable name="nbPatcit"
                    select="count(//document[@type = 'notice']//exch:exchange-document/exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]/patcit)"/>
                <xsl:variable name="nbNplcit"
                    select="count(//document[@type = 'notice']//exch:exchange-document/exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]/nplcit)"/>
                <xsl:variable name="rootTagName">
                    <xsl:choose>
                        <xsl:when test="($nbPatcit + $nbNplcit) &gt; 1">ul</xsl:when>
                        <xsl:otherwise>p</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$rootTagName}">
                    <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]/patcit">
                        <xsl:choose>
                            <!-- Non Pattent Citation -->
                            <xsl:when test="($nbPatcit + $nbNplcit) &gt; 1">
                                <!-- muti-occurent -->
                                <xsl:for-each
                                    select="//document[@type = 'notice']//exch:exchange-document/exch:bibliographic-data/exch:references-cited/exch:citation[((@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)) and patcit]">
                                    <!-- <p class="pi2"> -->
                                    <li>
                                        <xsl:choose>
                                            <xsl:when test="patcit/document-id/doc-number/HIT">
                                                <span class="cHit" id="hitmimosa_{generate-id()}" skip="false">
                                                    <xsl:apply-templates select="patcit">
                                                        <xsl:with-param name="hit">yes</xsl:with-param>
                                                    </xsl:apply-templates>
                                                </span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="patcit"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
                                    </li>
                                    <!-- </p> -->
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- mono-occurent -->
                                <xsl:call-template name="attBiblioBlockPara"/>
                                <xsl:choose>
                                    <xsl:when test="patcit/document-id/doc-number/HIT">
                                        <span class="cHit" id="hitmimosa_{generate-id()}" skip="false">
                                            <xsl:apply-templates
                                                select="//document[@type = 'notice']//exch:exchange-document/exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]/patcit">
                                                <xsl:with-param name="hit">yes</xsl:with-param>
                                            </xsl:apply-templates>
                                        </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates
                                            select="//document[@type = 'notice']//exch:exchange-document/exch:bibliographic-data/exch:references-cited/exch:citation[(@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)]/patcit"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>

                    <xsl:choose>
                        <!-- Non Pattent Citation -->
                        <xsl:when test="(($nbPatcit &gt; 1) and ($nbNplcit &gt;= 1)) or ($nbNplcit &gt; 1)">
                            <!-- muti-occurent -->
                            <xsl:for-each
                                select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[((@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)) and nplcit]">
                                <li>
                                    <xsl:if test="category">
                                        <xsl:value-of select="concat('[', category, ']&#160;')"/>
                                    </xsl:if>
                                    <xsl:apply-templates select="nplcit/text" mode="citation"/>
                                    <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
                                </li>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[((@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)) and nplcit]">
                            <!-- mono-occurent -->
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <xsl:for-each
                                select="//document[@type = 'notice']//exch:bibliographic-data/exch:references-cited/exch:citation[((@srep-phase = $vSel) or (@srep-phase = $vSelOr) or (@cited-phase = $vSel) or (@cited-phase = $vSelOr)) and nplcit]">
                                <xsl:if test="category">
                                    <xsl:value-of select="concat('[', category, ']&#160;')"/>
                                </xsl:if>
                                <xsl:apply-templates select="nplcit/text" mode="citation"/>
                                <xsl:apply-templates select="exch:corresponding-docs" mode="m_cita_cor_doc"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text" mode="citation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="exch:corresponding-docs" mode="m_cita_cor_doc">
        <xsl:for-each select="patcit | nplcit">
            <xsl:text> &amp; </xsl:text>
            <xsl:apply-templates select="." mode="m_cita_cor_doc"/>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="tpl_patcit">
        <?xslDoc at="patcit"?>

        <xsl:variable name="doc-number">
            <!-- 201512
            <xsl:value-of select="substring-before(substring-after(@dnum,./document-id/country),./document-id/kind)"/>
            -->
            <xsl:call-template name="before-last-delim">
                <xsl:with-param name="s" select="substring-after(@dnum, ./document-id/country)"/>
                <xsl:with-param name="d" select="./document-id/kind"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="./@dnum-type = 'application number'">
                <xsl:value-of select="concat(./document-id/country, ' ', $doc-number, ' ', ./document-id/kind)"/>
                <xsl:if test="string-length(./document-id/date) &gt; 1">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="./document-id/date"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tpl-LnkInt">
                    <xsl:with-param name="pStyle">cCitation</xsl:with-param>
                    <xsl:with-param name="pCtry" select="./document-id/country"/>
                    <xsl:with-param name="pDocNum" select="$doc-number"/>
                    <xsl:with-param name="pKind" select="./document-id/kind"/>
                    <xsl:with-param name="pDate" select="./document-id/date"/>
                    <xsl:with-param name="pAdd_date">yes</xsl:with-param>
                    <xsl:with-param name="pType">document</xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="string-length(./document-id/name) &gt; 1">
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="./document-id/name" mode="citation"/>
        </xsl:if>

    </xsl:template>


    <xsl:template match="exch:citation/patcit">
        <xsl:param name="hit"/>
        <xsl:if test="../category">
            <xsl:value-of select="concat('[', ../category, ']&#160;')"/>
        </xsl:if>
        <xsl:call-template name="tpl_patcit"/>
    </xsl:template>

    <xsl:template match="patcit" mode="m_cita_cor_doc">
        <?xslDoc msg =" format 'patcit' without category"?>
        <xsl:call-template name="tpl_patcit"/>
    </xsl:template>

    <xsl:template match="nplcit" mode="m_cita_cor_doc">
        <?xslDoc msg =" format keep only 'text' ?>
        <xsl:apply-templates select="text"/>
    </xsl:template>


    <xsl:template match="name" mode="citation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="DAD">
        <xsl:if test="//document[@type = 'notice']//@date-added-docdb">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="//document[@type = 'notice']//@date-added-docdb"/>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DPE">
        <xsl:if test="//document[@type = 'notice']//@date-of-previous-exchange">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="//document[@type = 'notice']//@date-of-previous-exchange"/>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DLE">
        <xsl:if test="//document[@type = 'notice']//@date-of-last-exchange">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="//document[@type = 'notice']//@date-of-last-exchange"/>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DCF">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:date-of-coming-into-force/date">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="//document[@type = 'notice']//exch:bibliographic-data/exch:date-of-coming-into-force/date"/>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DPP">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:preceding-publication-date/date">

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="//document[@type = 'notice']//exch:bibliographic-data/exch:preceding-publication-date/date"/>
                    </xsl:call-template>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="DSP">
        <xsl:if
            test="
                //document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-pct/exch:regional
                | //document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-pct/exch:national/country">

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <xsl:for-each select="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-pct/*">
                    <p>
                        <xsl:call-template name="attBiblioBlockPara"/>
                        <xsl:apply-templates select="."/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-pct/exch:regional">
        <xsl:apply-templates select="region/country"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="country" mode="separated"/>
    </xsl:template>

    <xsl:template match="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-pct/exch:national">
        <xsl:apply-templates select="country" mode="separated"/>
    </xsl:template>

    <xsl:template match="country" mode="separated">
        <xsl:apply-templates/>
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <xsl:template match="DCS">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:contracting-states/country">

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:apply-templates select="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:contracting-states/country" mode="separated"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DXS">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:extension-states/country">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:apply-templates select="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:extension-states/country" mode="separated"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="DVS">
        <xsl:if test="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:validation-states/country">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:apply-templates select="//document[@type = 'notice']//exch:bibliographic-data/exch:designation-of-states/exch:designation-epc/exch:validation-states/country" mode="separated"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="FAM">
        <xsl:if test="//document[@type = 'family-members']/family-members/p | //document[@type = 'family-representative']/family-representative/p">
            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:call-template name="attBiblioBlockPara"/>
                    <xsl:apply-templates select="//document[@type = 'family-representative']/family-representative/p"/>
                    <xsl:if test="
                            //document[@type = 'family-representative']/family-representative/p and
                            //document[@type = 'family-members']/family-members/p">; </xsl:if>
                    <xsl:apply-templates select="//document[@type = 'family-members']/family-members/p"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="family-members/p | family-representative/p">
        <xsl:call-template name="tpl-LnkInt">
            <xsl:with-param name="pStyle">
                <xsl:choose>
                    <xsl:when test="ancestor::family-representative">cFamilyMemberRep</xsl:when>
                    <xsl:otherwise>cFamilyMemberOth</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="pCtry" select="./country"/>
            <xsl:with-param name="pDocNum" select="./doc-number"/>
            <xsl:with-param name="pKind" select="./kind"/>
            <xsl:with-param name="pDate" select="./date"/>
            <xsl:with-param name="pAdd_date">yes</xsl:with-param>
            <xsl:with-param name="pType">document</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="count(following-sibling::p) &gt; 0">; </xsl:if>
    </xsl:template>

    <!-- ==== OPS FIELDS ====  -->

    <xsl:template match="IFAM">
        <xsl:choose>
            <?MANTIS id="0120466"  msg="see mantis's note" "?>
            <xsl:when test="//legal-status-document">
                <?xslDoc [legalStatus] No "INPADOC familly" ?> </xsl:when>
            <xsl:when test="$pHtmlType = 'embedded'">
                <?xslDoc [Blibio.] retrive OPS "INPADOC familly" dynamicalyn ?>
                <div>
                    <xsl:call-template name="attBiblioBlock">
                        <xsl:with-param name="extra_class">field-ops-IFAM</xsl:with-param>
                    </xsl:call-template>
                    <xsl:call-template name="tpl_BiblioTitle"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <?xslDoc "INPADOC familly" in GPI never used, it was for EPAB ?>
                <!-- WARNING !!! comme dans les 1er documents on suppose que seul les  exch:application-reference/@is-representative sont de format "docdb" -->
                <xsl:if test="//document[@type = 'notice']//exch:patent-family/exch:family-member">
                    <div>
                        <xsl:call-template name="attBiblioBlock"/>
                        <xsl:call-template name="tpl_BiblioTitle"/>
                        <p>
                            <xsl:call-template name="attBiblioBlockPara"/>
                            <!-- representant -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:patent-family/exch:family-member[exch:application-reference/@is-representative = 'YES']">
                                <xsl:for-each select="./exch:publication-reference[@data-format = 'docdb']">
                                    <xsl:call-template name="tpl-LnkInt">
                                        <xsl:with-param name="pStyle" select="'cFamilyMemberRep'"/>
                                        <xsl:with-param name="pCtry" select="./document-id/country"/>
                                        <xsl:with-param name="pDocNum" select="./document-id/doc-number"/>
                                        <xsl:with-param name="pKind" select="./document-id/kind"/>
                                        <xsl:with-param name="pDate" select="./document-id/date"/>
                                        <xsl:with-param name="pType">document</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if
                                    test="
                                        parent::exch:patent-family/following-sibling::exch:patent-family/exch:family-member[exch:application-reference/@is-representative = 'YES' and exch:publication-reference[@data-format = 'docdb']] or
                                        following-sibling::exch:family-member[exch:application-reference[@is-representative = 'YES'] and exch:publication-reference[@data-format = 'docdb']]">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- si represantant et autre membre -->
                            <xsl:if
                                test="
                                    //document[@type = 'notice']//exch:patent-family/exch:family-member[exch:application-reference/@is-representative = 'YES']
                                    and
                                    //document[@type = 'notice']//exch:patent-family/exch:family-member[exch:application-reference/@is-representative = 'NO']
                                    ">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                            <!-- autre membre -->
                            <xsl:for-each select="//document[@type = 'notice']//exch:patent-family/exch:family-member[exch:application-reference/@is-representative = 'NO']">
                                <xsl:for-each select="./exch:publication-reference[@data-format = 'docdb']">
                                    <xsl:call-template name="tpl-LnkInt">
                                        <xsl:with-param name="pStyle" select="'cFamilyMemberOth'"/>
                                        <xsl:with-param name="pCtry" select="./document-id/country"/>
                                        <xsl:with-param name="pDocNum" select="./document-id/doc-number"/>
                                        <xsl:with-param name="pKind" select="./document-id/kind"/>
                                        <xsl:with-param name="pDate" select="./document-id/date"/>
                                        <xsl:with-param name="pType">document</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>; </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:if
                                    test="
                                        parent::exch:patent-family/following-sibling::exch:patent-family/exch:family-member[exch:application-reference[@is-representative = 'NO'] and exch:publication-reference[@data-format = 'docdb']] or
                                        following-sibling::exch:family-member[exch:application-reference[@is-representative = 'NO'] and exch:publication-reference[@data-format = 'docdb']]">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </p>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>



    <xsl:template match="ICLIP">
        <xsl:if test="$pHtmlType = 'embedded' and //document[@type = 'family-representative']">
            <div>
                <xsl:call-template name="attBiblioBlock">
                    <xsl:with-param name="extra_class">field-ops-ICLIP</xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="tpl_BiblioTitle"/>
            </div>
        </xsl:if>
    </xsl:template>


    <!-- ==== OPS GPI LEGAL STATUS [201608+] ====  -->


    <xsl:template match="ILEG">
        <xsl:if test="//legal-status-document/legal-event[not(@status = 'D')]">

            <div>
                <xsl:call-template name="attBiblioBlock"/>
                <xsl:call-template name="tpl_BiblioTitle"/>
                <p>
                    <xsl:apply-templates select="//legal-status-document/legal-event[not(@status = 'D')]"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template name="tplLegalSub">
        <xsl:param name="aLabel"/>
        <xsl:param name="aLegSubElt"/>
        <xsl:param name="aXsltMode"/>
        <xsl:if test="$aLegSubElt">
            <p>
                <span class="cLsDetailLabelGpi">
                    <xsl:text>- </xsl:text>
                    <xsl:call-template name="get-label">
                        <xsl:with-param name="id" select="$aLabel"/>
                    </xsl:call-template>
                </span>
                <xsl:text>: </xsl:text>
                <xsl:choose>
                    <xsl:when test="'mdLegalEvent' = $aXsltMode">
                        <xsl:apply-templates select="$aLegSubElt" mode="mdLegalEvent"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$aLegSubElt"/>
                    </xsl:otherwise>
                </xsl:choose>
            </p>
        </xsl:if>
    </xsl:template>


    <xsl:template name="tplLegalCountries">
        <xsl:param name="aLabel"/>
        <xsl:param name="aLegSubElt"><?xd msg=" empty at 'designated-states' element or node-set(designated-states) ?></xsl:param>
        <xsl:choose>
            <xsl:when test="'' != $aLegSubElt">
                <p>
                    <span class="cLsDetailLabelGpi">
                        <xsl:text>- </xsl:text>
                        <xsl:call-template name="get-label">
                            <xsl:with-param name="id" select="$aLabel"/>
                        </xsl:call-template>
                    </span>
                    <xsl:text>: </xsl:text>
                    <xsl:for-each select="$aLegSubElt/country">
                        <xsl:value-of select="concat(' ', .)"/>
                    </xsl:for-each>
                </p>
            </xsl:when>
            <xsl:when test="./country">
                <p>
                    <span class="cLsDetailLabelGpi">
                        <xsl:text>- </xsl:text>
                        <xsl:call-template name="get-label">
                            <xsl:with-param name="id" select="$aLabel"/>
                        </xsl:call-template>
                    </span>
                    <xsl:text>: </xsl:text>
                    <xsl:for-each select="./country">
                        <xsl:value-of select="concat(' ', .)"/>
                    </xsl:for-each>
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- [new][ launched by 'apply-templates select...' instead of 'call-template'] -/->
	<x.l:template match="designated-states|extension-states" mode="md-designated-states">
		<x.l:param name="aLabel"/>
			<p> 
				<x.l:if test="'' != $aLabel">
					<span class="cLsDetailLabelGpi">
					<x.l:text>- </x.l:text>
					<x.l:call-template name="get-label">
						<x.l:with-param name="id" select="$aLabel"/>
					</x.l:call-template>
					</span>
				</x.l:if>
				
				<x.l:text>: </x.l:text>
				<x.l:apply-templates mode="md-designated-states"/>
			</p>
	</x.l:template>
	
	<x.l:template match="country" mode="md-designated-states">
		<x.l:text> </x.l:text>
		<x.l:apply-templates/>
	</x.l:template>
  <!-/- [/new] -->


    <xsl:template match="legal-event">
        <?xgl prev="EVENT" nouv="legal-event"?>
        <div class="cLsBloc skiptranslate">
            <h1>
                <span class="cLsDate">
                    <xsl:choose>
                        <xsl:when test="./event-date/HIT">
                            <?xgl prev="L007EP" nouv="event-date"?>
                            <xsl:attribute name="class">cLsDate cHit</xsl:attribute>
                            <xsl:attribute name="id">
                                <xsl:text>hitmimosa_</xsl:text>
                                <xsl:value-of select="generate-id()"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">cLsDate</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="formatDate">
                        <xsl:with-param name="pDate" select="./event-date"/>
                    </xsl:call-template>
                </span>
                <xsl:text>&#160;</xsl:text>
                <span>
                    <xsl:text>[</xsl:text>
                    <xsl:apply-templates select="./EVC"/>
                    <?xgl msg=" event-code + ref. cc"?>
                    <xsl:text>]&#32;</xsl:text>
                    <xsl:choose>
                        <?xgl prev="./EVT/TEXT" nouv="./EVT/event-details/event-description[@lang =en]" msg=" en or original if no en" ?>
                        <xsl:when test="./EVT/event-details/event-description[@lang = 'en']">
                            <xsl:apply-templates select="./EVT/event-details/event-description[@lang = 'en']"/>
                        </xsl:when>
                        <xsl:when test="./EVT/event-details/event-description[@event-description-type = 'original']">
                            <xsl:apply-templates select="./EVT/event-details/event-description[@event-description-type = 'original']"/>
                        </xsl:when>
                    </xsl:choose>
                </span>
            </h1>

            <xsl:apply-templates select="./OWNERS"/>

            <xsl:if test="./EVT/event-details/parties/text">
                <xsl:call-template name="tplLegalSub">
                    <xsl:with-param name="aLabel" select="'L_L510EP'"/>
                    <xsl:with-param name="aLegSubElt" select="./EVT/event-details/parties/text"/>
                </xsl:call-template>
            </xsl:if>

            <xsl:if test="'' != ./EVT/event-details/*/COUNTRY[1]">
                <xsl:call-template name="tplLegalSub">
                    <xsl:with-param name="aLabel" select="'L_L501EP'"/>
                    <xsl:with-param name="aLegSubElt" select="./EVT/event-details/*/COUNTRY[1]"/>
                </xsl:call-template>
            </xsl:if>

            <?xOrdered msg="see revision svn 17678 to choice beetwen 'flow or data ordreded'(not used)  and 'label ordered'(current version)"?>

            <?xgl prev="./EVT/L500EP/*  or ./EVT/L500EP/L5[0:2][0:9]EP" nouv="./EVT/event-details/*" msg='for-each'?>
            <?xgl msg="ordered by label L500EP/L5[0:2][0:9]EP" ?>
            <?xT [ordered by label] ?>
            <?xgl msg="don't display with label 'L_L502EP'" ?>

            <xsl:call-template name="tplLegalSub">
                <?xd msg=" L503_DOC : L504EP + L503EP + L506EP + L505EP" ?>
                <xsl:with-param name="aLabel" select="'L_L503EP_DOC'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/event-reference/event-ref-document"/>
                <xsl:with-param name="aXsltMode" select="'mdLegalEvent'"/>
            </xsl:call-template>

            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L506EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/event-reference/event-ref-kind/kind"/>
            </xsl:call-template>


            <xsl:call-template name="tplLegalCountries">
                <xsl:with-param name="aLabel" select="'L_L507EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/designated-states"/>
            </xsl:call-template>

            <?xd use L524EP  and not L508EP ?>

            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L510EP'"/>
                <?xgl msg="some 'text' element in event-details , not all"?>
                <xsl:with-param name="aLegSubElt"
                    select="./EVT/event-details/parties/party-details-old/text | ./EVT/event-details/spc/text | ./EVT/event-details/fee-payment/text | ./EVT/event-details/notification-of-lapse/text | ./EVT/event-details/notification-of-reinstatement/text | ./EVT/event-details/text"
                />
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L511EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/spc/spc-number"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L512EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/spc/date-filing"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L513EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/spc/date-expiry-of-patent"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L515EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/parties[@party-type = 'inventor']/parties-details/party/name"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L516EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/patent-classification/classification-symbol"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L517EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/parties[@party-type = 'representative']/parties-details/party/name"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L518EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/fee-payment/fee-payment-date"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L519EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/parties[@party-type = 'opponent']/parties-details/party/name"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L520EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/fee-payment/fee-payment-year"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L522EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/parties[@party-type = 'licensee']/parties-details/party/name"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L523EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/spc/date-extension-granted"/>
            </xsl:call-template>

            <xsl:call-template name="tplLegalCountries">
                <xsl:with-param name="aLabel" select="'L_L524EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/extension-states"/>
            </xsl:call-template>

            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L525EP'"/>
                <?xgl prev="L525EP"  xsd-doc="[./event-date-effective: Represents the date this event has come into force Reference to legacy product: L525EP|/notification-of-lapse: Reference to legacy product: L525EP when code=PG25 |notification-of-reinstatement:Reference to legacy product: L525EP when code=PGRI]"?>
                <xsl:with-param name="aLegSubElt"
                    select="./event-date-effective | ./EVT[event-code = 'PG25']/event-details/notification-of-lapse/date-patent-lapsed | ./EVT[event-code = 'PGRI']/event-details/notification-of-reinstatement/date-patent-reinstated"/>
            </xsl:call-template>
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L526EP'"/>
                <xsl:with-param name="aLegSubElt" select="./EVT/event-details/date-application-withdrawn"/>
            </xsl:call-template>
            <?xT [/ordered by label] ?>
        </div>
    </xsl:template>


    <xsl:template match="legal-event/OWNERS">
        <xsl:for-each select="./OWNER">
            <xsl:call-template name="tplLegalSub">
                <xsl:with-param name="aLabel" select="'L_L509EP'"/>
                <xsl:with-param name="aLegSubElt" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="event-ref-document/*" mode="mdLegalEvent">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

</xsl:stylesheet>
