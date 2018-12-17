require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

scheduler.cron '5 0 * * *' do # runs 5 mins after midnight
  require './lib/harvester'
end

scheduler.in '1s' do
  require './lib/harvester'
end

require './jewelers'
run Jewelers.new