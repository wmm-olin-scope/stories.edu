mandrill = require('mandrill-api')
mandrill_client = new mandrill.Mandrill(process.env.MANDRILL_KEY)

exports.send_email = (req, res) ->
    template_name = "schools-email"
    template_content = []
    message =
        subject: ""
        from_email: "hello@thank-a-teacher.org"
        from_name: "Thank A Teacher"
        to: [
            email: req.body.SchoolEmail
            name: req.body.SchoolName
            type: "to"
        ]
        headers:
            "Reply-To": "hello@thank-a-teacher.org"

        important: false
        track_opens: null
        track_clicks: null
        auto_text: null
        auto_html: null
        inline_css: null
        url_strip_qs: null
        preserve_recipients: null
        view_content_link: null
        bcc_address: "hello@thank-a-teacher.org"
        tracking_domain: null
        signing_domain: null
        return_path_domain: null
        merge: true
        global_merge_vars: [
            {
                name: "SchoolName"
                content: "your school"
            },
            {
                name: "TeacherName"
                content: "a teacher at your school"
            },
            {
                name: "Message"
                content: ""
            },
            {
                name: "UserName"
                content: "A Student"
            },
            {
                name: "City"
                content: ""
            },
            {
                name: "State"
                content: ""
            }

        ]
        merge_vars: [
            rcpt: req.body.SchoolEmail
            vars: [
                {
                    name: "SchoolName"
                    content: req.body.SchoolName
                },
                {
                    name: "TeacherName"
                    content: req.body.TeacherName
                },
                {
                    name: "Message"
                    content: req.body.Message
                },
                {
                    name: "UserName"
                    content: req.body.UserName
                },
                {
                    name: "City"
                    content: req.body.City
                },
                {
                    name: "State"
                    content: req.body.State
                }
            ]
        ]
        google_analytics_domains: ["http://thank-a-teacher.org"]
        google_analytics_campaign: "hello@thank-a-teacher.org"
        metadata:
            website: "www.thank-a-teacher.org"
    async = false

    mandrill_client.messages.sendTemplate
        template_name: template_name
        template_content: template_content
        message: message
        async: async
    , ((result) ->
        console.log result
        return
    ), (e) ->
        console.log "A mandrill error occurred: " + e.name + " - " + e.message
        return
