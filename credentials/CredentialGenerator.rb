require 'etc'
require 'open-uri'
require_relative 'Credentials'

class CredentialGenerator
  def self.create(ip, port)
    nick = Etc.getlogin
    username = Etc.getlogin
    realname = open('http://whatismyip.akamai.com').read
    channel = '#TheHerd'
    herders = ['herder']
    return Credentials.new(ip, port, nick, username, realname, channel, herders)
  end
end
