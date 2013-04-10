<cfsilent>
<!---
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
 
--->
<cfscript>
	qFolders = rc.razunaObj.getFolders(url.folderid);
	qAssets = rc.razunaObj.getassets(url.folderid);
	
	arr = arrayNew(1);
	
	for (x = 1; x <= qFolders.RecordCount; x=x+1) { 
		arr[x] = structNew();
		arr[x]["data"] = "#qFolders.FOLDER_NAME[x]#";
		arr[x]["attr"] = structNew();
		arr[x]["attr"]["id"] = "#qFolders.FOLDER_ID[x]#";
		
		arr[x]["attr"]["rel"] = "folder";
		arr[x]["state"] = "closed";
	}
	
	for (y = 1; y <= qAssets.RecordCount; y=y+1) { 
		
		arr[x] = structNew();
		arr[x]["data"] = "#qAssets.filename[x]#";
		arr[x]["attr"] = structnew();
		arr[x]["attr"]["id"] = "#qAssets.id[x]#";
		
		//arr[x]["attr"]["rel"] = "leaf";
		arr[x]["attr"]["rel"] = "#qAssets.KIND[x]#";
		arr[x]["state"] = "";
		arr[x]["attr"]["data-filename"] = "#qAssets.filename[x]#";
        arr[x]["attr"]["data-folder_id"] = "#qAssets.folder_id[x]#";
        arr[x]["attr"]["data-extension"] = "#qAssets.extension[x]#";
        arr[x]["attr"]["data-video_image"] = "#qAssets.video_image[x]#";
        arr[x]["attr"]["data-filename_org"] = "#qAssets.filename_org[x]#";
        arr[x]["attr"]["data-kind"] = "#qAssets.kind[x]#";
        arr[x]["attr"]["data-extension_thumb"] = "#qAssets.extension_thumb[x]#";
        arr[x]["attr"]["data-description"] = "#qAssets.description[x]#";
        arr[x]["attr"]["data-path_to_asset"] = "#qAssets.path_to_asset[x]#";
        arr[x]["attr"]["data-cloud_url"] = "#qAssets.cloud_url[x]#";
        arr[x]["attr"]["data-cloud_url_org"] = "#qAssets.cloud_url_org[x]#";
        arr[x]["attr"]["data-local_url_org"] = "#qAssets.local_url_org[x]#";
        arr[x]["attr"]["data-local_url_thumb"] = "#qAssets.local_url_thumb[x]#";
		x=x+1;	
	}
</cfscript>
	
</cfsilent>
<cfsetting enablecfoutputonly="true">
<cfoutput>#serializeJSON(arr)#</cfoutput>

