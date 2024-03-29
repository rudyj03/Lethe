class UserMailer < ActionMailer::Base
  default :from => "letheapp@gmail.com"
  def welcome_email(user)
    @user = user
    @url  = "http://lethe.heroku.com/"
    mail(:to => user.email, :subject => "Welcome to Lethe!")
  end

  def reminder_email
    @items = Item.where("expiration >= ? AND borrower != ?", 2.days.from_now.to_date, '')
    if(!@items.nil?)
        @url  = "http://lethe.heroku.com/"
        @items.each do |item|
          if(!item.borrower.empty?)
              @borrower_email = item.borrower
              loaner = User.find_by_email(item.user.email)
              borrower = User.find_by_email(@borrower_email)
              @loaner_name = loaner.name
              if(!borrower.nil?)
                @borrower_name = borrower.name
              else
                @borrower_name = @borrower_email
              end
              @days = item_expiry_date_in_days(item)
              @item_description = item.description
              mail(:to => @borrower_email, :subject => "Reminder to return #{item.description}")
            end
        end
      end
  end


  def overdue_email
    @items = Item.where("expiration < ? AND borrower != ?", Date.today.to_date, '')
    if(!@items.nil?)
        @url  = "http://lethe.heroku.com/"
        @items.each do |item|
          if(!item.borrower.empty?)
              @borrower_email = item.borrower
              loaner = User.find_by_email(item.user.email)
              borrower = User.find_by_email(@borrower_email)
              @loaner_name = loaner.name
              if(!borrower.nil?)
                if(borrower.score.nil?)
                  borrower.score = 0
                end
                borrower.update_attribute(:score, borrower.score - 1)
                @borrower_name = borrower.name
              else
                @borrower_name = @borrower_email
              end
              @item_description = item.description
              mail(:to => @borrower_email, :subject => "#{item.description} is overdue!")
            end
        end
      end
  end

  def returned_notification_email(item)
    @item = item
    @loaner = User.find_by_email(item.user.email)
    borrower = User.find_by_email(item.borrower)
    if(!borrower.nil?)
      @borrower_name = borrower.name
    else
      @borrower_name = item.borrower
    end

    mail(:to => @loaner.email, :subject => "#{item.description} has been returned to you!")

  end

  def loaned_notification_email(user, item)
    @item = item;
    @loaner = user;

    mail(:to => item.borrower, :subject => "#{user.name} just loaned you #{item.description}!")
  end

  private

  def item_expiry_date_in_days(item)
        item_date=item.expiration.strftime("%Y-%m-%d")
        today=Date.today.strftime("%Y-%m-%d")
        item_date_parsed=Date.parse(item_date)
        today_parsed=Date.parse(today)
        days=(item_date_parsed-today_parsed).to_i
    end

end
