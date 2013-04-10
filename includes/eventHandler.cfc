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
	
	
	function checkAjaxRequest(){
		var httpData = getHttpRequestData();
		var isAjaxRequest = ( structKeyExists(httpData, "headers") 
					AND structKeyExists(httpData.headers, "X-Requested-With") 
					AND httpData.headers["X-Requested-With"] EQ "XMLHttpRequest" );
		return isAjaxRequest;			 
	} 
	// ========================== Helper Methods ==============================

	private any function getApplication() {
		if( !StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}
	
	
		


}

