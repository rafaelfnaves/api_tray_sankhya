Arask.setup do |arask|
  ## Examples

  # Rake tasks with cron syntax
  #arask.create task: 'update:cache', cron: '*/5 * * * *' # Every 5 minutes
  arask.create task: 'db:update_products', cron: '0 11,02 * * *' # At 11:00 and 02:00 every day (UTC)

  # Scripts with interval (when time of day or month etc doesn't matter)
  #arask.create script: 'puts "IM ALIVE!"', interval: :daily
  arask.create task: 'snk:stock_price', interval: 10.minutes
  arask.create task: 'tray:get_orders', interval: 5.minutes

  # Run an ActiveJob.
  #arask.create job: 'ImportCurrenciesJob', interval: 1.month

  # Only run on production
  #arask.create script: 'Attachment.process_new', interval: 5.hours if Rails.env.production?

  # Run first time. If the job didn't exist already when starting rails, run it:
  #arask.create script: 'Attachment.process_new', interval: 5.hours, run_first_time: true

  # On exceptions, send email with details
  #arask.on_exception email: 'errors@example.com'

  # Run code on exceptions
  #arask.on_exception do |exception, arask_job|
  #  MyExceptionHandler.new(exception)
  #end
end
