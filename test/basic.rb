require 'rubygems'
require 'logger'
require 'lib/hive/worker'
require 'lib/hive/scheduler'

class MyScheduler < Hive::Scheduler
  
  def start_tasks
    schedule( :my_task, :minute => Time.now.min + 1 )
    schedule( :another_task, :interval => 10.seconds )
    schedule( :odd_tasks, :minute => (0..59).select{ |x| x.odd? } )
  end
  
  def my_task
    logger.info "Yay! My task is done!"
  end
  
  def another_task
    logger.info "My work here is done."
  end
  
  def odd_tasks
    logger.info "Well, that sure is strange."
  end
  
end

MyScheduler.run( :logger => Logger.new( $stdout ) )