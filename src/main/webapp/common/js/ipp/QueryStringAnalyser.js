// ----------------------------------------------------------------------------------------------------
// Small object to analyse QueryString values for use in the credit card tokenisation "protect" project.
// Could be expanded and re-used for any other QueryString analysis functionality.
// ----------------------
// Vic Webster 14/12/2012
// ----------------------------------------------------------------------------------------------------
QueryStringAnalyser = function()
	{

		this.queryString 	 = "";
		this.keyValuePairs = null;


		this.getValue = function( key )
			{
				return this.keyValuePairs[key];
			};



		this.keyExists = function( key )
			{
				var keyExists = (this.queryStringExists() &&
									  this.keyValuePairs != null &&
									  key in this.keyValuePairs );
				return keyExists;
			};



		this.getAllAsAssociativeArray = function()
			{
				return this.keyValuePairs;
			};



		this.queryStringExists = function()
			{
				return this.queryString.length > 0;
			};



		// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		// ON CONSTRUCT
		// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		var queryString = window.location.href.split("?")[1] || false;

		if ( queryString )
			{
				var percentTwentiesPattern 	 = /(%20)+/gm,
					equalsWithSpacesPattern 	 = /\s+=\s+/gm,
					ampersandWithSpacesPattern = /(\s*)&(\s*)/gm,
					leadingAndTrailingSpaces	 = /(^\s+)|(\s+$)/gm;

				queryString = queryString.replace(percentTwentiesPattern, " ");
				queryString = queryString.replace(equalsWithSpacesPattern, "=");
				queryString = queryString.replace(ampersandWithSpacesPattern, "&");
				queryString = queryString.replace(leadingAndTrailingSpaces, "");


				//Ensure all ampersands are single (not entities) so we can split using "&"
				queryString = queryString.replace(/&amp;/g, "&");

				var pairs 	= queryString.split("&" );
				this.keyValuePairs = new Array();
				this.queryString 		= queryString;

				for(var i = 0; i < pairs.length; i++)
					{
						var keyValue = pairs[i].split("=");
						this.keyValuePairs[ keyValue[0] ] = keyValue[1];
					}
			}



		// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	}
