#
#	just template for your own data structs
#
module.exports = (utils, state) ->
	jf = require('jsfunky')
	newmsg = () ->
		msg = new utils.proto.Request
		msg.login = state.login
		msg.password = state.password
		msg.cmd = 'ping'
		msg.orders = []
		msg
	long2date = (long) ->
		moment(1000 * parseInt(long.toString())).format('YYYY-MM-DD HH:mm:ss')
	port = ':7770' # (if location.port then ":"+location.port else "")
	bullet = $.bullet((if window.location.protocol == "https:" then "wss://" else "ws://") + location.hostname + port + location.pathname + "bullet")
	utils.bullet = bullet
	utils.to_server = (data) -> bullet.send( utils.encode_proto(data) )
	utils.bullet.onopen = () -> utils.notice("соединение с сервером установлено")
	utils.bullet.ondisconnect = () -> utils.error("соединение с сервером потеряно")
	utils.bullet.onclose = () -> utils.warn("соединение с сервером закрыто")
	utils.bullet.onheartbeat = () -> utils.to_server(newmsg())
	utils.get_state = () ->
		msg = newmsg()
		msg.cmd = 'state'
		utils.to_server(msg)
	utils.confirm_payout = (order) ->
		order_copy = jf.clone(order)
		order_copy.cdate = 0
		order_copy.edate = 0
		msg = newmsg()
		msg.cmd = 'confirm_payout'
		msg.orders.push(order_copy)
		utils.to_server(msg)
	utils.bullet.onmessage = (data) ->
		data = utils.decode_proto(data)
		console.log(data)
		switch data.status
			when "void" then "ok"
			when "error" then utils.error(data.message)
			when "info" then utils.notice(data.message)
			when "refreshstate" then (if state.auth then utils.get_state())
			when "state"
				state.auth = true
				state.orders = data.orders.map((el) -> el.cdate = long2date(el.cdate) ; el.edate = long2date(el.edate) ; el)
	utils
