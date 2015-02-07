class Credentials
  def initialize(_address, _port, _nick, _username, _realname, _channel, _herders)
    @address = _address
    @port = _port
    @nick = _nick
    @username = _username
    @realname = _realname
    @channel = _channel
    @herders = _herders
  end

  attr_reader :address, :port, :nick, :username, :realname, :channel, :herders
end

