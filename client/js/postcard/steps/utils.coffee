

exports.isButtonEnabled = (button) -> not $(button).attr 'disabled'

exports.setButtonEnabled = (button, enabled=yes) ->
    $(button).attr 'disabled', not enabled

exports.setInputEnabled = (input, enabled=yes, placeholder='') ->
    if enabled
        $ input
            .attr 'disabled', no
            .val ''
            .attr 'placeholder', placeholder
    else
        $ input
            .attr 'disabled', yes
            .val ''
            .attr 'placeholder', placeholder