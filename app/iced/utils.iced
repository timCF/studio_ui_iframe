calendar_opts = {
	timeFormat: 'HH:mm',
	defaultView: 'agendaWeek',
	views: {
		agenda: {
			titleFormat: "MMMM D",
			minTime: "09:00:00",
			slotLabelInterval: "01:00:00",
			slotLabelFormat: 'HH:mm',
			allDaySlot: false,
		}
	},
	height: "auto",
	lang: 'ru',
	firstDay: 1,
	monthNames: [
		"Январь",
		"Февраль",
		"Март",
		"Апрель",
		"Май",
		"Июнь",
		"Июль",
		"Август",
		"Сентябрь",
		"Октябрь",
		"Ноябрь",
		"Декабрь",
	],
	dayNames: [
		"Воскресенье",
		"Понедельник",
		"Вторник",
		"Среда",
		"Четверг",
		"Пятница",
		"Суббота",
	],
	buttonText: {
		today: 'сегодня',
		month: 'месяц',
		week: 'неделя',
		day: 'день'
	},
	columnFormat: 'dddd',
	eventAfterRender: ((data, element, _) -> $(element).css('width', ($(element).width() * data.percentfill) + 'px'))
}

jf = require('jsfunky')
urijs = require('urijs')
module.exports =
	tz: "Europe/Moscow"
	jf: jf
	state_error: (state, error) ->
		state.ok = false
		state.errormess = error
	qsparams: () -> urijs.parseQuery( (new urijs()).query() )
	error: (mess) -> toastr.error(mess)
	warn: (mess) -> toastr.warning(mess)
	notice: (mess) -> toastr.success(mess)
	info: (mess) -> toastr.info(mess)
	view_set: (state, path, ev) ->
		if (ev? and ev.target? and ev.target.value?)
			subj = ev.target.value
			jf.put_in(state, path, subj)
	view_put: (state, path, data) ->
		jf.put_in(state, path, data)
	view_swap: (state, path) ->
		jf.update_in(state, path, (bool) -> not(bool))
	view_files: (state, path, ev) ->
		if (ev? and ev.target? and ev.target.files? and (ev.target.files.length > 0))
			jf.update_in(state, path, (_) -> [].map.call(ev.target.files, (el) -> el))
			console.log(jf.get_in(state, path))
	auth: (state) ->
		state.auth = true
	jf: jf
	multiple_select: (state, path, ev) ->
		if (ev? and ev.target?)
			jf.put_in(state, path, [].slice.call(ev.target.options).filter((el) -> el.selected).map((el) -> el.value))
	rerender_events_coroutine_process: (state, prevstate) ->
		# rm html elements and create new state ...
		newstate = jf.reduce(state, {}, (k,v,acc) -> jf.put_in(acc, [k], jf.clone(v)))
		if not(jf.equal(prevstate, newstate))
			calendar = $("#calendar")
			if (calendar.length > 0)
				calendar_opts.firstDay = moment().day()
				calendar.fullCalendar(calendar_opts)
				calendar.fullCalendar( 'removeEventSources' )
				calendar.fullCalendar( 'removeEvents' )
				calendar.fullCalendar( 'addEventSource', state.events)
				console.log("re-render "+state.events.length+" events ... new state is")
			newstate
		else
			prevstate
	rerender_events_coroutine: (state, this_state) ->
		utils = @
		try
			this_state = utils.rerender_events_coroutine_process(state, this_state)
			setTimeout((() -> utils.rerender_events_coroutine(state, this_state)), 500)
		catch error
			console.log("RENDER EVENTS ERROR !!! ", error)
			setTimeout((() -> utils.rerender_events_coroutine(state, this_state)), 500)
	create_event: ({id: id, time_from: time_from, time_to: time_to, room_id: room_id, status: status}, state) ->
		utils = @
		m_from = moment(time_from * 1000)
		m_to = moment(time_to * 1000)
		percentfill = Math.abs(time_to - time_from) / 10800
		percentfill = 1
		this_room = if (state.dicts.rooms_full and state.dicts.rooms_full[room_id.toString()]) then state.dicts.rooms_full[room_id.toString()] else null
		{
			id: id,
			title: "занято",
			start: m_from.tz(utils.tz).format('YYYY-MM-DDTHH:mm:ss'),
			end: m_to.tz(utils.tz).format('YYYY-MM-DDTHH:mm:ss'),
			percentfill: percentfill,
			room_id: room_id,
			status: status,
			color: this_room.color
		}
