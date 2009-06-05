require 'rubygems'
require 'facets/duration' unless 1.respond_to? :minute

module Hive
  
  class Scheduler < Hive::Worker
  
    def stop_tasks
      threads = Thread.list.select { |t| t.alive? && t != Thread.current }
      until threads.empty?
        logger.info "#{threads.count} threads still running ... "
        threads.each { |t| t.kill && t != Thread.current }
        threads = threads.select { |t| t.alive? }
      end
      logger.info "All threads are finished."
    end
    
    private 
    
    def schedule( method, options )
      raise ArgumentError.new( "Invalid schedule for task #{method}.") unless valid?(options)
      logger.info "Scheduling task #{method} ..."
      Thread.new do
        t = Time.now
        loop do
          t += 60
          sleep( ( options[:interval] || ( t - Time.now ) ).to_i )
          if match( t, options )
            if self.respond_to?( method )
              Thread.new do
                logger.info "Running task #{method} ..."
                begin
                  self.send( method ) 
                rescue Exception => e 
                  logger.error e
                end
                logger.info "Task #{method} complete."
              end
            else
              logger.warn "Task #{method} scheduled but not defined."
            end
          end
        end
      end
    end
    
    def valid?( options )
      ! ( options.keys & [ :minute, :hour, :day, :weekday, :month, :interval] ).empty?
    end
    
    def match( t, options )
      options[:interval] ||
        (( match_item( options[:minute], t.min )) &&
         ( match_item( options[:hour], t.hour )) &&
         ( match_item( options[:day], t.day )) &&
         ( match_item( options[:weekday], t.wday )) &&
         ( match_item( options[:month], t.month )))
    end
    
    def match_item( x, y )
      case x
      when nil then true
      when Array then x.include? y
      when Range then x.include? y
      when Integer then x == y
      else 
        logger.warn "Value #{x.inspect} will never be matched"
        false
      end
    end
    
  end

end