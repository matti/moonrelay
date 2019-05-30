# frozen_string_literal: true
require 'socket'
require 'faye/websocket'
require 'eventmachine'

module Moonrelay
  module Cli
    class ProxyCommand < Clamp::Command
      option "--server", "SERVER", "moonrelay server", required: true
      option "--channel", "CHANNEL", "moonrelay channel", required: true
      option "--port", "PORT", "port to bind", required: true

      def execute

        downstream = Queue.new
        upstream = Queue.new
        proxy_server = TCPServer.open("0.0.0.0", 2000)

        Thread.new do
          loop do
            c = proxy_server.accept    # Wait for a client to connect
            puts "conn"
            t = Thread.new do
              loop do
                m = downstream.pop
                print m
                c.write m
              end
            end

            while data = c.recv(81920) do
              break if data.empty?
              upstream << data
            end
            puts "disconnect"
            t.kill
          end
        end

        EM.run {
          ws = Faye::WebSocket::Client.new("ws://#{server}/#{channel}")

          ws.on :open do |event|
            puts "ready"
          end

          ws.on :message do |event|
            p [:message, event.data.class, event.data]
            if event.data.is_a? Array
              downstream.push event.data.pack("C*")
            else
              downstream.push event.data
            end
          end

          ws.on :close do |event|
            p [:close, event.code, event.reason]
            ws = nil
          end

          Thread.new do
            loop do
              m = upstream.pop
              # TODO

              puts ""
              puts "----"
              p ["->", m.encoding, m]
              if m.encoding.name == "ASCII-8BIT"
                ws.send m.unpack("C*")
              else
                ws.send m
              end
#                puts m.unpack("C*")
#                ws.send m # .unpack("C*")
#              else
 #               ws.send m
  #            end
            end
          end
        }
      end
    end
  end
end
