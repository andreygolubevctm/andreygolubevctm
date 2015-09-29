var k_button_js_revision='$Rev: 20280 $';var k_button={"ff_link":document.getElementById("kampylink"),"host_server":document.getElementById("k_host_server"),"help_button":document.getElementById("k_help_button"),"k_slogan":document.getElementById("k_slogan"),"close_button":document.getElementById("k_close_button"),"extra_params":null,"use_colorbox":false,"newwindow":'',"popitup":function(url,longUrl){if(!this.newwindow.closed&&this.newwindow.location)
    this.newwindow.location.href=url;else
{if(!this.window_width)
    this.window_width=440;if(!this.window_height)
    this.window_height=502;var ua=navigator.userAgent;var isIpad=(ua.indexOf(" AppleWebKit")>=0&&ua.indexOf("Mobile")>=0&&ua.indexOf("iPad")>=0);if(isIpad&&k_button.use_colorbox&&typeof($)!="undefined"&&$.colorbox)
{$.colorbox({href:url,innerWidth:450,innerHeight:512,iframe:true});return false;}
else
{this.newwindow=window.open(url+"",'kampyle_ff','left='+((window.screenX||window.screenLeft)+10)+',top='+((window.screenY||window.screenTop)+10)+',height='+this.window_height+'px,width='+this.window_width+'px,resizable=false');if(!this.newwindow)
{this.newwindow='';return;}
    if(!this.newwindow.opener)this.newwindow.opener=self;}}
    if(window.focus)
        this.newwindow.focus();if(longUrl!='kampyle_ff')
        this.newwindow.name=longUrl;return false;},"Set_Cookie":function(name,value,expires,path,domain,secure)
{var today=new Date();today.setTime(today.getTime());if(expires)
    expires=expires*1000*60*60*24;var expires_date=new Date(today.getTime()+(expires));document.cookie=name+"="+escape(value)+
((expires)?";expires="+expires_date.toGMTString():"")+
((path)?";path="+path:"")+
((domain)?";domain="+domain:"")+
((secure)?";secure":"");},"Get_Cookie":function(name)
{var start=document.cookie.indexOf(name+"=");var len=start+name.length+1;if((!start)&&(name!=document.cookie.substring(0,name.length)))
    return null;if(start==-1)
    return null;var end=document.cookie.indexOf(";",len);if(end==-1)end=document.cookie.length;return unescape(document.cookie.substring(len,end));},"get_main_domain":function()
{var main_domain='';var domain=document.domain;if(document.domain!="undefined"&&document.domain!=="")
{if(document.domain!='localhost')
{var dots=domain.split(/\./g);var tld=dots[dots.length-1];var sTlds=['AERO','ASIA','BIZ','CAT','COM','COOP','INFO','INT','JOBS','MOBI','MUSEUM','NAME','NET','ORG','PRO','TEL','TRAVEL','XXX','EDU','GOV','MIL','TV'];var mDotsLength=3;for(var i in sTlds)
{if(sTlds[i]==tld.toUpperCase())
    mDotsLength=2;}
    if(dots.length>mDotsLength)
    {if(dots.length>3)
    {main_domain=dots.slice(1).join('.');}
    else
    {main_domain=dots.slice(dots.length-mDotsLength).join('.');}}
    else
    {main_domain=domain;}}}
    return main_domain;},"generate_pre_id":function()
{var vector1=Math.floor(Math.random()*(Math.pow(2,48)));var vector2=new Date().getTime();return vector1+"_"+vector2;},"last_open_ff":0,"open_ff":function(ff_params,url,protocol)
{var currentTime=(new Date()).getTime()
    if(currentTime-k_button.last_open_ff<500)
        return false;k_button.last_open_ff=currentTime;try
{if(typeof(k_sc_param)=="object")
{if(k_sc_param.version==1.1)
{var vectors=this.generate_pre_id();if(!k_button.extra_params)
{k_button.extra_params={};}
    k_button.extra_params.vectors=k_button.vectors=vectors;}
else
{k_button.callSiteCatalyst(k_sc_param.instance,k_sc_param.evar);}}}
catch(e)
{window.k_sc_error=e;}
    try
    {var js_element=document.createElement('script');js_element.setAttribute('type','text/javascript');js_element.setAttribute('src',k_track.getDomain()+'/track/k_track.js?site_code='+k_track.getSiteCode());document.body.appendChild(js_element);}
    catch(e)
    {window.k_track_error=e}
    var main_domain=k_button.get_main_domain();var cookie_expiration_time_yes=21;k_button.Set_Cookie('k_push8','1',cookie_expiration_time_yes,'/',main_domain,'');var urlObject=this.create_ff_url(ff_params,url,protocol);this.popitup(urlObject.shortUrl,urlObject.longUrl);},"create_ff_url":function(ff_params,url,protocol)
{var stats_kvp=[];var matches=false;if(typeof(k_button_js_revision)!='undefined')
{matches=k_button_js_revision.match(/\d+/);if(matches!==false)
{stats_kvp.push('k_button_js_revision='+matches[0]);}}
    if(typeof(k_push_js_revision)!='undefined')
    {matches=k_push_js_revision.match(/\d+/);if(matches!==false)
    {stats_kvp.push('k_push_js_revision='+matches[0]);}}
    if(typeof(k_push_vars)!='undefined')
    {if(typeof(k_push_vars.view_percentage)!='undefined')
        stats_kvp.push('view_percentage='+k_push_vars.view_percentage);if(typeof(k_push_vars.display_after)!='undefined')
        stats_kvp.push('display_after='+k_push_vars.display_after);if(typeof(k_push_vars.cookie_expiration_time_yes)!='undefined')
        cookie_expiration_time_yes=k_push_vars.cookie_expiration_time_yes;}
    var stats_string=stats_kvp.join("&");var main_domain=k_button.get_main_domain();var url2send=url||window.location.href;url2send=encodeURIComponent(url2send);var ff_url='';if(!ff_params)
{ff_url=k_button.ff_link.href;if(k_button.ff_link.rel=='&push=1')
    ff_url=ff_url+k_button.ff_link.rel;}
else
{var ff_link_rel='';if(k_button.ff_link)
{ff_link_rel=k_button.ff_link.rel;k_button.ff_link.href="#";k_button.ff_link.target="";k_button.ff_link.rel='';if(ff_link_rel=='nofollow')
    ff_link_rel='';}
    var main_url='';if((k_button.host_server)&&k_button.host_server.value){main_url=k_button.host_server.value;}
else if((k_button.ff_link)&&k_button.ff_link.getAttribute('ref_server')!==null){var urlParts=k_button.ff_link.getAttribute('ref_server').split("/");main_url=urlParts[2];}
else{main_url='www.kampyle.com';}
    if(!this.loader_url)
        this.loader_url='/feedback_form/ff-feedback-form.php?';if(typeof(protocol)=="undefined"||!protocol)
    protocol=document.location.protocol;if(protocol!="http:"&&protocol!="https:")
{protocol="http:";}
    ff_url=protocol+'//'+main_url+this.loader_url+ff_params+ff_link_rel;}
    if(window.pageTracker&&window.pageTracker._trackEvent)
    {var vectors=k_button.vectors;if(typeof(vectors)=="undefined")
        vectors=this.generate_pre_id();window.pageTracker._trackEvent("KampyleFeedback","NewFeedback",vectors);if(!this.extra_params)
        this.extra_params={};this.extra_params.vectors=vectors;}
    if(this.extra_params)
    {var extra_params=this.make_query_string(this.extra_params);ff_url=ff_url+'&'+extra_params;}
    if(k_button.Get_Cookie("session_start_time")!==null)
    {var startTime=k_button.Get_Cookie("session_start_time");var now=(new Date()).getTime();var numOfSecondsElapsed=Math.round((now-startTime)/1000);ff_url=ff_url+'&time_on_site='+numOfSecondsElapsed;}
    if(stats_string!=='')
    {ff_url=ff_url+'&stats='+encodeURIComponent(stats_string);}
    var ga_url='';if(k_button.Get_Cookie("__utmz")!==null)
{ga_url='&utmb='+encodeURIComponent(k_button.Get_Cookie("__utmb"))+'&utma='+encodeURIComponent(k_button.Get_Cookie("__utma"));}
else if(k_button.Get_Cookie("k_visit")!==null)
{ga_url='&kvisit='+encodeURIComponent(k_button.Get_Cookie("k_visit"));}
    var ct_url='';var ct_pid='';if(typeof(ClickTaleGetPID)=='function')
    ct_pid=ClickTaleGetPID();if(ct_pid===''&&typeof(KampyleGetClickTalePID)=='function')
    ct_pid=KampyleGetClickTalePID();if(ct_pid!==''&&typeof(ClickTaleGetUID)=='function'&&typeof(ClickTaleGetSID)=='function')
{var ct_uid=ClickTaleGetUID();var ct_sid=ClickTaleGetSID();ct_url='&ctdata=0';if(ct_uid!==null&&ct_sid!==null)
{ct_url='&ctdata='+ct_pid+'..'+ct_uid+'..'+ct_sid;}}
    var longUrl='kampyle_ff';if(typeof document.body.style.maxHeight=="undefined"){ff_url=ff_url.substring(0,900)
    url2send+="&ie6trim=1";}
else if((ff_url.length+url2send.length)>2083){longUrl=url2send;url2send='noUrl';}
    k_button.Set_Cookie("k_vectors",null,-1,"/",k_button.get_main_domain(),'');return{"shortUrl":ff_url+'&url='+url2send+ga_url+ct_url,"longUrl":longUrl};},"hide_button":function()
{k_button.ff_link.style.display="none";k_button.close_button.style.display="none";if(k_button.k_slogan)
    k_button.k_slogan.style.display="none";},"make_query_string":function(params)
{var query_string='';var params_tmp=[];for(var s in params)
{if(params.hasOwnProperty(s))
{if((s=='u_id')||(s=='u_email'))
    params[s]=params[s].replace('+','KAMP_SPEC2B');params_tmp.push(s+'='+encodeURIComponent(params[s]));}}
    query_string=params_tmp.join('&');return query_string;},"bind":function(obj,eventType,callback){if(obj.addEventListener)
    obj.addEventListener(eventType,callback,false)
else if(obj.attachEvent)
    obj.attachEvent("on"+eventType,callback);},"addCss":function(path)
{var fileref=document.createElement("link");fileref.setAttribute("rel","stylesheet");fileref.setAttribute("type","text/css");fileref.setAttribute("href",path);if(typeof fileref!="undefined")
    document.getElementsByTagName("head")[0].appendChild(fileref);},"callSiteCatalyst":function(sc_instance,sc_evar)
{try
{var vectors=k_button.Get_Cookie("k_vectors");if(vectors===null)
{vectors=k_button.generate_pre_id();k_button.Set_Cookie("k_vectors",vectors,0,"/",k_button.get_main_domain(),'');}
    if(!k_button.extra_params)
    {k_button.extra_params={};}
    k_button.extra_params.vectors=k_button.vectors=vectors;sc_instance.linkTrackVars=sc_evar;sc_instance[sc_evar]=vectors;sc_instance.tl(true,"o","Feedback Form");}
catch(e)
{window.k_sc_error=e;}},"setCustomVariable":function(paramId,paramValue)
{if(!k_button.extra_params)
{k_button.extra_params={};}
    k_button.extra_params['param['+paramId+"]"]=paramValue;},"init":function()
{if(k_button.Get_Cookie("session_start_time")===null)
{var main_domain=k_button.get_main_domain();k_button.Set_Cookie("session_start_time",(new Date()).getTime(),0,"/",main_domain,'');if(k_button.Get_Cookie("k_visit")===null)
{k_button.Set_Cookie('k_visit','1','365','/',main_domain,'');}
else
{k_button.Set_Cookie('k_visit',parseInt(k_button.Get_Cookie("k_visit"),10)+1,'365','/',main_domain,'');}
    k_button.newSession=true;}
    var ua=navigator.userAgent;var isWebkitMobile=(ua.indexOf(" AppleWebKit")>=0&&ua.indexOf("Mobile")>=0&&ua.indexOf("iPad")<0)||ua.indexOf("Nokia")>=0||ua.indexOf("BlackBerry")>=0;var middleButtonMode=k_button.ff_link&&k_button.ff_link.className.indexOf("k_middle")>=0;if(isWebkitMobile||middleButtonMode)
{var positionButton=function(){var but=k_button.ff_link;var topHeight=null;if(isWebkitMobile&&but.className.indexOf("k_bottom")>=0)
{topHeight=Math.max(document.documentElement["clientHeight"],document.body["scrollHeight"],document.documentElement["scrollHeight"],document.body["offsetHeight"],document.documentElement["offsetHeight"])-k_button.ff_link.children[0].offsetHeight;k_button.ff_link.className+=" absolute";k_button.ff_link.parentNode.className+=" k_container"
    if(k_button.k_slogan)
        k_button.k_slogan.style.display="none";}
else if(middleButtonMode)
{var viewportHeight=typeof(window.innerHeight)!="undefined"?window.innerHeight:document.documentElement.clientHeight;var topHeight=(viewportHeight-k_button.ff_link.children[0].offsetHeight)/2;}
    if(topHeight!==null)
    {k_button.ff_link.style.top=topHeight+"px";}};k_button.bind(window,"orientationchange",positionButton);k_button.bind(window,"resize",positionButton);k_button.bind(window,'load',positionButton);if(isWebkitMobile&&middleButtonMode)
    positionButton();}
else if(((screen.width<=800)&&(screen.height<=600))&&k_button.ff_link&&(k_button.ff_link.className!='k_static')&&k_button.close_button)
{k_button.close_button.onclick=k_button.hide_button;k_button.close_button.innerHTML='X';k_button.close_button.style.display="block";}
    if(k_button.k_slogan===null)
    {if(k_button.ff_link)
        k_button.ff_link.className=k_button.ff_link.className.replace("_sl","");if(k_button.help_button)
        k_button.help_button.className=k_button.help_button.className.replace("_sl","");if(k_button.close_button)
        k_button.close_button.className=k_button.close_button.className.replace("_sl","");}
    if(typeof(k_sc)=="object"&&k_sc.vectors)
    {k_button.extra_params={'vectors':k_sc.vectors};}}};var k_button1=k_button;k_button.init();window.k_button_js_revision=k_button_js_revision;window.k_button=k_button;var k_track={"init":function()
{var track_allowed=k_button.Get_Cookie("k_track");if(track_allowed!=null)
{k_track.trackCurrentPage();}},"getDomain":function()
{var main_url='';if((k_button.host_server)&&k_button.host_server.value){main_url=k_button.host_server.value;}
else if((k_button.ff_link)&&k_button.ff_link.getAttribute('ref_server')!==null){var urlParts=k_button.ff_link.getAttribute('ref_server').split("/");main_url=urlParts[2];}
else{main_url='www.kampyle.com';}
    var protocol=document.location.protocol;if(protocol!="http:"&&protocol!="https:")
{protocol="http:";}
    return protocol+'//'+main_url;},"startTracking":function()
{k_button.Set_Cookie("k_track","1",1000,'/');},"stopTracking":function()
{k_button.Set_Cookie("k_track","0",-1000,'/');},"getSiteCode":function()
{var onclick_split=null;if((k_button.ff_link)&&k_button.ff_link.getAttribute('ref_server')!==null)
    onclick_split=k_button.ff_link.getAttribute('onclick').split("'");if(typeof(onclick_split)=="object"&&typeof(onclick_split[1])!='undefined')
{onclick_split=onclick_split[1].split('&');if(typeof(onclick_split[0])!='undefined')
{onclick_split=onclick_split[0].split('=');return onclick_split[1];}}
    return'';},"getVisitorID":function()
{var utma=k_button.Get_Cookie('__utma');if(utma!=null)
{utma_items=utma.split('.');if(typeof(utma_items[1])!='undefined')
    return utma_items[1];}
    return'';},"getVisitorSession":function()
{var utma=k_button.Get_Cookie('__utma');if(utma!=null)
{utma_items=utma.split('.');if(typeof(utma_items[4])!='undefined')
    return utma_items[4];}
    return'';},"trackCurrentPage":function()
{var track_url=k_track.getDomain()+'/track/hit.php?visitor_type=google&site_code='+k_track.getSiteCode()
    +'&visitor_id='+k_track.getVisitorID()
    +'&visitor_session='+k_track.getVisitorSession()
    +'&url='+encodeURIComponent(top.location.href);var img_element=document.createElement('img');img_element.setAttribute('src',track_url);document.body.appendChild(img_element);}}
