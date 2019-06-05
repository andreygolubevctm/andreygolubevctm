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
        var selectedBenefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel().filter(function(benefit) {
          return benefit.selected;
        });

        var html = '';
        if(selectedBenefits.length > 0) {
          for(var i = 0; i < selectedBenefits.length; i++) {
            var benefit = selectedBenefits[i];
            html += '<li>' + benefit.label + '</li>';
          }
        }else{
          html += 'A number of clinical categories like ';
          var keys = Object.keys(product.hospital.benefits);
          var found = 0;
          for(var j = 0; j < keys.length; j++) {
            var hospital = product.hospital.benefits[keys[j]];
              if(hospital.covered === 'Y' || hospital.covered === 'YY') {
                if(found > 0 && found < 2) {
                  html += ', ';
                }

                if(found === 2) {
                  html += ' and ';
                }

                html += hospital.name;
                found++;
              }

              if(found === 3) {
                break;
              }
          }
        }

        return html;
      }
    },
    {
      text: '%DYNAMIC_EXTRASBENEFITS%', 
      get: function(product) {
        var selectedBenefits = meerkat.modules.healthBenefitsStep.getExtraBenefitsModel().filter(function(benefit) {
          return benefit.selected;
        });

        var html = '';
        if(selectedBenefits.length > 0) {
          for(var i = 0; i < selectedBenefits.length; i++) {
            var benefit = selectedBenefits[i];
            html += '<li>' + benefit.label + '</li>';
          }
        }else{
          html += 'A number of extras benefits like ';
          var keys = Object.keys(product.extras);
          var found = 0;
          for(var j = 0; j < keys.length; j++) {
            var extra = product.extras[keys[j]];
              if(extra.covered === 'Y' || extra.covered === 'YY') {
                if(found > 0 && found < 2) {
                  html += ', ';
                }

                if(found === 2) {
                  html += ' and ';
                }
                html += extra.name;
                found++;
              }

              if(found === 3) {
                break;
              }
          }
        }

        return html;
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
      text: '%DYNAMIC_FREQUENCYAMOUNT%',
      get: function(product) {
        return '<strong>' + product.premium[product._selectedFrequency].text + '</strong>';
      }
    },
    {
      text: '%DYNAMIC_PRODUCT_PROMOTION%',
      get: function(product) {
        return product.promo.promoText;
      }
    },
    {
      text: '%DYNAMIC_MAJOR_WAITING%',
      get: function(product) {
       var majorDental = product.extras['DentalMajor'];
       var majorDentalText = majorDental.covered === 'Y' ? majorDental.waitingPeriod + ' for Major Dental, ' : '';
       var optical = product.extras['Optical'];
       var opticalText = optical.covered === 'Y' ? optical.waitingPeriod + '  for Optical, ' : '';
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
        var keys = Object.keys(product.extras);
        var text = '';

        for(var i = 0; i < keys.length; i++) {
          var extra = product.extras[keys[i]];
          if(extra) {
            var waitingPeriod = extra.waitingPeriod ? extra.waitingPeriod.split(' ') : '';
            if(extra.covered !== 'N' && waitingPeriod > 2 && extra.name && extra.name.toLowerCase() != 'optical' && extra.name.toLowerCase() != 'major dental') {
              text += extra.waitingPeriod + ' for ' + extra.name + ', ';
            }
          }
        }

        return text;
      }
    }
  ];
    
    function parse(id) {
      if(!id) return;

      _.defer(function () {
        var dialogue = $('.simples-dialogue-' + id);
        var product = Results.getSelectedProduct();
        var html = dialogue.html();

        for(var i = 0; i < dynamicValues.length; i++) {
          var value = dynamicValues[i];
          html = html.replace(new RegExp(value.text, 'g'), value.get(product));
        }

        dialogue.html(html);
    });
    }

	meerkat.modules.register('simplesDynamicDialogue', {
		parse: parse
	});

})(jQuery);
