<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i_f="http://internalXslt/function" exclude-result-prefixes="i_f xd xs" version="3.0">
    <xd:doc scope="stylesheet/epab">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> syntaxe xsl</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/epab/bibliographie.html5.xsl</xd:p>
            <xd:p>
                <xd:ul>
                    <xd:li/>
                </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>


<!-- ==== Autres Variables ====  -->

    <xsl:variable name="vRefCtry" select="//ep-patent-document/SDOBI/B100//B190" />
    <xsl:variable name="vRefDocNum" select="//ep-patent-document/SDOBI/B100//B110" />
    <xsl:variable name="vRefKind" select="//ep-patent-document/SDOBI/B100//B130" />


    <xsl:variable name="vAppDocNum" select="//ep-patent-document/SDOBI/B200//B210" />

    <!-- ==== xsl:key ====  -->

    <xsl:key name="keyIpcr" match="//ep-patent-document/SDOBI/B500/B510EP/classification-ipcr" use="concat (substring(./text,28,1), substring(./text,30,1))" />

    <!-- ==== attributes ====  -->
    <xsl:template name="attBiblioBlock">
        <xsl:attribute name="class">mt2 skiptranslate</xsl:attribute>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>
    
    <xsl:template name="attBiblioBlockTitle">
        <xsl:attribute name="class">coGrey skiptranslate</xsl:attribute>
        <xsl:attribute name="class">en</xsl:attribute>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>
    
    <xsl:template name="attBiblioBlockPara">
        <xsl:attribute name="class">coGrey skiptranslate</xsl:attribute>
        <xsl:call-template name="dbgAttTrace"/>
    </xsl:template>
    

    <!-- ==== FIELDS ====  -->

    <!-- === Title (en) | Title (de) | Title (fr) === -->
    <xsl:template match="TIEN|TIDE|TIFR">
        <xsl:variable name="vCodeLang" select="lower-case(substring(local-name(),3))"/>
        <xsl:if test="//ep-patent-document/SDOBI/B500/B540/B541[(text() = $vCodeLang) or (text() = substring(name(),3))]">
            <section data-part="title">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:attribute name="lang"><xsl:value-of select="//ep-patent-document/SDOBI/B500/B540/B541[(text() = $vCodeLang) or (text() = substring(name(),3))]"/></xsl:attribute>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B500/B540/B542[(preceding-sibling::B541[1] = $vCodeLang) or (preceding-sibling::B541[1] = substring(name(),3))]"/>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Abstract (en) | Abstract (de) | Abstract (fr) === -->
    <xsl:template match="ABEN|ABDE|ABFR">
        <xsl:variable name="vCodeLang" select="lower-case(substring(local-name(),3))"/>
        <xsl:if test="//ep-patent-document/abstract[(@lang = $vCodeLang) or (@lang = substring(name(),3))]">
            <section data-part="abstract">
                <xsl:call-template name="tpl-Label" />
                <xsl:apply-templates select="//ep-patent-document/abstract[(@lang = $vCodeLang) or (@lang = substring(name(),3))]/p"/>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Publication === -->
    <xsl:template match="EP_">
        <!-- [uoss before]
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B100"/>
                </xsl:element>
            </section>
            