var k_track1=k_track;k_track.init();

var k_push_js_revision='$Rev: 18687 $';var k_button1={"Set_Cookie":function(name,value,expires,path,domain,secure)
{var today=new Date();today.setTime(today.getTime());if(expires)
    expires=expires*1000*60*60*24;var expires_date=new Date(today.getTime()+(expires));document.cookie=name+"="+escape(value)+
((expires)?";expires="+expires_date.toGMTString():"")+
((path)?";path="+path:"")+
((domain)?";domain="+domain:"")+
((secure)?";secure":"");},"Get_Cookie":function(name)
{var start=document.cookie.indexOf(name+"=");var len=start+name.length+1;if((!start)&&(name!=document.cookie.substring(0,name.length)))
    return null;if(start==-1)return null;var end=document.cookie.indexOf(";",len);if(end==-1)end=document.cookie.length;return unescape(document.cookie.substring(len,end));},"get_main_domain":function()
{var main_domain='';var domain=document.domain;if(document.domain!="undefined"&&document.domain!=="")
{if(document.domain!='localhost')
{var dots=domain.split(/\./g);var tld=dots[dots.length-1];var sTlds=['AERO','ASIA','BIZ','CAT','COM','COOP','INFO','INT','JOBS','MOBI','MUSEUM','NAME','NET','ORG','PRO','TEL','TRAVEL','XXX','EDU','GOV','MIL','TV'];var mDotsLength=3;for(var i in sTlds)
{if(sTlds[i]==tld.toUpperCase())
    mDotsLength=2;}
    if(dots.length>mDotsLength)
    {if(dots.length>3)
    {main_domain=dots.slice(1).join('.');}
    else
    {main_domain=dots.slice(dots.length-mDotsLength).join('.');}}
    else
    {main_domain=domain;}}}
    return main_domain;}};if(typeof(k_push_vars)=="undefined")
    var k_push_vars={};var k_push={"after_time":20,"after_time_on_page":0,"popup_w":380,"popup_h":185,"popup_h_brand":200,"myWidth":0,"myHeight":0,"popup_open":false,"counter":0,"branding":1,"lastPosy":null,"cookie_expiration_time_no":21,"getSize":function(){if(typeof(window.innerWidth)=='number'){k_push.myWidth=window.innerWidth;k_push.myHeight=window.innerHeight;}else if(document.documentElement&&(document.documentElement.clientWidth||document.documentElement.clientHeight)){k_push.myWidth=document.documentElement.clientWidth;k_push.myHeight=document.documentElement.clientHeight;}else if(document.body&&(document.body.clientWidth||document.body.clientHeight)){k_push.myWidth=document.body.clientWidth;k_push.myHeight=document.body.clientHeight;}},"getScrollY":function(){var scrOfY=0;if(typeof(window.pageYOffset)=='number')
    scrOfY=window.pageYOffset;else if(document.body&&(document.body.scrollTop))
    scrOfY=document.body.scrollTop;else if(document.documentElement&&(document.documentElement.scrollTop))
    scrOfY=document.documentElement.scrollTop;return scrOfY;},"mousePos":function(e){if(k_push.popup_open||k_push_vars.popup_manual)
    return;k_push.getSize();var posy=0;if(!e)e=window.event;if(e.pageX||e.pageY)
    posy=e.pageY;else if(e.clientX||e.clientY)
    posy=e.clientY+k_push.getScrollY();if(k_push.lastPosy===null)
    k_push.lastPosy=posy;else
{if(k_push.lastPosy<posy)
    k_push.lastPosy=posy;else
{if(posy<k_push.getScrollY()+15)
    k_push.openPopup();}}},"popup_init":function(){if(k_push.popup)
    k_push.popup.parentNode.removeChild(k_push.popup);k_push.getSize();if(window.addEventListener)
    window.addEventListener('mousemove',k_push.mousePos,false);else
    document.attachEvent('onmousemove',k_push.mousePos);var maskBG=document.createElement('div');maskBG.setAttribute('id','k_maskBG');document.body.appendChild(maskBG);var popup=document.createElement('div');var use_brand=k_push.branding&&!k_push_vars.no_brand?true:false;popup.setAttribute('id','k_popup');popup.style.width=(k_push_vars.popup_w?k_push_vars.popup_w:k_push.popup_w)+'px';if(!k_push_vars.popup_h)
    popup.style.lineHeight="normal";popup.style.color=(k_push_vars.popup_font_color)?k_push_vars.popup_font_color:'#000000';k_push.ff_link_id=(k_push_vars.ff_link_id)?k_push_vars.ff_link_id:'kampylink';k_push.ff_params=(k_push_vars.ff_params)?k_push_vars.ff_params:false;k_push.header=(k_push_vars.header)?k_push_vars.header:'Your feedback is important to us!';k_push.question=(k_push_vars.question)?k_push_vars.question:'Would you be willing to give us a short (1 minute) feedback?';k_push.footer=(k_push_vars.footer)?k_push_vars.footer:'Thank you for helping us improve our website';k_push.yes=(k_push_vars.yes)?k_push_vars.yes:'Yes';k_push.no=(k_push_vars.no)?k_push_vars.no:'No';k_push.yes_background=(k_push_vars.yes_background)?k_push_vars.yes_background:'#76AC78';k_push.no_background=(k_push_vars.no_background)?k_push_vars.no_background:'#8D9B86';k_push.dir=(k_push_vars.text_direction=='rtl')?'rtl':'ltr';k_push.remind=k_push_vars.remind?k_push_vars.remind:'Remind me later';k_push.remind_font_color=(k_push_vars.remind_font_color)?k_push_vars.remind_font_color:'#3882C3';if(k_push.dir=='ltr')
{k_push.yes_float='left';k_push.no_float='right';}
else
{k_push.yes_float='right';k_push.no_float='left';}
    k_push.images_dir=(k_push_vars.images_dir)?k_push_vars.images_dir:'http://cf.kampyle.com/';k_push.separator=k_push_vars.popup_separator?k_push_vars.popup_separator:"#ffffff";var landingPage;landingPage="/ff-reg";var branding=use_brand?"<a target='_blank' style='position:relative;bottom:3px' href='http://www.kampyle.com"+landingPage+"?r=push'>Feedback Analytics by</a>"+" &nbsp;<a target='_blank' href='http://www.kampyle.com"+landingPage+"?r=push_logo'><img src='"+k_push.images_dir+"k_logo.gif' /></a>"+"<div id='k_pop_whatisthis'><a href='http://www.kampyle.com"+landingPage+"?r=push_wist&amp;sid="+k_push_vars.site_code+"' target='_blank' style='position: relative; bottom: -3px;'><img src='"+k_push.images_dir+"k_help.gif' style='vertical-align:bottom;' /></a><a href='http://www.kampyle.com"+landingPage+"?r=push_wist&amp;sid="+k_push_vars.site_code+"' target='_blank' style='position: relative; bottom: -3px;left:-5px;'>What is this?</a></div>":"";popup.innerHTML=""+"<div id='k_popup_inner'>"+"<div id='k_pop_header' style='border-color: "+k_push.separator+"; direction:"+k_push.dir+"'>"+k_push.header+"</div>"+"<div id='k_pop_question_container' style='border-color:"+k_push.separator+"; direction:"+k_push.dir+"'>"+
    k_push.question+"<div id='k_pop_yes_no'>"+"<a id='k_pop_yes_btn' style='background-color:"+k_push.yes_background+"; float: "+k_push.yes_float+";' onclick='k_push.handleYes(); return false;'>"+
    k_push.yes+"</a>"+"<a id='k_pop_no_btn' style='background-color:"+k_push.no_background+"; float: "+k_push.no_float+";' onclick='k_push.handleNo(); return false;'>"+
    k_push.no+"</a><br /><br />"+"<a id='k_pop_remind' onclick='k_push.handleRemind()' style='color: "+k_push.remind_font_color+";'>"+
    k_push.remind+"</a>"+"</div><br />"+
    k_push.footer+"</div>"+"<div id='k_pop_branding'>"+branding+"</div>"+"</div>";popup.style.background=(k_push_vars.popup_background)?k_push_vars.popup_background:'#FFFFFF';popup.style.borderColor=k_push.separator;k_push.popup=popup;document.body.appendChild(popup);},"handlePostYes":function(){},"handlePostNo":function(){},"handlePostRemind":function(){},"handleYes":function()
{if(k_push.ff_params&&typeof(k_button)!="undefined")
{k_button.open_ff(k_push.ff_params+"&push=1");}
else
{var ff_link=document.getElementById(k_push.ff_link_id);if(ff_link)
{if(typeof(k_button)=="object"&&k_button.ff_link)
    k_button.ff_link.rel="&push=1";ff_link.onclick();}}
    k_push.closePopup();},"handleNo":function()
{k_push.closePopup();},"handleRemind":function()
{k_push.closePopup();k_push.counter=0;var timeForPopup=(new Date()).getTime()+parseInt((1000*60*2),10);var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start",timeForPopup,0,"/",main_domain,'');k_button1.Set_Cookie("k_push8",0,0,"/",main_domain,'');},"remind_later":function()
{k_push.handleRemind();},"openPopup":function()
{if(!k_push_vars.popup_manual)
{var timeNow=(new Date()).getTime();var timeLeft=k_push.initData.timeForPopup-timeNow;if(timeLeft>0)
    return;if(k_button1.Get_Cookie('k_push8')&&k_button1.Get_Cookie('k_push8')!==0&&!k_push_vars.disable_cookie)
    return;if((k_push.popup_open)||(k_push.counter>0)||(!document.getElementById(k_push.ff_link_id)))
    return;}
    var main_domain=k_button1.get_main_domain();var cookie_expiration_time_no=k_push_vars.cookie_expiration_time_no!==undefined?k_push_vars.cookie_expiration_time_no:k_push.cookie_expiration_time_no;k_button1.Set_Cookie('k_push8','1',cookie_expiration_time_no,'/',main_domain,'');k_push.counter++;k_push.popup_open=true;var maskBG=document.getElementById('k_maskBG');var popup=document.getElementById('k_popup');var scrollTop=document.documentElement.scrollTop||document.body.scrollTop;popup.style.top=(k_push.myHeight/2)-(k_push.popup_h/2)+scrollTop+'px';popup.style.left=k_push.myWidth/2-k_push.popup_w/2+'px';popup.style.display='block';var inner=document.getElementById("k_popup_inner");maskBG.innerHTML='<div style="width: 100%; height: 100%; opacity: 0.6; filter: alpha(opacity=60); background-color:#111111;"></div>';maskBG.style.position='absolute';maskBG.style.top='0px';maskBG.style.left='0px';maskBG.style.zIndex='999998';var w=(document.documentElement.scrollWidth>document.body.scrollWidth)?document.documentElement.scrollWidth:document.body.scrollWidth;maskBG.style.width=w+'px';var h=(document.documentElement.scrollHeight>document.body.scrollHeight)?document.documentElement.scrollHeight:document.body.scrollHeight;maskBG.style.height=h+'px';maskBG.style.display='block';if(document.all)
    k_push.toggleSelects('hidden');},"closePopup":function()
{var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start","0",0,"/",main_domain,'');k_push.popup_open=false;var maskBG=document.getElementById('k_maskBG');var popup=document.getElementById('k_popup');popup.style.display='none';maskBG.style.display='none';if(document.all)
    k_push.toggleSelects('visible');},"toggleSelects":function(visibility){try{var selects=document.getElementsByTagName('select');for(var i=0;i<selects.length;i++)
    selects[i].style.visibility=visibility;}
catch(err)
{}},"initData":{},"init":function(){if(k_button1.Get_Cookie("push_time_start")>0)
{k_push.initData.timeForPopupSession=parseInt(k_button1.Get_Cookie("push_time_start"),10);}
else
{var seconds_to_delay=k_push_vars.display_after!==undefined?k_push_vars.display_after:k_push.after_time;k_push.initData.timeForPopupSession=(new Date()).getTime()+seconds_to_delay*1000;var main_domain=k_button1.get_main_domain();k_button1.Set_Cookie("push_time_start",k_push.initData.timeForPopupSession,0,"/",main_domain,'');}
    var seconds_to_delay_page=k_push_vars.display_after_on_page!==undefined?k_push_vars.display_after_on_page:k_push.after_time_on_page;k_push.initData.timeForPopupPage=(new Date()).getTime()+seconds_to_delay_page*1000;k_push.initData.timeForPopup=Math.max(k_push.initData.timeForPopupSession,k_push.initData.timeForPopupPage);if(!k_push_vars.view_percentage)
        k_push.n=0;else
        k_push.n=(k_push_vars.view_percentage&&((k_push_vars.view_percentage>=0)&&(k_push_vars.view_percentage<=100)))?k_push_vars.view_percentage:10;k_push.initData.shouldLoad=false;if(k_push_vars.popup_manual)
    {k_push.initData.shouldLoad=true;}
    else if(((k_push.n===null)||(((Math.random()*100)<k_push.n))))
    {if(k_push_vars.disable_cookie)
        k_push.initData.shouldLoad=true;else if(!k_button1.Get_Cookie('k_push8')||k_button1.Get_Cookie('k_push8')===0)
        k_push.initData.shouldLoad=true;}
    if(k_push.initData.shouldLoad)
    {if(window.addEventListener)
        window.addEventListener('load',k_push.popup_init,false);else
        window.attachEvent('onload',k_push.popup_init);}}};k_push.init();window.k_push_js_revision=k_push_js_revision;window.k_push=k_push;