require 'guard'
require 'timeout'

module Guard
  class Shoryuken < Plugin

    DEFAULT_SIGNAL = :TERM
    DEFAULT_CONCURRENCY = 1

    # Allowable options are:
    #  - :environment  e.g. 'test'
    #  - :queue e.g. 'default'
    #  - :timeout e.g. 5
    #  - :config e.g. config/shoryuken.yml
    #  - :concurrency, e.g. 20
    #  - :verbose e.g. true
    #  - :stop_signal e.g. :TERM, :QUIT or :SIGQUIT
    #  - :logfile e.g. log/shoryuken.log (defaults to STDOUT)
    #  - :require e.g. ./shoryuken_helper.rb
    def initialize(options = {})
      @options = options
      @pid = nil
      @stop_signal = options[:stop_signal] || DEFAULT_SIGNAL
      @options[:concurrency] ||= DEFAULT_CONCURRENCY
      @options[:verbose] = @options.fetch(:verbose, true)
      super
    end

    def start
      stop
      UI.info 'Starting up shoryuken...'
      UI.info cmd

      # launch Shoryuken worker
      @pid = spawn({}, cmd)
    end

    def stop
      if @pid
        UI.info 'Stopping shoryuken...'
        ::Process.kill @stop_signal, @pid
        begin
          Timeout.timeout(15) do
            ::Process.wait @pid
          end
        rescue Timeout::Error
          UI.info 'Sending SIGKILL to shoryuken, as it\'s taking too long to shutdown.'
          ::Process.kill :KILL, @pid
          ::Process.wait @pid
        end
        UI.info 'Stopped process shoryuken'
      end
    rescue Errno::ESRCH
      UI.info 'Guard::Shoryuken lost the Shoryuken worker subprocess!'
    ensure
      @pid = nil
    end

    # Called on Ctrl-Z signal
    def reload
      UI.info 'Restarting shoryuken...'
      restart
    end

    # Called on Ctrl-/ signal
    def run_all
      true
    end

    # Called on file(s) modifications
    def run_on_changes(paths)
      restart
    end

    def restart
      stop
      start
    end

    private

    def queue_params
      params = @options[:queue]
      params = [params] unless params.is_a? Array
      params.collect {|param| "--queue #{param}"}.join(" ")
    end

    def cmd
      command = ['bundle exec shoryuken']

      command << "--logfile #{@options[:logfile]}"          if @options[:logfile]
      command << queue_params                               if @options[:queue]
      command << "-C #{@options[:config]}"                  if @options[:config]
      command << "--verbose"                                if @options[:verbose]
      command << "--environment #{@options[:environment]}"  if @options[:environment]
      command << "--timeout #{@options[:timeout]}"          if @options[:timeout]
      command << "--require #{@options[:require]}"          if @options[:require]
      command << "--concurrency #{@options[:concurrency]}"

      command.join(' ')
    end

  end
end
