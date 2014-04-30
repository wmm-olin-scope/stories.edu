mongoose = require 'mongoose'
Q = require 'q'
_ = require 'underscore'

db = require '../data/db'
{PublicSchool, PrivateSchool} = require '../data/schools'
{Postcard} = require '../data/postcards'

{Mandrill} = require 'mandrill-api'
mandrill = new Mandrill process.env.MANDRILL_APIKEY

DEBUG_EMAIL = 'chase.kernan@gmail.com'

exports.sendAllUnprocessedPostcards = ->
    query = Postcard.find({processed: no})
    db.batchStream query, 2, (postcards) ->
        console.log "Sending #{postcards.length} postcards"
        Q.all (sendPostcard postcard for postcard in postcards)
    
sendPostcard = (postcard) ->
    postcard.getSchool()
    .then (school) ->
        console.log {school}
        schoolEmail = school?.email
        return Q() unless schoolEmail

        sendEmail {postcard, school, schoolEmail}
        .then -> markProcessed postcard

sendEmail = ({postcard, school, schoolEmail}) ->
    Q.all [sendEmailToSchool schoolEmail, postcard, school
           sendEmailToThanker postcard.email, postcard, school]

sendEmailToSchool = (email, postcard, school) ->
    console.log "Email to school: #{email}"
    email = DEBUG_EMAIL
    subject = 'Someone just thanked a teacher at your school'
    fullUrl = "http://thank-a-teacher.org/thank-you/#{postcard._id}"

    sendTemplateEmail
        template_name: 'Note to Principal'
        message:
            subject: subject
            to: [
                email: email
                name: capitalize(school.principal or school.name) or ''
                type: 'to'
            ]
            global_merge_vars: [
                {name: 'SchoolName', content: capitalize school.name}
                {name: 'TeacherName', content: postcard.teacher}
                {name: 'Message', content: postcard.note}
                {name: 'StudentName', content: postcard.name}
                {name: 'City', content: capitalize school.city}
                {name: 'State', content: school.state}
                {name: 'FullMessageURL', content: fullUrl}
                {name: 'ARCHIVE', content: fullUrl}
            ]
            merge_vars: [{rcpt: email, vars: []}]
    .then (result) ->
        console.log result
        postcard.schoolSendStatus = result?[0]?.status or 'error'
        console.log {postcard}
        Q.ninvoke postcard, 'save'

sendEmailToThanker = (email, postcard, school) ->
    console.log "Email to thanker: #{email}"
    Q()

sendTemplateEmail = (template) ->
    _.defaults template,
        template_content: []
        async: no
    
    {message} = template
    console.log {message}
    console.log {template}
    _.defaults message,
        from_email: 'hello@thank-a-teacher.org'
        from_name: 'Thank a Teacher'
        headers:
            'Reply-To': 'hello@thank-a-teacher.org'
        important: no
        track_opens: yes
        track_clicks: yes
        preserve_recipients: yes
        merge: yes
        google_analytics_domains: ['thank-a-teacher.org']
        google_analytics_campaign: 'hello@thank-a-teacher.org'
        metadata:
            website: 'www.thank-a-teacher.org'

    message.global_merge_vars = message.global_merge_vars.concat [
        {name: 'CURRENT_YEAR', content: new Date().getUTCFullYear()}
        {name: 'MC:SUBJECT', content: message.subject}
    ]

    deferred = Q.defer()
    onResult = (result) -> deferred.resolve result
    onError = (error) -> deferred.reject error
    mandrill.messages.sendTemplate template, onResult, onError
    deferred.promise

markProcessed = (postcard) ->
    postcard.processed = no #yes
    Q.ninvoke postcard, 'save'

capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

