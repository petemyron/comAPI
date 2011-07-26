class CallsController < ApplicationController

require 'rubygems'
require 'typhoeus'
#require 'json_pure'
require 'awesome_print'
require 'nokogiri'

  # GET /calls
  # GET /calls.xml
  def index
    puts "\n--calls#index".yellowish
    
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

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calls }
    end
  end

  # GET /calls/1
  # GET /calls/1.xml
  def show
    puts "\n--calls#show".yellowish
    
    @call = Call.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/new
  # GET /calls/new.xml
  def new
    puts "\n--calls#new".yellowish
    
    @call = Call.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/1/edit
  def edit
    puts "\n--calls#edit".yellowish
    
    @call = Call.find(params[:id])
  end

  # POST /calls
  # POST /calls.xml
  def create
    puts "\n--calls#create".yellowish
    
    @call = Call.new(params[:call])

    respond_to do |format|
      if @call.save
        format.html { redirect_to(@call, :notice => 'Call was successfully created.') }
        format.xml  { render :xml => @call, :status => :created, :location => @call }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /calls/1
  # PUT /calls/1.xml
  def update
    puts "\ncalls#update".yellowish
    
    @call = Call.find(params[:id])

    respond_to do |format|
      if @call.update_attributes(params[:call])
        format.html { redirect_to(@call, :notice => 'Call was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @call.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.xml
  def destroy
    puts "\ncalls#destroy".yellowish
    @call = Call.find(params[:id])
    @call.destroy

    respond_to do |format|
      format.html { redirect_to(calls_url) }
      format.xml  { head :ok }
    end
  end


  def make_request
    puts "\ncalls#make_request".yellowish
    
    @call = Call.find(params[:id])
    @common_params = CommonParam.all

    # Read in the XML
    @orig_xml = @call.xml
    @modified_xml = @orig_xml.dup # which will later be modified, .dup to avoid changing both strings

    @count = @orig_xml.count("#") # how many # are there -- should be even, too


    # Iterate through each common_param and replace each instance with the real value
    @common_params.each do |cp|
      # Add # to the name
      @find = "#" + cp.name + "#"

      # Replace that string with the actual value
      # the last time this runs gives us the final @modified_xml string
      @modified_xml.sub!(@find, cp.value) 
    end


    # Load up some header variables
    # This is, unfortunately, not a very fast way to do this and could use some refactoring
    @subno = CommonParam.find_by_name("x-up-subno").value
    @ua = CommonParam.find_by_name("user_agent").value


    # Use Typhoeus to make the request
    @request = Typhoeus::Request.new( @call.endpoint_uri,
      :method => @call.method_type,
      :auth_method => :ntlm,
      :proxy => "http://ftpproxy.wdc.cingular.net:8080",
      :headers => { :content_type => "text/xml", :charset => "UTF-8", :"x-up-subno" => @subno },
      :body => @modified_xml,
      :user_agent => @ua,
      :verbose => false # set to true for debugging
    )

    # Schedule the task -- which runs immediately
    @hydra = Typhoeus::Hydra.new
    @hydra.queue(@request)
    @hydra.run      # Execute the request

    # Set the response object
    @response = @request.response

    @parsed_xml = Nokogiri::XML(@response.body)


    # Only if the user is signed in, add the call to the log
    if user_signed_in?
      puts "CONT - make_request --- user is signed in".yellowish
      @new_log_entry = Log.new(
                          :method_name => @call.method_name, 
                          :user_id => current_user.id, 
                          :request => @modified_xml, 
                          :response => @response.body,
                          :method_type => @call.method_type,
                          :endpoint_uri => @call.endpoint_uri
                          )
      @new_log_entry.save!
    end

  end


end













#

