require 'rufus-scheduler'
Rufus::Scheduler.new.cron '5 0 * * *' do # runs 5 mins after midnight
  require './lib/harvester'
end
require './lib/harvester'

require './jewelers'
run Jewelers.new