class PagesController < ApplicationController

  # added route: get "help" => "pages#help"
  def help
    # does nothing
  end
  
  def index
    @calls = Call.search(params[:search])
    @common_params = CommonParam.search(params[:cp_search])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calls }
    end
  end
  
end

