class GenericClientCommandHandler
  def doListenToUser(user,creds)
    return (user == creds.nick or user.upcase == "ALL")
  end
end