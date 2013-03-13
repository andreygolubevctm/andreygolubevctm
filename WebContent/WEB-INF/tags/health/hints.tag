<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" required="false" rtexprvalue="true" description="optional additional css class attribute"%>

<%-- CSS --%>
<go:style marker="css-head">

	.hint-tag {
		display:				none;
		margin:					0 0 0 20px !important;
	}

	.hint-tag .right-panel-top {
		height:					11px;
	}

	.hint-tag .right-panel-bottom {
		height:					6px;
		background-position:	bottom left;
	}
	
	.hint-tag h1 {
		font-family: 			"SunLT Light", "Open Sans", Helvetica, Arial, sans-serif;
		font-size: 				19px;
		font-weight: 			300;
		color: 					#0CB24E;
	}
	
	.hint-tag h3 {
		margin-top:				10px;
		margin-bottom: 			3px;
		font-size: 				13px;
		color: 					#113594;
	}
	
	.hint-tag p {
		font-size:				100%;
		line-height: 			15px;
		/*padding-left: 			30px;
		background: 			transparent url(common/images/info.png) top left no-repeat;*/
	}
	
	.hint-tag a {
		font-size:				100%;
	}
	
	.hint-tag ul {}
	
	.hint-tag ul li {
		display: 				block;
	}

	.right-panel.hint-tag.hidden {
		display:				none !important;
	}
		
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var HintTag = function(params)
{
	var that =			this,
		properties =	{},
		element =		null,
		params = 		$.extend({
				target:		$("#content"), 
				id:			"hint", 
				content:	"default hint content", 
				group:		false, 
				position:	'mid',
				y_offset:	0,
				x_offset:	0
		},params);
	
	var init = function()
	{
		element = $("<div class='right-panel hint-tag ${className}' id='hint_" + params.id + "'><div class='right-panel-top'></div><div class='right-panel-middle'><p>" + params.content + "<p></div><div class='right-panel-bottom'></div></div>").hide();
		$(".right-panel").last().after( element );
		
		calculateProperties();			
		that.render();
	};
	
	var calculateProperties = function()
	{
		properties = 			{};
		properties = 			params.target.position();
		properties.width =		params.target.width();
		properties.height = 	params.target.height();
		properties.y_offset = 	params.y_offset;
		properties.x_offset = 	params.x_offset;
		properties.position =	params.position;
		properties.me = 		{
			width:	element.width(),
			height:	element.height(),
			left:	properties.left + properties.width + params.x_offset
		};
		
		switch( params.position )
		{
			case "top": 
				properties.me.top = properties.top + params.y_offset;
				break;
				
			case "mid":
			default:
				properties.me.top = properties.top + (properties.height/2) - (element.height()/2) + params.y_offset;
				break;
		}
	};
	
	this.render = function()
	{
		element.css({
			position:	'absolute',
			top:		properties.me.top,
			left:		properties.me.left,
			zIndex:		200
		});		
		
		if( !element.is(":visible") )
		{
			element.slideDown("slow");
		}
	}
	
	this.remove = function()
	{
		element.slideUp("false", function() {
			element.remove();
		});
	};
	
	this.getProperties = function()
	{
		return properties;
	};
	
	this.setProperties = function( props )
	{
		properties = props;
	};
	
	this.isInGroup = function( grp )
	{
		return grp == params.group;
	};
	
	this.getGroup = function()
	{
		return params.group;
	}
	
	init();
};

var Hints = function()
{
	var	that =		this,
		tags =		{},
		params =	{};
	
	this.add = function( params )
	{	
		setTimeout(function() {	
			params = $.extend({
				target:		$("#content"), 
				id:			"hint"
			},params);
			
			if( params.target.is(":visible") )
			{
				that.remove(params.id);
				tags[params.id] = new HintTag( params );
				
				if( params.group )
				{
					repositionGroup( params.group );
				}
				
				toggleRightPanel();
			}
		}, 400);
	};
	
	this.remove = function( id )
	{
		if( tags.hasOwnProperty(id) )
		{
			tags[id].remove();
			delete tags[id];
			 
			toggleRightPanel();
		}
	};
	
	this.clear = function(){
		if(typeof tags == 'object'){
			for (var key in tags) {
		    	hints.remove(key);
		    };
	    };
	};
	
	var hasHints = function()
	{
		var count = 0;
		
		for(var i in tags)
		{
			if( typeof tags[i] == "object" && tags[i].constructor == HintTag )
			{
				count++;
			}
		}
		
		return count > 0;
	};
	
	var toggleRightPanel = function()
	{
		if( !hasHints() ) 
		{
			$(".right-panel").not(".hint-tag, .slideScrapesContainer, #policy_details").each(function(){
				if( !$(this).is(":visible") )
				{
					$(this).slideDown("fast");
				}
			});
		}
		else
		{
			$(".right-panel").not(".hint-tag, .slideScrapesContainer, #policy_details").each(function(){
				if( $(this).is(":visible") )
				{
					$(this).slideUp("fast");
				}
			});
		}
	};
	
	var checkVisibleHints = function()
	{
		var groups = [];
		
		for(var i in tags)
		{
			var grp = tags[i].getGroup();
			
			if( grp != false && groups.indexOf(grp) < 0 )
			{
				groups.push(grp)
				repositionGroup( grp );
			}
			else if( grp === false )
			{
				tags[i].render();
			}
		}
	}
	
	var isValid = function( obj )
	{
		return typeof obj == "object" && obj.constructor === HintTag
	};
	
	var repositionGroup = function(group)
	{
		var v_spacing =		10;
		var members = 		[];
		var group_height =	0;
		
		for(var i in tags)
		{
			if( group && isValid(tags[i]) && tags[i].isInGroup(group) )
			{
				members.push( tags[i] );
				group_height += tags[i].getProperties().me.height;
			}
		}
		
		if( members.length >= 2 )
		{
			group_height += (members.length - 1) * v_spacing;
		}
		
		var next_top = 0;
		
		for(var i = 0; i < members.length; i++)
		{
			var props = members[i].getProperties();
			
			if(i === 0)
			{
				switch( props.position )
				{
					case "top":
						props.me.top = props.top + props.y_offset;
						break;
						
					case "mid":
					default:
						props.me.top = props.top + (props.height/2) - (group_height/2) + props.y_offset;
						break;
				}
				
				next_top = props.me.top + props.me.height + v_spacing;
			}
			else
			{
				props.me.top = next_top;
				next_top = props.me.top + props.me.height + v_spacing;
			}
			
			members[i].render();
		}
	};
	
	var flush = function()
	{
		for(var i in tags)
		{
			if( isValid( tags[i]) )
			{
				that.remove[i];
			}
		}
		
		tags = {};
	};
	
	var init = function()
	{
		$.address.internalChange(function(event){
			flush();
		});
		
		$("#next-button").on("click", function(){
			flush();
		});
	};
	
	init();
};

var hints = new Hints();

</go:script>