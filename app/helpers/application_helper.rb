module ApplicationHelper

  def logo
    image_tag("logo.png", :alt => "Lethe Logo", :class => "round")
  end

  def yes_no bool
    bool ? "yes" : "no"
  end

end
