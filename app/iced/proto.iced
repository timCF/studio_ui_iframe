#
#	just template for your own data structs
#
module.exports = (utils) ->
	proto2base64 = require('base64-arraybuffer')
	utils.proto = require("protobufjs").loadProtoFile("./kzsh_proto/kzsh.proto").build("kzsh.proto")
	utils.stringifyEnums = (message) ->
		if (message and message.$type and message.$type.children)
			message.$type.children.forEach((child) ->
				field = child.name
				if (message[field] and child.element.resolvedType)
					switch child.element.resolvedType.className
						when 'Enum'
							dict = child.element.resolvedType.children.reduce(((acc, {id: id, name: name}) -> acc[id] = name ; acc), {})
							if child.repeated
								message[field] = message[field].map((el) -> if dict[el] then dict[el] else el)
							else
								if dict[message[field]] then message[field] = dict[message[field]]
						when 'Message'
							if child.repeated
								message[field] = message[field].map((el) -> utils.stringifyEnums(el))
							else
								message[field] = utils.stringifyEnums(message[field]))
		message
	utils.decode_proto = (data) ->
		try
			utils.stringifyEnums( utils.proto.Response.decode64( data.data ) )
		catch error
			"protobuf decode error "+error+" raw data : "+data
	utils.encode_proto = (data) ->
		proto2base64.encode( utils.proto.Request.encode(data).toArrayBuffer() )
	utils
