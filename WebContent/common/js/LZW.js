//LZW Compression/Decompression for Strings
var LZW = {
		compress: function (uncompressed) {
			"use strict";
			// Build the dictionary.
			var i,
				dictionary = {},
				c,
				wc,
				w = "",
				result = [],
				dictSize = 256;
			for (i = 0; i < 256; i += 1) {
				dictionary[String.fromCharCode(i)] = i;
			}

			for (i = 0; i < uncompressed.length; i += 1) {
				c = uncompressed.charAt(i);
				wc = w + c;
				//Do not use dictionary[wc] because javascript arrays
				//will return values for array['pop'], array['push'] etc
			// if (dictionary[wc]) {
				if (dictionary.hasOwnProperty(wc)) {
					w = wc;
				} else {
					result.push(dictionary[w]);
					// Add wc to the dictionary.
					dictionary[wc] = dictSize++;
					w = String(c);
				}
			}

			// Output the code for w.
			if (w !== "") {
				result.push(dictionary[w]);
			}
			result =  result.join(".");
			var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_:/?@";
			for(var i=0; i<str.length; i++) {
				var regex = new RegExp((10 + i) + "", 'g');
				result = result.replace(regex,str.charAt(i));
			}
			return result;
		},


		decompress: function (s) {
			"use strict";
			// Build the dictionary.
			var i,
				dictionary = [],
				w,
				result,
				k,
				entry = "",
				dictSize = 256;
			for (i = 0; i < 256; i += 1) {
				dictionary[i] = String.fromCharCode(i);
			}

			var str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
			var x=0;
			for(x=0; x < str.length; x++) {
				var regex = new RegExp(str.charAt(x), 'g');
				s = s.replace(regex, (10 + x));
			}
			str = "-_:/?@";
			for(var y=0; y < str.length; y++) {
				var value = "\\" + str.charAt(y);
				var regex = new RegExp(value, 'g');
				s = s.replace(regex, (10 + y + x));
			}

			var compressed = s.split(".");

			w = String.fromCharCode(compressed[0]);
			result = w;
			for (i = 1; i < compressed.length; i += 1) {
				k = compressed[i];
				if (dictionary[k]) {
					entry = dictionary[k];
				} else {
					if (k == dictSize) {
						entry = w + w.charAt(0);
					} else {
						return null;
					}
				}

				result += entry;

				// Add w+entry[0] to the dictionary.
				dictionary[dictSize++] = w + entry.charAt(0);

				w = entry;
			}
			return result;
		}
};