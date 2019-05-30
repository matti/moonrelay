#require_relative "moonage/server"
require "websocket/eventmachine/server"

#TODO: ?
EM.epoll

module Moonrelay::Server
  def self.run!
    EM.run do
      $clients = {}
      $channels = {}

      WebSocket::EventMachine::Server.start(host: "0.0.0.0", port: 8080) do |ws|
        ws.onopen do |handshake|
          $channels[handshake.path] ||= {}
          $channels[handshake.path][ws.object_id] = ws
        end

        ws.onmessage do |msg, type|
          handshake = ws.instance_eval("@handshake")

          delivered = false
          $channels[handshake.path].each do |object_id, subscriber|
            unless subscriber == ws
              delivered = true
              subscriber.send msg, type: type
            end
          end

          unless delivered
            ws.close
          end
        end

        ws.onclose do
          handshake = ws.instance_eval("@handshake")
          $channels[handshake.path].delete ws.object_id
        end
      end

      puts "🌗 listening at 0.0.0.0:8080"
    end
  end
end
