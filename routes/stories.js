
var User = require('../data/users').User
  , Story = require('../data/stories').Story
  , utils = require('../lib/utils')
  , sessions = require('../lib/sessions')
  , _ = require('underscore')
  , makeRequest = require('request');

var youtubeIdRegEx = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;
var youtubeVideoApiUrl = "http://gdata.youtube.com/feeds/api/videos/";

function checkYoutubeId(req) {
    var match = youtubeIdRegEx.exec(req.body.youtubeUrl);
    if (match == null) throw "Not a valid YouTube url";
    return match[1];
}

function checkTags(req) {
    if (req.body.tags) {
        for (var i = 0; i < req.body.tags.length; i++) {
            utils.check(req.body.tags[i]).len(1, 32);
        }
        return req.body.tags;
    } else return [];
}

function getIndex(req, res) {
    res.render('stories/index', {
        user: req.user,

    });
}

function putStory(req, res) {
    var check = utils.checkAll(req, res, {
        youtubeId: checkYoutubeId,
        tags: checkTags
    });
    if (check[0]) return;

    Story.findOne({youtubeId: check[1].youtubeId}, function(err, story) {
        if (story) return utils.fail(res, {
            message: "A story already exists with this YouTube video."
        });

        makeRequest({ 
            uri: youtubeVideoApiUrl + check[1].youtubeId,
            qs: {v: '2', alt: 'jsonc'}
        }, function (err, response, body) {
            if (err) return utils.fail(res, err);

            var json = JSON.parse(body);
            if (json.error) return utils.fail(res, json.error.message);
            var data = json.data;

            var story = new Story({
                youtubeId: check[1].youtubeId,
                title: data.title,
                description: data.description,
                created: Date.parse(data.uploaded),
                added: Date.now(),
                tags: check[1].tags,
                thumbnail: {
                    standard: data.thumbnail.sqDefault,
                    highQuality: data.thumbnail.hqDefault
                }
            });
            console.log(data);
            if (req.user) story.user = req.user;
            story.save(function (err) {
                if (err) utils.fail(res, err);
                else utils.succeed(res, {story: story});
            });
        });
    });
}

function getStory(req, res) {
    Story.findById(req.params.storyId, function(err, story) {
        if (err) utils.fail(res, err);
        else utils.succeed(res, {story: story});
    });
}

function putStoryViewed(req, res) {
    Story.findById(req.body.storyId, function(err, story) {
        if (err) return utils.fail(res, err);
        story.views += 1;
        story.lastViewed = Date.now();
        story.save(function(err) {
            if (err) utils.fail(res, err);
            else utils.succeed(res, {});
        });
    });
}

function getPopularStories(req, res) {
    var limit = parseInt(req.query.limit);
    if (isNaN(limit) || limit <= 0) limit = 10; 
    Story.find() // {shared: True}
                .sort('-views')
                .limit(limit)
                .exec(function (err, stories) {
        if (err) utils.fail(res, err);
        else utils.succeed(res, {stories: stories});
    });
}

function putShareStory(req, res) {
    Story.findById(req.body.storyId, function(err, story) {
        if (err) return utils.fail(res, err);

        session.getCurrentUser(req, function(err, user) {
            if (user) story.registerSharedBy(user);
            else story.sharesByNonUser += 1;

            //TODO: way to not hardlink this?
            var link = req.protocol + "://" + req.get('host');
            link += "/stories/share/" + story._id;
            if (user) link += "?user=" + user._id;

            utils.succeed(res, {link: link});
        });
    });
}

function getShareStory(req, res) {
    Story.findById(req.params.storyId, function(err, story) {
        if (err || story == null) return res.render('youtubeNotFound'); 

        function done() {
            story.save(function(err) {
                if (err) console.log(err);
                res.redirect('/stories#' + story._id);
            });
        }

        if (req.query.user) {
            User.findById(req.query.user, function(err, user) {
                if (err) res.redirect('/stories/share/' + story._id);
                else {
                    story.registerShareView(user);
                    done();
                }
            });
        } else {
            story.nonUserShareViews += 1;
            done();
        }
    });
}

function putLinkUserToStory(req, res) {
    Story.findById(req.body.storyId, function(err, story) {
        if (err) return utils.fail(res, err);
        if (story.user != null) return utils.fail(res, {
            message: "This story has already been linked to a user."
        });

        if (!req.user) return utils.fail(res, {
            message: "You need to be logged in to associate with this story."
        });

        story.user = req.user;
        story.save(function(err) {
            if (err) utils.fail(res, err);
            else utils.succeed(res, {});
        });
    });
}

function viewStory(req, res) {
    Story.findById(req.params.storyId, function(err, story) {
        if (err) utils.fail(res, err);
        else res.render("stories/view", {
            story: story,
            user: req.user
        });
    });
}

exports.create = function(app) {
    app.get('/stories/', getIndex);
    app.put('/stories/viewed', putStoryViewed);
    app.get('/stories/popular', getPopularStories);
    app.put('/stories/share', putShareStory);
    app.get('/stories/share/:storyId', getShareStory);
    app.put('/stories/link-user-to-story/:storyId', putLinkUserToStory);
    app.get('/stories/view/:storyId', viewStory);
    app.get('/stories/story/:storyId', getStory);
    app.put('/stories/story', putStory);
};
