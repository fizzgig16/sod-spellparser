class TargetTypesController < ApplicationController
  # GET /target_types
  # GET /target_types.xml
  def index
    @target_types = TargetType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @target_types }
    end
  end

  # GET /target_types/1
  # GET /target_types/1.xml
  def show
    @target_type = TargetType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @target_type }
    end
  end

  # GET /target_types/new
  # GET /target_types/new.xml
  def new
    @target_type = TargetType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @target_type }
    end
  end

  # GET /target_types/1/edit
  def edit
    @target_type = TargetType.find(params[:id])
  end

  # POST /target_types
  # POST /target_types.xml
  def create
    @target_type = TargetType.new(params[:target_type])

    respond_to do |format|
      if @target_type.save
        format.html { redirect_to(@target_type, :notice => 'Target type was successfully created.') }
        format.xml  { render :xml => @target_type, :status => :created, :location => @target_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @target_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /target_types/1
  # PUT /target_types/1.xml
  def update
    @target_type = TargetType.find(params[:id])

    respond_to do |format|
      if @target_type.update_attributes(params[:target_type])
        format.html { redirect_to(@target_type, :notice => 'Target type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @target_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /target_types/1
  # DELETE /target_types/1.xml
  def destroy
    @target_type = TargetType.find(params[:id])
    @target_type.destroy

    respond_to do |format|
      format.html { redirect_to(target_types_url) }
      format.xml  { head :ok }
    end
  end
end
