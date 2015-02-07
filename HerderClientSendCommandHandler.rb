require_relative 'GenericClientSendCommandHandler'
require_relative 'filetransfer/FileTransferSenderUtil'
require_relative 'CommandFormatter'

class HerderClientSendCommandHandler < GenericClientSendCommandHandler
  def DIRECTIVE(client, creds, params)
    client.write(CommandFormatter.say(creds, params * " "))
    if (params[1].upcase == 'TRANSFER')
      DIRECTIVE_TRANSFER(client, creds, params[2..-1])
    end
  end

  def DIRECTIVE_TRANSFER(client,creds,params)
    puts "Uploading"
    ftsu = FileTransferSenderUtil.new
    ftsu.sendAsync(params[2], params[3], UploadCB.new(client))
  end
end

class UploadCB
  def initialize(_client)
    @client = _client
  end

  def Run
    puts "Done Uploading"
  end
end