require_relative 'HerderClientSendCommandHandler'
require_relative 'HerderClientReceiveCommandHandler'
require_relative 'credentials/CredentialGenerator'
require_relative 'Connection'
require_relative 'exceptions/CredentialsAlreadyInUseException'
require_relative 'exceptions/QuitCommandException'
require_relative 'exceptions/RemoteQuitException'
require_relative 'exceptions/DisconnectException'

class HerderClient

  def Run
    client = Connection.new(true)
    sender = HerderClientSendCommandHandler.new
    receiver = HerderClientReceiveCommandHandler.new

    creds = CredentialGenerator.create('localhost', 6667,)

    client.connect(creds.address, creds.port)
    initialAuthentication(client, creds)

    # Reader
    Thread.new {
      receiveCommands(client, creds, receiver)
    }
    # Writer

    sendCommands(client, creds, sender)

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

  def sendCommands(client, creds, sender)

    while true
      input = gets.chomp
      begin
        params = input.split(' ')
        sender[params[0].upcase, client, creds, params[0..-1]]
      rescue QuitCommandException
        client.close
        Process.exit!(true)
      rescue NoMethodError
        #if its not a built in command send it across the net
        client.write(input)
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
        #do nothing
      rescue RemoteQuitException
        client.close
        Process.exit!(true)
      end
    end
  end
end

h = HerderClient.new
h.Run