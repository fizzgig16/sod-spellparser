class ResistTypesController < ApplicationController
  # GET /resist_types
  # GET /resist_types.xml
  def index
    @resist_types = ResistType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resist_types }
    end
  end

  # GET /resist_types/1
  # GET /resist_types/1.xml
  def show
    @resist_type = ResistType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resist_type }
    end
  end

  # GET /resist_types/new
  # GET /resist_types/new.xml
  def new
    @resist_type = ResistType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resist_type }
    end
  end

  # GET /resist_types/1/edit
  def edit
    @resist_type = ResistType.find(params[:id])
  end

  # POST /resist_types
  # POST /resist_types.xml
  def create
    @resist_type = ResistType.new(params[:resist_type])

    respond_to do |format|
      if @resist_type.save
        format.html { redirect_to(@resist_type, :notice => 'Resist type was successfully created.') }
        format.xml  { render :xml => @resist_type, :status => :created, :location => @resist_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resist_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resist_types/1
  # PUT /resist_types/1.xml
  def update
    @resist_type = ResistType.find(params[:id])

    respond_to do |format|
      if @resist_type.update_attributes(params[:resist_type])
        format.html { redirect_to(@resist_type, :notice => 'Resist type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resist_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resist_types/1
  # DELETE /resist_types/1.xml
  def destroy
    @resist_type = ResistType.find(params[:id])
    @resist_type.destroy

    respond_to do |format|
      format.html { redirect_to(resist_types_url) }
      format.xml  { head :ok }
    end
  end
end
