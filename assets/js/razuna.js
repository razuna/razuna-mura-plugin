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
if ('CKEDITOR' in window) {

    (function () {

		pluginFolder = '/plugins/RazunaPlugin/';    	
    	razunaPluginAdded = false;
    	CKEDITOR.on('instanceReady', function(){
	    	
	    	
	    	if (razunaPluginAdded == false){
	    		
	    		razunaPluginAdded = true;
				for(var instanceName in CKEDITOR.instances) {
				    $targetTextArea = $(CKEDITOR.instances[instanceName].element.$)
				    $parentLabel = $targetTextArea.parent().siblings('.control-label');
				    aHref = '<a href=\'javascript:renderRazunaWindow("'+instanceName+'")\' class="pull-right">Razuna</a>';
				    $parentLabel.append(aHref)
				}
				
				$('body').append('<div id="razunaModalWindow"></div>');
			}	
		});
		
	})();
	/*$('#insetr').live('click',function(){
		$('ckeditor').bodyAppend($('razunaThumbnailTxtBox').val());
	});*/
	function renderRazunaWindow(){
		$('#razunaModalWindow').html('<div align="center"><img src="'+pluginFolder+'assets/images/ajax-loader.gif"></div>');
		$('#razunaModalWindow').dialog({
	        bgiframe: true,
	        autoOpen: false,
	        width: 800,
	        modal: true,
	        title: "Razuna plugin" 
       	});
		$('#razunaModalWindow').load(pluginFolder+'?razunaaction=ajax',function(){
			

		$("#tagTree").jstree({
			"plugins" : ["json_data", "ui", "types"],
			"types" : {
            	"types" : {
		                "folder" : {
		                    "hover_node" : false,
		                    "select_node" : function () {return false;}
		                },
		                "default" : {
		                    "select_node" : function (target) {
								//$(target.children("a")).after($('#razunaImageDetails').html(''));
								$('.jstree-leaf #inner-div').slideUp(1000);
								setTimeout(function(){
									$('.jstree-leaf #inner-div').remove();
									$('#razunaImageDetails #show-image').attr('src',$(target).attr('data-local_url_thumb'));
									$('#razunaImageDetails #fileName').html($(target).attr('data-filename_org'));
									var type = $(target).attr('data-kind');
									if(type == 'aud')
										type = 'audio';
									else if(type == 'img')
										type = 'Image';
									else if(type == 'doc')
										type = 'Document';
									else if(type == 'vid')
										type = 'Video';
									$('#razunaImageDetails #filetype').html(type);
									$('#razunaImageDetails #filetype').html(type);
									$(target.children("a")).after($('#razunaImageDetails').html());
									//$('#razunaImageDetails').slideDown(1000);
								},1000);
								
								
								/*$(target).click(function(){
									$(target).after($('#razunaImageDetails').html());
									$('#razunaImageDetails').html();
								});*/
		                       // console.log(target);
		                        /*console.log($(target).attr('data-local_url_org'));
		                        console.log($(target).attr('data-local_url_thumb'));
		                        console.log(target.children("a"));*/
		                        return false;
		                    }
		                }
		            }
		       },
			"json_data" : { 
				"ajax" : {
					"url" : pluginFolder+'?razunaaction=ajax.getNodes',
					"data" : function (n) { 
						return { 
							"folderid" : n.attr ? n.attr("id") : 0
						}; 
					}
				}
			}
		});
		
		}).dialog('open');
	}
}