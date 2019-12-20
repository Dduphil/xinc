<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:i_f="http://internalXslt/function" exclude-result-prefixes="xd xs i_f" version="3.0">
    <xd:doc scope="stylesheet/libXsl">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> debug functions or templates</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>Preview update:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/commons/v2_com_txt.xsl</xd:p>
        </xd:desc>
    </xd:doc>

    <!-- ==== lib string and format ==== -->

    <xsl:template name="lib-upper">
        <!-- @depracted -->
        <!-- # temporary use directly xpath function -->
        <xsl:param name="val"/>
        <xsl:value-of select="upper-case($val)"/>
    </xsl:template>

    <xsl:template name="lib-lower">
        <!-- @depracted -->
        <!-- # temporary use directly xpath function -->
        <xsl:param name="val"/>
        <xsl:value-of select="lower-case($val)"/>
    </xsl:template>

    <!-- ===== Non Breaking Space ==== -->
    
    <xsl:template name="carNbsp">
        <!-- OLD:
            <x.l:text disable-output-escaping="yes">&amp;</x.l:text><x.l:text>#160;</x.l:text>
        -->
        <xsl:text>&#160;</xsl:text>
    </xsl:template>
    

    <xsl:template name="set-non-beaking-spaces">
        <xsl:param name="data"/>
        <!-- # utilisation de translate + l'espace insecable -->
        <xsl:value-of select="translate($data, ' ', ' ')"/>
    </xsl:template>


    <xsl:template match="generating-office" mode="mdNbsp">
        <!-- [GPI/CPC] convert black to &#160; and apply on '<HIT>' 
