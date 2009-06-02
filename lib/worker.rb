module Kernel
  def safe_trap(*signals)
    signals.each { |s| trap(s) { yield } }
    Thread.new { loop { sleep 1 } } if RUBY_PLATFORM =~ /mswin32/
  end   
end

module Hive
  
  # "Workers" are just dedicated processes. Managers, Servers, and Monitors are all
  # examples of Workers. This class just encapsulates the common features across all
  # Workers: daemonization, signal traps, console support, logging, only-ness, etc.
  
  class Worker
    
    def self.run( options = {} )
      @instance ||= new( options )
      @instance.start
    end
    
    # make this the one-and-only
    def self.instance ; @instance ; end
    class << self ; private :new, :allocate ; end
    private :dup, :clone
    
    attr_accessor :logger, :options
    
    def initialize( options )
      @options = options
    end
    
    # returns the PID of the new process
    def start
      pid = daemonize if options[ :daemon ]
      puts "#{self.class.name} process #{pid} started ..." if pid
      return pid if pid
      begin
        # from here on in, we're in the daemon
        start_logger ; logger.info "#{self.class} starting ..."
        start_debugger if options[:debug] # unless Kernel.engine == 'jruby'
        # various ways to talk to a worker
        set_traps ; start_console ; start_drb
        start_tasks.join
      rescue Exception => e
        logger.error e.to_s
      end
    end
    
    def stop
      logger.info "#{self.class} shutting down ..."
      @console.stop if @console
      stop_tasks
    end
    
    def restart ; stop ; start ; end
        
    def daemonize
      pwd = Dir.pwd ; pid = fork ; return pid if pid ; Dir.chdir( pwd )
      File.umask 0000 ; STDIN.reopen( '/dev/null') ; 
      STDOUT.reopen( '/dev/null', 'a' ) ; STDERR.reopen( STDOUT )
      nil # return nil for child process, just like fork does
    end
    
    def set_traps
      safe_trap( 'HUP' ) { restart }
      safe_trap( 'TERM','INT' ) { stop }
    end
    
    def start_console
      # TODO: add live console support
    end
    
    def start_drb
      # TODO: add DRb support
    end
    
    def start_debugger
      require 'ruby-debug' ; Debugger.start
      Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
      logger.info "ruby-debug enabled"
    end
    
    def start_logger
      if options[ :logger ]
        @logger = options[ :logger ]
      else
        require 'logger'
        @logger = Logger.new( 'log.out' )
      end
    end
    
    protected 
    
    # workers should override these methods
    def start_tasks
    end

    def stop_tasks
    end
        
  end
  
end