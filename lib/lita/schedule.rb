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
    end

    def initialize(robot)
      @robot = robot
      @redis = Redis::Namespace.new(Lita::REDIS_NAMESPACE, redis: Lita.redis)
    end
  end
end
