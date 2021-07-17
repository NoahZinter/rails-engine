class ApplicationController < ActionController::API
  def page
    page = params.fetch(:page, 0).to_i
  end

  def per_page
    per_page = params.fetch(:per_page, 20).to_i
  end
end
