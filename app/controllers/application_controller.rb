class ApplicationController < ActionController::API
  def page
    page = params.fetch(:page, 0).to_i
    if page == 0
      page
    else
      page = (page - 1)
    end
  end

  def per_page
    per_page = params.fetch(:per_page, 20).to_i
  end
end
