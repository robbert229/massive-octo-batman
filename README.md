# massive-octo-batman
This is just a fun little ruby / security project I decided to make.
Essentialy its a botnet written in ruby. Albeit a bad one lacking 
security its a fun little project that I built in a weekend.

This is my first ruby project and I have been having a few issues with organization
and file structuring so I have a very informal method of running it right now. 

You run either HerderClient.rb or ZombieClient.rb and it does its magic. The program
itself isn't that useful because of the requirement of ruby on a machine but it was a
fun project to learn ruby.

TERMS

who - nick

cmd - the command you want executed

address - the ip address to connect to

port - the port to connect to

fileSource - the path of the file you want to upload

fileDest - the path that you want to write the file to

COMMANDS

directive kill [who] - closes the program for the specified bot.

directive ping - has all of the bots respond with a pong and thier global ip. ex - "PONG 123.123.123.123".

directive exec [who] [cmd] - executes the specified command and says the result in the channel.

directive transfer [who] [address] [port] [fileSource] [fileDest] - transfers a specified file to or from the bots.
