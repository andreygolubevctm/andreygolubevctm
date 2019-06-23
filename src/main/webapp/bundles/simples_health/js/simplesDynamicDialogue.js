;(function($, undefined){

	var meerkat = window.meerkat,
    log = meerkat.logging.info,
    dynamicValues = [
    {
      text: '%DYNAMIC_FUNDNAME%', 
      get: function(product) {
        return '<b>' + product.info.providerName + '</b>';
      }
    },
    {
      text: '%DYNAMIC_HOSPITALBENEFITS%', 
      get: function(product) {
        var benefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel();
        var productBenefits = product ? product.hospital.benefits : [];
        var listText = 'A number of clinical categories like Brain and Nervous System, Kidney and Bladder and Digestive System, just to name a few';
        return getBenefitsList(benefits, productBenefits, listText, false);
      }
    },
    {
      text: '%DYNAMIC_Y_HOSPITALBENEFITS%',
      get: function(product) {
        var productBenefits = product ? product.custom.reform.tab1.benefits : [];
        var html = '';

        for(let i = 0; i < productBenefits.length; i++) {
          var benefit = productBenefits[i];

          if(benefit.covered === 'Y') {
            html += '<li>' + benefit.category + '</li>';
          }
        }

        return html;
      }
    },
    {
      text: '%DYNAMIC_HOSPITALBENEFITS_NO_BLURB%', 
      get: function(product) {
        var benefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel();
        var productBenefits = product ? product.hospital.benefits : [];
        var listText = '<li>NO HOSPITAL BENEFITS SELECTED</li>';
        return getBenefitsList(benefits, productBenefits, listText, false);
      }
    },
    {
      text: '%DYNAMIC_EXTRASBENEFITS%', 
      get: function(product) {
        var benefits = meerkat.modules.healthBenefitsStep.getExtraBenefitsModel();
        var productBenefits = product ? product.extras : [];
        var listText = 'A number of extras benefits like ';
        return getBenefitsList(benefits, productBenefits, listText, true);
      }
    },
    {
      text: '%DYNAMIC_EXTRASBENEFITS_NO_BLURB%', 
      get: function(product) {
        var benefits = meerkat.modules.healthBenefitsStep.getExtraBenefitsModel();
        var productBenefits = product ? product.extras : [];
        var listText = '<li>NO EXTRAS SELECTED</li>';
        return getBenefitsList(benefits, productBenefits, listText, false);
      }
    },
    {
      text: '%DYNAMIC_LHCTEXT%', 
      get: function(product) {
        var lhc =meerkat.modules.health.getRates().loading;
        if(lhc === "0") return '';

        return '<li>By having private hospital cover you will now avoid lifetime health cover loading.</li>';
      }
    },
    {
      text: '%DYNAMIC_MLSTEXT%', 
      get: function(product) {
        var tier =meerkat.modules.health.getRates().tier;
        if(tier === "0") return '';

        return '<li>By having private hospital cover you will now avoid the Medicare Levy Surcharge.</li>';
      }
    },
    {
      text: '%DYNAMIC_PROVIDER_SPECIFIC_CONTENT%', 
      get: function(product) {
        var content = meerkat.modules.healthResults.getProviderSpecificPopoverData(product.info.provider);
        if(content.length === 0) { return ''; }

        return content[0].providerBlurb; 
      }
    },
    {
      text: '%DYNAMIC_FREQUENCYAMOUNT%',
      get: function(product) {
        return '<strong>' + product.premium[product._selectedFrequency].text + '</strong>';
      }
    },
    {
      text: '%DYNAMIC_PRODUCT_PROMOTION%',
      get: function(product) {
        if(! product.promo.promoText) { 
          return ''; 
        }

        return '(Discuss promotions)' + '<p>' + product.promo.promoText + '</p>';
      }
    },
    {
      text: '%DYNAMIC_MAJOR_WAITING%',
      get: function(product) {
      var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();

       var majorDental = product.extras['DentalMajor'];
       var majorDentalText = selectedBenefitsList.indexOf('DentalMajor') > -1 ? majorDental.waitingPeriod + ' for Major Dental, ' : '';
       var optical = product.extras['Optical'];
       var opticalText = selectedBenefitsList.indexOf('Optical') > -1 ? optical.waitingPeriod + '  for Optical, ' : '';
       var startText = 'The extras waiting periods are only ';
       
       if(!opticalText && !majorDentalText) {
         startText = '';
       }

        return startText + majorDentalText + opticalText;
      }
    },
    {
      text: '%DYNAMIC_WAITING_OVER2%',
      get: function(product) {
        var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
        var keys = Object.keys(product.extras);
        var text = '';
        var hasMajorWaiting = false;

        for(var i = 0; i < keys.length; i++) {
          var extra = product.extras[keys[i]];
          if(extra) {
            var waitingPeriod = extra.waitingPeriod ? extra.waitingPeriod.split(' ')[0] : '';
            if(selectedBenefitsList.indexOf(keys[i]) > -1) {
              if(extra.name.toLowerCase() == 'optical' || extra.name.toLowerCase() == 'major dental') {
                hasMajorWaiting = true;
                continue;
              }else {
                if(waitingPeriod > 2) {
                  text += extra.waitingPeriod + ' for ' + extra.name + ', ';
                }
              }
            }
          }
        }

        if(text && !hasMajorWaiting) {
          text = 'The extras waiting periods are only ' + text;  
        }

        return text;
      }
    }, 
    {
      text: '%DYNAMIC_REMAINING_WAITING%',
      get: function(product) {
        var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
        var keys = Object.keys(product.extras);
        var hasMajorWaiting = false;
        var has2MonthGreaterWaiting = false;
        var text = '';

        for(var i = 0; i < keys.length; i++) {
          var extra = product.extras[keys[i]];
          if(extra) {
            if(selectedBenefitsList.indexOf(keys[i]) > -1 && extra.name) {
              if(extra.name.toLowerCase() == 'optical' || extra.name.toLowerCase() == 'major dental') {
                hasMajorWaiting = true;
                continue;
              }else {
                var waitingPeriod = extra.waitingPeriod ? extra.waitingPeriod.split(' ')[0] : '';

                if(waitingPeriod > 2) {
                  has2MonthGreaterWaiting = true;
                }else {
                  text = '2 months for all other services that we discussed are important to you.';
                }
              }
            }
          }
        }
        if(text) {
          if(hasMajorWaiting || has2MonthGreaterWaiting) {
            text = ' and ' + text;
          }

          if(!hasMajorWaiting && !has2MonthGreaterWaiting) {
            text = 'The extras waiting periods are 2 months for all the services that we discussed are important to you.';
          }
        }

        return text;

      }  
    }
  ];

  function getBenefitsList(benefits, productBenefits, listStartText, renderList) {
    var selectedBenefitsList = meerkat.modules.healthBenefitsStep.getSelectedBenefits();
    var selectedBenefits = benefits.filter(function(benefitItem) {
      return selectedBenefitsList.indexOf(benefitItem.value) > -1;
    });
    var benefit;

    var html = '';
    if(selectedBenefits.length > 0) {
      for(var i = 0; i < selectedBenefits.length; i++) {
        benefit = selectedBenefits[i];
        html += '<li>' + benefit.label + '</li>';
      }
    }else{
        html += getProductBenefitList(benefits, productBenefits, renderList, listStartText, ['Y', 'YY'], false);
    }

    return html;
  }

  function getProductBenefitList(benefits, productBenefits, renderList, listStartText, coveredCheck, isOrderedList) {
    var html = '';
    var keys = Object.keys(productBenefits || []);
    html += listStartText;
    var found = 0;
    if(renderList) {
      for(var j = 0; j < keys.length; j++) {
        benefit = benefits.find(function(benefit) {
          return benefit.value === keys[j];
        });
        var productBenefit = productBenefits[keys[j]];

          if(benefit && coveredCheck.indexOf(productBenefit.covered) > -1) {
            if(!isOrderedList) { 
              if(found > 0 && found < 2) {
                html += ', ';
              }

              if(found === 2) {
                html += ' and ';
              }

              html += benefit.label;
          }else{
            html += '<li>' + benefit.label + '</li>';
          }
        }

          if(found === 3) {
            break;
          }
      }
    }
    return html;
  }

    function parse(id, onParse) {
      if(!id) return;

      _.defer(function () {
        var dialogue = $('.simples-dialogue-' + id);
        var product = Results.getSelectedProduct();
        var html = dialogue.html();

        for(var i = 0; i < dynamicValues.length; i++) {
          var value = dynamicValues[i];
          if(html.indexOf(value.text) > -1) {
            html = html.replace(new RegExp(value.text, 'g'), value.get(product));
          }
        }

        dialogue.html(html);
        if(onParse && typeof onParse === 'function') { 
          onParse();
        }
    });
    }

	meerkat.modules.register('simplesDynamicDialogue', {
		parse: parse
	});

})(jQuery);
