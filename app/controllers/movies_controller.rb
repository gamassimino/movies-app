class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    respond_to do |format|
      format.html
      format.json { render json: index_datatable }
    end
  end

  def index_datatable
    Movies::MoviesDatatable.new(view_context)
  end

  def new
  end

  def show
    uri = URI("http://localhost:3001/api/v1/movies/#{params[:id]}.json")
    Net::HTTP.get(uri)
    response = Net::HTTP.get_response(uri)
    @movie = JSON.parse(response.body)
  end

  def edit
  end

  def create
    uri = URI('http://localhost:3001/api/v1/movies')
    Net::HTTP.post_form(uri, 'title' => params[:title],
     'release_year' => params[:release_year])
    response = Net::HTTP.get_response(uri)

    if response.code == '200'
      redirect_to movies_path
    else
      render :new
    end
  end
end
