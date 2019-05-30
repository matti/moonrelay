# frozen_string_literal: true

module Moonrelay
  module Cli
    class ServerCommand < Clamp::Command
      def execute
        Moonrelay::Server.run!
      end
    end
  end
end
