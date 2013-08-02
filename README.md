# lita-schedule

Add base class for scheduled job (cron) to [jimmycuadra/lita](https://github.com/jimmycuadra/lita)

## Installation

Add this line to your application's Gemfile:

    gem 'lita-schedule'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lita-schedule

## Usage

```
require 'lita-schedule'

module Lita
  module Schedules
    class TimeTone < Schedule

      cron('* * * * * Asia/Tokyo', :every_minutes_job)
      def every_minutes_job
        target = Struct.new(:room).new('your_room@conf.hipchat.com')
        robot.send_message(target, Time.now.to_s)
      end
    end
    Lita.register_schedule(TimeTone)
  end
end
```

cron-fields comes from [jmettraux/rufus-scheduler](https://github.com/jmettraux/rufus-scheduler)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
