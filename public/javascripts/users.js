

var emailRegex = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i;

function updateUserNav() {
    $(".navbar-user").detach();

    function renderPullRight(id, text, onclick) {
        $("#navbar-right").append(
            '<ul class="nav navbar-nav pull-right navbar-user">\
                 <li><a id="'+id+'" style="cursor:pointer">'+text+'</a></li>\
             </ul>');
        $("a#" + id).on('click', onclick);
    }

    if (user) {
        renderPullRight("log-out", "Log Out", function() {
            $.ajax({url: "/logout", type: "PUT"}).done(function() {console.log("Logged out");});
            window.user = null;
            updateUserNav();
        });

        var name = user.name ? user.name.nickname || user.name.first : "User";
        renderPullRight("go-to-profile", name, function() {
            console.log("go to profile!");
        });
    } else {
        renderPullRight("log-in", "Log In", function() {
            $("#log-in-window").dialog("open");
        });
        renderPullRight("sign-up", "Sign Up", function() {
            console.log("Sign up!");
        });
    }
}

function setupLogInWindow() {
    function updateValidate(text) {
        $(".validate").text(text).addClass("ui-state-highlight");
        setTimeout(function() { 
            $(".validate").removeClass('ui-state-highlight', 1000); 
        }, 500);
    }

    var logInWindow = $("#log-in-window");
    logInWindow.dialog({
        autoOpen: false,
        height: 260,
        width: 320,
        modal: true,
        resizable: false,
        buttons: {
            "Log In": function () {
                var email = $("#email").val();
                var password = $("#password").val();

                if (!emailRegex.test(email)) {
                    updateValidate("Please enter a valid email");
                } else {
                    $.ajax({
                        url: "/login/local", 
                        type: "POST",
                        data: { email: email, password: password}
                    }).fail(function () {
                        updateValidate("Could not log in. Please try again.");
                    }).done(function (res, other) {
                        if (res.success) {
                            window.user = res.user;
                            updateUserNav();
                            logInWindow.dialog("close");
                        } else {
                            updateValidate(res.error);
                        }
                    });
                }
            },
            "Cancel": function () { logInWindow.dialog("close") }
        },
        close: function () {
            $("#email").val("");
            $("#password").val("");
        }
    });
}

$(function() {
    console.log("Hello world!");
    updateUserNav();
    setupLogInWindow();
});