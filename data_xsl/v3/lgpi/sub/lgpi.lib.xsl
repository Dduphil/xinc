<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd" version="3.0">
    <xd:doc scope="stylesheet/lgpi">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> common LGPI</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/lib_temp_html5.xsl</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template name="tpl-LnkInt"><!-- pour traiter l'element  "./document-id"  -->
        <xsl:param name="pStyle"/>
        <xsl:param name="pCtry"/>
        <xsl:param name="pDocNum"/>
        <xsl:param name="pKind"/>
        <xsl:param name="pDate"/>
        <xsl:param name="pAdd_date"/>
        <xsl:param name="pType"/>
        
        <xsl:variable name="vRef">
            <xsl:choose>
                <xsl:when test="$pAdd_date = 'yes'"><xsl:value-of select="concat ( $pCtry, '&#160;', $pDocNum, '&#160;', $pKind)"/></xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat ( $pCtry, $pDocNum, $pKind)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="use-date-for-ukey">
            <xsl:call-template name="useDateForUkey">
                <xsl:with-param name="ctry" select="$pCtry"/>
                <xsl:with-param name="kind" select="$pKind"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:element name="a">
            <!-- Links are temporarily disabled -->
            <xsl:attribute name="data-link-ref">
                <xsl:choose>
                    <xsl:when test="(string-length(normalize-space($pDate)) &gt; 0) and $use-date-for-ukey = 'true'">
                        <xsl:value-of select="concat($pUrlPrefix,$pCtry,$pDocNum,$pKind,$pDate)"/>        
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="concat($pUrlPrefix,$pCtry,$pDocNum,$pKind)"/></xsl:otherwise>
                </xsl:choose>                        
            </xsl:attribute>
            <xsl:attribute name="data-link-type"><xsl:value-of select="$pType"/></xsl:attribute>      
            <xsl:attribute name="class"><xsl:value-of select="$pStyle"/><xsl:text> cInternalLnk</xsl:text></xsl:attribute>
            <xsl:value-of select="$vRef"/><xsl:if test="($pAdd_date = 'yes') and (string-length($pDate) &gt; 1)"><xsl:value-of select="concat( '&#160;', $pDate)"/></xsl:if>
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="tpl-LnkInt-disabled"><!-- pour traiter l'element  "./document-id"  -->
        <xsl:param name="pStyle"/>
        <xsl:param name="pCtry"/>
        <xsl:param name="pDocNum"/>
        <xsl:param name="pKind"/>
        <xsl:param name="pDate"/>
        <xsl:param name="pOutput"/>
        <xsl:param name="pAdd_date"/>
        <xsl:param name="pType"/>
        
        <xsl:variable name="vRef">
            <xsl:choose>
                <xsl:when test="$pAdd_date = 'yes'"><xsl:value-of select="concat ( $pCtry, '&#160;', $pDocNum, '&#160;', $pKind)"/></xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat ( $pCtry, $pDocNum, $pKind)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="use-date-for-ukey">
            <xsl:call-template name="useDateForUkey">
                <xsl:with-param name="ctry" select="$pCtry"/>
                <xsl:with-param name="kind" select="$pKind"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:element name="a">            
            <!-- Links are temporarily disabled -->
            <xsl:attribute name="data-link-type"><xsl:value-of select="$pType"/></xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="$pStyle"/><xsl:text> cInternalLnk</xsl:text></xsl:attribute>
            <xsl:value-of select="$vRef"/><xsl:if test="($pAdd_date = 'yes') and (string-length($pDate) &gt; 1)"><xsl:value-of select="concat( '&#160;', $pDate)"/></xsl:if>
        </xsl:element>
        
    </xsl:template>
    
    <!-- ==== IPC 6 et  7 ==== -->
    <xsl:template name="tpl-Ipc7">
        <xsl:param name="ipc"/>
        <xsl:param name="edition"/>
        <xsl:param name="style"/>
        
        <?xslDoc env="pUrlIpc8Wipo,vLang" ?>
<!--
context :
 exch:classification-ipc/text
 exch:classification-ipc/main-classification
 exch:classification-ipc/further-classification
