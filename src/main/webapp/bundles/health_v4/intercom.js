/**
 * Description: Health Intercom setup
 */

    var intercomElement = this.createIntercomElement();

    var journeyEngineSlidesContainer = document.getElementById('journeyEngineSlidesContainer')

    var healthInsurance =  document.getElementsByClassName('health-insurance').item(0);

    var hasElement = false;

    if(journeyEngineSlidesContainer) {
        hasElement = true;
        this.injectCss();
        journeyEngineSlidesContainer.appendChild(intercomElement);
    }else if(healthInsurance) {
        hasElement = true;
        this.injectCss();
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

    function injectCss() {
        var rules = '\n' +
            '.intercom-launcher {\n' +
            '    backface-visibility: hidden;\n' +
            '    background: #004890;\n' +
            '    border-radius: 50%;\n' +
            '    bottom: 20px;\n' +
            '    box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06),\n' +
            '    0 2px 32px rgba(0, 0, 0, 0.16);\n' +
            '    cursor: pointer;\n' +
            '    font-family: Helvetica, Arial, sans-serif;\n' +
            '    height: 0;\n' +
            '    opacity: 0;\n' +
            '    outline: 0;\n' +
            '    position: fixed;\n' +
            '    right: 20px;\n' +
            '    transform: scale(0.5);\n' +
            '    transform-origin: center;\n' +
            '    transition: opacity 0.25s ease,\n' +
            '    transform 0.25s ease;\n' +
            '    width: 0;\n' +
            '    z-index: 2147483000;\n' +
            '}\n' +
            '\n' +
            '    &:focus {\n' +
            '        outline: 0;\n' +
            '    }\n' +
            '\n' +
            '    .intercom-booted {\n' +
            '        height: 60px;\n' +
            '        opacity: 1;\n' +
            '        transform: scale(1);\n' +
            '        width: 60px;\n' +
            '    }\n' +
            '\n' +
            '.intercom-unread-count {\n' +
            '    backface-visibility: hidden;\n' +
            '    background: #fc576b;\n' +
            '    border-radius: 20px / 2;\n' +
            '    box-shadow: 0 1px 0 rgba(0, 0, 0, 0.15);\n' +
            '    box-sizing: border-box;\n' +
            '    color: #fff;\n' +
            '    font-size: 20px * 0.6;\n' +
            '    height: 20px;\n' +
            '    line-height: 20px;\n' +
            '    min-width: 20px;\n' +
            '    opacity: 0;\n' +
            '    padding: 0 4px;\n' +
            '    position: absolute;\n' +
            '    right: -2px;\n' +
            '    text-align: center;\n' +
            '    top: -2px;\n' +
            '    transform: scale(0.5);\n' +
            '    transform-origin: center;\n' +
            '    transition: opacity 0.15s ease,\n' +
            '    transform 0.15s ease;\n' +
            '}\n' +
            '\n' +
            '    .active {\n' +
            '        opacity: 1;\n' +
            '        transform: scale(1);\n' +
            '    }\n' +
            '\n' +
            '.intercom-icon-open,\n' +
            '.intercom-icon-close {\n' +
            '    background-position: 50%;\n' +
            '    background-repeat: no-repeat;\n' +
            '    border-radius: 50%;\n' +
            '    bottom: 0;\n' +
            '    position: absolute;\n' +
            '    top: 0;\n' +
            '    transition: transform 0.16s linear,\n' +
            '    opacity 0.08s linear;\n' +
            '    width: 100%;\n' +
            '}\n' +
            '\n' +
            '.intercom-icon-open {\n' +
            '    background-image: url(\'data:image/svg+xml;charset=UTF-8,<svg fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0px" y="0px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve"><path d="M59.7,3.7c-21,0-38,14.9-38,33.4s17,33.4,38,33.4c7.6,0,14.7-2,20.7-5.4c5.4,3.2,11.2,3.1,14.5,2.6c1-0.1,1.2-1.4,0.4-1.9  c-3.3-2.1-5-5.1-6-7.8c5.3-5.7,8.5-13,8.5-21C97.8,18.6,80.7,3.7,59.7,3.7z M62.3,50.5c0,0.8-0.7,1.5-1.5,1.5h-3.8  c-0.8,0-1.5-0.7-1.5-1.5V48c0-0.8,0.7-1.5,1.5-1.5h3.8c0.8,0,1.5,0.7,1.5,1.5V50.5z M68.4,35.7c-1,1.4-2.3,2.5-3.9,3.4  c-0.9,0.6-1.5,1.2-1.8,1.8c-0.2,0.5-0.4,1-0.4,1.7c0,0.5-0.5,0.9-1.1,0.9h-4.7c-0.6,0-1.1-0.5-1.1-1.1c0.1-1.3,0.4-2.4,1-3.1  c0.7-0.9,1.9-2,3.6-3.3c0.9-0.6,1.6-1.3,2.1-2.1c0.5-0.8,0.8-1.8,0.8-2.9c0-1.1-0.3-2-0.9-2.7c-0.6-0.7-1.5-1-2.6-1  c-0.9,0-1.7,0.3-2.3,0.8c-0.4,0.3-0.6,0.8-0.8,1.4c-0.2,0.7-0.8,1.1-1.5,1.1l-4.4-0.1c-0.5,0-1-0.5-0.9-1c0.2-2.3,1.1-4.1,2.7-5.4  c1.8-1.4,4.3-2.1,7.3-2.1c3.2,0,5.8,0.8,7.6,2.4c1.8,1.6,2.8,3.8,2.8,6.6C69.9,32.7,69.4,34.3,68.4,35.7z M9.3,86  c-4.4-4.8-7-10.8-7-17.4c0-9.5,5.5-18,13.9-23C20.5,63.5,38.4,77,59.7,77c1.5,0,3-0.1,4.4-0.2c-4,11.3-16,19.6-30.3,19.6  c-6.3,0-12.2-1.6-17.2-4.5c-4.5,2.7-9.3,2.6-12.1,2.2c-0.8-0.1-1-1.1-0.3-1.6C7,90.7,8.5,88.2,9.3,86z"></path></svg>\');\n' +
            '    background-position: 50% 50%;\n' +
            '    background-size: 54% 60%;\n' +
            '    opacity: 1;\n' +
            '    transform: rotate(0deg) scale(1);\n' +
            '}\n' +
            '    .intercom-open {\n' +
            '        opacity: 0;\n' +
            '        transform: rotate(30deg) scale(0);\n' +
            '    }\n' +
            '\n' +
            '.intercom-icon-close {\n' +
            '    background-image: url(\'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcBAMAAACAI8KnAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAIVBMVEUAAAD///////////////////////////////////8AAADPn83rAAAACXRSTlMACq47u/I8r7wWzHxoAAAAAWJLR0QAiAUdSAAAAAlwSFlzAAALEgAACxIB0t1+/AAAAJJJREFUGNNdzzEKhDAQBdAvwtYWW9hbbSdCDrBnWBDS2Sx7A8HSKwgic1tNxj/jmirDC5P/UTSw01V4ri2nMr7xkg/HIAu+Qi6j9HhEcpB1gHFGGCuSTyQTlQ2Vg3ic4x49TVpzwcQXvI+3x/+r0p9eLAfyYhrIWNOSmfZkVlH2Kpm9Z+bJeh68oSYmnlGMnv1X7RZ2SET5id+LAAAAAElFTkSuQmCC\');\n' +
            '    background-size: 25%;\n' +
            '    opacity: 0;\n' +
            '    transform: rotate(-30deg);\n' +
            '}' +
            '\n' +
            '    .intercom-open {\n' +
            '        opacity: 1;\n' +
            '        transform: rotate(0deg);\n' +
            '    }\n';


        var css = document.createElement('style');
        css.type = 'text/css';
        if (css.styleSheet) {
            css.styleSheet.cssText = rules; // Support for IE
        }
        else {
            css.appendChild(document.createTextNode(rules));  // Support for the rest
        }
        document.getElementsByTagName("head")[0].appendChild(css);
    }