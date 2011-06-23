class CommonParamsController < ApplicationController
  # GET /common_params
  # GET /common_params.xml
  def index
    @common_params = CommonParam.search(params[:cp_search])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @common_params }
    end
  end

  # GET /common_params/1
  # GET /common_params/1.xml
  def show
    @common_param = CommonParam.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @common_param }
    end
  end

  # GET /common_params/new
  # GET /common_params/new.xml
  def new
    @common_param = CommonParam.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @common_param }
    end
  end

  # GET /common_params/1/edit
  def edit
    @common_param = CommonParam.find(params[:id])
  end

  # POST /common_params
  # POST /common_params.xml
  def create
    @common_param = CommonParam.new(params[:common_param])

    respond_to do |format|
      if @common_param.save
        format.html { redirect_to(@common_param, :notice => 'Common param was successfully created.') }
        format.xml  { render :xml => @common_param, :status => :created, :location => @common_param }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @common_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /common_params/1
  # PUT /common_params/1.xml
  def update
    @common_param = CommonParam.find(params[:id])

    respond_to do |format|
      if @common_param.update_attributes(params[:common_param])

        # determine where the user should be redirected to, depending on where the field was updated
        if params[:redirect_to] == "calls_path"
          format.html { redirect_to(calls_path, :notice => 'Common Param was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(@common_param, :notice => 'Common Param was successfully updated.') } # we never really go to the common_params list page
#          format.html { redirect_to(@calls_path, :notice => 'Common Param was successfully updated.') }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @common_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /common_params/1
  # DELETE /common_params/1.xml
  def destroy
    @common_param = CommonParam.find(params[:id])
    @common_param.destroy

    respond_to do |format|
      format.html { redirect_to(common_params_url) }
      format.xml  { head :ok }
    end
  end

end