input ipc :'G05G 9/053'
-->            
        <!-- LINK paramaters -->
        <xsl:variable name="vClass"><xsl:value-of select="substring($ipc,1,4)"/></xsl:variable>
        <xsl:variable name="vGroup2" select="substring($ipc,5)"/>
        <xsl:variable name="vGroupBrut"><xsl:value-of select="substring-before(substring($ipc,5),'/')"/></xsl:variable>
        <xsl:variable name="vGroup">
            <xsl:choose>
                <xsl:when test="contains($ipc,'/') and (string-length(translate($vGroupBrut,' ','')) &gt; 0)">
                    <xsl:value-of select="format-number($vGroupBrut,'0000')"/>
                </xsl:when>
                <xsl:otherwise>0000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vSousGroup">
            <xsl:choose>
                <xsl:when test="contains($ipc,'/')">
                    <xsl:variable name="vSousGroupBrut" select="translate(substring-after($ipc,'/'),' ','0')"/>
                    <xsl:call-template name="add-rigth-zeros">
                        <xsl:with-param name="begin">0</xsl:with-param>
                        <xsl:with-param name="end" select="6 - string-length($vSousGroupBrut)"/>
                        <xsl:with-param name="string" select="$vSousGroupBrut"/>
                        <xsl:with-param name="version" select="'v1'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>000000</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vSymbol"><xsl:value-of select="concat($vClass,$vGroup,$vSousGroup)"/></xsl:variable>       
        <xsl:variable name="vEdition">
            <xsl:choose>
                <xsl:when test="$edition = '1'">19680901</xsl:when>
                <xsl:when test="$edition = '2'">19740701</xsl:when>
                <xsl:when test="$edition = '3'">19800101</xsl:when>
                <xsl:when test="$edition = '4'">19850101</xsl:when>
                <xsl:when test="$edition = '5'">19900101</xsl:when>
                <xsl:when test="$edition = '6'">19950101</xsl:when>
                <xsl:otherwise>20000101</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="vLangIpc">
            <xsl:choose>
                <xsl:when test="$vLang = 'de'">en</xsl:when>
                <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
            </xsl:choose>            
        </xsl:variable>
        <!-- Display Value -->
        <xsl:variable name="ipc-norm">
            <xsl:choose>
                <xsl:when test="number($edition) or $edition='0'">
                    <xsl:value-of select="concat($edition,substring(normalize-space($ipc),1))" />
                </xsl:when>
                <xsl:when test="number(substring($ipc,1,1)) and substring($ipc,1,1) != '0'">
                    <xsl:value-of select="$ipc" />
                </xsl:when>                
                <!-- xsl:when test="number(substring($ipc,2,1)) and substring($ipc,2,1) !=0">
                    <xsl:value-of select="substring($ipc,2)" />
                </xsl:when -->
                <xsl:otherwise>
                    <xsl:value-of select="concat('7',substring(normalize-space($ipc),1))" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="c1"><xsl:value-of select="translate(substring($ipc-norm,2,4),' ','')"/></xsl:variable>
        <xsl:variable name="c2">
            <xsl:choose>
                <xsl:when test="number(substring-before(substring($ipc-norm,6),'/')) and (string-length(translate(substring-before(substring($ipc-norm,6),'/'),' ','')) &gt; 0)">
                    <xsl:value-of select="number(substring-before(substring($ipc-norm,6),'/'))"/>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="c3_brut">
            <xsl:value-of select="normalize-space(substring-after($ipc-norm,'/'))"/>
        </xsl:variable>
        
        <xsl:variable name="c3">
            <xsl:choose>
                <xsl:when test="contains($c3_brut, '&#160;') and (number(substring-before($c3_brut,' ')) or translate($c3_brut,'0','')='')">
                    <xsl:value-of select="substring-before($c3_brut,' ')"/>
                </xsl:when>
                <xsl:when test="number($c3_brut) or translate($c3_brut,'0','')=''">
                    <xsl:value-of select="$c3_brut"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="number(0)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="a">
            <xsl:attribute name="data-link-type">wipo</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="concat($pUrlIpc8Wipo,'/?version=',$vEdition,'&amp;symbol=',normalize-space($vSymbol),'&amp;priorityorder=yes&amp;lang=',$vLangIpc)"/></xsl:attribute>
            <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_IPC</xsl:with-param></xsl:call-template></xsl:attribute-->            
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="class"><xsl:value-of select="$style"/><xsl:text> cExternalLnk</xsl:text></xsl:attribute>
            <xsl:variable name="ipc-br">
                <xsl:choose>
                    <xsl:when test="string-length($c2) = 0 and  string-length($c3) = 0">
                        <xsl:value-of select="$c1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($c1,'&#160;',$c2)"/>
                        <xsl:if test="string-length($c3) &gt; 0"><xsl:value-of select="concat('/',$c3)"/></xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="set-non-beaking-spaces"><xsl:with-param name="data" select="translate(normalize-space(concat(substring($ipc-br,1,4), translate(substring($ipc-br,5), 'NaN',' ')) ),' ','&#160;')"></xsl:with-param></xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="tpl-classif-cpc">
        <!-- @level='patent-classification' -->
        <xsl:param name="current-cla"/>
        <xsl:param name="vLang"/>
        <xsl:param name="hit"/>
        <xsl:param name="type"/>
        <xsl:param name="value"/>
        <xsl:param name="pType"/>
        <xsl:param name="hasMutilpleGenOffice" select="false()"/>

        <?xslDoc loc="'http://worldwide.espacenet.com/classification?locale=" ?>
        

        <xsl:variable name="pLangOk">
            <xsl:choose>
                <xsl:when test="($vLang = 'es') or ($vLang = 'jp')">en</xsl:when>
                <xsl:otherwise><xsl:value-of select="$vLang"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="classification">
            <xsl:choose>
                <xsl:when test="contains($current-cla, '(')"><xsl:value-of select="normalize-space(substring-before($current-cla,'('))"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$current-cla"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="separateur">
            <xsl:choose>
                <xsl:when test="contains($classification, ':')">:</xsl:when>
                <xsl:otherwise>/</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="vNorm">
            <xsl:value-of select="substring($classification,1,4)" />
        </xsl:variable>
        <xsl:variable name="vP1" select="substring($classification,1,4)" />
        <xsl:variable name="vP2" select="substring-before(substring($classification,5),$separateur)" />
        <xsl:variable name="vP3" select="substring-after($classification,$separateur)" />
        <span><xsl:element name="a">
            <!-- TODO   global.vRefCtry -->
            <xsl:attribute name="data-link-type"><xsl:value-of select="$pType"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="concat('http://worldwide.espacenet.com/classification?locale=',$pLangOk,'_EP','#!/CPC=',normalize-space($vP1),normalize-space($vP2),'/',$vP3)"/></xsl:attribute>
            <!--xsl:attribute name="title"><xsl:call-template name="get-label"><xsl:with-param name="id">TT_CPC</xsl:with-param></xsl:call-template></xsl:attribute-->       
            <xsl:attribute name="codeParameter">CPC</xsl:attribute>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="($type = 'CPC' or $type = 'CS') and $value = 'I'">cClassCcpInv</xsl:when>
                    <xsl:when test="($type = 'CPC' or $type = 'CS') and $value = 'A'">cClassCcpAdd</xsl:when>
                </xsl:choose>
                <xsl:text> cExternalLnk</xsl:text>
            </xsl:attribute>            
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:choose>
                <xsl:when test="$hit='yes'">
                    <span class="cHit" id="hitmimosa_{generate-id()}">
                        <xsl:call-template name="set-non-beaking-spaces"><xsl:with-param name="data" select="normalize-space(concat($vP1,' ',$vP2,$separateur,$vP3))"></xsl:with-param></xsl:call-template>
                    </span>
                </xsl:when>
                <xsl:otherwise><xsl:call-template name="set-non-beaking-spaces"><xsl:with-param name="data" select="normalize-space(concat($vP1,' ',$vP2,$separateur,$vP3))"></xsl:with-param></xsl:call-template></xsl:otherwise>
            </xsl:choose>
        </xsl:element>
            <xsl:if test="'CS' != $type">
                <xsl:text>&#160;</xsl:text>
                <span class="cClassCcp">
                    <xsl:variable name="vClassifDate">
                        <xsl:choose>
                            <xsl:when test="contains($current-cla, '(')">
                                <xsl:value-of select="normalize-space(substring-before(substring-after($current-cla,'('), ')'))"/>    
                            </xsl:when>
                            <xsl:when test="'' != ./classification-scheme/date">
                                <xsl:value-of select="concat(substring(./classification-scheme/date,1,4), '.', substring(./classification-scheme/date,5,2))"/>    
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="vGenOffice">
                        <xsl:if test="$hasMutilpleGenOffice">
                            <xsl:if test="'' != $vClassifDate">                            
                                <xsl:call-template name="carNbsp"/>
								<xsl:text>-</xsl:text>
								<xsl:call-template name="carNbsp"/>
                            </xsl:if>
                            <xsl:apply-templates select="./generating-office" mode="mdNbsp"/>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:if test="'' != $vClassifDate or  '' != $vGenOffice">
                        <xsl:text>(</xsl:text>
                        <xsl:copy-of select="$vClassifDate"/>
                        <xsl:copy-of select="$vGenOffice" />
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </span>
            </xsl:if>
        </span>
    </xsl:template>
    
</xsl:stylesheet>
