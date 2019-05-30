# frozen_string_literal: true
require 'socket'

module Moonrelay
  module Cli
    class ExposeCommand < Clamp::Command
      option "--server", "SERVER", "moonrelay server", required: true
      option "--channel", "CHANNEL", "moonrelay channel", required: true
      option "--host", "HOST", "host to expose", required: true
      option "--port", "PORT", "port to expose", required: true

      def execute
        s = nil
        downstream = Queue.new
        t = Thread.new do
          loop do
            unless s
              sleep 0.1
              next
            end
            data = s.recv(8192)
            downstream.push data
          end
        end

        EM.run {
          ws = Faye::WebSocket::Client.new("ws://#{server}/#{channel}")

          ws.on :open do |event|
            p [:open]
          end

          ws.on :message do |event|
            s ||= TCPSocket.new host, port

            p [:message, event.data]

            if event.data.is_a? Array
              s.write(event.data.pack("C*"))
            else
              s.write event.data
            end
          end

          Thread.new do
            loop do
              m = downstream.pop
              if m.empty?
                # disconnect TODO
                if s.nil?
                  puts "wat"
                else
                  t.kill
                  s.close
                  s = nil
                end
              end

              p ["<-", m]
              ws.send(m.unpack("C*"))
            end
          end
          ws.on :close do |event|
            p [:close, event.code, event.reason]
            ws = nil
          end

        }

      end
    end
  end
end
