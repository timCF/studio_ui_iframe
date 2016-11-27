module.exports =
	files:
		javascripts:
			joinTo: 'app.js'
		stylesheets:
			joinTo: 'app.css'
		templates:
			joinTo: 'app.js'
	server:
		port: 3333
		stripSlashes: true
		hostname: "0.0.0.0"
	plugins:
		sass:
			mode: 'native' # set to 'native' to force libsass
