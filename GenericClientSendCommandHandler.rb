require_relative 'GenericClientCommandHandler'

class GenericClientSendCommandHandler < GenericClientCommandHandler
  alias [] send

  def QUIT(client, creds, params)
    client.write('QUIT' + (params.length > 1 ? ' :' + params[1..-1] * ' ' : ''))
    raise QuitCommandException
  end
end