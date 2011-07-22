class CallsController < ApplicationController

require 'rubygems'
require 'typhoeus'
#require 'json_pure'
require 'awesome_print'
require 'nokogiri'

  # GET /calls
  # GET /calls.xml
  def index
    @groups = Group.select("DISTINCT name, id") # used to show the tabs/available groups
    
#    if user_signed_in?
#      if params[:tab]
#        puts "\n----specific tab indicated".green
#        @tab = params[:tab]
#      elsif current_user.recent_group_id.present?
#        puts "\n----group_id present".green
#        @tab = Group.find(current_user.recent_group_id).name
#      else
#        puts "\n----@tab == nil".green
#        @tab = "all"
#      end
#      if @tab != "all"
#        current_user.recent_group_id = Group.find_by_name(@tab).id
#      end
#      
#      puts "current_user.recent_group_id now == #{current_user.recent_group_id}".blue.on_white
#    else  # user isn't signed in 
#      if params[:tab]
#        puts "\n----user not signed in - params[:tab] is present".green
#        @tab = params[:tab]
#      else
#        puts "\n----user not signed in - @tab == nil".green
#        @tab = "all"
#      end
#    end
#    
#    # set the user's recent_group_id if they're logged in
#    if user_signed_in? 
#        group_id = Group.find_by_name(@tab).id unless @tab == "all"
#        puts "user_signed_in, group id: #{group_id}".red
##      if current_user.recent_group_id != @group_id
##        current_user.recent_group_id = @group_id
##      end
#    end
    
    

    
    # testing 
    if user_signed_in?
      if (params[:search].present? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.present?)
        # should: search for search term, should go to 'all' tab, set recent to 'all'
        puts "\nCONT 1: search.present, tab.present, tab == all, recent_group_id.present".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].present? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.nil?)
        # should: earch for search term, should go to 'all' tab, set recent to 'all'
        puts "\nCONT 2: search.present, tab.present, tab == all, recent_group_id.nil".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
      
      elsif (params[:search].present? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.present?)
        # should: search for search term, should go to specific tab, set recent to specific tab
        puts "\nCONT 3: search.present, tab.present, tab != all, recent_group_id.present".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
              
      elsif (params[:search].present? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.nil?)
        # should: search for search term, should go to specific tab, set recent to specific tab
        puts "\nCONT 4: search.present, tab.present, tab != all, recent_group_id.nil".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
      
      elsif (params[:search].present? && params[:tab].nil? && current_user.recent_group_id.present?)
        # should: search for search term, should go to recent group tab
        puts "\nCONT 5: search.present, tab.nil, recent_group_id.present".yellowish
        @tab = Group.find(current_user.recent_group_id).name
      
      elsif (params[:search].present? && params[:tab].nil? && current_user.recent_group_id.nil?)
        # should: search for search term, should go to 'all' tab, set recent to 'all'
        puts "\nCONT 6: search.present, tab.nil, recent_group_id.nil".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].nil? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.present?)
        # should: should go to 'all' tab, set recent to 'all'
        puts "\nCONT 7: search.nil, tab.present, tab == all, recent_group_id.present".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].nil? && params[:tab].present? && params[:tab] == 'all' && current_user.recent_group_id.nil?)
        # should: should go to 'all' tab, set recent to 'all'
        puts "\nCONT 8: search.nil, tab.present, tab == all, recent_group_id.nil".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      elsif (params[:search].nil? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.present?)
        # should: should go to specific tab, set recent to specific tab
        puts "\nCONT 9: search.nil, tab.present, tab != all, recent_group_id.present".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
        
      elsif (params[:search].nil? && params[:tab].present? && params[:tab] != 'all' && current_user.recent_group_id.nil?)
        # should: should go to specific tab, set recent to specific tab
        puts "\nCONT 10: search.nil, tab.present, tab != all, recent_group_id.nil".yellowish
        @tab = params[:tab]
        group = Group.find_by_name(params[:tab])
        current_user.update_recent_group_id(group.id)
        
      elsif (params[:search].nil? && params[:tab].nil? && current_user.recent_group_id.present?)
        # should: should go to recent group tab
        puts "\nCONT 11: search.nil, tab.nil, recent_group_id.present".yellowish
        @tab = Group.find(current_user.recent_group_id).name
        
      elsif (params[:search].nil? && params[:tab].nil? && current_user.recent_group_id.nil?)
        # should: should go to 'all' tab, set recent to 'all'
        puts "\nCONT 12: search.nil, tab.nil, recent_group_id.nil".yellowish
        @tab = nil
        current_user.update_recent_group_id("") #which defaults to the all tab
        
      else
      end
    end
    
# options:
# # | search | tab | tab == all | recent_group_id             | action
# 1 | yes    | yes | yes        | yes                         | search for search term, should go to 'all' tab, set recent to 'all'
# 2 | yes    | yes | yes        | no                          | search for search term, should go to 'all' tab, set recent to 'all'
# 3 | yes    | yes | no         | yes                         | search for search term, should go to specific tab, set recent to specific tab
# 4 | yes    | yes | no         | no                          | search for search term, should go to specific tab, set recent to specific tab
# 5 | yes    | no  | no         | yes                         | search for search term, should go to recent group tab
# 6 | yes    | no  | no         | no                          | search for search term, should go to 'all' tab, set recent to 'all'
# 7 | no     | yes | yes        | yes                         | should go to 'all' tab, set recent to 'all'
# 8 | no     | yes | yes        | no                          | should go to 'all' tab, set recent to 'all'
# 9 | no     | yes | no         | yes                         | should go to specific tab, set recent to specific tab
#10 | no     | yes | no         | no                          | should go to specific tab, set recent to specific tab
#11 | no     | no  | no         | yes                         | should go to recent group tab

# haven't made these yet
#12 | no     | no  | no         | no                          | should go to 'all' tab, set recent to 'all'
#   | yes    | no  | yes        | yes # can't actually happen |
#   | yes    | no  | yes        | no  # can't actually happen |
#   | no     | no  | yes        | yes # can't actually happen |
#   | no     | no  | yes        | no  # can't actually happen |

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
    @call = Call.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/new
  # GET /calls/new.xml
  def new
    @call = Call.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @call }
    end
  end

  # GET /calls/1/edit
  def edit
    @call = Call.find(params[:id])
  end

  # POST /calls
  # POST /calls.xml
  def create
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
    @call = Call.find(params[:id])
    @call.destroy

    respond_to do |format|
      format.html { redirect_to(calls_url) }
      format.xml  { head :ok }
    end
  end


  def make_request
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
      @new_log_entry = Log.new(
                          :method_name => @call.method_name, 
                          :user_id => current_user.id, 
                          :request => @modified_xml, 
                          :response => @response.body,
                          :method_type => @call.method_type,
                          :endpoint_uri => @call.endpoint_uri
                          )
      @new_log_entry.save
    end

  end


end













#

