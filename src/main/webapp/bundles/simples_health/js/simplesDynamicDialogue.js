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

        for(var i = 0; i < selectedBenefits.length; i++) {
          var benefit = selectedBenefits[i];
          html += '<li>' + benefit.label + '</li>';
        }

        return html;
      }
    },
    {
      text: '%DYNAMIC_HOSPITALBENEFITS_THREE%', 
      get: function(product) {
        var benefits = meerkat.modules.healthBenefitsStep.getHospitalBenefitsModel();

        var html = '';

        for(var i = 0; i < 3; i++) {
          var benefit = benefits[i];
          if(i > 0) {
            html += ', ';
          }
          html += benefit.label;
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
    }
  ];
    
    function init() {

    }

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
    init: init,
		parse: parse
	});

})(jQuery);
