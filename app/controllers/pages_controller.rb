class PagesController < ApplicationController

  # added route: get "help" => "pages#help"
  def help
    # does nothing
  end
  
  def index
    @common_params = CommonParam.search(params[:cp_search])
    @groups = Group.select("DISTINCT name, id")
    @list = Call.search(params[:search], params[:tab])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calls }
    end
  end
  
end