-->              
        <div>
            <xsl:call-template name="attBiblioBlock"/>
            <divTitle class="coGrey skiptranslate" lang="en">
                <xsl:call-template name="attBiblioBlockTitle"/>
                <xsl:text><!--#stripSpace--></xsl:text>
                <xsl:text>Publication<!-- TODO  <xsl:call-template name="tpl-Label"/> --></xsl:text>
            </divTitle>
            <xsl:apply-templates select="//ep-patent-document/SDOBI/B100"/>
        </div>
    </xsl:template>




    <xsl:template match="B100">
        <xsl:variable name="v_content">
            <xsl:apply-templates select="B190"/>
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates select="B110"/>
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates select="B130"/>
            <xsl:text>&#160;</xsl:text>
            <xsl:if test="B150/B151">
                <xsl:apply-templates select="B150/B151"/>
                <xsl:text>&#160;</xsl:text>
            </xsl:if>
            <xsl:if test="B132EP">
                <xsl:apply-templates select="B132EP"/>
                <xsl:text>&#160;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="B140/date"/>
            <xsl:choose>
                <xsl:when test="(B130='A1' or B130='A2') and (string-length(//ep-patent-document/SDOBI/B400/B430/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B400/B430/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B430/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B430/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="(B130='A3') and (string-length(//ep-patent-document/SDOBI/B800/B880/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B800/B880/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B800/B880/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B800/B880/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="(B130='B1') and (string-length(//ep-patent-document/SDOBI/B400/B450/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B400/B450/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B450/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B450/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="(B130='B2') and (string-length(//ep-patent-document/SDOBI/B400/B477/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B400/B477/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B477/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B477/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="(B130='B3') and (string-length(//ep-patent-document/SDOBI/B400/B453EP/B4530EP/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B400/B453EP/B4530EP/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B453EP/B4530EP/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B453EP/B4530EP/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="(B130='A8' or B130='A9' or B130='B8' or B130='B9') and (string-length(//ep-patent-document/SDOBI/B400/B480/bnum) &gt; 0)">
                    <xsl:choose>
                        <xsl:when test="not(//ep-patent-document/SDOBI/B400/B480/bnum/HIT)">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B480/bnum"/>
                                <xsl:with-param name="higlighted">no</xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:call-template name="formatbnum">
                                <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B480/bnum"/>
                                <xsl:with-param name="higlighted">yes</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!-- anchor -->
        <xsl:variable name="vDataLinkTypeAndUrl">
            <xsl:call-template name="tpl-TypUrlPubServer">
                <xsl:with-param name="fLang" select="$pLang"/>
                <xsl:with-param name="fLinkFormat" select="'EPAB'"/>
                <xsl:with-param name="fKind" select="$vRefKind"/>
                <xsl:with-param name="fPubCountry" select="$vRefCtry"/>
                <xsl:with-param name="fPubNumber" select="$vRefDocNum"/>
            </xsl:call-template>
        </xsl:variable>
        
        <p>
            <xsl:call-template name="attBiblioBlockPara"/>
            
            <xsl:choose>
                <xsl:when test=" $vDataLinkTypeAndUrl != '_'">
                    <a>
                        <xsl:attribute name="href"><xsl:value-of select="substring-after($vDataLinkTypeAndUrl,'!')"/></xsl:attribute>
                        <xsl:attribute name="data-link-type"><xsl:value-of select="substring-before($vDataLinkTypeAndUrl,'!')"/></xsl:attribute>
                        <xsl:attribute name="target">_blank</xsl:attribute>
                        <xsl:attribute name="class">cInterPub cExternalLnk</xsl:attribute>
                        <xsl:value-of select="$v_content"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$v_content"/>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>

    <!-- === Application === -->
    <xsl:template match="APN_DOC">
        <xsl:if test="//ep-patent-document/SDOBI/B200">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B200"/>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template name="tpl-B200">
        <!--# @ B200 level -->
        <xsl:apply-templates select="//SDOBI/B100/B190"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:apply-templates select="B210"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:apply-templates select="B220/date"/>
    </xsl:template>

    <xsl:template match="B200">
            <xsl:variable name="vDataLinkTypeAndUrl">
                <xsl:call-template name="tpl-TypUrlRegisterLink">
                    <xsl:with-param name="fLang" select="$pLang"/>
                    <xsl:with-param name="fLinkFormat" select="'EPAB'"/>
                    <xsl:with-param name="fCountry" select="$vRefCtry"/>
                    <xsl:with-param name="fAppNumber" select="$vAppDocNum"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test=" $vDataLinkTypeAndUrl != '_'">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="substring-after($vDataLinkTypeAndUrl,'!')"/>
                        </xsl:attribute>
                        <xsl:attribute name="data-link-type">
                            <xsl:value-of select="substring-before($vDataLinkTypeAndUrl,'!')"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">_blank</xsl:attribute>
                        <xsl:attribute name="class">cAppNumber cExternalLnk</xsl:attribute>
                        <xsl:call-template name="tpl-B200"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="tpl-B200"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

    <!-- === Priority === -->
    <xsl:template match="PRN_DOC">
        <xsl:if test="//ep-patent-document/SDOBI/B300">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <ul class="cPriority">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B300/B310">
                        <li>
                            <xsl:apply-templates select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="B310">
        <xsl:apply-templates select="following-sibling::B330[count(.)]/ctry"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:choose>
            <xsl:when test="starts-with(.,following-sibling::B330[count(.)]/ctry)">
                <xsl:choose>
                    <xsl:when test="HIT">
                        <span class="cHit" id="hitmimosa_{generate-id()}">
                            <xsl:value-of select="substring-after(.,following-sibling::B330[count(.)]/ctry)"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(.,following-sibling::B330[count(.)]/ctry)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#160;</xsl:text>
        <xsl:apply-templates select="following-sibling::B320[count(.)]/date"/>
    </xsl:template>

    <!-- === Parent Application / Publication === -->
    <xsl:template match="PAAP">
        <xsl:if test="//ep-patent-document/SDOBI/B600/B620/parent/pdoc/dnum//anum">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <ul class="cParAppPub">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B600/B620/parent/pdoc">
                        <li>
                            <xsl:apply-templates select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Divisional Application / Publication === -->
    <xsl:template match="DIAP">
        <xsl:if test="//ep-patent-document/SDOBI/B600/B620EP/parent/cdoc/dnum//anum">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <ul class="cDivAppPub">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B600/B620EP/parent/cdoc">
                        <li>
                            <xsl:apply-templates select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </section>
        </xsl:if>
    </xsl:template>


    <xsl:template name="tplB620dnum">
        <xsl:choose>
            <xsl:when test="contains(.//anum,'.')">
                <xsl:value-of select="substring-before(.//anum,'.')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select=".//anum"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test=".//pnum">
            <xsl:text>&#160;</xsl:text>
            <xsl:text>/</xsl:text>
<!-- [ToMerge] -->
            <xsl:text>&#160;</xsl:text>
<!-- [/ToMerge] -->
            <xsl:apply-templates select=".//pnum"/>
            <!--xsl:choose>
                <xsl:when test="ancestor::B620EP">
                    <xsl:apply-templates select="dnum//pnum"/>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:variable name="urlParams">
                            <xsl:text>?cc=</xsl:text><xsl:value-of select="url:encode($vRefCtry)" />
                            <xsl:text>&amp;pn=</xsl:text><xsl:value-of select="url:encode(dnum//pnum)"/>
                            <xsl:text>&amp;ki=</xsl:text><xsl:value-of select="url:encode($vRefKind)"/>
                        </xsl:variable>
                        <xsl:attribute name="href"><xsl:value-of select="concat($pUrlPubServer)" /><xsl:value-of select="$urlParams" /></xsl:attribute>
                        <xsl:attribute name="class">cLnk</xsl:attribute>
                        <xsl:attribute name="target">_blank</xsl:attribute>
                        <xsl:apply-templates select="dnum//pnum"/>
                    </a>
                </xsl:otherwise>
            </xsl:choose-->
        </xsl:if>
    </xsl:template>

    <xsl:template match="B620/parent/pdoc|B620EP/parent/cdoc">
        <xsl:choose>
            <xsl:when test="dnum/HIT">
                <span class="cHit" id="hitmimosa_{generate-id()}">
                    <xsl:call-template name="tplB620dnum"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="tplB620dnum"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- === Designated state === -->
    <xsl:template match="DCS">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B840//ctry">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B800/B840//ctry">
                        <xsl:apply-templates select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>&#32;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>


    <!-- === Extension state === -->
    <xsl:template match="DXS">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B844EP/B845EP//ctry">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B800/B844EP/B845EP//ctry">
                        <xsl:apply-templates select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>&#32;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Designated Validation States === -->
    <xsl:template match="DVS">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B848EP//ctry">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <xsl:element name="p">
                    <xsl:for-each select="//ep-patent-document/SDOBI/B800/B848EP//ctry">
                        <xsl:apply-templates select="."/>
                        <xsl:if test="position() != last()">
                            <xsl:text>&#32;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>
    
    
    <!-- === IC17, IPC 1-7 , B51[1-5], (main, further and additional classification) === -->
    <xsl:template match="IC17">
		<!--#cmt:msg="TODO solr4.6 cf IGPI add tpl-Ipc7 (tag B51[1-5]) "-->
        <xsl:if test="//ep-patent-document/SDOBI/B500/B510">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:for-each select="//ep-patent-document/SDOBI/B500/B510">
                    <xsl:element name="p">
                        <xsl:for-each select="B511|B512|B513|B514|B515">
                            <xsl:choose>
                                <xsl:when test="./HIT">
                                    <span class="cHit" id="hitmimosa_{generate-id()}"><xsl:call-template name="tplCallLnkIpc7"/></span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="tplCallLnkIpc7"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                </xsl:element>
                </xsl:for-each>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === IPC 7 full level (invention information) === -->
    <xsl:template name="tplCallLnkIpc7">
		<!--# cmt:ctxt="B511|...|B515"-->
        <xsl:variable name="vIpc" select="string(.)"/>

        <!--[DBG]-/->
        <xsl:comment><xsl:value-of select="$vIpc"/></xsl:comment>
        <!-/-[/DBG]-->

        <xsl:call-template name="tpl-lnkIpc7">
            <xsl:with-param name="ipc" select="$vIpc"/>
            <xsl:with-param name="style" select="''"/>
        </xsl:call-template>
    </xsl:template>

    <!-- === IPC full level (invention information) === -->
    <xsl:template match="ICFI">
        <xsl:if test="count (key( 'keyIpcr', 'AI') ) &gt; 0">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:for-each select="key('keyIpcr', 'AI')">
                        <xsl:call-template name="tpl-Ipc8">
                            <xsl:with-param name="ipc" select="./text"/>
                            <xsl:with-param name="hit">
                                <xsl:if test="./text/HIT">yes</xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>


    <!-- === IPC full level (additional information) === -->
    <xsl:template match="ICFA">
        <xsl:if test="count (key( 'keyIpcr', 'AN')) &gt; 0">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <xsl:for-each select="key('keyIpcr', 'AN')">
                        <xsl:call-template name="tpl-Ipc8">
                            <xsl:with-param name="ipc" select="./text"/>
                            <xsl:with-param name="hit">
                                <xsl:if test="./text/HIT">yes</xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Applicant / Proprietor === -->
    <xsl:template match="APP_WORD">
        <xsl:if test="//ep-patent-document/SDOBI/B700/B710/B711 | //ep-patent-document/SDOBI/B700/B730/B731">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:variable name="nbelt" select="count(//ep-patent-document/SDOBI/B700/B710/B711 | //ep-patent-document/SDOBI/B700/B730/B731)"/>
                <xsl:choose>
                    <xsl:when test="$nbelt &gt; 1">
                        <ul>
                            <xsl:for-each select="//ep-patent-document/SDOBI/B700/B710/B711|//ep-patent-document/SDOBI/B700/B730/B731">
                                <xsl:call-template name="personsdata">
                                    <xsl:with-param name="nbelt" select="$nbelt"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:for-each select="//ep-patent-document/SDOBI/B700/B710/B711|//ep-patent-document/SDOBI/B700/B730/B731">
                                <xsl:call-template name="personsdata">
                                    <xsl:with-param name="nbelt" select="$nbelt"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Inventor === -->
    <xsl:template match="INV_WORD">
        <xsl:if test="//ep-patent-document/SDOBI/B700/B720">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <xsl:variable name="nbelt" select="count(//ep-patent-document/SDOBI/B700/B720/B721)"/>
                <xsl:choose>
                    <xsl:when test="$nbelt &gt; 1">
                        <ul>
                            <xsl:for-each select="//ep-patent-document/SDOBI/B700/B720/B721">
                                <xsl:call-template name="personsdata">
                                    <xsl:with-param name="nbelt" select="$nbelt"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                     <p>
                        <xsl:for-each select="//ep-patent-document/SDOBI/B700/B720/B721">
                         <xsl:call-template name="personsdata">
                            <xsl:with-param name="nbelt" select="$nbelt"/>
                         </xsl:call-template>
                        </xsl:for-each>
                     </p>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Representative === -->
    <xsl:template match="REP_WORD">
        <xsl:if test="//ep-patent-document/SDOBI/B700/B740">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <xsl:variable name="nbelt" select="count(//ep-patent-document/SDOBI/B700/B740/B741)"/>
                <xsl:choose>
                    <xsl:when test="$nbelt &gt; 1">
                        <ul>
                            <xsl:for-each select="//ep-patent-document/SDOBI/B700/B740/B741">
                                <xsl:call-template name="personsdata">
                                    <xsl:with-param name="nbelt" select="$nbelt"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:for-each select="//ep-patent-document/SDOBI/B700/B740/B741">
                                <xsl:call-template name="personsdata">
                                    <xsl:with-param name="nbelt" select="$nbelt"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template name="personsdata">
        <xsl:param name="nbelt"/>
        <xsl:choose>
            <xsl:when test="$nbelt &gt; 1">
                <xsl:choose>
                    <xsl:when test="B725EP/text">
                        <li>
                            <xsl:apply-templates select="B725EP/text"/>
                        </li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li>
                            <xsl:apply-templates select="snm"/>
                            <xsl:if test="sfx">
                                <xsl:text>, </xsl:text>
                                <xsl:apply-templates select="sfx"/>
                            </xsl:if>
                            <xsl:if test="adr|B716EP|B736EP">
                                <br/>
                                <xsl:if test="adr">
                                    <span>
                                        <xsl:apply-templates select="adr/node()"/>
                                    </span>
                                </xsl:if>
                                <xsl:if test="B716EP|B736EP">
                                    <xsl:if test="adr">
                                        <br/>
                                    </xsl:if>
                                    <span class="grayColor">
                                        <xsl:call-template name="get-label">
                                            <xsl:with-param name="id">DCS</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:text> : </xsl:text>
                                    </span>
                                    <span>
                                        <xsl:apply-templates select="B716EP|B736EP"/>
                                    </span>
                                </xsl:if>
                            </xsl:if>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="B725EP/text">
                        <span>
                            <xsl:apply-templates select="B725EP/text"/>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:apply-templates select="snm"/>
                            <xsl:if test="sfx">
                                <xsl:text>, </xsl:text>
                                <xsl:apply-templates select="sfx"/>
                            </xsl:if>
                        </span>
                        <xsl:if test="adr">
                            <br/>
                            <span>
                                <xsl:apply-templates select="adr/node()"/>
                            </span>
                        </xsl:if>
                        <xsl:if test="B716EP|B736EP">
                            <br/>
                            <span class="grayColor">
                                <xsl:call-template name="get-label">
                                    <xsl:with-param name="id">DCS</xsl:with-param>
                                </xsl:call-template>
                                <xsl:text> : </xsl:text>
                            </span>
                            <span>
                                <xsl:apply-templates select="B716EP|B736EP"/>
                            </span>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="adr">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- Tous les noeuds fils de adr separe par un espace -->
    <xsl:template match="adr/node()">
        <xsl:if test="preceding-sibling::node()">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="B716EP|B736EP">
        <xsl:apply-templates mode="blanclist"/>
    </xsl:template>

    <xsl:template match="ctry" mode="blanclist">
        <xsl:if test="preceding-sibling::ctry">
            <xsl:text>&#160;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- === International publication === -->
    <xsl:template match="IPUN_DOC">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B870/B871">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <xsl:element name="p">
                    <!--[OLD]-/->
                    <x.l:call-template name="tpl-LnkWipoPatsco">
                        <x.l:with-param name="p_ref" select="url:encode(//ep-patent-document/SDOBI/B800/B870/B871/dnum/pnum)"/>
                        <x.l:with-param name="p_txt">
                            <x.l:apply-templates select="//ep-patent-document/SDOBI/B800/B870/B871/dnum/pnum"/>
                            <x.l:if test=" //ep-patent-document/SDOBI/B800/B870/B871/date">
                                <x.l:text disable-output-escaping="yes">&amp;</x.l:text>
                                <x.l:text>#160;</x.l:text>
                                <x.l:value-of select="//ep-patent-document/SDOBI/B800/B870/B871/date"/>
                            </x.l:if>
                        </x.l:with-param>
                    </x.l:call-template>
                    <!-/-[/OLD]-->
                    <!--[NEW]-->
                    <xsl:variable name="v_content">
                        <xsl:apply-templates select="//ep-patent-document/SDOBI/B800/B870/B871/dnum/pnum"/>
                        <xsl:if test=" //ep-patent-document/SDOBI/B800/B870/B871/date">
                            <xsl:value-of select="concat('&#160;', //ep-patent-document/SDOBI/B800/B870/B871/date)"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="v_cc_pubnum" select="//ep-patent-document/SDOBI/B800/B870/B871/dnum/pnum"/>

                    <xsl:variable name="vDataLinkTypeAndUrl">
                        <xsl:call-template name="tpl-TypUrlPatenscopePublication">
                            <xsl:with-param name="fLang" select="$pLang"/>
                            <xsl:with-param name="fPubCountry" select="substring($v_cc_pubnum,1,2)"/>
                            <xsl:with-param name="fPubNumber" select="substring($v_cc_pubnum,3)"/>
                            <xsl:with-param name="fPubDate" select="//ep-patent-document/SDOBI/B800/B870/B871/dnum/date"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:choose>
                            <xsl:when test=" $vDataLinkTypeAndUrl != '_'">
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="substring-after($vDataLinkTypeAndUrl,'!')"/></xsl:attribute>
                                    <xsl:attribute name="data-link-type"><xsl:value-of select="substring-before($vDataLinkTypeAndUrl,'!')"/></xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:attribute name="class">cInterPub cExternalLnk</xsl:attribute>
                                    <xsl:value-of select="$v_content"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$v_content"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    <!--[/NEW]-->
                    <xsl:choose>
                     <xsl:when test="string-length(//ep-patent-document/SDOBI/B800/B870/B871/bnum/HIT) != 0">
                         <span class="cHit" id="hitmimosa_{generate-id()}">
                             <xsl:text>&#160;</xsl:text>
                             <xsl:text>[</xsl:text>
                             <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B800/B870/B871/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B800/B870/B871/bnum,5))" />
                             <xsl:text>]</xsl:text>
                         </span>
                     </xsl:when>
                     <xsl:when test="string-length(//ep-patent-document/SDOBI/B800/B870/B871/bnum) != 0">
                         <xsl:text>&#160;</xsl:text>
                         <xsl:text>[</xsl:text>
                         <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B800/B870/B871/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B800/B870/B871/bnum,5))" />
                         <xsl:text>]</xsl:text>
                     </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === International application === -->
    <xsl:template match="IAPN_DOC">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B860/B861">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label" />
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B800/B860/B861/dnum/anum"/>
                    <xsl:if test="//ep-patent-document/SDOBI/B800/B860/B861/date">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:apply-templates select="//ep-patent-document/SDOBI/B800/B860/B861/date"/>
                    </xsl:if>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B800/B860/B862) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:text>(</xsl:text>
                        <xsl:apply-templates  select="//ep-patent-document/SDOBI/B800/B860/B862" />
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Patent citation (examination phase) === -->
    <xsl:template match="CPEP">
        <xsl:if test="//ep-patent-document/SDOBI/B500/B560/B561">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:for-each select="//ep-patent-document/SDOBI/B500/B560/B561">
                        <xsl:variable name="ctry" select="substring-before(text,' ')"/>
                        <xsl:variable name="kind">
                            <xsl:call-template name="cpepkind">
                                <xsl:with-param name="cpep" select="text"/>
                                <xsl:with-param name="idx" select="string-length(text)"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="doc-number" select="normalize-space(substring-before(substring-after(text,' '),$kind))"/>
                        <xsl:call-template name="tpl-LnkEspacenet">
                            <xsl:with-param name="pStyle" select="'cCitation cExternalLnk'"/>
                            <xsl:with-param name="pCtry" select="$ctry"/>
                            <xsl:with-param name="pDocNum" select="translate($doc-number,' ','')"/>
                            <xsl:with-param name="pKind" select="$kind"/>
                            <xsl:with-param name="pHit">
                                <xsl:if test="text/HIT">yes</xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:if test="position() != last()">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === NPL citation (examination phase) === -->
    <xsl:template match="CNEP">
        <xsl:if test="//ep-patent-document/SDOBI/B500/B560/B562">
            <section class="skiptranslate">
                 <xsl:call-template name="tpl-Label"/>
                 <xsl:variable name="nbelt" select="count(//ep-patent-document/SDOBI/B500/B560/B562)"/>
                 <xsl:variable name="tagName">
                     <xsl:choose>
                         <xsl:when test="$nbelt &gt; 1">ul</xsl:when>
                         <xsl:otherwise>p</xsl:otherwise>
                     </xsl:choose>
                 </xsl:variable>
                 <xsl:element name="{$tagName}">
                     <xsl:choose>
                         <xsl:when test="$nbelt = 1">
                             <xsl:apply-templates select="//ep-patent-document/SDOBI/B500/B560/B562/text"/>
                         </xsl:when>
                         <xsl:otherwise>
                             <xsl:for-each select="//ep-patent-document/SDOBI/B500/B560/B562[text!='']">
                                 <li>
                                     <xsl:apply-templates select="text"/>
                                 </li>
                             </xsl:for-each>
                         </xsl:otherwise>
                     </xsl:choose>
                 </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === Patent citation (applicant) === -->
    <xsl:template match="CPAP_DOC">
        <xsl:if test="//ep-patent-document/ep-reference-list//li//patcit">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <xsl:variable name="nbelt" select="count(//ep-patent-document/ep-reference-list//li//patcit)"/>
                <xsl:variable name="tagName">
                    <xsl:choose>
                        <xsl:when test="$nbelt &gt; 1">ul</xsl:when>
                        <xsl:otherwise>p</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$tagName}">
                    <xsl:choose>
                        <xsl:when test="$nbelt = 1">
                            <xsl:for-each select="//ep-patent-document/ep-reference-list//li//patcit">
                                <xsl:choose>
                                    <xsl:when test="HIT">
                                        <span class="cHit" id="hitmimosa_{generate-id()}">
                                            <xsl:call-template name="patcit-entry"/>
                                        </span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="patcit-entry"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="//ep-patent-document/ep-reference-list//li//patcit">
                                <li>
                                    <xsl:choose>
                                        <xsl:when test="HIT">
                                            <span class="cHit" id="hitmimosa_{generate-id()}">
                                                <xsl:call-template name="patcit-entry"/>
                                            </span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="patcit-entry"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template name="patcit-entry">
        <xsl:variable name="ctry">
            <xsl:choose>
                <xsl:when test="descendant::document-id">
                    <xsl:value-of select="descendant::document-id/country"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(@dnum,1,2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="doc-number">
            <xsl:choose>
                <xsl:when test="descendant::document-id">
                    <xsl:value-of select="descendant::document-id/doc-number"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(@dnum,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="kind">
            <xsl:choose>
                <xsl:when test="descendant::document-id">
                    <xsl:value-of select="descendant::document-id/kind"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(@dnum,$doc-number)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:value-of select="descendant::document-id/date"/>
        </xsl:variable>
        <xsl:variable name="name">
            <xsl:value-of select="descendant::document-id/name"/>
        </xsl:variable>


        <xsl:call-template name="tpl-LnkEspacenet">
            <xsl:with-param name="pStyle" select="'cCitation cExternalLnk'"/>
            <xsl:with-param name="pCtry" select="$ctry"/>
            <xsl:with-param name="pDocNum" select="$doc-number"/>
            <xsl:with-param name="pKind" select="$kind"/>
            <xsl:with-param name="pDate" select="$date"/>
            <xsl:with-param name="pName"><!-- garder vide --></xsl:with-param>
            <xsl:with-param name="pText" select="text"/>
            <xsl:with-param name="pHit" select="'no'"/>
            <xsl:with-param name="pId"><!-- garder vide --></xsl:with-param>
        </xsl:call-template>
        <!--[OLD]-/->
        <xsl:element name="a">
            ...
            <x.l:choose>
                <x.l:when test="string-length(text) &gt; 0">
                    <x.l:apply-templates select="text"/>
                </x.l:when>
                <x.l:otherwise>
                    <x.l:apply-templates select="descendant::document-id/country"/>
                    <x.l:text disable-output-escaping="yes">&amp;</x.l:text>#160;<x.l:apply-templates select="descendant::document-id/doc-number"/>
                    <x.l:text disable-output-escaping="yes">&amp;</x.l:text>
                    <x.l:text>#160;</x.l:text>
                    <x.l:apply-templates select="descendant::document-id/kind"/>
                    <x.l:if test="string-length(descendant::document-id/date)  &gt; 0">
                        <x.l:text disable-output-escaping="yes">&amp;</x.l:text>
                        <x.l:text>#160;</x.l:text>
                        <x.l:apply-templates select="descendant::document-id/date"/>
                    </x.l:if>
                </x.l:otherwise>
            </x.l:choose>
        </x.l:element>
        <!-/-[/OLD]-->
        <xsl:if test="(string-length(descendant::document-id/name) &gt; 0)">
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates select="descendant::document-id/name"/>
        </xsl:if>

        <xsl:for-each select="../crossref">
            <xsl:call-template name="tpl-LnkCrossref">
                <xsl:with-param name="pNumber" select="."/>
                <xsl:with-param name="pHref" select="@idref"/>
                <xsl:with-param name="pDockey">
                    <xsl:if test="preceding-sibling::patcit"><xsl:value-of select="$pDocumentId" /></xsl:if>
                </xsl:with-param>
                <xsl:with-param name="pHit">
                    <xsl:if test="HIT">yes</xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>



    <!-- === NPL citation (applicant) === -->
    <xsl:template match="CNAP_DOC">
        <xsl:if test="//ep-patent-document/ep-reference-list//li/nplcit">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <xsl:variable name="nbelt" select="count(//ep-patent-document/ep-reference-list//li/nplcit)"/>
                <xsl:variable name="tagName">
                    <xsl:choose>
                        <xsl:when test="$nbelt &gt; 1">ul</xsl:when>
                        <xsl:otherwise>p</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$tagName}">
                    <xsl:choose>
                        <xsl:when test="$nbelt = 1">
                            <xsl:for-each select="//ep-patent-document/ep-reference-list//li/nplcit">
                                <xsl:call-template name="nplcit-entry"/>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="//ep-patent-document/ep-reference-list//li/nplcit">
                                <li>
                                    <xsl:call-template name="nplcit-entry"/>
                                </li>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template name="nplcit-entry">
        <xsl:apply-templates mode="nplcit"/>
        <xsl:for-each select="../crossref">
            <xsl:call-template name="tpl-LnkCrossref">
                <xsl:with-param name="pNumber" select="."/>
                <xsl:with-param name="pHref" select="@idref"/>
                <xsl:with-param name="pDockey"><xsl:value-of select="$pDocumentId"/></xsl:with-param>
                <xsl:with-param name="pHit">
                    <xsl:if test="HIT">yes</xsl:if>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="nplcit">
        <xsl:choose>
            <xsl:when test="name() = 'book-title'">
                <b>
                    <xsl:apply-templates mode="nplcit"/>
                </b>
                <xsl:if test="string-length(text()) &gt; 0">
                    <xsl:text>&#32;</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:when test="name() = 'name' and parent::author">
                <b>
                    <xsl:choose>
                        <xsl:when test="./HIT">
                            <xsl:for-each select="HIT">
                                <xsl:value-of select="preceding-sibling::text()"/>
                                <span class="cHit" id="hitmimosa_{generate-id()}">
                                    <xsl:value-of select="."/>
                                </span>
                            </xsl:for-each>
                            <xsl:value-of select="HIT[last()]/following-sibling::text()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="parent::author[following-sibling::author]">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </b>
                <xsl:if test="string-length(string(.)) &gt; 0">
					<!--#  cmt:msg="test on all content if HIT -->
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="nplcit"/>
                <xsl:if test="string-length(text()) &gt; 0">
                    <xsl:text>&#32;</xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="HIT" mode="nplcit">
        <span class="cHit" id="hitmimosa_{generate-id()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- === Correction date === -->
    <xsl:template match="COD">
        <xsl:if test="//ep-patent-document/SDOBI/B400/B480/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:for-each select="//ep-patent-document/SDOBI/B400/B480">
                        <xsl:apply-templates select="date"/>
                        <xsl:if test="string-length(bnum) != 0">
                            <xsl:text>&#160;</xsl:text>
                            <xsl:text>[</xsl:text>
                            <xsl:value-of  select="concat(substring(bnum,1,4), '-',substring(bnum,5))" />
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="position() != last()">; </xsl:if>
                    </xsl:for-each>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === A1/A2 publication date === -->
    <xsl:template match="PUA12">
        <xsl:if test="//ep-patent-document/SDOBI/B400/B430/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B400/B430/date"/>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B400/B430/bnum) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B400/B430/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B400/B430/bnum,5))" />
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === A3 publication date === -->
    <xsl:template match="PUA3">
        <xsl:if test="//ep-patent-document/SDOBI/B800/B880/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B800/B880/date"/>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B800/B880/bnum) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B800/B880/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B800/B880/bnum,5))" />
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === B1 publication date === -->
    <xsl:template match="PUB1">
        <xsl:if test="//ep-patent-document/SDOBI/B400/B450/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B400/B450/date"/>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B400/B450/bnum) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B400/B450/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B400/B450/bnum,5))" />
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === B2 publication date === -->
    <xsl:template match="PUB2">
        <xsl:if test="//ep-patent-document/SDOBI/B400/B477/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B400/B477/date"/>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B400/B477/bnum) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of  select="concat(substring(//ep-patent-document/SDOBI/B400/B477/bnum,1,4), '-',substring(//ep-patent-document/SDOBI/B400/B477/bnum,5))" />
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>

    <!-- === B3 publication date === -->
    <xsl:template match="PUB3">
        <xsl:if test="//ep-patent-document/SDOBI/B400/B453EP/B4530EP/date">
            <section class="skiptranslate">
                <xsl:call-template name="tpl-Label"/>
                <p>
                    <xsl:apply-templates select="//ep-patent-document/SDOBI/B400/B453EP/B4530EP/date"/>
                    <xsl:if test="string-length(//ep-patent-document/SDOBI/B400/B453EP/B4530EP/bnum) != 0">
                        <xsl:text>&#160;</xsl:text>
                        <xsl:call-template name="formatbnum">
                            <xsl:with-param name="bnum" select="//ep-patent-document/SDOBI/B400/B453EP/B4530EP[not(../B4530EP/@sequence &gt; @sequence)]/bnum"/>
                        </xsl:call-template>
                    </xsl:if>
                </p>
            </section>
        </xsl:if>
    </xsl:template>


    <!-- ==== OPS FIELDS ====  -->

    <xsl:template match="IECLA">
        <xsl:if test="//ep-patent-document/SDOBI">
            <section class="field-ops-IECLA skiptranslate">
                <xsl:call-template name="tpl-Label"/>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ICPC">
        <xsl:if test="//ep-patent-document/SDOBI">
            <section class="field-ops-ICPC skiptranslate">
                <xsl:call-template name="tpl-Label"/>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ISFAM">
        <xsl:if test="//ep-patent-document/SDOBI">
            <section class="field-ops-ISFAM skiptranslate">
                <xsl:call-template name="tpl-Label"/>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="IFAM">
        <xsl:if test="//ep-patent-document/SDOBI">
            <section class="field-ops-IFAM skiptranslate">
                <xsl:call-template name="tpl-Label"/>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="B110|B190|B130|B210|B151|B132EP|B542|B862|text|str|city|iid|irf|anum|pnum|snm|sfx|ctry|country|kind|doc-number|name|date">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
