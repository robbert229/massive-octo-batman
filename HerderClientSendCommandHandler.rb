require_relative 'GenericClientSendCommandHandler'
require_relative 'filetransfer/FileTransferSenderUtil'
require_relative 'CommandFormatter'

class HerderClientSendCommandHandler < GenericClientSendCommandHandler
  def DIRECTIVE(client, creds, params)
    puts "Start Uploading"
    puts params

  end

  def DIRECTIVE_TRANSFER(client,creds,params)

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