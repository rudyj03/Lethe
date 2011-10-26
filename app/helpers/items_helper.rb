module ItemsHelper
  def yes_no bool
    if bool
       "yes"
    else
      "no"
    end
  end

  def email_or_name borrower

    user = User.find_by_email borrower

    if(user.nil?)
      borrower
    else
      user.name
    end
  end
end
