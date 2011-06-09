class CallsController < ApplicationController
  # GET /calls
  # GET /calls.xml
  def index
    @calls = Call.all
    @common_params = CommonParam.all

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


  def execute_request
    @call = Call.find(params[:id])

    # Read in the XML
    @xml = @call.xml

    # Replace the coded fields with the matching fields from the common_params

    @count = @xml.count("#") # how many # are there -- should be even, too

    # add the pairs of locations of each # sign to the hash
    @hash_arr = []
    @offset = 0 # To start reading in the hash characters, start at the beginning
    @i = 0

    # Load the # sign locations into an array
    while @i < @count do
      @location = @xml.index("#", offset = @offset)
      @hash_arr[@i] = @location
      @offset = @location + 1
      @i += 1
    end

    # Delete between, and including, the hashes

    # Replace them with the actual values from the common_params table


    # Form string for sending the request, including headers



  end

end













#

