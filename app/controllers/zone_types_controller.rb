class ZoneTypesController < ApplicationController
  # GET /zone_types
  # GET /zone_types.xml
  def index
    @zone_types = ZoneType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @zone_types }
    end
  end

  # GET /zone_types/1
  # GET /zone_types/1.xml
  def show
    @zone_type = ZoneType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @zone_type }
    end
  end

  # GET /zone_types/new
  # GET /zone_types/new.xml
  def new
    @zone_type = ZoneType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @zone_type }
    end
  end

  # GET /zone_types/1/edit
  def edit
    @zone_type = ZoneType.find(params[:id])
  end

  # POST /zone_types
  # POST /zone_types.xml
  def create
    @zone_type = ZoneType.new(params[:zone_type])

    respond_to do |format|
      if @zone_type.save
        format.html { redirect_to(@zone_type, :notice => 'Zone type was successfully created.') }
        format.xml  { render :xml => @zone_type, :status => :created, :location => @zone_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @zone_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /zone_types/1
  # PUT /zone_types/1.xml
  def update
    @zone_type = ZoneType.find(params[:id])

    respond_to do |format|
      if @zone_type.update_attributes(params[:zone_type])
        format.html { redirect_to(@zone_type, :notice => 'Zone type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @zone_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /zone_types/1
  # DELETE /zone_types/1.xml
  def destroy
    @zone_type = ZoneType.find(params[:id])
    @zone_type.destroy

    respond_to do |format|
      format.html { redirect_to(zone_types_url) }
      format.xml  { head :ok }
    end
  end
end
