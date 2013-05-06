/*
 *
 * Copyright (C) 2005-2008 Razuna Ltd.
 *
 * This file is part of Razuna - Enterprise Digital Asset Management.
 *
 * Razuna is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Razuna is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero Public License for more details.
 *
 * You should have received a copy of the GNU Affero Public License
 * along with Razuna. If not, see <http://www.gnu.org/licenses/>.
 *
 * You may restribute this Program with a special exception to the terms
 * and conditions of version 3.0 of the AGPL as described in Razuna's
 * FLOSS exception. You should have received a copy of the FLOSS exception
 * along with Razuna. If not, see <http://www.razuna.com/licenses/>.
 *
 *
 * HISTORY:
 * Date US Format		User					Note
 * 2013/04/10			CF Mitrah		 	Initial version
*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.pluginGenericEventHandler" {

	// framework variables
	include 'fw1config.cfm';
	
	// ========================== Mura CMS Specific Methods ==============================
	// Add any other Mura CMS Specific methods you need here.

	public void function onApplicationLoad(required struct $) {
		variables.pluginConfig.addEventHandler(this);
	}
	
	
	function onAdminRequestStart(required struct $) {
		If( not checkAjaxRequest()){
			pluginConfig.addToHTMLHeadQueue("includes/htmlhead.cfm");
		}
	}

	
	public void function onSiteRequestStart(required struct $) {
		arguments.$.setCustomMuraScopeKey(variables.framework.package, getApplication());
	}

	public void function onContentEdit(required struct $){
		writeDump(arguments.$);abort;
	}
	
	public any function onRenderStart(required struct $, required event ) {
		$.rmp = this;
		event.razunaMediaPlayer = this;
	}
	
	function checkAjaxRequest(){
		var httpData = getHttpRequestData();
		var isAjaxRequest = ( structKeyExists(httpData, "headers") 
					AND structKeyExists(httpData.headers, "X-Requested-With") 
					AND httpData.headers["X-Requested-With"] EQ "XMLHttpRequest" );
		return isAjaxRequest;			 
	} 
	// ========================== Helper Methods ==============================
	
	public string function dspMedia(string file,numeric height, numeric width){
	var local = structNew();
			if ( structKeyExists(variables, 'pluginConfig') ) {
				arguments.streamer = variables.pluginConfig.getSetting('streamurl');
			};

			local.mediaplayer = '';

			// if an invalid filetype has been passed, then return an empty string
			local.allowedTypes = 'flv^mp3^mp4^aac';
			if ( not listFindNoCase(local.allowedTypes, right(arguments.file, 3), '^') OR not len(trim(arguments.file)) ) {
				return local.mediaplayer;
			};

			// no need to validate any other args since validation is done in the custom tag itself
			// i.e., regex is performed on things like validating hex values are passed in for colors, etc.
			local.mp 					= structNew();
			local.mp.basedir			= variables.pluginConfig.getConfigBean().getContext() & '/plugins/' & variables.pluginConfig.getDirectory() & '/cfmediaplayer';
			var local.mp.file = arguments.file;
			var local.mp.width = arguments.width;
			var local.mp.height = arguments.height;
			param name="local.mp.allowfullscreen" default="true";
			param name="local.mp.autostart" default="false";
			param name="local.mp.backcolor" default="ffffff";
			param name="local.mp.bgcolor" default="ffffff";
			param name="local.mp.border" default="0";
			param name="local.mp.bordercolor" default="000000";
			param name="local.mp.borderstyle" default="solid";
			param name="local.mp.controlbar" default="bottom";
			param name="local.mp.duration" default="0";
			param name="local.mp.frontcolor" default="000000";
			param name="local.mp.hdfile" default="";
			param name="local.mp.image" default="";
			param name="local.mp.lightcolor" default="000000";
			param name="local.mp.mute" default="false";
			param name="local.mp.screencolor" default="000000";
			param name="local.mp.showtitle" default="true";
			param name="local.mp.sharecode" default="false";
			param name="local.mp.sharelink" default="false";
			param name="local.mp.skin" default="default";
			param name="local.mp.stretching" default="fill";
			param name="local.mp.title" default="";
			param name="local.mp.volume" default="90";
			param name="local.mp.isstream" default="false";
			param name="local.mp.streamer" default="";
			
			// create the media player 
		if( structKeyExists(local, 'mp')){
			savecontent variable="local.mediaplayer"{
				try{
					include "mediaPage.cfm";
					/*module template="../../cfmediaplayer/mediaplayer.cfm" attributecollection="#local.mp#";*/
				}
				catch(any e){
					/*<cfoutput>
							<h3>MuraMediaPlayer Error</h3>
							<p><strong>Error Message:</strong><br />
							#cfcatch.message#</p>
							<p><strong>Error Detail:</strong><br />
							#cfcatch.detail#</p>
						</cfoutput>*/
				}
			}
		}
		return local.mediaplayer;
	}

	private any function getApplication() {
		if( !StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}
	
}

