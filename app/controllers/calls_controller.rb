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
    
    # give the view the correct list, depending on whether or not there's a URL param already 
    # included or the user has recently visited a specific group
    @list = Call.search(params[:search], params[:tab])

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

