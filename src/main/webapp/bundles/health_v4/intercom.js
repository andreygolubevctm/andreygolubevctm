/**
 * Description: Health Intercom setup
 */

    var intercomElement = this.createIntercomElement();

    var journeyEngineSlidesContainer = document.getElementById('journeyEngineSlidesContainer')

    var healthInsurance =  document.getElementsByClassName('health-insurance').item(0);

    var hasElement = false;

    if(journeyEngineSlidesContainer) {
        hasElement = true;
        journeyEngineSlidesContainer.appendChild(intercomElement);
    }else if(healthInsurance) {
        hasElement = true;
        healthInsurance.appendChild(intercomElement);
    }

    if (window.Intercom && hasElement) {
        window.intercomSettings = {
            app_id: 'd29h2i1h',
            custom_launcher_selector: '.intercom-launcher',
            hide_default_launcher: true
        };

        window.Intercom('update');

        // Register callbacks
        window.Intercom('onShow', function () {
                var launcher = document.querySelector('.intercom-launcher');
                launcher.classList.add('intercom-open');
            }
        );

        window.Intercom('onHide', function () {
                var launcher = document.querySelector('.intercom-launcher');
                launcher.classList.remove('intercom-open');
            }
        );

        window.Intercom('onUnreadCountChange', function (count) {
            var launcher = document.querySelector('.intercom-launcher');
            var unreadCount = launcher.querySelector('.intercom-unread-count');

            unreadCount.textContent = count;
            if (count) {
                unreadCount.classList.add('active');
            } else {
                unreadCount.classList.remove('active');
            }
        });

        // Wait for Intercom to boot (max 30 seconds)
        var timeout = setTimeout(function () {
            clearInterval(interval);
        }, 30000);
        var interval = setInterval(function () {
            var launcher = document.querySelector('.intercom-launcher');

            if (window.Intercom.booted) {
                // Add class to show the launcher
                launcher.classList.add('intercom-booted');

                clearInterval(interval);
                clearTimeout(timeout);
            }
        }, 100);
    }

    function createIntercomElement() {
        var intercomElement = document.createElement('a');
        intercomElement.className = 'intercom-launcher';
        intercomElement.id = 'intercom-element';
        intercomElement.href = 'mailto:d29h2i1h@incoming.intercom.io';

        var intercomElementHtml = '<div class="intercom-icon-close"></div>\n' +
            '<div class="intercom-icon-open"></div>\n' +
            '<span class="intercom-unread-count"></span>\n';

        intercomElement.innerHTML = intercomElementHtml;

        return intercomElement;
    }