<cfscript>
/*
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
	// FW1 Configuration
	variables.framework = {};

	// !important: enter the plugin packageName here. must be the same as found in '{context}/plugin/config.xml.cfm'
	variables.framework.package = 'RazunaPlugin';
	variables.framework.packageVersion = '0.1 Alpha';

	// If true, then additional information is returned by the Application.onError() method
	// and FW1 will 'reloadApplicationOnEveryRequest' (unless explicitly set otherwise below).
	variables.framework.debugMode = true;
	
	// change to TRUE if you're developing the plugin so you can see changes in your controllers, etc.
	variables.framework.reloadApplicationOnEveryRequest = variables.framework.debugMode ? true : false;

	// the 'action' defaults to your packageNameAction, (e.g., 'MuraFW1action') you may want to update this to something else.
	// please try to avoid using simply 'action' so as not to conflict with other FW1 plugins
	variables.framework.action = 'razunaaction';

	// less commonly modified
	variables.framework.defaultSection = 'main';
	variables.framework.defaultItem = 'default';
	variables.framework.usingSubsystems = true;
	variables.framework.defaultSubsystem = 'admin';

	// by default, fw1 uses 'fw1pk' ... however, to allow for plugin-specific keys, this plugin will use your packageName + 'pk'
	variables.framework.preserveKeyURLKey = variables.framework.package & 'pk';

	// ***** rarely modified *****
	variables.framework.applicationKey = variables.framework.package;
	variables.framework.base = '/' & variables.framework.package;
	variables.framework.reload = 'reload';
	variables.framework.password = 'appreload'; // IF you're NOT using the default reload key of 'appreload', then you'll need to update this!
	variables.framework.generateSES = false;
	variables.framework.SESOmitIndex = true;
	variables.framework.baseURL = 'useRequestURI';
	variables.framework.suppressImplicitService = false; //true to suppress fw/1 from storing service calls results in rc.data
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;

	if ( variables.framework.usingSubSystems ) {
		variables.framework.subsystemDelimiter = ':';
		//variables.framework.siteWideLayoutSubsystem = 'common';
		variables.framework.home = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.error';
	} else {
		variables.framework.home = variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSection & '.error';
	};
</cfscript>