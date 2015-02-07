require_relative 'ZombieClientReceiveCommandHandler'
require_relative 'credentials/CredentialGenerator'
require_relative 'Connection'
require_relative 'exceptions/CredentialsAlreadyInUseException'
require_relative 'exceptions/QuitCommandException'
require_relative 'exceptions/RemoteQuitException'
require_relative 'exceptions/DisconnectException'

class ZombieClient

  def Run
    client = Connection.new(true)
    receiver = ZombieClientReceiveCommandHandler.new

    creds = CredentialGenerator.create('localhost', 6667,)

    client.connect(creds.address, creds.port)
    initialAuthentication(client, creds)

    receiveCommands(client, creds, receiver)

    client.close
  end

  def initialAuthentication(client, creds)
    client.write('NICK ' + creds.nick)
    client.write('USER ' + creds.username + ' 8 * : ' + creds.realname)

    # Initializer

    while (line = client.read) != nil
      if line.include? 'PING :'
        pingCode = line.split('PING :').last
        client.write('PONG ' + pingCode)
      elsif line.include? '001'
        client.write('JOIN ' + creds.channel)
        break
      elsif line.include? '433'
        raise CredentialsAlreadyInUseException
      end
    end
  end

  def receiveCommands(client, creds, reciever)
    while (line = client.read) != nil
      begin
        params = line.split(' ')
        if params[0].include?('@') and params[1].upcase.include?('PRIVMSG')
          params[3][0] = ''
          reciever['MESSAGE', client, creds, params[0][1..-1], params[3..-1]] #client, creds, sender,params
        else
          reciever[params[0].upcase, client, creds, params[0..-1]]
        end
      rescue NoMethodError
        puts 'noe'
      rescue RemoteQuitException
        break;
      end
    end
  end
end

z = ZombieClient.new
z.Run