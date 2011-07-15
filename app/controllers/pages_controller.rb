class PagesController < ApplicationController

  # added route: get "help" => "pages#help"
  def help
    # does nothing
  end
  
  def index
    @common_params = CommonParam.search(params[:cp_search])


    #### This should be refactored as it's the same code as in calls_controller#index, with the exception
    #### of @common_params above    
    @groups = Group.select("DISTINCT name, id") # used to show the tabs/available groups
    if user_signed_in?
      if params[:tab]
#        puts "----params[:tab]"
        @tab = params[:tab]
      elsif current_user.recent_group_id.present?
#        puts "----group_id present"
        @tab = Group.find(current_user.recent_group_id).name
      else
#        puts "----@tab = nil"
        @tab = "All"
      end
    else  # user isn't signed in 
      if params[:tab]
#        puts "----user not signed in - params[:tab]"
        @tab = params[:tab]
      else
#        puts "----user not signed in - @tab = nil"
        @tab = "All"
      end
    end

    # give the view the correct list, depending on whether or not there's a URL param already 
    # included or the user has recently visited a specific group
    @calls = Call.search(params[:search], @tab)
  end
end

