# frozen_string_literal: true

module Moonrelay
  module Cli
    class RootCommand < Clamp::Command
      banner "🌗 moonrelay #{Moonrelay::VERSION}"

      option ['-v', '--version'], :flag, "Show version information" do
        puts Moonrelay::VERSION
        exit 0
      end

      subcommand ["server"], "start server", Moonrelay::Cli::ServerCommand

      def self.run
        super
      rescue StandardError => exc
        warn exc.message
        warn exc.backtrace.join("\n")
      end
    end
  end
end
