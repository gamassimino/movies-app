class PeopleController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_person, only: [:show, :edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: index_datatable }
    end
  end

  def index_datatable
    People::PeopleDatatable.new(view_context)
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
    uri = URI("#{ENV['API_DOMAIN']}/api/v1/people")
    Net::HTTP.post_form(uri, 'first_name' => params[:first_name],
     'last_name' => params[:last_name], 'aliases' => params[:aliases])
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      redirect_to people_path
    else
      render :new
    end
  end

  def get_person
    uri = URI("#{ENV['API_DOMAIN']}/api/v1/people/#{params[:id]}.json")
    Net::HTTP.get(uri)
    response = Net::HTTP.get_response(uri)
    @person = JSON.parse(response.body)
  end
end
