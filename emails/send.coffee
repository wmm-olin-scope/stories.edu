mongoose = require 'mongoose'
Q = require 'q'
_ = require 'underscore'

db = require '../data/db'
{PublicSchool, PrivateSchool} = require '../data/schools'
{Postcard} = require '../data/postcards'

{Mandrill} = require 'mandrill-api'
mandrill = new Mandrill process.env.MANDRILL_APIKEY

DEVELOPMENT_EMAIL = 'hello@thank-a-teacher.org'

CREATED_THRESHOLD = new Date 2014, 4, 4, 21 # Sunday May 4th at 9pm

exports.sendAllUnprocessedPostcards = (development=yes) ->
    query = Postcard.find({processed: no, created: {$gte: CREATED_THRESHOLD}})
    db.batchStream query, 16, (postcards) ->
        console.log "Sending #{postcards.length} postcards"
        Q.all (sendPostcard postcard, development for postcard in postcards)
    
sendPostcard = (postcard, development=yes) ->
    postcard.getSchool()
    .then (school) ->
        schoolEmail = school?.email
        return Q() unless schoolEmail

        if development
            schoolEmail = DEVELOPMENT_EMAIL
            thankerEmail = DEVELOPMENT_EMAIL
        else
            thankerEmail = postcard.email

        Q.all [sendEmailToSchool schoolEmail, postcard, school
               sendEmailToThanker thankerEmail, postcard, school]
        .then -> markProcessed postcard, development

sendEmailToSchool = (email, postcard, school) ->
    console.log "Email to school: #{email}"

    sendTemplateEmail
        template_name: 'Note to Principal'
        message:
            subject: 'Someone just thanked a teacher at your school'
            to: [
                email: email
                name: capitalize(school.principal or school.name) or ''
                type: 'to'
            ]
            global_merge_vars: makePostcardMergeVars postcard, school
            merge_vars: [{rcpt: email, vars: []}]
    .then (result) ->
        setSendStatus postcard, 'school', result

sendEmailToThanker = (email, postcard, school) ->
    console.log "Email to thanker: #{email}"

    sendTemplateEmail
        template_name: 'Note to User'
        message:
            subject: 'Your thank you note is on its way'
            to: [
                email: email
                name: postcard.name or ''
                type: 'to'
            ]
            global_merge_vars: makePostcardMergeVars postcard, school
            merge_vars: [{rcpt: email, vars: []}]
    .then (result) ->
        setSendStatus postcard, 'user', result

setSendStatus = (postcard, field, result) ->
    postcard["#{field}SendStatus"] = result?[0]?.status or 'error'
    Q.ninvoke postcard, 'save'

makePostcardMergeVars = (postcard, school) -> [
    {name: 'SchoolName', content: capitalize _.unescape school.name}
    {name: 'TeacherName', content: _.unescape postcard.teacher}
    {name: 'Message', content: _.unescape postcard.note}
    {name: 'StudentName', content: _.unescape postcard.name}
    {name: 'City', content: capitalize _.unescape school.city}
    {name: 'State', content: school.state}
    {name: 'FullMessageURL', content: postcard.getUrl()}
    {name: 'ARCHIVE', content: postcard.getUrl()}
]

sendTemplateEmail = (template) ->
    _.defaults template,
        template_content: []
        async: no
    
    {message} = template
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

markProcessed = (postcard, development=yes) ->
    return Q() if development
    postcard.processed = yes
    Q.ninvoke postcard, 'save'

capitalize = (s) ->
    return null unless s?
    (w[0].toUpperCase() + w[1...].toLowerCase() for w in s.split /\s+/)
    .join ' '

if require.main is module
    Q.longStackSupport = true
    db.connect().then -> console.log 'Connected'
    .then exports.sendAllUnprocessedPostcards
    .catch (error) -> console.error error?.stack or error
    .fin -> process.exit()
