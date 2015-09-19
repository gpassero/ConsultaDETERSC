/*
 * @author Carlos A. Junior
 * http://carlos.inf.br
 * version: 1.1.2
 */
(function ( $ ) {

	$.fn.vraptortypeahead = function(options) {
		
		var settings = $.extend({}, $.fn.vraptortypeahead.defaults, options);
		
		var ids 			= new Array();
		var descriptions 	= new Array();
		var fullObjects		= new Array();
		
		return $(this).typeahead({
			minLength: settings.minLength,
			updater:function(item){
				if(settings.debug){
					console.log(item);
				}
				
				var selected = null;
				for ( var i = 0; i < descriptions.length; i++) {
					if(descriptions[i] === item){

                        if(settings.debug){
                            console.log("Set selected value [" + ids[i] + "] at element [" + settings.out.storeId + "]");
                        }

						$(settings.out.storeId).val(ids[i]).trigger('blur');

						selected = fullObjects[i];
						
						break;
					}
				}
				if(settings.debug){
					console.log("Triggering events...");
				}
				
				settings.events.change(selected);
				
				if(settings.jumpTo != null){
					$(settings.jumpTo).focus().select();
				}
				
				return item;
			},
			source: function(query, process){
				
				var args = {};
				args[settings.params.name] = query;
				
				if(settings.debug){
					console.log("query: "   + query);
					console.log("uri: "     + settings.uri);
					console.log("args: "    + args);
				}
				
				ids 			= new Array();
				descriptions 	= new Array();
				fullObjects		= new Array();
				
				return $.post(settings.uri, args, function(data){
					if(settings.debug){
						console.log(data);
						console.log(data.list);
					}
					if(data != null && data.list != null){
						for (var i= 0; i < data.list.length; i++) {
							var object = data.list[i];
							
							console.log(object);
							
							descriptions[i] = $.fn.vraptortypeahead.descriptionString(object, settings);
							ids			[i] = object[settings.out.id];
							fullObjects [i] = object;
						}
					}
					
					return process(descriptions);
				});
			}
		});
		
		return this;
	};
	
	$.fn.vraptortypeahead.byString = function(o, s) {
	    s = s.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
	    s = s.replace(/^\./, '');           // strip a leading dot
	    var a = s.split('.');
	    while (a.length) {
	        var n = a.shift();
	        if (n in o) {
	            o = o[n];
	        } else {
	            return;
	        }
	    }
	    return o;
	}
	
	$.fn.vraptortypeahead.descriptionString = function(object, settings){
		
		var description = "";
		for (var i = 0; i < settings.out.description.length; i++) {

            var field = settings.out.description[i];

			// Applies all after this char.
			if((/^#/).test(field)){
				description += field.replace("#", '');
			}else{
				if(field.indexOf(".")> 0){
                    description += $.fn.vraptortypeahead.byString(object, field);
				}
				else{
					description += object[field] + " ";
				}
			}
		}
		
		return description;
	};
	
	$.fn.vraptortypeahead.defaults = {
		out: 		{
			id: 		 null,
			description: [],
			storeId:	 null
		},
		uri: 		null,
		params:		{
			name: 		null
		},
		minLength:	5,
		events:		{
			change: function(object){
				
			}
		},
		// all methods;
		methods:	{
			jumpTo:	null,
			// You can modify html or another information based
			// an any idea.
			customizeWhen: function(description, object, field){
				return description;
			}
		},
		// debug configs.
        debug: 		false
    };
	
}( jQuery ));
