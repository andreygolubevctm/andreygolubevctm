;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var campaignTileTemplate, campaignTileMobileTemplate,
        currentCampaign = false;

    function initRewardCampaign(){
        $(document).ready(function() {
            campaignTileTemplate = _.template($('#template-campaign-tile').html());
            campaignTileMobileTemplate = _.template($('#template-campaign-tile-mobile').html());
            fetchCampaigns();
        });
    }
    
    function fetchCampaigns() {

        meerkat.modules.comms.get({
            url: 'spring/rest/reward/campaigns/get.json',
            cache: false,
            errorLevel: 'silent',
            dataType: 'json'
        })
        .done(function onSuccess(json) {
            if (json && json.hasOwnProperty('campaigns')) {
                currentCampaign = json.campaigns.filter(function(campaign) {
                    return campaign.active === true && campaign.visible === true;
                })[0];
                renderCampaignTile();
            } else {
                debug('No active campaigns.');
            }

        })
        .fail(function onError(obj, txt, errorThrown) {
            exception(txt + ': ' + errorThrown);
        });
    }

    function renderCampaignTile() {
        if (isCurrentCampaignValid() !== true) return;

        var availableRewards = currentCampaign.rewards.filter(function(reward) {
            return reward.active === true && ['Available', 'Low'].indexOf(reward.stockLevel) > -1;
        });

        if (availableRewards.length < 1) return;

        var $campaignTileContainers = $('.campaign-tile-container');

        var counter = 0;
        $campaignTileContainers.each(function render(index) {
            var data = null;
            if (availableRewards.length === 1) {
                data = availableRewards[0];
                data.assetOrder = index + 1;
            } else if (availableRewards.length > index) {
                data = availableRewards[index];
                data.assetOrder = 1;
            } else {
                var currentIndex = index % availableRewards.length;
                for (var i = 0; i < availableRewards.length; i++) {
                    if (i === availableRewards.length - 1) {
                        counter++;
                    }
                    if (i === currentIndex) {
                        data = availableRewards[i];
                        data.assetOrder = counter + 1;
                        break;
                    }
                }
            }

            if (data && data.hasOwnProperty('assetOrder')) {
                $(this).html(campaignTileTemplate(data));
            }
        });
    }

    function isCurrentCampaignValid() {
        if (!currentCampaign || !currentCampaign.hasOwnProperty('campaignCode')) {
            debug("No valid campaign - can not render");
            return false;
        }
        return true;
    }


    meerkat.modules.register("rewardCampaign", {
        init: initRewardCampaign
    });

})(jQuery);