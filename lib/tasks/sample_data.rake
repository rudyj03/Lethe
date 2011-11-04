namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "admin",
                         :email => "rudyj03@gmail.com",
                         :password => "triO4553!+123",
                         :password_confirmation => "triO4553!+123")
    User.create!(:name => "Tester",
                 :email => "tester@test.com",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    User.create!(:name => "Rudrasinh",
                 :email => "rudrasinh.jadeja@gmail.com",
                 :password => "password",
                 :password_confirmation => "password")
    admin.toggle!(:admin)
    #99.times do |n|
     # name  = Faker::Name.name
     # email = "example-#{n+1}@railstutorial.org"
     # password  = "password"
     # User.create!(:name => name,
     #              :email => email,
     #              :password => password,
     #              :password_confirmation => password)
    #end
  end
end
