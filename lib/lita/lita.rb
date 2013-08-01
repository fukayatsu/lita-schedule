require 'rufus/scheduler'

module Lita
  class << self
    def schedules
      @schedules ||= Set.new
    end

    def register_schedule(schedule)
      schedules << schedule
    end
  end

  module ScheduleRobot
    def initialize
      @scheduler = Rufus::Scheduler.start_new
      super
    end

    def register_schedules
      # @scheduler.every '5s' do
      #   puts "hogehoge"
      # end
      Lita.schedules.each { |schedule|
        schedule.jobs.each { |job|
          @scheduler.cron job.cron_field do
            schedule.new(self).send job.job_name
          end
        }
      }
    end

    def run
      register_schedules
      super
    end
  end

  class Robot
    prepend ScheduleRobot
  end
end