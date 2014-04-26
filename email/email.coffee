mongoose = require 'mongoose'
Q = require 'q'
db = require '../data/db'
{Postcard} = require '../data/postcards'
{PublicSchool, PrivateSchool} = require '../data/schools'

mandrill = require('mandrill-api')
mandrill_client = new mandrill.Mandrill(process.env.MANDRILL_APIKEY)

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

process_postcard = (postcard) ->
    console.log("Process Postcard")

    deferred = Q.defer()

    console.log("FOUND EM: #{postcard._id}")

    model = switch postcard.schoolType?.toLowerCase()
        when 'public' then PublicSchool
        when 'private' then PrivateSchool

    model.findById(postcard.schoolId, 'email', (err, school) ->
            email = school.email
            console.log("School Email could be: #{email}")
            deferred.resolve()
        )

    deferred.promise

test = ->

    deferred = Q.defer()
    # {'processed': null}, {'processed': false}: Order must be null, false in order to find all matches
    stream = Postcard.find().or([{'processed': null}, {'processed': false}]).stream()
        .on 'data', (postcard) ->
            Q().then(-> stream.pause())
            .then(-> process_postcard postcard)
            .then(-> stream.resume())
        .on 'error', (err) ->
            console.log("Error")
            deferred.reject err
        .on 'close', () ->
            console.log("Closed")
            deferred.resolve()
    deferred.promise

exports.send_emails = ->
    promise = Q()
    console.log("SENDING EMAILS!")
    promise.then(-> test)
    promise
    # console.log(Postcard.models)
    # Postcard.find({processed: false},(p)->console.log("FOUND SUMMAT"))

    # Q().then(test)
    # .then(-> console.log 'Done Sending!')
    # .catch((err) -> console.log err)

    # Postcard.find().or([{processed: false}, {processed: null}]).stream()
    # .on 'data', (postcard) ->
    #     console.log("Found an Email!")
    #     stream.pause()

    #     model = switch postcard.schoolType?.toLowerCase()
    #         when 'public' then PublicSchool
    #         when 'private' then PrivateSchool
    #     Q.ninvoke model, 'findById', postcard.schoolId if model
    #     .then((school) ->

    #         console.log("School Email could be: #{school.email}")

    #         console.log("Postcard req is: #{get_req_for_postcard(postcard, 'julian.ceipek@gmail.com', 'Note to Principal')}")
    #         # should_send  = (status) ->
    #         #     not (status in ["queued", "rejected", "invalid", "sent"])

    #         # send_second_email = (res,err) ->
    #         #     console.log("School Email could be: #{school.email}")
    #         #     # XXX: Change to School Email somehow!!!!!
    #         #     if should_send postcard.status
    #         #         send_email(get_req_for_postcard(postcard, "julian.ceipek@gmail.com", "Note to Principal"),
    #         #             (responses) ->
    #         #                 postcard.userSendStatus = responses[0].status
    #         #                 stream.resume()
    #         #           , (err) ->
    #         #                 if should_send postcard.status
    #         #                     postcard.schoolSendStatus = responses[0].status
    #         #                     postcard.processed = true
    #         #                 stream.resume()
    #         #                 console.error(err))
    #         # send_email(get_req_for_postcard(postcard, postcard.email, "Note to User"),
    #         #     (responses) ->
    #         #         postcard.userSendStatus = responses[0].status
    #         #   , (err) ->
    #         #         console.error(err))
    #         )

    # Q().then(send_email)
    # .then(-> console.log 'Done!')
    # .catch((err) -> console.log err)

if require.main is module
    db.connect()
    .then(test)
    # .then(exports.send_emails)
    .fin(-> process.exit())