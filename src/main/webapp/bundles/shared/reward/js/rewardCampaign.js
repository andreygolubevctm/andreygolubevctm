;(function($, undefined){

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        log = meerkat.logging.info,
        debug = meerkat.logging.debug,
        exception = meerkat.logging.exception;

    var campaignTileTemplate, campaignTileTemplateXs,
        currentCampaign = false;

    function initRewardCampaign(){
        $(document).ready(function() {
            campaignTileTemplate = _.template($('#template-campaign-tile').html());
            campaignTileTemplateXs = _.template($('#template-campaign-tile-xs').html());
            eventSubscriptions();
            fetchCampaigns();
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(meerkatEvents.moreInfo.bridgingPage.SHOW, function () {
            renderCampaignTile();
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
        var $campaignTileContainersXs = $('.campaign-tile-container-xs');

        $campaignTileContainersXs.each(function renderXs() {
            $(this).html(campaignTileTemplateXs(availableRewards[0]));
        });

        var currentBackupAssetOrder = 2;
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
                        currentBackupAssetOrder++;
                    }
                    if (i === currentIndex) {
                        data = availableRewards[i];
                        data.assetOrder = currentBackupAssetOrder;
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

    function getCurrentCampaign() {
        return currentCampaign;
    }


    meerkat.modules.register("rewardCampaign", {
        init: initRewardCampaign,
        getCurrentCampaign: getCurrentCampaign
    });

})(jQuery);