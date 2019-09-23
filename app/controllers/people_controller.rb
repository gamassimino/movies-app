class PeopleController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: index_datatable }
    end
  end

  def index_datatable
    People::PeopleDatatable.new(view_context)
  end
end
