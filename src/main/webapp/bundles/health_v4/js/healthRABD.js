;(function ($, undefined) {

  var meerkat = window.meerkat,
      $healthPrimaryDateofBirth,
      $healthSecondaryDateofBirth;

  function init() {
    $(document).ready(function() {
      $healthPrimaryDateofBirth = $('#health_healthCover_primary_dob');
      $healthSecondaryDateofBirth = $('#health_healthCover_partner_dob');
    });
  }

  function calculateABDValue() {
    
  }

  function isABD() {

  }

  function isRABD() {

  }

  meerkat.modules.register('healthRABD', {
      init: init,
      calculateABDValue: calculateABDValue,
      isABD: isABD,
      isRABD: isRABD
  });

})(jQuery);