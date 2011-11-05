scheduler = Rufus::Scheduler.start_new
#scheduler.cron("0 12 * * *") do

scheduler.cron("0 12 * * *") do
  UserMailer.reminder_email.deliver
  UserMailer.overdue_email.deliver
end