###
send_email = (req, res, err) ->
    template_name = "Note to Principal"
    template_content = []
    message =
        subject: req.body.EmailSubject
        from_email: "hello@thank-a-teacher.org"
        from_name: "Thank A Teacher"
        to: [
            email: req.body.DestEmail
            name: req.body.SchoolName
            type: "to"
        ]
        headers:
            "Reply-To": "hello@thank-a-teacher.org"

        important: false
        track_opens: true
        track_clicks: true
        auto_text: null
        auto_html: null
        inline_css: null
        url_strip_qs: null
        preserve_recipients: true
        view_content_link: null
        bcc_address: null
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
                name: "StudentName"
                content: "A student"
            },
            {
                name: "City"
                content: ""
            },
            {
                name: "State"
                content: ""
            },
            {
                name: "CURRENT_YEAR"
                content: (new Date()).getUTCFullYear()
            },
            {
                name: "MC:SUBJECT"
                content: "Someone just thanked a teacher at your school"
            },
            {
                name: "FullMessageURL"
                content: "http://thank-a-teacher.org"
            }
        ]
        merge_vars: [
            rcpt: req.body.SchoolEmail
            vars: [
                {
                    name: "FullMessageURL"
                    content: req.body.FullMessageURL
                },
                {
                    name: "MC:SUBJECT"
                    content: req.body.EmailSubject
                },
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
                    name: "StudentName"
                    content: req.body.StudentName
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
    , res
        # (result) ->
        # console.log result
        # return
    , err
    # (e) ->
    #     console.log "A mandrill error occurred: " + e.name + " - " + e.message
    #     return

# If someone unsubscribes:
# ?md_id=??&md_email=??

content: req.body.FullMessageURL

get_req_for_postcard = (postcard, email_to, template_name) ->
    {
        template_name: template_name
        body:
            FullMessageURL: "http://thank-a-teacher.org/thank-you/#{postcard._id}"
            EmailSubject: "Someone just thanked a teacher at your school"
            SchoolName: postcard.schoolName
            TeacherName: postcard.teacher
            Message: postcard.note
            StudentName: postcard.name
            City: postcard.city
            State: postcard.state
            DestEmail: email_to
    }

# email               the email address of the recipient
# status              the sending status of the recipient - either "sent", "queued", "rejected", or "invalid"
# reject_reason       the reason for the rejection if the recipient status is "rejected"
# _id                 the message's unique id

exports.send_emails = ->
    Postcard.find({processed: false}).stream()
    .on 'data', (postcard) ->
        stream.pause()

        model = switch postcard.schoolType?.toLowerCase()
            when 'public' then PublicSchool
            when 'private' then PrivateSchool
        Q.ninvoke model, 'findById', postcard.schoolId if model
        .then((school) ->

            console.log("School Email could be: #{school.email}")

            console.log("Postcard req is: #{get_req_for_postcard(postcard, 'julian.ceipek@gmail.com', 'Note to Principal')}")
            # should_send  = (status) ->
            #     not (status in ["queued", "rejected", "invalid", "sent"])

            # send_second_email = (res,err) ->
            #     console.log("School Email could be: #{school.email}")
            #     # XXX: Change to School Email somehow!!!!!
            #     if should_send postcard.status
            #         send_email(get_req_for_postcard(postcard, "julian.ceipek@gmail.com", "Note to Principal"),
            #             (responses) ->
            #                 postcard.userSendStatus = responses[0].status
            #                 stream.resume()
            #           , (err) ->
            #                 if should_send postcard.status
            #                     postcard.schoolSendStatus = responses[0].status
            #                     postcard.processed = true
            #                 stream.resume()
            #                 console.error(err))
            # send_email(get_req_for_postcard(postcard, postcard.email, "Note to User"),
            #     (responses) ->
            #         postcard.userSendStatus = responses[0].status
            #   , (err) ->
            #         console.error(err))
            )

    Q().then(send_email)
    .then(-> console.log 'Done!')
    .catch((err) -> console.log err)
###

if require.main is module
    Q.longStackSupport = true
    db.connect().then -> console.log 'Connected'
    .then exports.sendAllUnprocessedPostcards
    .catch (error) -> console.error error?.stack or error
    .fin -> process.exit()
