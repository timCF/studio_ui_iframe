jf = require('jsfunky')
urijs = require('urijs')
module.exports =
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
