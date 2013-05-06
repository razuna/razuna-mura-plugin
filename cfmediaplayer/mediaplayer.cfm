<cfprocessingdirective suppresswhitespace="true">
<cfsilent>
	<!---

		Document:		cfMediaPlayer.cfm
		Author:			Stephen J. Withington, Jr. (steve [at] stephenwithington [dot] com)
						Copyright (c) 2009, Stephen J. Withington. All rights reserved.
		Version:		20100219.01

		License:		Creative Commons, Attribution-Noncommercial-Share Alike 3.0 Unported
						Visit http://creativecommons.org/licenses/by-nc-sa/3.0/

						By using cfMediaPlayer, you agree to the 'non-commercial' license found at
						http://creativecommons.org/licenses/by-nc-sa/3.0/.
						
						For corporate use or if you're planning to generate revenue from your site
						(e.g., by running advertisements on the page, selling anything, etc.) 
						you will need to buy a license for JW Player�. To obtain a commercial license
						of the JW Player�, please visit:
						http://longtailvideo.com/players/jw-flv-player/commercial-license/

		Purpose:		I play FLV, MP3, MP4, and AAC files using the JW Player by longtail video
						(HD .mov files can also be used by utilizing the "hdfile={HDFileURL}" attribute)
						More info about JW Player can be found at http://www.logntailvideo.com/
						Please see assets/readme.html for additional license information.

	--->
	
	
	<!--- ::::::::::: RESOLVE PATH TO ASSETS :::::::::: --->
	<!---
			if cfMediaPlayer is stored outside of the webroot, then you need to provide the 'basedir' attribute pointing to the 'virtual directory' (IIS) or 'alias directory' (apache)!
	--->
	<cfparam name="attributes.basedir" type="string" default="" />
	<cfscript>
		// dynamically resolve the installation path 
		if ( len(trim(attributes.basedir)) ) {
			objPath = CreateObject("component", "resolvepath").init(attributes.basedir);
		} else {
			objPath = Createobject("component", "resolvepath").init();
		}
		request.installdir = objPath.getURLPath();
		request.playerpath = request.installdir & "/player/";
		
		// sharing setup
		request.playerbaselink = getPageContext().getRequest().getScheme() & "://" & getPageContext().getRequest().getHeader("Host");
		request.playerlink = getPageContext().getRequest().getRequestURL();
		if ( len(trim(getPageContext().getRequest().getQueryString())) ) {
			request.playerlink = request.playerlink & getPageContext().getRequest().getQueryString();
		}
	</cfscript>
	<cfparam name="request.swfObjIsThere" default="false" />

	<!--- ::::::::::::::: PARAMETERS ::::::::::::::::::: --->
	<!--- inspired by: http://www.longtailvideo.com/support/jw-player-setup-wizard --->
	<!--- PLAYER TYPE --->
	<cfparam name="attributes.player" type="string" default="player.swf" /><!--- if you have purchased a license for JW Player, drop the 'player-licensed.swf' into the 'assets' directory and change the default to 'player-licensed.swf' or pass the 'player' attribute when calling this customtag. --->
	<cfset playerOptions = "player.swf,player-viral.swf,player-licensed.swf,player-licensed-viral.swf" />
	<!--- FILE PROPERTIES --->
	<cfparam name="attributes.file" type="string" default="" /><!--- location of the mediafile or playlist to play --->
	<cfparam name="attributes.hdfile" type="string" default="" /><!--- optional: if you have a High Definition file, pass in the file location to this attribute (i.e., http://www.longtailvideo.com/jw/upload/bunny.mov) --->
	<cfparam name="attributes.author" type="string" default="" /><!--- author of the video, shown in the display or playlist --->
	<cfparam name="attributes.date" default="" /><!--- publish date of the media file --->
	<cfparam name="attributes.description" type="string" default="" /><!--- text description of the file --->
	<cfparam name="attributes.duration" type="integer" default="0" /><!--- duration of the file in seconds --->
	<cfparam name="attributes.image" type="string" default="" /><!--- location of a preview image; shown in display and playlist --->
	<cfparam name="attributes.link" default="" /><!--- url to an external page the display, controlbar and playlist can link to --->
	<cfparam name="attributes.start" type="integer" default="0" /><!--- position in seconds where playback has to start. Won't work for regular (progressive) videos, but only for streaming (HTTP / RTMP) --->
	<cfparam name="attributes.tags" type="string" default="" /><!--- keywords associated with the media file --->
	<cfparam name="attributes.title" type="string" default="" /><!--- title of the video, shown in the display or playlist --->
	<cfparam name="attributes.showtitle" type="boolean" default="true" /><!--- show title above the media file --->
	<cfparam name="attributes.type" type="string" default="none" /><!--- this determines what type of mediafile this item is, and thus which model the player should use for playback. by default, the type is detected by the player based upon the file extension. if there's no suiteable extension or you use a streaming server, it can be manually set. the following media types are supported:
* video: progressively downloaded FLV / MP4 video, but also AAC audio. 
* sound: progressively downloaded MP3 files.
* image: JPG/GIF/PNG images.
* youtube: videos from Youtube.
* http: FLV/MP4 videos played as http speudo-streaming.
* rtmp: FLV/MP4/MP3 files played from an RTMP server.
valid options: none, video, sound, image, youtube, http, rtmp --->
	<cfset typeOptions = "none,video,sound,image,youtube,http,rtmp" />

	<!--- LAYOUT --->
	<!--- css styling options on container div element --->
	<cfparam name="attributes.padding" type="string" default="0" /><!--- padding on container div --->
	<cfparam name="attributes.margin" type="string" default="1em 0" /><!--- margin on container div --->
	<cfparam name="attributes.border" type="integer" default="1" /><!--- border (in pixels) to apply around the player --->
	<cfparam name="attributes.bgcolor" type="string" default="ffffff" /><!--- background color of container div --->
	<cfparam name="attributes.bordercolor" type="string" default="000000" /><!--- color of border --->
	<cfparam name="attributes.borderstyle" type="string" default="solid" /><!--- style of border --->
	<cfset borderstyleOptions = "solid,ridge,outset,none,inset,hidden,groove,double,dotted,dashed" />
	<!--- player options --->
	<cfparam name="attributes.controlbar" default="bottom" /><!--- position of the control bar --->
	<cfset controlbarOptions = "bottom,over,none" />
	<cfparam name="attributes.skin" type="string" default="default" /><!--- skinning options: default, vimeo, desktop --->
	<cfset skinOptions = "default,vimeo,desktop" />
	<cfparam name="attributes.logo" type="string" default="" /><!--- location of an external jpg, png or gif image to show in a corner of the display --->
	<!--- Colors: can be any hex color (without the hash tag [#]) --->
	<cfparam name="attributes.backcolor" default="ffffff" /><!--- background color of the controlbar and playlist --->
	<cfparam name="attributes.frontcolor" default="000000" /><!--- color of all icons and texts in the controlbar and playlist --->
	<cfparam name="attributes.lightcolor" default="000000" /><!--- color of an icon or text when you rollover it with the mouse --->
	<cfparam name="attributes.screencolor" default="000000" /><!--- background color of the display --->
	<cfparam name="attributes.wmode" type="string" default="opaque" /><!--- Specifies the absolute positioning and layering capabilities in your browser: window: Plays the media player in its own rectangular window on a web page, opaque: Hides everything behind the media player on the web page, transparent: Lets the background of the web page show through the transparent portions of the media player --->
	<cfset wmodeOptions = "window,opaque,transparent" />
	<!---
			Standard Web Video Pixel Dimensions (WIDTHxHEIGHT):
			16:9
				common:			1280x720 (720p), 960x540 (540p), 720x405, 640x360, 480x270, 400x225 
				less common:	1920x1080 (1080p), 560x315, 320x180, 240x135, 160x90, 80x45

			4:3
				common:			640x480, 480x360, 320x240
				less common:	560x420, 400x300, 240x180, 160x120, 120x90, 100x75, 80x60, 60x45
			
			NOTE:	Add 20px to the above HEIGHTs to accomodate the player control bar (if using)!
	--->	
	<cfparam name="attributes.width" type="integer" default="480" /><!--- width of the display in pixels --->
	<cfparam name="attributes.height" type="integer" default="270" /><!--- height of the display in pixels --->

	<!---
		PLAYLIST NOTES:

			in order to use playlist, the 'file' attribute must actually be an XML Playlist
			note that playlist XML files are subject to the crossdomain security restrictions of Flash
			for more information, see http://developer.longtailvideo.com/trac/wiki/FlashFormats#XMLPlaylists
			(i.e. http://gdata.youtube.com/feeds/api/standardfeeds/recently_featured )
			
			ALSO: to use an xml playlist, you need to add an xml namespace as follows:
			xmlns:jwplayer="http://developer.longtailvideo.com/trac/wiki/FlashFormats"
	--->
	<cfparam name="attributes.playlist" type="string" default="none" /><!--- position of the playlist --->
	<cfset playlistOptions = "none,bottom,over,right" />
	<cfparam name="attributes.playlistsize" type="integer" default="180" /><!--- when 'below' this refers to the height, when 'right' this refers to the width of the playlist --->

	<!--- BEHAVIOURS --->
	<cfparam name="attributes.allowfullscreen" type="boolean" default="true" /><!--- allow user to view fullscreen mode --->
	<cfparam name="attributes.autostart" type="boolean" default="false" /><!--- automatically start the player on load --->
	<cfparam name="attributes.bandwidth" type="integer" default="5000" /><!--- available bandwidth for streaming the file. used predominately for 'bitrate switching.' set this var if you want to hint the player on the initial bandwidth. overwritten every 2 seconds whenever a 'video' or 'http' stream is loading or an 'rtmp' stream is playing --->
	<cfparam name="attributes.bufferlength" type="integer" default="1" /><!--- number of seconds of the file that has to be loaded before starting. set this to a low value to enable instant-start and to a high value to get less mid-stream buffering. see http://developer.longtailvideo.com/trac/wiki/FlashFormats#BitrateSwitching for more information --->
	<cfparam name="attributes.displayclick" type="string" default="play" /><!--- what to do when one clicks the display. when set to 'none', the handcursor is also not shown --->
	<cfset displayclickOptions = "play,link,fullscreen,mute,next,none" />
	<cfparam name="attributes.dock" type="boolean" default="false" /><!--- set this to 'true' to show the dock with large buttons in the top right of the player --->
	<cfparam name="attributes.icons" type="boolean" default="true" /><!--- show icons on top of movie screen? --->
	<cfparam name="attributes.item" type="integer" default="0" /><!--- playlistitem that should start to play. use this to set a specific start-item (an array beginning at 0) --->
	<cfparam name="attributes.linktarget" type="string" default="_blank" /><!--- browserframe where link from the display are opened in --->
	<cfset linktargetOptions = "_blank,_self,_parent,_top" />
	<cfparam name="attributes.mute" type="boolean" default="false" /><!--- mute all sounds on startup. is saved in a cookie --->
	<cfparam name="attributes.repeat" type="string" default="none" /><!--- set to 'list' to play the entire playlist once, to 'always' to continuously play the song/video/playlist and to 'single' to continue repeating the selected file in a playlist --->
	<cfset repeatOptions = "none,list,always,single" />
	<cfparam name="attributes.shuffle" type="boolean" default="false" /><!--- shuffle playback of playlist items --->
	<cfparam name="attributes.smoothing" type="boolean" default="true" /><!--- this sets the smoothing of videos, so you won't see blocks when a video is upscaled. set this to 'false' to get performance improvements with old computers / big files --->
	<cfparam name="attributes.state" type="string" default="idle" /><!--- current playback state of the player. 'idle'=no file loaded, 'buffering'=loading a file, 'playing'=playing a file, 'paused'=pausing playback; loading continues, 'completed'=same as 'idle,' but the file and player are loaded completely --->
	<cfset stateOptions = "idle,buffering,playing,paused,completed" />	
	<cfparam name="attributes.stretching" default="uniform" /><!--- defines how to resize images in the display. can be 'none'=no stretching, 'exactfit'=disproportionate, 'uniform'=stretch with black borders, or 'fill'=uniform, but completely fill the display  --->
	<cfset stretchingOptions = "uniform,fill,exactfit,none" />
	<cfparam name="attributes.volume" type="integer" default="90" /><!--- startup volume of the player. can be 0-100. is saved in a cookie --->

	<!--- EXTERNAL COMMUNICATION --->
	<!---
		for streaming, please read: http://developer.longtailvideo.com/trac/wiki/FlashFormats#RTMPStreaming
		in addition to the 'file' and the 'type=rtmp' variables, RTMP streams usually need the 'streamer' var
		which gives the player the location of the RTMP server (i.e., streamer='rtmp://edge.sercer.com/application')
	--->
	<cfparam name="attributes.streamer" type="string" default="" /><!--- location of server/script to use for streaming --->
	<cfparam name="attributes.rtmploadbalance" type="boolean" default="false" />
	<cfparam name="attributes.rtmpsubscribe" type="boolean" default="false" />
	<cfparam name="attributes.plugins" type="string" default="" /><!--- comma-separated list of plugins --->

	<!--- Sharing --->
	<cfparam name="attributes.sharecode" type="boolean" default="false" /><!--- display 'embed' code button --->
	<cfparam name="attributes.sharelink" type="boolean" default="false" /><!--- display 'share' link button --->

	<!--- :::::::::::::: ATTRIBUTE VALIDATION :::::::::::::::::::: --->
	<cfscript>
		uid = CreateUUID();
		// since most people would probably pass in the desired width and height of the 'video', let's account for the toolbar height auto-magically
		attributes.height = val(attributes.height) + 20;
		// if we're only playing a .mp3 file, then constraing the height to the player toolbar if no 'image' attribute has been passed
		if ( right(attributes.file, 4) eq ".mp3" and not len(trim(attributes.image)) ) { attributes.height = 20; }
		// height: minimum of 20px to display the player control bar only (i.e., for mp3 playback)
		if ( val(attributes.height) lt 20 ) { attributes.height = 20; }
		// width: minimum of 200px to display properly
		if ( val(attributes.width) lt 200 ) { attributes.width = 200; }
		if ( val(attributes.duration) lt 0 ) { attributes.duration = 0; }
		if ( val(attributes.volume) lt 0 ) { attributes.volume = 0; } else if ( val(attributes.volume) gt 100 ) { attributes.volume = 100; }
		// could also do this at the 'param' level, but this just seems cleaner
		if ( not IsValid("regex", attributes.bgcolor, "[0-9A-Fa-f]{6}") ) { attributes.bgcolor = "ffffff"; }
		if ( not IsValid("regex", attributes.bordercolor, "[0-9A-Fa-f]{6}") ) { attributes.bordercolor = "000000"; }
		if ( not IsValid("regex", attributes.backcolor, "[0-9A-Fa-f]{6}") ) { attributes.backcolor = "ffffff"; }
		if ( not IsValid("regex", attributes.frontcolor, "[0-9A-Fa-f]{6}") ) { attributes.frontcolor = "000000"; }
		if ( not IsValid("regex", attributes.lightcolor, "[0-9A-Fa-f]{6}") ) { attributes.lightcolor = "000000"; }
		if ( not IsValid("regex", attributes.screencolor, "[0-9A-Fa-f]{6}") ) { attributes.screencolor = "000000"; }
		if ( not IsValid("url", attributes.link) ) { attributes.link = ""; }
		// enforce attribute options/choices
		if ( not ListFindNoCase(stretchingOptions, attributes.stretching, ",") ) { attributes.stretching = "uniform"; }
		if ( not ListFindNoCase(controlbarOptions, attributes.controlbar, ",") ) { attributes.controlbar = "bottom"; }
		if ( not ListFindNoCase(skinOptions, attributes.skin, ",") ) { attributes.skin = "default"; }
		if ( not ListFindNoCase(repeatOptions, attributes.repeat, ",") ) { attributes.repeat = "none"; }
		if ( not ListFindNoCase(playlistOptions, attributes.playlist, ",") ) { attributes.playlist = "none"; }
		if ( not ListFindNoCase(typeOptions, attributes.type, ",") ) { attributes.type = "none"; }
		if ( not ListFindNoCase(displayclickOptions, attributes.displayclick, ",") ) { attributes.displayclick = "play"; }
		if ( not ListFindNoCase(linktargetOptions, attributes.linktarget, ",") ) { attributes.linktarget = "_blank"; }
		if ( not ListFindNoCase(stateOptions, attributes.state, ",") ) { attributes.state = "idle"; }
		if ( not ListFindNoCase(playerOptions, attributes.player, ",") ) { attributes.player = "player.swf"; }
		if ( not ListFindNoCase(borderstyleOptions, attributes.borderstyle, ",") ) { attributes.borderstyle = "solid"; }
		if ( not ListFindNoCase(wmodeOptions, attributes.wmode, ",") ) { attributes.wmode = "opaque"; }
		// auto-fix display when using a playlist
		switch ( attributes.playlist ) {
			case "bottom" : {
				attributes.height += val(attributes.playlistsize);
				break;
			}
			case "right" : {
				attributes.width += val(attributes.playlistsize);
				break;
			}
		}
		if ( len(trim(attributes.hdfile)) ) {
			attributes.dock = true;
			attributes.plugins = attributes.plugins & ",hd-1";
		}
		// sharing
		if ( attributes.sharecode or attributes.sharelink ) {
			attributes.dock = true;
			attributes.plugins = attributes.plugins & ",sharing-1";
		}
		// clean up title attribute
		if ( len(trim(attributes.title)) ) {
			attributes.title = HTMLEditFormat(attributes.title);
			attributes.title = REReplace(attributes.title, "'", "&##39;", "ALL");
		}
	</cfscript>
	<!--- sharing embed code --->
	<cfsavecontent variable="request.embedcode">
		<cfoutput><embed src="#request.playerbaselink##request.playerpath##attributes.player#" width="<cfif attributes.playlist eq'right'>#val(attributes.width-attributes.playlistsize)#<cfelse>#val(attributes.width)#</cfif>" height="<cfif attributes.playlist eq 'bottom'>#val(attributes.height-attributes.playlistsize)#<cfelse>#val(attributes.height)#</cfif>" allowscriptaccess="always" allowfullscreen="#attributes.allowfullscreen#" flashvars="file=#attributes.file#<cfif attributes.stretching neq "uniform">&stretching=#attributes.stretching#</cfif>" /></cfoutput>
	</cfsavecontent>
</cfsilent>
<cfif thisTag.executionMode is "start">
	<cfif structKeyExists(attributes, "file") and len(trim(attributes.file))>
		<cfif not request.swfObjIsThere>
			<cfsavecontent variable="headStuff">
				<cfoutput><script type="text/javascript" src="#request.playerpath#swfobject.js"></script></cfoutput>
			</cfsavecontent><cfhtmlhead text="#headStuff#" />
			<cfset request.swfObjIsThere = true />
		</cfif>
		<cfsavecontent variable="cssStuff">
			<cfoutput><style type="text/css">##mediaspace_#uid# { padding: #attributes.padding#; margin: #attributes.margin#; border: #val(attributes.border)#px #attributes.borderstyle# ###attributes.bordercolor#; background-color: ###attributes.bgcolor#; width: #val(attributes.width)#px; } h3.mediatitle { padding: 1em 0 0 0; margin: 0 0 -0.75em 0; }</style></cfoutput>
		</cfsavecontent><cfhtmlhead text="#cssStuff#" />
			<cfif attributes.showtitle and len(trim(attributes.title))><cfoutput><h3 class="mediatitle">#attributes.title#</h3></cfoutput></cfif>
			<cfoutput><div id="mediaspace_#uid#">This text will be replaced <noscript>when you enable JavaScript.</noscript></div></cfoutput>
			<script type="text/javascript">
				<cfoutput>
					var so = new SWFObject('#request.playerpath##attributes.player#','mpl','#val(attributes.width)#','#val(attributes.height)#','9');
					so.addParam('allowfullscreen','#attributes.allowfullscreen#');
					so.addParam('allowscriptaccess','always');
					so.addParam('wmode','#attributes.wmode#');
					<cfif attributes.wmode eq "transparent">so.addParam('windowless','true');</cfif>
					so.addVariable('file','#urlencodedformat(attributes.file)#');
					so.addVariable('backcolor','#attributes.backcolor#');
					so.addVariable('frontcolor','#attributes.frontcolor#');
					so.addVariable('lightcolor','#attributes.lightcolor#');
					so.addVariable('screencolor','#attributes.screencolor#');
				</cfoutput>
				<cfscript>
					// plugins
					if ( len(trim(attributes.plugins)) ) {
						WriteOutput("so.addVariable('plugins','#attributes.plugins#');");
					}

					// File properties
					if ( len(trim(attributes.author)) ) {
						WriteOutput("so.addVariable('author','#htmleditformat(attributes.author)#');");
					}
					if ( len(trim(attributes.date)) ) {
						WriteOutput("so.addVariable('date','#attributes.date#');");
					}
					if ( len(trim(attributes.description)) ) {
						WriteOutput("so.addVariable('description','#htmleditformat(attributes.description)#');");
					}
					if ( val(attributes.duration) gt 0 ) {
						WriteOutput("so.addVariable('duration','#val(attributes.duration)#');");
					}
					if ( len(trim(attributes.hdfile)) ) {
						WriteOutput("so.addVariable('hd.file','#urlencodedformat(attributes.hdfile)#');");
					}
					if ( len(trim(attributes.image)) ) {
						WriteOutput("so.addVariable('image','#urlencodedformat(attributes.image)#');");
					}
					if ( len(trim(attributes.link)) ) {
						WriteOutput("so.addVariable('link','#urlencodedformat(attributes.link)#');");
					}
					if ( val(attributes.start) gt 0 ) {
						WriteOutput("so.addVariable('start','#val(attributes.start)#');");
					}
					if ( len(trim(attributes.streamer)) ) {
						WriteOutput("so.addVariable('streamer','#urlencodedformat(attributes.streamer)#');");
					}
					if ( len(trim(attributes.tags)) ) {
						WriteOutput("so.addVariable('tags','#urlencodedformat(attributes.tags)#');");
					}
					if ( len(trim(attributes.title)) ) {
						WriteOutput("so.addVariable('title','#attributes.title#');");
					}
					if ( attributes.type neq "none" ) {
						WriteOutput("so.addVariable('type','#attributes.type#');");						
						if ( attributes.rtmploadbalance ) {
							WriteOutput("so.addVariable('rtmp.loadbalance','true');");
						}
						if ( attributes.rtmpsubscribe ) {
							WriteOutput("so.addVariable('rtmp.subscribe','true');");
						}
					}

					// Layout
					if ( attributes.controlbar neq "bottom" ) {
						WriteOutput("so.addVariable('controlbar','#attributes.controlbar#');");
					}
					if ( not attributes.icons ) {
						WriteOutput("so.addVariable('icons','false');");
					}
					if ( len(trim(attributes.logo)) ) {
						WriteOutput("so.addVariable('logo','#urlencodedformat(attributes.logo)#');");
					}
					if ( attributes.playlist neq "none" ) {
						WriteOutput("so.addVariable('playlist','#attributes.playlist#');");
						WriteOutput("so.addVariable('playlistsize','#val(attributes.playlistsize)#');");
					}
					if ( attributes.skin neq "default" ) {
						WriteOutput("so.addVariable('skin','#request.playerpath#skins/#urlencodedformat(attributes.skin)#.swf');");
					}

					// Behaviour
					if ( attributes.autostart ) {
						WriteOutput("so.addVariable('autostart','true');");
					}
					if ( val(attributes.bufferlength) gt 0 ) {
						WriteOutput("so.addVariable('bufferlength','#val(attributes.bufferlength)#');");
					}
					if ( attributes.displayclick neq "play" ) {
						WriteOutput("so.addVariable('displayclick','#attributes.displayclick#');");
					}
					if ( attributes.dock ) {
						WriteOutput("so.addVariable('dock','true');");
					}
					if ( len(trim(attributes.item)) ) {
						WriteOutput("so.addVariable('item','#urlencodedformat(attributes.item)#');");
					}
					if ( attributes.linktarget neq "_blank" ) {
						WriteOutput("so.addVariable('linktarget','#attributes.linktarget#');");
					}
					if ( attributes.mute ) {
						WriteOutput("so.addVariable('mute','true');");
					}
					if ( attributes.repeat neq "none" ) {
						WriteOutput("so.addVariable('repeat','#attributes.repeat#');");
					}
					if ( attributes.shuffle ) {
						WriteOutput("so.addVariable('shuffle','true');");
					}
					if ( not attributes.smoothing ) {
						WriteOutput("so.addVariable('smoothing','false');");
					}
					if ( attributes.state neq "idle" ) {
						WriteOutput("so.addVariable('state','#attributes.state#');");
					}
					if ( attributes.stretching neq "uniform" ) {
						WriteOutput("so.addVariable('stretching','#attributes.stretching#');");
					}
					if ( val(attributes.volume) lt 100 ) {
						WriteOutput("so.addVariable('volume','#val(attributes.volume)#');");
					}

					// sharing 
					if ( attributes.sharelink ) {
						WriteOutput("so.addVariable('sharing.link','#urlencodedformat(request.playerlink)#');");
					}
					if ( attributes.sharecode ) {
						WriteOutput("so.addVariable('sharing.code','#urlencodedformat(request.embedcode)#');");
					}
				</cfscript>
				<cfoutput>so.write('mediaspace_#uid#');</cfoutput>
			</script>
		</cfif>
	<cfelse>
</cfif></cfprocessingdirective>