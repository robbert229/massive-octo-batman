require 'socket'
require_relative 'FileTransferUtil'
class FileTransferReceiverUtil < FileTransferUtil
  def receiveSync(address,port,fileDestination)
    socket = TCPSocket.open(address,port)
    fout = File.open(fileDestination,'w')

    while(buf = socket.read(@SIZE)) != nil
      fout.write(buf)
    end

    fout.close
    socket.close
  end

  def receiveAsync(address, port, fileDestination, cb)
    Thread.new {
      receiveSync(address,port,fileDestination)
      cb.Run()
    }
  end
end
