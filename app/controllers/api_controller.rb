class ApiController < ApplicationController
  def index
    render template: 'api/index', layout: 'blank'
  end
end