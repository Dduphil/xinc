<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:exch="http://www.epo.org/exchange" exclude-result-prefixes="xs xd exch" version="3.0">
    
    <xd:doc scope="stylesheet/LGPI">
        <xd:desc>
            <xd:p><xd:b>Application:</xd:b>Pise</xd:p>
            <xd:p><xd:b>Aim:</xd:b> convert to 'standalone' or html5 for crawler</xd:p>
            <xd:p><xd:b>Last update:</xd:b> 201811 V.O. </xd:p>
            <xd:p><xd:b>History:</xd:b> see SCM comments</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/notice-header.xsl</xd:p>
            <xd:p><xd:b>Origin:</xd:b>{collections}/lgpi/notice.html5.xsl</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!--[collections}/lgpi/notice-header.xsl]-->
    
    <xsl:template name="pageHead">
        <head>
            <meta charset="utf-8"/>
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
            <title>
                <xsl:attribute name="lang"><xsl:value-of select="$vtitleLang"/></xsl:attribute>
                <xsl:apply-templates select="//document//exch:bibliographic-data/exch:publication-reference[@data-format=$vPubFormat]" mode="human-readableID"><xsl:with-param name="addtime">no</xsl:with-param></xsl:apply-templates>
                <xsl:text> - </xsl:text>
                <xsl:value-of select="//document//exch:bibliographic-data/exch:invention-title[@lang=$vtitleLang and @data-format=$vTitleFormat]"/>
            </title>
            <meta name="description" lang="en">
                <xsl:variable name="vhXmlContent">
                    <xsl:value-of select="$pDocumentId"/>
                    <xsl:text> - </xsl:text>
                    <xsl:apply-templates select="//document//exch:bibliographic-data/exch:publication-reference[@data-format=$vPubFormat]" mode="human-readableID"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="//document//exch:bibliographic-data/exch:invention-title[@lang=$vtitleLang and @data-format=$vTitleFormat]"/>
                    <xsl:text> - </xsl:text>
                    <xsl:apply-templates select="//document//exch:abstract[@lang=$vtitleLang and @data-format=$vTitleFormat]"/>
                </xsl:variable>
                <xsl:attribute name="content">
                    <xsl:call-template name="patchSuppressXmlEntities">
                        <xsl:with-param name="pData" select="$vhXmlContent"/>
                    </xsl:call-template>
                </xsl:attribute>
            </meta>
            <meta name="author" content="European Patent Office"/>
            <meta name="copyright" content="&#169;{year-from-date(current-date())} European Patent Office" />
            <meta name="keywords">
                <xsl:attribute name="content">
                    <xsl:value-of select="$pDocumentId"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="//document//exch:bibliographic-data/exch:publication-reference[@data-format=$vPubFormat]" mode="human-readableID"/>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="//document//exch:bibliographic-data/exch:patent-classifications" mode="cpctexte" />
                </xsl:attribute>
            </meta>
            <meta name="viewport" content="width=device-width"/>
            
            <link rel="shortcut icon">
                <xsl:attribute name="href"><xsl:value-of select="$pUrlMimo"/><xsl:text>favicon.ico</xsl:text></xsl:attribute>
            </link>            
            <link rel="stylesheet">
                <xsl:attribute name="href"><xsl:value-of select="$pUrlMimo"/><xsl:text>css/normalize.css</xsl:text></xsl:attribute>
            </link>
            <link rel="stylesheet">
                <xsl:attribute name="href"><xsl:value-of select="$pUrlMimo"/><xsl:text>css/main.css</xsl:text></xsl:attribute>
            </link>
            <script>
                <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>js/vendor/modernizr-2.6.2.min.js</xsl:text></xsl:attribute>
            </script>
            <script data-dojo-config="async:true">
                <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>js/dojo/dojo.js</xsl:text></xsl:attribute>
            </script>
        </head>
    </xsl:template>
    
    <xsl:template match="//document/notice/field/content//exch:exchange-document/exch:bibliographic-data/exch:publication-reference" mode="human-readableID">
        <xsl:param name="addtime"/>
        <xsl:apply-templates select="./document-id//country"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="./document-id//doc-number"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="./document-id//kind"/>
        <xsl:if test="./document-id//date">
            <xsl:text>&#32;</xsl:text>
            <xsl:choose>
                <xsl:when test="$addtime = 'no'"><xsl:value-of select="./document-id//date"/></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="./document-id//date"/></xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="exch:patent-classifications" mode="cpctexte">
        <xsl:apply-templates
            select="patent-classification[classification-scheme/@scheme = 'CPC' and (contains(./classification-symbol,':') or contains(./classification-symbol, '/'))]"
            mode="cpctexte">
            <xsl:sort select="classification-value" order="descending"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="patent-classification" mode="cpctexte">
        <xsl:choose>
            <xsl:when test="./classification-symbol/HIT">
                <xsl:value-of select="translate(substring-before(./classification-symbol/HIT, '('),' ','')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(substring-before(./classification-symbol, '('),' ','')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- [{collections}/lgpi/notice.html5.xsl] -->
    
    
    <xsl:template name="pageStandalone">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
     &lt;!--[if lt IE 7]&gt;      &lt;html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"&gt; &lt;![endif]--&gt;
     &lt;!--[if IE 7]&gt;         &lt;html class="no-js lt-ie9 lt-ie8" lang="en"&gt; &lt;![endif]--&gt;
     &lt;!--[if IE 8]&gt;         &lt;html class="no-js lt-ie9" lang="en"&gt; &lt;![endif]--&gt;
     </xsl:text><xsl:text disable-output-escaping='yes'>&lt;!--[if gt IE 8]&gt;&lt;!--&gt; </xsl:text><html class="no-js" lang="en"> <xsl:text disable-output-escaping='yes'>&lt;!--&lt;![endif]--&gt;</xsl:text>
         <xsl:call-template name="pageHead"/>
         
         <body>
             <xsl:attribute name="data-resource-root-uri"><xsl:value-of select="$pUrlMimo"/></xsl:attribute>
             <xsl:text disable-output-escaping='yes'>&lt;!--[if lt IE 7]&gt;</xsl:text>
             <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
             <xsl:text disable-output-escaping='yes'>&lt;![endif]--&gt;</xsl:text>
             
             <div class="pageWrapper">
                 <xsl:call-template name="headerContent"/>
                 <xsl:call-template name="navContent"/>
                 <xsl:call-template name="asideContent"/>
                 <xsl:call-template name="toolbarContent"/>
                 <xsl:call-template name="articleContent"/>
                 <footer>
                     <a href="http://www.epo.org/" target="_blank">&#169; European Patent Office</a>
                     <a href="http://www.epo.org/footer/accessibility.html" target="_blank">Accessibility</a>
                     <a href="http://www.epo.org/footer/legal-notice.html" target="_blank">Legal notice</a>
                     <a href="http://www.epo.org/footer/terms.html" target="_blank">Terms of use</a>
                 </footer>
             </div>
             <script>
                 <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>js/plugins.js</xsl:text></xsl:attribute>
             </script>
             <script>
                 <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>js/main.js</xsl:text></xsl:attribute>
             </script>
         </body>
     </html>
    </xsl:template>
    
    <xsl:template name="headerContent">
        <xsl:if test="$pHtmlType='standalone'">
            <header class="epoHeader clearfix skiptranslate">
                <a href="http://www.epo.org/" target="_blank" name="epoLogo" lang="en" title="Link to EPO Homepage" id="epoLogo" tabindex="1"><img lang="en" alt="Link to EPO homepage" title="Link to EPO homepage">
                    <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>img/logo.gif</xsl:text></xsl:attribute>
                </img></a>
                <div id="epoHeaderCenter">
                    <h1 lang="en" tabindex="2">Global Patent Index - <span id="notice-id"><xsl:apply-templates select="//document[@type='notice']/notice/field/content//exch:exchange-document/exch:bibliographic-data/exch:publication-reference[@data-format='docdb']" mode="header"/></span></h1>
                </div>
                <div id="epoHeaderMetaNav">
                    <a href="http://www.epo.org/service-support/contact-us.html" target="_blank" id="epoContact" tabindex="3">Contact</a>
                </div>
            </header>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="exch:publication-reference" mode="header">
        <xsl:value-of select="./document-id//country"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:value-of select="./document-id//doc-number"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:value-of select="./document-id//kind"/>
    </xsl:template>
    
    <xsl:template name="navContent">
        <xsl:if test="$pHtmlType='standalone'">
            <nav class="epoNavMenu skiptranslate">
                <ul>
                    <li class="services" id="services">
                        <span>Other EPO online services</span><span class="inline arrowBottom" role="presentation"></span>
                        <ul class="servicesListe" id="servicesListe">
                            <li><a href="http://www.epo.org/searching/free/espacenet.html" target="_blank">Espacenet</a></li>
                            <li class="grayLine"><a href="http://www.epo.org/searching-for-patents/technical/espacenet/ops.html" target="_blank">Open patent services (OPS)</a></li>
                            <li><a href="http://www.epo.org/searching/free/register.html" target="_blank">European patent register</a></li>
                            <li class="grayLine"><a href="http://www.epo.org/searching/free/register/register-alert.html" target="_blank">Register alert</a><img>
                                <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>img/icon_padlock.gif</xsl:text></xsl:attribute>
                            </img></li>
                            <li><a href="https://data.epo.org/publication-server/?lg=en" target="_blank">European publication server</a></li>
                            <li class="grayLine"><a href="http://www.epo.org/searching/subscription.html" target="_blank">Subscription products</a><img>
                                <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>img/icon_padlock.gif</xsl:text></xsl:attribute>
                            </img></li>
                            <li><a href="http://www.epo.org/searching/subscription/raw.html" target="_blank">Raw data products and test data</a><img>
                                <xsl:attribute name="src"><xsl:value-of select="$pUrlMimo"/><xsl:text>img/icon_padlock.gif</xsl:text></xsl:attribute>
                            </img></li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="asideContent">
        <xsl:if test="$pHtmlType='standalone'">
            <aside class="skiptranslate">
                <div class="aside_part">
                    <h2>GPI coverage and content</h2>
                    <p>You can use Global Patent Index (GPI) to carry out detailed searches of the EPO’s worldwide bibliographic and legal event data collections (DOCDB and INPADOC, also used in Espacenet and PATSTAT) and download or visualise the results for statistical analysis</p>
                    
                    <p>Current content: <xsl:value-of select="format-number($pNbDocuments,' ###','fr')" /> patent documents</p>
                    <div>This week's update (<xsl:value-of select="translate($pPublicationDate,'S','')"/>):</div>
                    <ul>
                        <li><xsl:value-of select="format-number($pNbAddedDocuments, ' ###','fr')"/> new  documents added</li>
                        <li><xsl:value-of select="format-number($pNbAmendedDocuments, ' ###','fr')"/> documents amended</li>
                    </ul>
                </div>
                <div class="aside_part">
                    <h2>GPI key values</h2>
                    <ul>
                        <li>Run regular monitoring (e.g. monthly or quarterly) of technical areas or companies</li>
                        <li>Use built-in charts to visualise technical trends and patenting activity of companies</li>
                        <li>Choose the data you want to see and download to focus on what you are interested in</li>
                        <li>Run data quality assessments to measure the risk of incomplete search results</li>
                    </ul>
                </div>
                <div class="aside_part">
                    <h2>More information</h2>
                    <p>GPI user manual (PDF), free trial and subscription information are available on the <a href="https://www.epo.org/gpi" target="_blank">EPO website</a></p>
                </div>
            </aside>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="toolbarContent">
        <xsl:if test="$pHtmlType='standalone'">
            <div class="docToolBar skiptranslate">
                <ul class="iconList">
                    <li class="downloadIcon">
                        <a id="downloadActuator" title="Download this patent document in PDF">
                            <xsl:attribute name="href"><xsl:value-of select="$pHumanReadableDocumentId"/><xsl:text>.pdf?download=true</xsl:text></xsl:attribute>
                            Download</a>
                    </li>
                    <li class="printIcon">
                        <a id="printActuator" title="Print this patent document - Javascript required" href="#">Print</a>
                    </li>
                    <li class="socialmediaIcon" id="socialmediaIcon">
                        <span id="socialmediaActuator"><span>Share</span></span>
                        <ul class="socialMedia" id="socialMedia">
                            <li class="mail">
                                <a href="mailto:?subject=" title="Share by mail">
                                    <xsl:variable name="vSubject">
                                        <xsl:apply-templates select="//document[@type='notice']//exch:bibliographic-data/exch:publication-reference[@data-format=$vPubFormat]" mode="human-readableID"/>
                                        <xsl:text> - </xsl:text>
                                        <xsl:value-of select="substring(//document[@type='notice']//exch:bibliographic-data/exch:invention-title[@lang=$vtitleLang and @data-format=$vTitleFormat],1,150)"/>
                                    </xsl:variable>
                                    <xsl:attribute name="href">
                                        <xsl:text>mailto:?subject=</xsl:text>
                                        <!-- TODO escape parameter -->
                                        <xsl:value-of select="$vSubject"/>
                                        <xsl:text>&amp;amp;body=</xsl:text>
                                        <!-- TODO escape parameter -->
                                        <xsl:value-of select="$pSelfUri" />
                                    </xsl:attribute>
                                    <xsl:text>Mail</xsl:text>
                                </a>
                            </li>
                            <li class="facebook">
                                <a href="#" title="Share in Facebook">Facebook</a>
                            </li>
                            <li class="xing">
                                <a href="#" title="Share in Xing">Xing</a>
                            </li>
                            <li class="linkedin">
                                <a href="#" title="Share in LinkedIn">LinkedIn</a>
                            </li>
                            <li class="googleplus">
                                <a href="#" title="Share in Google+">Google +</a>
                            </li>
                            <li class="twitter">
                                <a href="#" title="Share in Twitter">Twitter</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="articleContent">
        <article>
            <h1>
                <xsl:apply-templates select="//document[@type = 'notice']//exch:bibliographic-data/exch:publication-reference[@data-format = $vPubFormat]" mode="human-readableID"/>
                <xsl:text> - </xsl:text>
                <xsl:value-of select="//document[@type = 'notice']//exch:bibliographic-data/exch:invention-title[@lang = $vtitleLang and @data-format = $vTitleFormat]"/>
            </h1>
            <xsl:apply-templates select="*"/>
        </article>
    </xsl:template>
    
</xsl:stylesheet>