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
      subcommand ["expose"], "expose a local service", Moonrelay::Cli::ExposeCommand
      subcommand ["proxy"], "proxy local port to a remote service", Moonrelay::Cli::ProxyCommand

      def self.run
        super
      rescue StandardError => exc
        warn exc.message
        warn exc.backtrace.join("\n")
      end
    end
  end
end
