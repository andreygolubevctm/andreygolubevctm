;(function ($, undefined) {

    var meerkat = window.meerkat,
        meerkatEvents = meerkat.modules.events,
        moduleEvents = {
            hospitalCategoryGroup:      "HOSPITAL_CATEGORY_GROUP_CHANGED",
            manualBenefitSelection:     "BENEFIT_MANUALLY_SELECTED",
            triggerBenefitsLoading:     "BENEFITS_LOADING",
            sortBenefits:               "SORT_BENEFITS",
            updateBenefitCounters:      "UPDATE_BENEFIT_COUNTERS",
			hardResetBenefits: 			"HARD_RESET_BENEFITS",
			benefitsModel:				"BENEFITS_MODEL_UPDATE_COMPLETED"
        },
        $elements,
        options = {
            CANCER_COVER: "Cancer cover",
            CHRONIC_BACK_ISSUES: "Chronic back issues",
            EAR_NOSE_THROAT: "Ear, nose & throat",
            MEDICALLY_NECESSARY_PLASTIC_AND_RECONSTRUCTIVE_SURGERY: "Plastic and reconstructive surgery (medically necessary)",
            BONE_MUSCLE_AND_JOINT_RECONSTRUCTION: "Bone, muscle and joint reconstruction",
            JOINT_REPLACEMENT: "Joint replacement",
            PREGNANCY_COVER: "Pregnancy cover"
        },
        isXS = false,
        xsHiddenOptions = ["MEDICALLY_NECESSARY_PLASTIC_AND_RECONSTRUCTIVE_SURGERY", "BONE_MUSCLE_AND_JOINT_RECONSTRUCTION", "JOINT_REPLACEMENT", "PREGNANCY_COVER"],
        activeOptions = [],
        benefitGroups = [];

    function init() {
        _.defer(function(){
            $elements = {
                wrapper:        $('#health_benefits_quickSelectHospital-container'),
                options:        $('#health_benefits_quickSelectHospital-container .options-container'),
                benefitRows:    $('#benefitsForm .Hospital-wrapper').find('.short-list-item'),
                input:          $('#health_benefits_quickSelectHospital')
            };

            isXS = meerkat.modules.deviceMediaState.get() === "xs";
            setupBenefitGroups();
            toggleWrapper(meerkat.modules.healthBenefitsCategorySelectHospital.getSelectedCategory());
            renderOptions();
            initActiveOptions();
            if(isXS) {
                renderShowHideToggles();
            }
            eventSubscriptions();
            eventListeners();
        });
    }

    function eventSubscriptions() {
        meerkat.messaging.subscribe(moduleEvents.hospitalCategoryGroup, function(payload) {
            toggleWrapper(payload.selectedCategory);
            if(payload.selectedCategory !== 'SPECIFIC_COVER') {
                unsetSelectors();
            }
        });
        meerkat.messaging.subscribe(moduleEvents.manualBenefitSelection, function(payload) {
            reverseToggleSelectorsAfterManualBenefitToggle(payload);
        });
        meerkat.messaging.subscribe(moduleEvents.hardResetBenefits, resetQuickSelects);
        meerkat.messaging.subscribe(moduleEvents.benefitsModel.BENEFITS_MODEL_UPDATE_COMPLETED, reverseToggleSelectorsAfterResultsFilterApplied);
    }

    function eventListeners() {
        $elements.options.find(".selectable").not(".showhide").each(function(){
            var $that = $(this);
            $that.on("click.toggleQuickSelect", function(){
                toggleSelector($(this));
            });
        });
        $elements.options.find(".selectable.showhide").each(function(){
            var $that = $(this);
            $elements[$that.hasClass("less") ? "xsQuickSelectToggleLess" : "xsQuickSelectToggleMore"] = $that;
            $that.on("click.toggleQuickSelect", function(){
                toggleShowHideSelector($(this));
            });
        });
    }

    function unsetSelectors() {
        activeOptions = [];
        $elements.options.find(".selectable").each(function(){
            var $that = $(this);
            if($that.hasClass("active")) {
                $that.removeClass("active");
                $that.find('.groupCount').html("");
            }
        });
		// Update hidden field with current quick select options
		$elements.input.val(activeOptions.join(","));
        toggleGroupLabels(false);
    }

    function setupBenefitGroups() {
        benefitGroups = [];
        $elements.benefitRows.each(function(){
            var $row = $(this);
            var groups = [];
            var groupsStr = $row.attr("data-groups");
            if(!_.isEmpty(groupsStr)) {
                groups = groupsStr.split(",");
            }
            benefitGroups.push(groups);
        });
    }

    function initActiveOptions() {
        activeOptions = [];
        var optionsStr = $elements.input.val();
        if(!_.isEmpty(optionsStr) && optionsStr.length > 1) {
            activeOptions = optionsStr.split(",");
        }
        for(var i=0; i < activeOptions.length; i++) {
            var group = activeOptions[i];
            var $option = $elements.options.find("[data-group=" + group + "]");
            if ($option.length) {
                var count = getBenefitsCountForGroup(group);
                $option.toggleClass("active", true).find(".groupCount").html("&nbsp;(" + count + ")");
            }
        }
        _.defer(toggleGroupLabels);
    }

    function toggleWrapper(category) {
        if(category === "SPECIFIC_COVER") {
            $elements.wrapper.slideDown("fast");
        } else {
            $elements.wrapper.slideUp("fast");
        }
    }

    function toggleSelector($selector) {
        meerkat.messaging.publish(moduleEvents.triggerBenefitsLoading);
        var group = $selector.attr("data-group");
        var activating = !$selector.hasClass("active");
        $selector.toggleClass("active", activating);
        var position = _.indexOf(activeOptions, group);
        if(activating) {
            if(position === -1) {
                activeOptions.push(group);
            }
        } else if(position !== -1) {
            activeOptions[position] = null;
            activeOptions = _.compact(activeOptions);
        }
        var count = toggleBenefits(group);
        $selector.find(".groupCount").html(activating ? ("&nbsp;(" + count + ")") : "");
        meerkat.modules.benefits.updateModelFromForm();
		// Update hidden field with current quick select options
		$elements.input.val(activeOptions.join(","));
        _.defer(toggleGroupLabels);
        meerkat.messaging.publish(moduleEvents.sortBenefits);
        meerkat.messaging.publish(moduleEvents.updateBenefitCounters);
    }

    function getBenefitsCountForGroup(group) {
        var count = 0;
        for(var i = 0; i < benefitGroups.length; i++){
            if(benefitGroups[i].length > 0 && _.indexOf(benefitGroups[i], group) !== -1) {
                count++;
            }
        }
        return count;
    }

    /**
     * toggleBenefits updates the selected benefits when a quick select option group is toggled.
     * It returns the count of benefits updated so the selector can be udpated.
     *
     * @param group
     * @returns {number}
     */
    function toggleBenefits(group) {
        var count = 0;
        $elements.benefitRows.each(function(index){
            var $row = $(this);
            if(benefitGroups[index].length > 0) {
                // Toggled group must exist current benefit row
                if(_.indexOf(benefitGroups[index], group) !== -1) {
                    count++;
                    // Check benefit related to ANY selected groups
                    var isInASelectedGroup = _.intersection(benefitGroups[index], activeOptions).length > 0;
                    $row.find(":input").prop("checked", isInASelectedGroup).trigger("change.randomEventLabel");
                    $row.toggleClass("active", isInASelectedGroup);
                } else {
                    // Ignore as benefit not related to toggled group
                }
            } else {
                // Ignore as benefit is not related to any groups
            }
        });
        return count;
    }

    /**
     * reverseToggleSelectorsAfterManualBenefitToggle updates the selectors when a user manually toggles benefits.
     *
     * @param obj
     */
    function reverseToggleSelectorsAfterManualBenefitToggle(payload) {
        // Only proceed if benefit is in a group
        if(!_.isEmpty(payload.groups)) {
            if (!payload.checked) {
                // Need to unselect any selected groups applicable to the benefit
                var selectedBenefitGroups = _.intersection(payload.groups, activeOptions);
                if (selectedBenefitGroups.length > 0) {
                    _.each(selectedBenefitGroups, function (group) {
                        var position = _.indexOf(activeOptions, group);
                        if (position !== -1) {
                            activeOptions[position] = null;
                            activeOptions = _.compact(activeOptions);
                            var $option = $elements.options.find("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.removeClass("active").find(".groupCount").html("");
                            }
                        }
                    });
                }
            } else {
                /* This functionality is being removed at business request but am keeping code here just in
                   case they change their mind.

                // Need to select any groups that have all applicable benefits selectedvar nonSelectedBenefitGroups = _.difference(payload.groups, activeOptions);
                if (nonSelectedBenefitGroups.length > 0) {
                    _.each(nonSelectedBenefitGroups, function (group) {
                        var allBenefitsSelected = true;
                        var selectedBenefitCount = 0;
                        $elements.benefitRows.each(function(index){
                            var $row = $(this);
                            // Benefit has to have group or it can be ignored
                            if(benefitGroups[index].length > 0) {
                                // Benefit must be related to the compared group or it can be ignored
                                if(_.indexOf(benefitGroups[index], group) !== -1) {
                                    // Benefit must be checked or it fails the all-selected test
                                    if($row.find(":input").is(":checked")) {
                                        selectedBenefitCount++;
                                    } else {
                                        allBenefitsSelected = false;
                                    }
                                } else {
                                    // Ignore as benefit is not related to comparitor group
                                }
                            }
                        });

                        if (allBenefitsSelected && selectedBenefitCount > 0) {
                            activeOptions.push(group);
                            var $option = $elements.options.find("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.addClass("active").find(".groupCount").html("&nbsp;(" + selectedBenefitCount + ")");
                            }
                        }
                    });
                }*/
            }
			// Update hidden field with current quick select options
			$elements.input.val(activeOptions.join(","));

			_.defer(toggleGroupLabels);
        }
    }

	/**
	 * reverseToggleSelectorsAfterResultsFilterApplied updates the selectors when beneifts are toggled when results filters are applied.
	 */
	function reverseToggleSelectorsAfterResultsFilterApplied() {
    	var activeOptionsPositions = [];
        if(activeOptions.length) {
        	_.each(activeOptions, function(group, index){
            	var $benefitRows = getNonSelectedBenefitRows();
            	_.each($benefitRows, function($row){
					var $rowGroups = $row.attr("data-groups").split(",");
					if(_.indexOf($rowGroups, group) !== -1) {
						$elements.options.find("[data-group=" + group + "]").removeClass("active").find(".groupCount").html("");
						activeOptionsPositions.push(index);
					}
				});
			});

            _.each(activeOptionsPositions, function(position){
				if(position < activeOptions.length) {
					activeOptions[position] = null;
					activeOptions = _.compact(activeOptions);
				}
			});

			// Update hidden field with current quick select options
			$elements.input.val(activeOptions.join(","));

			_.defer(toggleGroupLabels);
        }
    }

    function toggleGroupLabels(removeAll) {
        removeAll = removeAll || false;
        if(removeAll) {
            $elements.benefitRows.find(".benefit-categories .innertube").remove();
        } else {
            // Remove for de-selected benefits
            $elements.benefitRows.find(":input").not(":checked").each(function () {
                $(this).closest(".short-list-item").find(".innertube").remove();
            });
            var nonSelectedBenefitGroups = _.difference(_.keys(options), activeOptions);
            if (nonSelectedBenefitGroups.length > 0) {
                _.each(nonSelectedBenefitGroups, function (group) {
                    $elements.benefitRows.find(".selected-category." + group).remove();
                });
            }
            // Add label for all benefits of selected group
            _.each(activeOptions, function (group) {
                var index = 0;
                _.each(benefitGroups, function (groups) {
                    if (_.indexOf(groups, group) !== -1) {
                        toggleBenefitGroupLabels($elements.benefitRows.eq(index), group, true, true);
                    }
                    index++;
                });
            });
            // Lastly remove any empty label containers
            $elements.benefitRows.find(".benefit-categories .innertube").each(function () {
                var $that = $(this);
                if (!$that.find("span").length) {
                    $that.remove();
                }
            });
        }
    }

    function toggleBenefitGroupLabels($benefit, group, isSelectedGroup, isSelectedBenefit) {
        var $row = $benefit.find(".benefit-categories");
        var $innertube = $row.find(".innertube");
        if(isSelectedBenefit && isSelectedGroup) {
            if(!$row.find("." + group).length) {
                if (!$innertube.length) {
                    $row.append($("<div/>").addClass("innertube"));
                    $innertube = $row.find(".innertube");
                }
                $innertube.append(
                    $("<span/>").addClass("selected-category " + group)
                        .append(options[group])
                );
            }
        } else {
            var $label = $row.find("." + group);
            if($label.length) {
                $label.remove();
                if(!$row.find(".selected-category").length) {
                    $innertube.remove();
                }
            }
        }
    }

    function renderOptions() {
        Object.keys(options).forEach(function(key,index) {
            var option = $("<span/>", {
                title: options[key]
            }).addClass("selectable").attr("data-group", key)
            .append(
                $("<span/>").addClass("groupLabel").append(options[key])
            )
            .append(
                $("<span/>").addClass("groupCount")
            )
            .append(
                $("<span/>").addClass("health-icon icon-health-quickselect-plus")
            );
            if(isXS && _.indexOf(xsHiddenOptions, key) !== -1) {
                option.addClass("hidden");
            }
            $elements.options.append(option);
        });
    }

    function toggleShowHideSelector($toggle) {
        $toggle.addClass("hidden");
        $elements[$toggle.hasClass("more") ? "xsQuickSelectToggleLess" : "xsQuickSelectToggleMore"].removeClass("hidden");
        _.each(xsHiddenOptions, function(key){
            $elements.options.find("[data-group=" + key + "]").toggleClass("hidden", $toggle.hasClass("less"));
        });
    }


    function renderShowHideToggles() {
        var $showMoreRelativeElement = $elements.options.find('[data-group=EAR_NOSE_THROAT]');
        var $showLessRelativeElement = $elements.options.find('[data-group=PREGNANCY_COVER]');

        $showMoreRelativeElement.after(
            $("<span/>", {
                title: "Show more"
            }).addClass("selectable showhide more visible-xs")
            .append(
                $("<span/>").addClass("groupLabel").append("Show more")
            )
            .append(
                $("<span/>").addClass("health-icon icon-health-quickselect-plus")
            )
        );

        $showLessRelativeElement.after(
            $("<span/>", {
                title: "Show less"
            }).addClass("selectable showhide less visible-xs hidden")
            .append(
                $("<span/>").addClass("groupLabel").append("Show less")
            )
            .append(
                $("<span/>").addClass("health-icon icon-health-quickselect-plus")
            )
        );
    }

    function resetQuickSelects() {
		activeOptions = [];
        $elements.options.children().each(function(){
            var $that = $(this);
            $that.removeClass('active');
            $that.find('.groupCount').empty();
        });
    }

    function getNonSelectedBenefitRows() {
    	var $nonSelectedRows = [];
    	_.each($elements.benefitRows, function(row){
    		var rowGroupsStr = $(row).attr("data-groups");
    		var isSelected = $(row).hasClass("active");
    		if(!_.isEmpty(rowGroupsStr)) {
    			var rowGroups = rowGroupsStr.split(",");
    			if(rowGroups.length && !isSelected) {
					$nonSelectedRows.push($(row));
				}
			}
		});
    	return $nonSelectedRows;
	}

    meerkat.modules.register('healthBenefitsQuickSelectHospital', {
        init: init,
        events: moduleEvents,
        resetQuickSelects: resetQuickSelects
    });

})(jQuery);