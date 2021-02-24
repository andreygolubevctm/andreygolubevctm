;(function ($, undefined) {

	var meerkat = window.meerkat,
		log = meerkat.logging.info,
		hospitalBenefitsSource = null,
		dynamicValues = [
			{
				text: '%DYNAMIC_FUNDNAME%',
				get: function (product) {
					return '<b>' + product.info.providerName + '</b>';
				}
			},
			{
				text: '%DYNAMIC_HOSPITALBENEFITS%',
				get: function (product) {
					var productBenefits = {};
					var benefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel();
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var selectedBenefits = benefits.filter(function (benefitItem) {
						return selectedBenefitsList.indexOf(benefitItem.value) > -1;
					});
					var list = [];
					var keys, productBenefit;
					if (selectedBenefits && selectedBenefits.length) {
						productBenefits = product ? product.hospital.benefits : [];
						var prefix = "So, starting with the hospital this policy's a great fit because it covers ";
						list = [];
						for(var j=0; j<selectedBenefits.length; j++) {
							var benefit = selectedBenefits[j];
							if(benefit && productBenefits.hasOwnProperty(benefit.value) && ['Y', 'YY'].indexOf(productBenefits[benefit.value].covered) > -1) {
								list.push('<li>' + benefit.label + "</li>");
							}
						}
						return prefix + list.join("\n");
					} else {
						var listTextBenefits = ['Brain and Nervous system', 'Kidney and bladder', 'Digestive system'];
						var listTextBenefitsCovered = _allCopyBenefitsAreCovered(product.custom.reform.tab1.benefits, listTextBenefits);
						if(listTextBenefitsCovered) {
							return "A number of clinical categories like Brain and Nervous System, Kidney and Bladder and Digestive System, just to name a few";
						} else {
							list = [];
							productBenefits = product.custom.reform.tab1.benefits;
							for (var k = 0; k < productBenefits.length; k++) {
								productBenefit = productBenefits[k];
								if (productBenefit && ['Y', 'YY'].indexOf(productBenefit.covered) > -1) {
									list.push('<li>'+ productBenefit.category + '</li>');
								}
							}
							return "So, starting with the hospital this policy's a great fit because it covers " + list.join("\n");
						}
					}
				}
			},
			{
				text: '%DYNAMIC_Y_HOSPITALBENEFITS%',
				get: function (product) {
					var productBenefits = product ? product.custom.reform.tab1.benefits : [];
					var html = '';

					for (var i = 0; i < productBenefits.length; i++) {
						var benefit = productBenefits[i];

						if (benefit.covered === 'Y') {
							html += '<li>' + benefit.category + '</li>';
						}
					}

					return html;
				}
			},
			{
				text: '%DYNAMIC_HOSPITALBENEFITS_LIST%',
				get: function (product) {
					meerkat.modules.healthAboutYou.restoreHospitalComplianceCopyDialogs();
					var benefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel();
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var selectedBenefits = benefits.filter(function (benefitItem) {
						return selectedBenefitsList.indexOf(benefitItem.value) > -1;
					});
					var list = ['<li>NO HOSPITAL BENEFITS SELECTED</li>'];
					if (selectedBenefits && selectedBenefits.length) {
						list = [];
						for (var i = 0; i < selectedBenefits.length; i++) {
							list.push('<li>' + selectedBenefits[i].label + '</li>');
						}
					}
					return list.join("\n");
				}
			},
			{
				text: '%DYNAMIC_EXTRASBENEFITS%',
				get: function (product) {
					var benefits = meerkat.modules.healthBenefitsStep.getExtraBenefitsModel();
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var selectedBenefits = benefits.filter(function (benefitItem) {
						return selectedBenefitsList.indexOf(benefitItem.value) > -1;
					});
					var productBenefits = product ? product.extras : [];
					var list = ['<li>general dental</li>'];
					if (selectedBenefits && selectedBenefits.length) {
						list = [];
						var keys = Object.keys(productBenefits || []);
						for (var j = 0; j < keys.length; j++) {
							var productBenefit = productBenefits[keys[j]];
							if (productBenefit && ['Y', 'YY'].indexOf(productBenefit.covered) > -1) {
								list.push('<li>' + _getBenefitLabel(keys[j], benefits) + '</li>');
							}
						}
					}
					return list.join("\n");
				}
			},
			{
				text: '%DYNAMIC_EXTRASBENEFITS_LIST%',
				get: function (product) {
					meerkat.modules.healthAboutYou.restoreExtrasComplianceCopyDialogs();
					var benefits = meerkat.modules.healthBenefitsStep.getExtraBenefitsModel();
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var selectedBenefits = benefits.filter(function (benefitItem) {
						return selectedBenefitsList.indexOf(benefitItem.value) > -1;
					});
					var list = ['<li>NO EXTRAS SELECTED</li>'];
					if (selectedBenefits && selectedBenefits.length) {
						list = [];
						for (var i = 0; i < selectedBenefits.length; i++) {
							list.push('<li>' + selectedBenefits[i].label + '</li>');
						}
					}
					return list.join("\n");
				}
			},
			{
				text: '%DYNAMIC_LHCTEXT%',
				get: function (product) {
					var lhc = meerkat.modules.health.getRates().loading;
					if (lhc === "0") return '';

					return '<li>By having private hospital cover you will now avoid lifetime health cover loading.</li>';
				}
			},
			{
				text: '%DYNAMIC_MLSTEXT%',
				get: function (product) {
					var tier = meerkat.modules.health.getRates().tier;
					if (tier === "0") return '';

					return '<li>By having private hospital cover you will now avoid the Medicare Levy Surcharge.</li>';
				}
			},
			{
				text: '%DYNAMIC_NEXTGEN_OUTBOUND_SPECIFIC_CONTENT%',
				get: function (product) {
					var isNextGenOutbound = meerkat.modules.healthContactType.is('nextgenOutbound');
					if (!isNextGenOutbound) return '';

					return ' And you will never re-serve any waiting periods on services you currently have unless upgrading so it&apos;s a really smooth transition.';
				}
			},
			{
				text: '%DYNAMIC_PROVIDER_SPECIFIC_CONTENT%',
				get: function (product) {
					var content = meerkat.modules.healthResults.getProviderSpecificPopoverData(product.info.provider);
					if (content.length === 0) {
						return '';
					}

					return content[0].providerBlurb;
				}
			},
			{
				text: '%DYNAMIC_FREQUENCYAMOUNT%',
				get: function (product) {
					return '<strong>' + product.premium[product._selectedFrequency].text + ' ' + product._selectedFrequency + '</strong>';
				}
			},
			{
				text: '%DYNAMIC_PRODUCT_PROMOTION%',
				get: function (product) {
					var copy = product.promo.promoText;
					if (!copy || _.isEmpty(copy)) {
						return '';
					}

					// Remove empty tags that leak in from Simples
					copy = copy.replaceAll("<p></p>", "").replaceAll("&lt;p&gt;&lt;/p&gt;", "");

					return '<p class="blue"><span class="black">(Discuss promotions)</span><br/>' + copy + '</p>';
				}
			},
			{
				text: '%DYNAMIC_MAJOR_WAITING%',
				get: function (product) {
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();

					var majorDental = product.extras['DentalMajor'];
					var majorDentalText = selectedBenefitsList.indexOf('DentalMajor') > -1 ? majorDental.waitingPeriod + ' for Major Dental, ' : '';
					var optical = product.extras['Optical'];
					var opticalText = selectedBenefitsList.indexOf('Optical') > -1 ? optical.waitingPeriod + '  for Optical, ' : '';
					var startText = 'The extras waiting periods are only ';

					if (!opticalText && !majorDentalText) {
						startText = '';
					}

					return startText + majorDentalText + opticalText;
				}
			},
			{
				text: '%DYNAMIC_WAITING_OVER2%',
				get: function (product) {
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var keys = Object.keys(product.extras);
					var text = '';
					var hasMajorWaiting = false;

					for (var i = 0; i < keys.length; i++) {
						var extra = product.extras[keys[i]];
						if (extra) {
							var waitingPeriod = extra.waitingPeriod ? extra.waitingPeriod.split(' ')[0] : '';
							if (selectedBenefitsList.indexOf(keys[i]) > -1) {
								if (extra.name.toLowerCase() == 'optical' || extra.name.toLowerCase() == 'major dental') {
									hasMajorWaiting = true;
									continue;
								} else {
									if (waitingPeriod > 2) {
										text += extra.waitingPeriod + ' for ' + extra.name + ', ';
									}
								}
							}
						}
					}

					if (text && !hasMajorWaiting) {
						text = 'The extras waiting periods are only ' + text;
					}

					return text;
				}
			},
			{
				text: '%DYNAMIC_REMAINING_WAITING%',
				get: function (product) {
					var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
					var keys = Object.keys(product.extras);
					var hasMajorWaiting = false;
					var has2MonthGreaterWaiting = false;
					var has2MonthWaiting = false;
					var text = '';

					for (var i = 0; i < keys.length; i++) {
						var extra = product.extras[keys[i]];
						if (extra) {
							if (selectedBenefitsList.indexOf(keys[i]) > -1 && extra.name) {
								if (extra.name.toLowerCase() == 'optical' || extra.name.toLowerCase() == 'major dental') {
									hasMajorWaiting = true;
									continue;
								} else {
									var waitingPeriod = extra.waitingPeriod ? extra.waitingPeriod.split(' ')[0] : '';

									if (waitingPeriod > 2) {
										has2MonthGreaterWaiting = true;
									} else if (waitingPeriod == 2) {
										has2MonthWaiting = true;
									}
								}
							}
						}
					}

					if (has2MonthWaiting && (hasMajorWaiting || has2MonthGreaterWaiting)) {
						text = ' and 2 months for all other services that we discussed are important to you.';
					} else if (has2MonthWaiting) {
						text = 'The extras waiting periods are 2 months for all the services that we discussed are important to you.';
					}

					return text;

				}
			}];

	function _getBenefitLabel(code, benefits) {
		for(var i=0; i < benefits.length; i++) {
			if(benefits[i].value === code) {
				return benefits[i].label;
			}
		}
		return null;
	}

	function _allCopyBenefitsAreCovered(productBenefits, requiredBenefits) {
		var expected = requiredBenefits.length;
		var found = 0;
		for(var i=0; i<productBenefits.length; i++) {
			var benefit= productBenefits[i];
			if( _.indexOf(requiredBenefits, benefit.category) !== -1 && benefit.covered === 'Y') {
				found++;
			}
		}
		return expected !== 0 && found === expected;
	}

	function parse(id, onParse) {
		if (!id) return;

		_.defer(function () {
			var dialogue = $('.simples-dialogue-' + id);
			var product = Results.getSelectedProduct();
			var html = dialogue.html();

			for (var i = 0; i < dynamicValues.length; i++) {
				var value = dynamicValues[i];
				if (html.indexOf(value.text) > -1) {
					html = html.replace(new RegExp(value.text, 'g'), value.get(product));
				}
			}

			dialogue.html(html);
			if (onParse && typeof onParse === 'function') {
				onParse();
			}
		});
	}

	function init() {
		hospitalBenefitsSource = meerkat.site.hospitalBenefitsSource;
	}

	meerkat.modules.register('simplesDynamicDialogue', {
		init: init,
		parse: parse
	});

})(jQuery);
