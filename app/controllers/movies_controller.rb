class MoviesController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: index_datatable }
    end
  end

  def index_datatable
    Movies::MoviesDatatable.new(view_context)
  end
end
