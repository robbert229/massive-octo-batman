class CommandFormatter
  def self.say(creds, message)
    return ('PRIVMSG ' + creds.channel + ' :' + message)
  end
end