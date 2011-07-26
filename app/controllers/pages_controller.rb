class PagesController < ApplicationController

  # added route: get "help" => "pages#help"
  def help
    puts "\n--pages#help".yellowish
    # does nothing
  end
  
  def index
    puts "\n--pages#index".yellowish
    
    @common_params = CommonParam.search(params[:cp_search])
    @groups = Group.select("DISTINCT name, id") # used to show the tabs/available groups
    
    # Determine which tab to show as active 
    if user_signed_in?
    
      # options:
      # # | search | tab | tab == all | recent_group_id             | action
      # 1 | yes    | yes | yes        | yes                         | search for search term, should go to 'all' tab, set recent to 'all'
      # 2 | yes    | yes | yes        | no                          | search for search term, should go to 'all' tab, set recent to 'all'
      # 3 | yes    | yes | no         | yes                         | search for search term, should go to specific tab, set recent to specific tab
      # 4 | yes    | yes | no         | no                          | search for search term, should go to specific tab, set recent to specific tab
      # 5 | yes    | no  | no         | yes                         | search for search term, should go to recent group tab
      # 6 | yes    | no  | no         | no                          | search for search term, should go to 'all' tab, set recent to 'all'
      # 7 | no     | yes | yes        | yes                         | go to 'all' tab, set recent to 'all'
      # 8 | no     | yes | yes        | no                          | go to 'all' tab, set recent to 'all'
      # 9 | no     | yes | no         | yes                         | go to specific tab, set recent to specific tab
      #10 | no     | yes | no         | no                          | go to specific tab, set recent to specific tab
      #11 | no     | no  | no         | yes                         | go to recent group tab
      #12 | no     | no  | no         | no                          | go to 'all' tab, set recent to 'all'
      
      # Choose the right tab to show as active
      if (params[:search].present? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.present?)
        # should: search for search term, should go to 'all' tab, set recent to 'all'
        puts "CONT 1: search.present, tab.present, tab == all, recent_group_id.present".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].present? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.blank?)
        # should: earch for search term, should go to 'all' tab, set recent to 'all'
        puts "CONT 2: search.present, tab.present, tab == all, recent_group_id.blank".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
      
      elsif (params[:search].present? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.present?)
        # should: search for search term, should go to specific tab, set recent to specific tab
        puts "CONT 3: search.present, tab.present, tab != all, recent_group_id.present".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
              
      elsif (params[:search].present? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.blank?)
        # should: search for search term, should go to specific tab, set recent to specific tab
        puts "CONT 4: search.present, tab.present, tab != all, recent_group_id.blank".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
      
      elsif (params[:search].present? && params[:tab].blank? && current_user.recent_group_id.present?)
        # should: search for search term, should go to recent group tab
        puts "CONT 5: search.present, tab.blank, recent_group_id.present".yellowish
        @tab = Group.find(current_user.recent_group_id).name
      
      elsif (params[:search].present? && params[:tab].blank? && current_user.recent_group_id.blank?)
        # should: search for search term, should go to 'all' tab, set recent to 'all'
        puts "CONT 6: search.present, tab.blank, recent_group_id.blank".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].blank? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.present?)
        # should: go to 'all' tab, set recent to 'all'
        puts "CONT 7: search.blank, tab.present, tab == all, recent_group_id.present".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].blank? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.blank?)
        # should: go to 'all' tab, set recent to 'all'
        puts "CONT 8: search.blank, tab.present, tab == all, recent_group_id.blank".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].blank? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.present?)
        # should: go to specific tab, set recent to specific tab
        puts "CONT 9: search.blank, tab.present, tab != all, recent_group_id.present".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
        
      elsif (params[:search].blank? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.blank?)
        # should: go to specific tab, set recent to specific tab
        puts "CONT 10: search.blank, tab.present, tab != all, recent_group_id.blank".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
        
      elsif (params[:search].blank? && params[:tab].blank? && current_user.recent_group_id.present?)
        # should: go to recent group tab
        puts "CONT 11: search.blank, tab.blank, recent_group_id.present".yellowish
        @tab = Group.find(current_user.recent_group_id).name
        
      elsif (params[:search].blank? && params[:tab].blank? && current_user.recent_group_id.blank?)
        # should: go to 'all' tab, set recent to 'all'
        puts "CONT 12: search.blank, tab.blank, recent_group_id.blank".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      else 
        puts "CONT 13: signed in else".yellowish
        @tab = nil
      end  # end choosing the right tab
      
    else  # user not signed in
    
      # # | search | tab | tab == all | action
      # 1 | yes    | yes | yes        | search for search term, should go to 'all' tab 
      # 2 | yes    | yes | no         | search for search term, should go to specific tab
      # 3 | yes    | no  | no         | search for search term, should go to 'all' tab
      # 4 | no     | yes | yes        | go to 'all' tab
      # 5 | no     | yes | no         | go to specific tab
      # 6 | no     | no  | no         | go to 'all' tab
      # 7 | yes    | no  | yes        | --not possible--
      # 8 | no     | no  | yes        | --not possible--
      
      if (params[:sarch].present? && params[:tab].present? && params[:tab] == 'all')
        # should: search for search term, should go to 'all' tab
        puts "CONT 14: search.present, tab.present, tab == all".greenish
        @tab = nil
        
      elsif (params[:sarch].present? && params[:tab].present? && params[:tab] != 'all')
        # should: search for search term, should go to specific tab
        puts "CONT 15: search.present, tab.present, tab != all".greenish
        @tab = params[:tab]
        
      elsif (params[:sarch].present? && params[:tab].blank?)
        # should: search for search term, should go to 'all' tab
        puts "CONT 16: search.present, tab.blank".greenish
        @tab = nil
        
      elsif (params[:sarch].blank? && params[:tab].present? && params[:tab] == 'all')
        # should: go to 'all' tab
        puts "CONT 17: search.blank, tab.present, tab == all".greenish
        @tab = nil
        
      elsif (params[:sarch].blank? && params[:tab].present? && params[:tab] != 'all')
        # should: go to specific tab
        puts "CONT 18: search.blank, tab.present, tab != all".greenish
        @tab = params[:tab]
        
      elsif (params[:sarch].blank? && params[:tab].blank?)
        # should: go to 'all' tab
        puts "CONT 19: search.blank, tab.blank".greenish
        @tab = nil
        
      else
        puts "CONT 20: not signed in else".greenish
        @tab = nil
      
      end
    end

    # give the view the correct list, depending on whether or not there's a URL param already 
    # included or the user has recently visited a specific group
    @calls = Call.search(params[:search], @tab)
  end
end