* in: "AA <HIT>BB</HIT> CC"
* out: "AA&#160;<a.hit...>BB</>#160;CC"
        -->
        <xsl:apply-templates select="* | text()" mode="mdNbsp"/>
    </xsl:template>

    <xsl:template match="HIT" mode="mdNbsp">
        <!-- use default mode -->
        <xsl:apply-templates select="."/>
    </xsl:template>

    <xsl:template match="text()" mode="mdNbsp">
        <xsl:value-of select="translate(., ' ', '&#160;')"/>
    </xsl:template>


    <xsl:template name="add-spaces">
        <xsl:param name="nb"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type = 'pdf'">
                <xsl:text>&#160;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="carNbsp"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="($nb - 1) &gt; 0">
            <xsl:call-template name="add-spaces">
                <xsl:with-param name="nb" select="$nb - 1"/>
                <xsl:with-param name="type" select="$type"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ===== Newligne ==== -->

    <!-- remplace les 'NewLine' par des '<br/>' -->
    <xsl:template name="nl2break">
        <xsl:param name="text" select="string(.)"/>
        <xsl:choose>
            <xsl:when test="contains($text, '&#xa;')">
                <xsl:value-of select="substring-before($text, '&#xa;')"/>
                <br/>
                <xsl:call-template name="nl2break">
                    <xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- //TODO -->
    
    <xsl:template name="patchSuppressXmlEntities">
        <!-- origine 201911: {collections}/lgpi/notice-head.xsl -->
        <xsl:param name="pData"/>
        <xsl:variable name="v1" select="translate($pData,'&gt;&lt;&quot;&amp;', '    ')"/>
        <xsl:variable name="v2" select='translate($v1, "&apos;", " ")'/>
        <xsl:value-of select="$v2"/>
    </xsl:template>

    <!--# tronquer une chaine a le derniere occurence du delimiteur	(src:http://stackoverflow.com/questions/11166784/xslt-1-0-finding-the-last-occurence-and-taking-string-before) -->
    <xsl:template name="after-delim">
        <xsl:param name="s"/>
        <xsl:param name="d"/>
        <xsl:choose>
            <xsl:when test="contains($s, $d)">
                <xsl:value-of select="concat($d, substring-before($s, $d))"/>
                <xsl:call-template name="after-delim">
                    <xsl:with-param name="s" select="substring-after($s, $d)"/>
                    <xsl:with-param name="d" select="$d"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="before-last-delim">
        <xsl:param name="s"/>
        <xsl:param name="d"/>
        <xsl:choose>
            <xsl:when test="contains($s, $d)">
                <xsl:value-of select="substring-before($s, $d)"/>
                <xsl:call-template name="after-delim">
                    <xsl:with-param name="s" select="substring-after($s, $d)"/>
                    <xsl:with-param name="d" select="$d"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$s"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!-- Ajoute des zeros a droite d'une chaine	-->
    <xsl:template name="add-rigth-zeros">
        <xsl:param name="begin" select="0"/>
        <xsl:param name="end" select="0"/>
        <xsl:param name="string" select="j"/>
        <xsl:param name="version">v0</xsl:param>
        <?xslDoc fct="add-rigth-zeros" msg="@version=[v1: default, one extra 0|v0:without extra 0 min from ../lgpi/lib_temp_com.xsl]" ?>
        <xsl:choose>
            <xsl:when test="$version = 'v1'">
                <xsl:if test="$begin = $end">
                    <xsl:value-of select="$string"/>
                </xsl:if>
                <xsl:if test="$begin != $end">
                    <xsl:call-template name="add-rigth-zeros">
                        <xsl:with-param name="begin" select="($begin) + 1"/>
                        <xsl:with-param name="end" select="$end"/>
                        <xsl:with-param name="string" select="concat($string, '0')"/>
                        <xsl:with-param name="version" select="'v1'"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="$string"/>
                <xsl:call-template name="add-zeros">
                    <xsl:with-param name="nb" select="$end - $begin"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Cree des zeros nb fois-->
    <xsl:template name="add-zeros">
        <xsl:param name="nb"/>
        <xsl:text>0</xsl:text>
        <xsl:if test="($nb - 1) &gt; 0">
            <xsl:call-template name="add-zeros">
                <xsl:with-param name="nb" select="$nb - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Replace">
        <!--remplace une chaine par une autre-->
        <xsl:param name="chaine"/>
        <xsl:param name="chaineCherche"/>
        <xsl:param name="chaineRempl"/>
        <xsl:param name="Occur"/>
        <!--si Occur n'est pas rempli il remplace toutes les occurences-->
        <xsl:choose>
            <xsl:when test="contains($chaine, $chaineCherche)">
                <xsl:choose>
                    <xsl:when test="number($Occur) = 0">
                        <xsl:value-of select="$chaine"/>
                    </xsl:when>
                    <xsl:when test="$Occur > 0">
                        <xsl:call-template name="Replace">
                            <xsl:with-param name="chaine" select="concat(substring-before($chaine, $chaineCherche), $chaineRempl, substring-after($chaine, $chaineCherche))"/>
                            <xsl:with-param name="chaineCherche" select="$chaineCherche"/>
                            <xsl:with-param name="chaineRempl" select="$chaineRempl"/>
                            <xsl:with-param name="Occur" select="$Occur - 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="Replace">
                            <xsl:with-param name="chaine" select="concat(substring-before($chaine, $chaineCherche), $chaineRempl, substring-after($chaine, $chaineCherche))"/>
                            <xsl:with-param name="chaineCherche" select="$chaineCherche"/>
                            <xsl:with-param name="chaineRempl" select="$chaineRempl"/>
                        </xsl:call-template>

                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$chaine"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="formatNumberBy3">
        <xsl:param name="val"/>
        <xsl:value-of select="translate(format-number($val, '###,###,###,###,###'), ',', ' ')"/>
    </xsl:template>

    <!-- ==== lib date ==== -->

    <xsl:template name="formatDate">
        <xsl:param name="pDate"/>
        <xsl:variable name="vYear" select="substring($pDate, 1, 4)"/>
        <xsl:variable name="vMonth" select="substring($pDate, 5, 2)"/>
        <xsl:variable name="vDay" select="substring($pDate, 7, 2)"/>
        <xsl:value-of select="$vYear"/>
        <xsl:if test="string-length($vMonth) = 2">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$vMonth"/>
        </xsl:if>
        <xsl:if test="string-length($vDay) = 2">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$vDay"/>
        </xsl:if>
    </xsl:template>



    <!-- ==== lib url  ==== -->

    <xsl:template name="url-encoder">
        <xsl:param name="url"/>
        <xsl:value-of select="encode-for-uri($url)"/>
    </xsl:template>



    <!-- ==== lib buisness  ==== -->

    <xsl:template name="tpl-DocId">
        <xsl:apply-templates select="./document-id//country"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="./document-id//doc-number"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="./document-id//kind"/>
    </xsl:template>

    <xsl:template name="tpl-DocId-full">
        <xsl:apply-templates select="./document-id//country"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="./document-id//doc-number"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:if test="./document-id//kind">
            <xsl:apply-templates select="./document-id//kind"/>
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <xsl:if test="./document-id//date">
            <xsl:call-template name="dateTime">
                <xsl:with-param name="pDate" select="./document-id//date"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>



    <xsl:template name="dateTime">
        <xsl:param name="pDate"/>
        <xsl:variable name="vYear" select="substring($pDate, 1, 4)"/>
        <xsl:variable name="vMonth" select="substring($pDate, 5, 2)"/>
        <xsl:variable name="vDay" select="substring($pDate, 7, 2)"/>
        <span><!-- [uoss 'time' to 'span'] -->
            <xsl:attribute name="datetime">
                <xsl:value-of select="$vYear"/>
                <xsl:if test="string-length($vMonth) = 2">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="$vMonth"/>
                </xsl:if>
                <xsl:if test="string-length($vDay) = 2">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="$vDay"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:value-of select="$pDate"/>
        </span>
    </xsl:template>


    <xsl:template name="cpepkind">
        <xsl:param name="cpep"/>
        <xsl:param name="idx"/>
        <xsl:param name="kind"/>

        <xsl:if test="$idx &gt;= 1">
            <xsl:variable name="car" select="substring($cpep, $idx, 1)"/>
            <xsl:choose>
                <xsl:when test="$car = ' '">
                    <xsl:value-of select="$kind"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="cpepkind">
                        <xsl:with-param name="cpep" select="$cpep"/>
                        <xsl:with-param name="idx" select="$idx - 1"/>
                        <xsl:with-param name="kind" select="concat($car, $kind)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>


    <xsl:template name="formatTitle">
        <xsl:param name="title"/>
        <xsl:param name="titleLowerCase"/>
        <xsl:variable name="currentCar" select="substring($title, 1, 1)"/>
        <xsl:if test="string-length($currentCar) &gt; 0">
            <xsl:choose>
                <xsl:when test="number($currentCar) or contains('abcdefghijklmnopqrstuvwxyz-_', substring($titleLowerCase, 1, 1))">
                    <xsl:value-of select="$currentCar"/>
                </xsl:when>
                <xsl:otherwise>-</xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="formatTitle">
                <xsl:with-param name="title" select="substring($title, 2)"/>
                <xsl:with-param name="titleLowerCase" select="substring($titleLowerCase, 2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="useDateForUkey">
        <xsl:param name="ctry"/>
        <xsl:param name="kind"/>
        <xsl:choose>
            <xsl:when test="'A8' = $kind or 'B8' = $kind or 'U8' = $kind or 'A9' = $kind or 'B9' = $kind or 'U9' = $kind">true</xsl:when>
            <xsl:when test="'EP' = $ctry and 'B3' = $kind">true</xsl:when>
            <xsl:when test="'WO' = $ctry and 'A3' = $kind">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- tpl 4 fonte-->

    <xsl:template name="getFont">
        <!--
  return the font name from the Character Range :
  * initial :  Helvetica
  * extended : arabic, ..  Arial
  * others : WipoUniExt

    -->
        <xsl:param name="data"/>
        <xsl:variable name="fontRange-Helvetica" select="'([\\u0000-\\u017F,\\u0080-\\u00FF,\\u0100-\\u017F,\\u0300-\\u036F,\\u2000-\\u206F,\\u20A0-\\u20CF,\\u2200-\\u22FF])*'"/>
        <xsl:variable name="fontRange-Arial"
            select="'([\\u0000-\\u017F,\\u0080-\\u00FF,\\u0100-\\u017F,\\u0180-\\u024F,\\u0370-\\u03FF,\\u0400-\\u04FF,\\u0590-\\u05FF,\\u0600-\\u06FF,\\u1E00-\\u1EFF,\\u2000-\\u206F,\\u20A0-\\u20CF,\\u2200-\\u22FF,\\u2500-\\u257F,\\u25A0-\\u25FF,\\u2600-\\u26FF,\\uFB00-\\uFB4F,\\uFB50-\\uFDFF,\\uFE70-\\uFEFF])*'"/>

        <xsl:choose>
            <xsl:when test="matches($data, $fontRange-Helvetica)">
                <xsl:text>Helvetica</xsl:text>
            </xsl:when>
            <!--xsl:when test="fn:matches($data,$fontRange-Arial)"><xsl:text>Arial</xsl:text></xsl:when-->
            <xsl:otherwise>
                <xsl:text>WipoUniExt</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tplAddFontFamily">
        <xsl:param name="data"/>

        <xsl:variable name="vGetFont">
            <xsl:call-template name="getFont">
                <xsl:with-param name="data" select="$data"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$vGetFont = 'Helvetica'"><!-- Don't add attibute --></xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="font-family">
                    <xsl:value-of select="$vGetFont"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
