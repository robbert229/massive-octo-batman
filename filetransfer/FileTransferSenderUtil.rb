require 'socket'
require_relative 'FileTransferUtil'

class FileTransferSenderUtil < FileTransferUtil
  def sendSync(port,fileSource)
    server = TCPServer.new("0.0.0.0",port)
    connection = server.accept
    fin = File.open(fileSource,"rb")

    while (buf = fin.read(@SIZE)) != nil
      connection.write(buf)
    end

    fin.close
    connection.close
    server.close
  end

  def sendAsync(port,fileSource,cb)
    Thread.new {
      sendSync(port,fileSource)
      cb.Run()
    }
  end
end
