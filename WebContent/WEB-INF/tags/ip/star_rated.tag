<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a star rating display"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="js-head">
var StarRating = {
	render : function(element, rating)
	{
		element.empty().append('<div class="star_rated_item"><div class="stars" title="Rated ' + rating + ' out of 5"><div class="template"><!-- empty --></div><div class="rating" style="width:' + StarRating.getRatingAsPercentage(rating) + '%;"><!-- empty --></div></div></div>');
	},
	
	getRatingAsPercentage : function( rating )
	{
		rating = Number(rating);
		if( rating >= 5 )
		{
			return 100;
		}
		else if( rating > 0 )
		{
			return (rating / 5) * 100;
		}
		else
		{
			return 0;
		}
	}
};
</go:script>

<go:style marker="css-head">
.star_rated_item .stars {
	position:				relative;
	overflow:				hidden;
}

.star_rated_item .stars,
.star_rated_item .stars > div{
	width:					85px;
	height:					21px;
}

.star_rated_item .stars > div{
	position:				absolute;
	top:					0;
	left:					0;
	background:				transparent url(brand/ctm/images/rating_stars.png?v5) top left no-repeat;
}

.star_rated_item .stars div.template{
	width:					100%;
}

.star_rated_item .stars div.rating{
	width:					0%;
	background-position:	bottom left;
}
</go:style>
