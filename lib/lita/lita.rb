require 'rufus/scheduler'

module Lita
  class Config < Hash
    class << self
      def default_config
        config = new.tap do |c|
          c.robot = new
          c.robot.name = "Lita"
          c.robot.adapter = :shell
          c.robot.log_level = :info
          c.robot.admins = nil
          c.redis = new
          c.http = new
          c.http.port = 8080
          c.http.debug = false
          c.adapter = new
          c.handlers = new
          c.schedules = new # added
        end
        load_handler_configs(config)
        load_schedule_configs(config) # added
        config
      end

      def load_schedule_configs(config)
        Lita.schedules.each do |schedule|
          next unless schedule.respond_to?(:default_config)
          schedule_config = config.schedules[schedule.namespace] = new
          schedule.default_config(schedule_config)
        end
      end
    end
  end

  class << self
    def schedules
      @schedules ||= Set.new
    end

    def register_schedule(schedule)
      schedules << schedule
    end
  end

  module ScheduleRobot
    def initialize(registry = Lita)
      @scheduler = Rufus::Scheduler.start_new
      super
    end

    def register_schedules

      Lita.schedules.each { |schedule|
        schedule.jobs.each { |job|
          case job.type
          when :cron
            @scheduler.cron job.field do
              schedule.new(self).send job.job_name
            end
          when :cycle
            @scheduler.every job.field do
              schedule.new(self).send job.job_name
            end
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
