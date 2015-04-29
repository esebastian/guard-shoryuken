require 'guard/compat/plugin'
require 'timeout'

module Guard
  class Shoryuken < Plugin

    DEFAULT_SIGNAL = :TERM
    DEFAULT_CONCURRENCY = 25

    # Allowable options are:
    #  - :concurrency INT e.g. 10, processor threads to use
    #  - :queue QUEUE[,WEIGHT]... e.g. 'my_queue,5' 'my_other_queue', queues to process with optional weights
    #  - :require [PATH|DIR] e.g. 'workers/my_worker.rb' | 'app/workers', location of the worker
    #  - :config [PATH] e.g. 'config/my_config.yml', path to YAML config file
    #  - :rails BOOL e.g. true, attempts to load the containing Rails project, implies :config => 'config/shoryuken.yml'
    #  - :logfile PATH e.g. 'log/my_logfile.log', path to writable logfile
    #  - :pidfile PATH e.g. 'my_pidfile.pid', path to pidfile
    #  - :verbose BOOL e.g. true, print more verbose output
    #  - :stop_signal SIGN e.g. :TERM, signal to send to stop the process
    def initialize(options = {})
      @options = options
      @pid = nil
      @stop_signal = options[:stop_signal] || DEFAULT_SIGNAL
      @options[:concurrency] ||= DEFAULT_CONCURRENCY
      @options[:rails] = @options.fetch(:rails, false)
      @options[:verbose] = @options.fetch(:verbose, true)
      super
    end

    def start
      stop
      Guard::Compat::UI.info 'Starting up shoryuken...'
      Guard::Compat::UI.info cmd

      # launch Shoryuken worker
      @pid = spawn({}, cmd)
    end

    def stop
      if @pid
        Guard::Compat::UI.info 'Stopping shoryuken...'
        ::Process.kill @stop_signal, @pid
        begin
          Timeout.timeout(15) do
            ::Process.wait @pid
          end
        rescue Timeout::Error
          Guard::Compat::UI.info 'Sending SIGKILL to shoryuken, as it\'s taking too long to shutdown.'
          ::Process.kill :KILL, @pid
          ::Process.wait @pid
        end
        UI.info 'Stopped process shoryuken'
      end
    rescue Errno::ESRCH
      Guard::Compat::UI.info 'Guard::Shoryuken lost the Shoryuken worker subprocess!'
    ensure
      @pid = nil
    end

    # Called on Ctrl-Z signal
    def reload
      Guard::Compat::UI.info 'Restarting shoryuken...'
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

      command << "--verbose"                                if @options[:verbose]
      command << "--pidfile #{@options[:pidfile]}"          if @options[:pidfile]
      command << "--logfile #{@options[:logfile]}"          if @options[:logfile]
      command << "-R"                                       if @options[:rails] &&  @options[:config]
      command << "-R -C config/shoryuken.yml"               if @options[:rails] && !@options[:config]
      command << "-C #{@options[:config]}"                  if @options[:config]
      command << "--require #{@options[:require]}"          if @options[:require]
      command << queue_params                               if @options[:queue]
      command << "--concurrency #{@options[:concurrency]}"

      command.join(' ')
    end

  end
end
