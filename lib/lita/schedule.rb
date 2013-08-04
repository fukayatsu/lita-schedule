require "lita/schedule/version"

module Lita
  class Schedule
    extend Forwardable

    attr_reader :redis
    attr_reader :robot

    Job = Struct.new('Job', :cron_field, :job_name)

    class << self
      def cron(cron_field, job_name)
        jobs << Job.new(cron_field, job_name)
      end

      def jobs
        @jobs ||= []
      end

      def namespace
        if name
          Util.underscore(name.split("::").last)
        else
          raise "Handlers that are anonymous classes must define self.name."
        end
      end
    end

    def initialize(robot)
      @robot = robot
      @redis = Redis::Namespace.new(redis_namespace, redis: Lita.redis)
    end

    private

    def redis_namespace
      "schedules:#{self.class.namespace}"
    end
  end
end
