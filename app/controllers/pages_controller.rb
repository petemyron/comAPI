class PagesController < ApplicationController

  # added route: get "help" => "pages#help"
  def help
    # does nothing
  end
  
  def index
    @calls = Call.search(params[:search])
    @common_params = CommonParam.search(params[:cp_search])
    @groups = Group.select("DISTINCT name, id")
    
    if params[:tab]
      @group_id = @groups.find_by_name("#{params[:tab]}").id
      @list = Call.find_all_by_group_id(@group_id)
    else
      @list = @calls.sort_by(&:method_name) # works!
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calls }
    end
  end
  
end

