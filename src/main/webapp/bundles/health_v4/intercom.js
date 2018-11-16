/**
 * Description: Health Intercom setup
 */

/*library*/
(function(){var w=window;var ic=w.Intercom;if(typeof ic==="function"){ic('reattach_activator');ic('update',intercomSettings);}else{var d=document;var i=function(){i.c(arguments)};i.q=[];i.c=function(args){i.q.push(args)};w.Intercom=i;function l(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/d29h2i1h';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s,x);}if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})()

    /*launch widget*/
    window.Intercom("boot", {
        app_id: "d29h2i1h"
    });

    /*get last page*/

    window.intercomSettings = {
        "Last_Page_Viewed":"{{get path with fragment}}"
    }
    window.Intercom('update');

    var intercomElement = createIntercomElement();
    injectCss();
    document.body.appendChild(intercomElement);

    window.intercomSettings = {
        custom_launcher_selector: '#intercom-element',
        hide_default_launcher: true
    }
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
            unreadCount.classList.add('intercom-active');
        } else {
            unreadCount.classList.remove('intercom-active');
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

    function createIntercomElement() {
        var intercomElement = document.createElement('a');
        intercomElement.className = 'intercom-launcher';
        intercomElement.id = 'intercom-element';
        intercomElement.href = 'mailto:d29h2i1h@incoming.intercom.io';

        var intercomElementHtml = '<div class="intercom-icon-close"></div>' +
            '<div class="intercom-icon-open"></div>' +
            '<span class="intercom-unread-count"></span>';

        intercomElement.innerHTML = intercomElementHtml;

        return intercomElement;
    }

    function injectCss() {
        var rules =
            '.intercom-launcher {' +
            'backface-visibility: hidden;' +
            'background: #004890;' +
            'border-radius: 50%;' +
            'bottom: 20px;' +
            'box-shadow: 0 1px 6px rgba(0, 0, 0, 0.06),' +
            '0 2px 32px rgba(0, 0, 0, 0.16);' +
            'cursor: pointer;' +
            'font-family: Helvetica, Arial, sans-serif;' +
            'height: 0;' +
            'opacity: 0;' +
            'outline: 0;' +
            'position: fixed;' +
            'right: 20px;' +
            'transform: scale(0.5);' +
            'transform-origin: center;' +
            'transition: opacity 0.25s ease,' +
            'transform 0.25s ease;' +
            'width: 0;' +
            'z-index: 2147483000;' +
            '}' +
            '.intercom-booted {' +
            'height: 60px;' +
            'opacity: 1;' +
            'transform: scale(1);' +
            'width: 60px;' +
            '}' +
            '.intercom-unread-count {' +
            'backface-visibility: hidden;' +
            'background: #fc576b;' +
            'border-radius: 20px / 2;' +
            'box-shadow: 0 1px 0 rgba(0, 0, 0, 0.15);' +
            'box-sizing: border-box;' +
            'color: #fff;' +
            'font-size: 20px * 0.6;' +
            'height: 20px;' +
            'line-height: 20px;' +
            'min-width: 20px;' +
            'opacity: 0;' +
            'padding: 0 4px;' +
            'position: absolute;' +
            'right: -2px;' +
            'text-align: center;' +
            'top: -2px;' +
            'transform: scale(0.5);' +
            'transform-origin: center;' +
            'transition: opacity 0.15s ease,' +
            'transform 0.15s ease;' +
            '}' +
            '.intercom-active {' +
            'opacity: 1;' +
            'transform: scale(1);' +
            '}' +
            '.intercom-icon-open,' +
            '.intercom-icon-close {' +
            'background-position: 50%;' +
            'background-repeat: no-repeat;' +
            'border-radius: 50%;' +
            'bottom: 0;' +
            'position: absolute;' +
            'top: 0;' +
            'transition: transform 0.16s linear,' +
            'opacity 0.08s linear;' +
            'width: 100%;' +
            '}' +
            '.intercom-icon-open {' +
            'background-image: url(\'data:image/svg+xml;charset=UTF-8,<svg fill="#FFFFFF" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0px" y="0px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve"><path d="M59.7,3.7c-21,0-38,14.9-38,33.4s17,33.4,38,33.4c7.6,0,14.7-2,20.7-5.4c5.4,3.2,11.2,3.1,14.5,2.6c1-0.1,1.2-1.4,0.4-1.9  c-3.3-2.1-5-5.1-6-7.8c5.3-5.7,8.5-13,8.5-21C97.8,18.6,80.7,3.7,59.7,3.7z M62.3,50.5c0,0.8-0.7,1.5-1.5,1.5h-3.8  c-0.8,0-1.5-0.7-1.5-1.5V48c0-0.8,0.7-1.5,1.5-1.5h3.8c0.8,0,1.5,0.7,1.5,1.5V50.5z M68.4,35.7c-1,1.4-2.3,2.5-3.9,3.4  c-0.9,0.6-1.5,1.2-1.8,1.8c-0.2,0.5-0.4,1-0.4,1.7c0,0.5-0.5,0.9-1.1,0.9h-4.7c-0.6,0-1.1-0.5-1.1-1.1c0.1-1.3,0.4-2.4,1-3.1  c0.7-0.9,1.9-2,3.6-3.3c0.9-0.6,1.6-1.3,2.1-2.1c0.5-0.8,0.8-1.8,0.8-2.9c0-1.1-0.3-2-0.9-2.7c-0.6-0.7-1.5-1-2.6-1  c-0.9,0-1.7,0.3-2.3,0.8c-0.4,0.3-0.6,0.8-0.8,1.4c-0.2,0.7-0.8,1.1-1.5,1.1l-4.4-0.1c-0.5,0-1-0.5-0.9-1c0.2-2.3,1.1-4.1,2.7-5.4  c1.8-1.4,4.3-2.1,7.3-2.1c3.2,0,5.8,0.8,7.6,2.4c1.8,1.6,2.8,3.8,2.8,6.6C69.9,32.7,69.4,34.3,68.4,35.7z M9.3,86  c-4.4-4.8-7-10.8-7-17.4c0-9.5,5.5-18,13.9-23C20.5,63.5,38.4,77,59.7,77c1.5,0,3-0.1,4.4-0.2c-4,11.3-16,19.6-30.3,19.6  c-6.3,0-12.2-1.6-17.2-4.5c-4.5,2.7-9.3,2.6-12.1,2.2c-0.8-0.1-1-1.1-0.3-1.6C7,90.7,8.5,88.2,9.3,86z"></path></svg>\');' +
            'background-position: 50% 50%;' +
            'background-size: 54% 60%;' +
            'opacity: 1;' +
            'transform: rotate(0deg) scale(1);' +
            '}' +
            '.intercom-open {' +
            'opacity: 0;' +
            'transform: rotate(30deg) scale(0);' +
            '}' +
            '.intercom-icon-close {' +
            'background-image: url(\'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcBAMAAACAI8KnAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAIVBMVEUAAAD///////////////////////////////////8AAADPn83rAAAACXRSTlMACq47u/I8r7wWzHxoAAAAAWJLR0QAiAUdSAAAAAlwSFlzAAALEgAACxIB0t1+/AAAAJJJREFUGNNdzzEKhDAQBdAvwtYWW9hbbSdCDrBnWBDS2Sx7A8HSKwgic1tNxj/jmirDC5P/UTSw01V4ri2nMr7xkg/HIAu+Qi6j9HhEcpB1gHFGGCuSTyQTlQ2Vg3ic4x49TVpzwcQXvI+3x/+r0p9eLAfyYhrIWNOSmfZkVlH2Kpm9Z+bJeh68oSYmnlGMnv1X7RZ2SET5id+LAAAAAElFTkSuQmCC\');' +
            'background-size: 25%;' +
            'opacity: 0;' +
            'transform: rotate(-30deg);' +
            '}' +
            '.intercom-open {' +
            'opacity: 1;' +
            'transform: rotate(0deg);' +
            '}';


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
