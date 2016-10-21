module.exports = (state, utils) ->
	{room_id: room_id} = utils.qsparams()
	if not(room_id) then utils.state_error(state, "не указан query string параметр 'room_id' для iframe")
	utils.render_coroutine() # here first render and starts coroutine
	if not(state.auth) then $('[tabindex="' + 1  + '"]').focus()
