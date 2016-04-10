class DashboardController < ApplicationController
  def index
    render layout: 'backstage', :template => 'dashboard/backstage/_pages/index'
  end
end