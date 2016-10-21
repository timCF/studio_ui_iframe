document.addEventListener "DOMContentLoaded", (e) ->
	jf = require('jsfunky')
	prettyform = (e) ->
		keyCode = e.keyCode || e.which
		if ( keyCode ==  13 )
			e.preventDefault()
			nextElement = $('[tabindex="' + (this.tabIndex+1)  + '"]')
			if(nextElement.length != 0)
				nextElement.focus()
			else
				$('[tabindex="1"]').focus()
				$('.submitmegaform')[0].click()
	$(document).on("keypress",".megaform", prettyform)
	react = require("react-dom")
	widget = require("widget")
	render_tooltips = () ->
		$('[data-toggle="tooltip"]').tooltip()
		out = $(".tooltip").attr('id')
		if out and ($("[aria-describedby='"+out+"']").length == 0)
			$( document.getElementById(out) ).remove()
			console.log("destroy tooltip "+out)
	render_jqcb = () ->
		# NOTICE !!! not reload page on submit forms
		$('form').submit((e) -> e.preventDefault())
	render = (cb) ->
		render_tooltips()
		render_jqcb()
		$('.selectpicker').selectpicker({noneSelectedText: "ничего не выбрано"})
		await react.render(widget(fullstate), document.getElementById("main_frame"), defer dummy)
		if jf.is_function(cb,1) then cb(state)
		dummy
	render_coroutine = () ->
		await render(defer dummy)
		setTimeout(render_coroutine, 500)
		dummy
	#
	# state for main function, mutable
	#
	state = {
		ok: true,
		auth: true,
		login: '',
		password: '',
		errormess: "неизвестная ошибка",
		room_id: false
	}
	#
	# state for main function, mutable
	#
	utils = Object.freeze( jf.merge(require("iced/utils"), {render: render, render_coroutine: render_coroutine}) )
	fullstate = Object.freeze({state: state, utils: utils})
	require("ls/main")(state, utils)
