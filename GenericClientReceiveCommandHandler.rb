require_relative 'GenericClientCommandHandler'

class GenericClientReceiveCommandHandler < GenericClientCommandHandler
  alias [] send

  def PING(client, creds, params)
    client.write('PONG ' + (params[1..-1] * ' '))
  end
end