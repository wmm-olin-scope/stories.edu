
exports.step = new (require('./steps').Step) '#step-3', [
    {field: 'note', input: '.js-note-field'}
    {field: 'video', input: '.js-video-field', optional: yes}
]