events = require("events").EventEmitter
vhostr = require("nginx-vhosts")
ServerSocket = require("socket.io")
ClientSocket = require("socket.io-client")

# Notes:
# nginx handles all http requests and logs them.
# nginx routes handles http, https
# router has no default frontend. // except online message if none


NGINX_DIR = "/etc/nginx"

settings =
  port : 80
  nginx :
    confDir: '/etc/nginx/conf.d/'
    pidLocation: '/var/run/nginx.pid'


class Server
  constructor: (options=settings) ->
    @nginx = vhostr(settings.nginx)
    @httpServer = http.createServer (req,res) ->
      res.status(200) .send('online')
    @httpServer.listen settings.port , () -> console.log "listening on #{settings.port}"
    @io = ServerSocket.listen(@httpServer)
    @events = events;
    # Connection Listener
    @io.on 'connection', (socket) ->
      console.log 'client connected'
      socket.on 'disconnect', () ->
        console.log 'client disconnected'
    return @

class Client
  constructor: (host="localhost",port=80)->
    @io = ClientSocket
    @socket = new io.Socket host, {port:port}
    @socket.on "connect", ()-> console.log "connected to #{host}:#{port}"
    return @
  connect = ()-> @socket.connect()

module.exports =
  Client : Client
  Server : Server





