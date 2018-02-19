module ApplicationHelper

  def render_title
    return @title if defined?(@title)
    "Generic Page Title"
  end


end

