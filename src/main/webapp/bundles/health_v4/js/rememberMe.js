;(function ($) {

    var meerkat = window.meerkat;

    initPage();

    function initPage() {
        validateDob();
        deleteCookieAndRedirect();
    }

    function deleteCookieAndRedirect() {
        $('.remember-me-remove').click(function () {
            event.preventDefault();

            meerkat.modules.comms.post({
                url: 'spring/rest/rememberme/quote/new.json',
                data: {
                    quoteType: 'health'
                },
                dataType: 'json',
                cache: true,
                errorLevel: "silent",
                onSuccess: function onSuccess() {
                    window.location.replace("/ctm/health_quote_v4.jsp");
                },
                onError: function onError(obj, txt, errorThrown) {
                    console.log(obj, errorThrown);
                }
            });
        });
    }

    function validateDob() {
        // meerkat.modules.comms.post({
        //     url: 'spring/rest/rememberme/quote/new.json',
        //     data: {
        //         quoteType: 'health'
        //     },
        //     dataType: 'json',
        //     cache: true,
        //     errorLevel: "silent",
        //     onSuccess: function onSuccess(json) {
        //         console.log('yes!');
        //     },
        //     onError: function onError(obj, txt, errorThrown) {
        //         console.log(obj, errorThrown);
        //     }
        // });

        $('#rememberMeSubmit').click(function () {
            event.preventDefault();

            var d = $('#healthInputD').val();
            var m = $('#healthInputM').val();
            var y = $('#healthInputY').val();

            if(d !== "" && m !== "" && y !== ""){
                var dob = d + "/" + m + "/" + y;
                var data = {
                    quoteType: 'health',
                    userAnswer: dob
                };
                console.log(data);

                meerkat.modules.comms.get({
                    url: 'spring/rest/rememberme/quote/get.json',
                    data: data,
                    cache: true,
                    errorLevel: "silent",
                    onSuccess: function onSuccess(json) {
                        console.log('yes!');
                    },
                    onError: function onError(obj, txt, errorThrown) {
                        console.log(obj, errorThrown);
                    }
                });
            } else{

            }
        });
    }

    meerkat.modules.register('rememberMe', {
        initPage: initPage
    });

})(jQuery);