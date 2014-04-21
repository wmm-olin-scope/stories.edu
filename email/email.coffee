mandrill = require('mandrill-api')
mandrill_client = new mandrill.Mandrill(process.env.MANDRILL_KEY)
template_name = "test-email"
template_content = [
    # name: "example name"
    # content: "example content"
]
message =
    # html: "<p>Example HTML content</p>"
    # text: "Example text content"
    subject: ""
    from_email: "hello@thank-a-teacher.org"
    from_name: "Thank A Teacher"
    to: [
        email: "jules.nazare@gmail.com"
        name: "Juliana Nazare"
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
        name: "NAME"
        content: "merge1 content"
    ]
    merge_vars: [
        rcpt: "jules.nazare@gmail.com"
        vars: [
            name: "NAME"
            content: "merge2 content"
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
