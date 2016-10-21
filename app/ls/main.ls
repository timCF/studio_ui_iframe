module.exports = (state, utils) ->
	# request template
	req = new utils.proto.Request
	req.cmd = 'CMD_get_state'
	req.client_kind = 'CK_observer'
	req.login = ''
	req.password = ''
	req.subject = new utils.proto.FullState
	req.subject.hash = ''
	state.request_template = req
	# parse qs
	{room_id: room_id} = utils.qsparams()
	if not(room_id) then utils.state_error(state, "не указан query string параметр 'room_id' для iframe")
	state.room_id = room_id
	utils.render_coroutine() # here first render and starts coroutine
	utils.rerender_events_coroutine(state, null) # render events coroutine for calendar
	if not(state.auth) then $('[tabindex="' + 1  + '"]').focus()
