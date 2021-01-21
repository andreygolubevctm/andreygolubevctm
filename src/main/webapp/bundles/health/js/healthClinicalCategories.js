;(function ($, undefined) {

    var meerkat = window.meerkat,
        activeGroups = [],
        benefitGroups = [],
        $elements,
		ctmBenefits = {
			AssistedReproductive : "Assisted reproduction",
			BackSurgery : "Back surgery",
			BoneMuscleJointRecon : "Bone, muscle and joint reconstruction",
			Cancer : "Cancer",
			DentalSurgery : "Dental surgery in hospital",
			RenalDialysis : "Dialysis",
			ENT : "Ear nose & throat",
			Cardiac : "Heart and vascular",
			HerniaAppendix : "Hernia & appendix",
			Psychiatric : "In hospital psychiatry",
			Rehabilitation : "In hospital rehabilitation",
			JointReplacement : "Joint replacements",
			CataractEyeLens : "Major eye surgery",
			PlasticNonCosmetic : "Medically necessary plastic and reconstructive surgery",
			PainManagementNoDevice : "Pain management (without device)",
			Palliative : "Palliative care",
			Obstetric : "Pregnancy",
			GastricBanding : "Weight loss surgery"
		};

    function init() {
        $(document).ready(function() {
            $elements = {
                toggle: $('#clinicalCategoriesToggle'),
                container: $('#clinicalCategoriesContent'),
                inputs: $('#benefitsForm .Hospital_container').find(":input").filter("[data-type=hospital]"),
                benefitRows: $('#clinicalCategoriesContent').find('.short-list-item'),
                toggles: $('#benefitsForm').find('.benefit-label-container'),
                hospital: $('#benefits-list-hospital')
            };

            setupActiveGroups();
            setupBenefitGroups();

            eventListeners();

            $elements.inputs.each(function(){
                var $that = $(this);
                if($that.is(":checked")) {
                    $that.change();
                }
            });

            _.defer(sort);
        });
    }

    function eventListeners(){
        $elements.toggle.on("click.toggleClinicalCategories", function(){
            var $that = $(this);
            var active = $that.hasClass("active");
            if(active) {
                hide();
            } else {
                show();
            }
        });
        $elements.toggles.each(function(){
            var $this = $(this);
            var $btn = $this.find('.benefit-toggle a');
            if(!$btn.hasClass('hidden')) {
                var $copy = $this.find('.benefit-description');
                $btn.on("click.toggle", function () {
                    var isToggled = $copy.is(':visible');
                    $(this).toggleClass('toggled', !isToggled);
                    $copy[isToggled ? 'removeClass' : 'addClass']('in', {duration:200});
                });
            }
        });
        $elements.inputs.each(function(){
            var $that = $(this);
            $that.on("change", function(){
                var $that = $(this);
                _.defer(function(){
                    toggleSelector($that);
                });
            });
        });
        $elements.benefitRows.on('click.manualBenefitSelection', function(){
            var $row = $(this);
            var groupsStr = $row.attr("data-groups");
            if(!_.isUndefined(groupsStr)) {
                var groups = groupsStr.split(",");
                _.defer(function () {
                    var $input = $row.find(":input");
                    var checked = $input.is(":checked");
                    $row.toggleClass("active", checked);
                    $input.prop('manually-selected', checked);
                    if(!_.isEmpty(groupsStr) && !_.isEmpty(groups)) {
                        reverseToggleSelectors({row: $row, groups: groups, checked: checked});
                        _.defer(toggleCTMBenefitLabels);
                    }
                });
            }
        });
    }

    function hide(includeToggle) {
        includeToggle = includeToggle || false;
        $elements.container.slideUp("fast", function(){
            if(includeToggle) {
                $elements.toggle.slideUp("fast", function(){
                    $elements.toggle.removeClass("active");
                });
            } else {
                $elements.toggle.removeClass("active");
            }
        });
    }

    function show(justToggle) {
        justToggle = justToggle || false;
        if(justToggle) {
            $elements.toggle.slideDown("fast");
        } else {
            $elements.toggle.addClass("active");
            $elements.container.slideDown("fast");
        }
    }

    function setupActiveGroups() {
        $elements.inputs.each(function() {
            var $that = $(this);
            var isChecked = $that.is(":checked");
            if(isChecked) {
                activeGroups.push($that.attr("data-group"));
            }
        });
    }

    function setupBenefitGroups() {
        benefitGroups = [];
        $elements.benefitRows.each(function(){
            var $row = $(this);
            var groups = [];
            var groupsStr = $row.attr("data-groups");
            if(!_.isUndefined(groupsStr) && !_.isEmpty(groupsStr)) {
                groups = groupsStr.split(",");
            }
            benefitGroups.push(groups);
        });
    }

    function toggleSelector($selector) {
        var group = $selector.attr("data-group");
        if(!_.isUndefined(group) && !_.isEmpty(group)) {
            var position = _.indexOf(activeGroups, group);
            if ($selector.is(":checked")) {
                if (position === -1) {
                    activeGroups.push(group);
                }
            } else if (position !== -1) {
                activeGroups[position] = null;
                activeGroups = _.compact(activeGroups);
            }
            toggleBenefits(group);
        }
    }

    /**
     * toggleBenefits updates the selected benefits when a quick select option group is toggled.
     *
     * @param group
     */
    function toggleBenefits(group) {
        $elements.benefitRows.each(function(index){
            var $row = $(this);
            if(benefitGroups[index].length > 0) {
                // Toggled group must exist current benefit row
                if(_.indexOf(benefitGroups[index], group) !== -1) {
                    // Check benefit related to ANY selected groups
                    var isInASelectedGroup = _.intersection(benefitGroups[index], activeGroups).length > 0;
                    var $input = $row.find(":input");
                    var manuallySelectedProp = $input.prop("manually-selected");
                    var manuallySelected = !_.isUndefined(manuallySelectedProp) && manuallySelectedProp !== false;
                    var isActive = manuallySelected || isInASelectedGroup;
                    $input.prop("checked", isActive).change();
                    $row.toggleClass("active", isActive);
                    if(isActive) {
                    	show();
                    }

                } else {
                    // Ignore as benefit not related to toggled group
                }
            } else {
                // Ignore as benefit is not related to any groups
            }
        });
        _.defer(function(){
        	sort();
        	_.defer(toggleCTMBenefitLabels);
		});

    }

    /**
     * reverseToggleSelectors updates the selectors when a user manually toggles benefits.
     *
     * @param obj
     */
    function reverseToggleSelectors(payload) {
        // Only proceed if benefit is in a group
        if(!_.isEmpty(payload.groups)) {
            if (!payload.checked) {
            	// Need to unselect any selected groups applicable to the benefit
                var selectedBenefitGroups = _.intersection(payload.groups, activeGroups);
                if (selectedBenefitGroups.length > 0) {
                    _.each(selectedBenefitGroups, function (group) {
                        var position = _.indexOf(activeGroups, group);
                        if (position !== -1) {
                            activeGroups[position] = null;
                            activeGroups = _.compact(activeGroups);
                            var $option = $elements.inputs.filter("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.prop("checked", false).trigger("change.randomChangeEvent");
                            }
                        }
                    });
                }
            } else {
				// Need to select any groups that have all applicable benefits selected
                var nonSelectedBenefitGroups = _.difference(payload.groups, activeGroups);
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
                            activeGroups.push(group);
                            var $option = $elements.inputs.filter("[data-group=" + group + "]");
                            if ($option.length) {
                                $option.prop("checked", true).trigger("change.randomChangeEvent");
                            }
                        }
                    });
                }
            }
        }
    }

	function sort() {
		var $sortables = {
			checked: [],
			unchecked: []
		};
		// 1 detach each element and put into sortable obj
		$elements.hospital.find(".short-list-item").each(function(){
			var $row = $(this);
			var term = $row.hasClass("active") ? "checked" : "unchecked";
			var data = {
				sortKey: $row.attr("data-sortable-key"),
				element: $row.detach()
			};
			$sortables[term].push(data);
		});
		// 2 sort each array by benefit name
		var keys = _.keys($sortables);
		for(var k=0; k < keys.length; k++) {
			var key = keys[k];
			$sortables[key] = _.sortBy($sortables[key], 'sortKey');
		}
		// 3 Add items back into form in reverse order
		var sortablesOrder = ["checked","unchecked"];
		_.each(sortablesOrder, function(key){
			_.each($sortables[key], function(row) {
				$elements.hospital.append(row.element);
			});
		});
	}

    function setAccidentOnlyCover(active) {
        active = active || false;
        if(active) {
            hide(true);
            $elements.benefitRows.filter(".active").each(function(){
                var $that = $(this);
                $that.removeClass("active");
                $that.find(":input").prop("checked", false).trigger("change.randomChangeEvent");
            });
        } else {
            show(true);
        }
    }

	function toggleCTMBenefitLabels(removeAll) {
		removeAll = removeAll || false;
		if(removeAll) {
			$elements.benefitRows.find(".benefit-categories .innertube").remove();
		} else {
			// Remove for de-selected benefits
			$elements.benefitRows.find(":input").not(":checked").each(function () {
				$(this).closest(".short-list-item").find(".innertube").remove();
			});
			var nonSelectedBenefitGroups = _.difference(_.keys(ctmBenefits), activeGroups);
			if (nonSelectedBenefitGroups.length > 0) {
				_.each(nonSelectedBenefitGroups, function (group) {
					$elements.benefitRows.find(".selected-category." + group).remove();
				});
			}
			// Add label for all benefits of selected group
			_.each(activeGroups, function (group) {
				var index = 0;
				_.each(benefitGroups, function (bGroups) {
					if (_.indexOf(bGroups, group) !== -1) {
						toggleCTMBenefitGroupLabels($elements.benefitRows.eq(index), group, true, true);
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

	function toggleCTMBenefitGroupLabels($benefit, group, isSelectedGroup, isSelectedBenefit) {
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
					.append(ctmBenefits[group])
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

    meerkat.modules.register('healthClinicalCategories', {
        init: init,
        setAccidentOnlyCover: setAccidentOnlyCover
    });

})(jQuery);