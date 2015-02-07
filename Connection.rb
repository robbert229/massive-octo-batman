require 'socket'

class Connection
  @socket
  @debug

  def initialize(debug)
    @debug = debug
  end

  def connect(address, port)
    @socket = TCPSocket.new(address, port)
  end

  def close
    @socket.close
  end

  def read
    input = @socket.readline
    if @debug
      puts 'SOCKIN->' + input
    end
    input
  end

  def write(line)
    @socket.write(line + "\n")
    @socket.flush
    if @debug
      puts 'SOCKOUT->' + line
    end
  end
end