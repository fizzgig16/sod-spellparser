class EffectTypesController < ApplicationController
  # GET /effect_types
  # GET /effect_types.xml
  def index
    @effect_types = EffectType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @effect_types }
    end
  end

  # GET /effect_types/1
  # GET /effect_types/1.xml
  def show
    @effect_type = EffectType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @effect_type }
    end
  end

  # GET /effect_types/new
  # GET /effect_types/new.xml
  def new
    @effect_type = EffectType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @effect_type }
    end
  end

  # GET /effect_types/1/edit
  def edit
    @effect_type = EffectType.find(params[:id])
  end

  # POST /effect_types
  # POST /effect_types.xml
  def create
    @effect_type = EffectType.new(params[:effect_type])

    respond_to do |format|
      if @effect_type.save
        format.html { redirect_to(@effect_type, :notice => 'Effect type was successfully created.') }
        format.xml  { render :xml => @effect_type, :status => :created, :location => @effect_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @effect_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /effect_types/1
  # PUT /effect_types/1.xml
  def update
    @effect_type = EffectType.find(params[:id])

    respond_to do |format|
      if @effect_type.update_attributes(params[:effect_type])
        format.html { redirect_to(@effect_type, :notice => 'Effect type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @effect_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /effect_types/1
  # DELETE /effect_types/1.xml
  def destroy
    @effect_type = EffectType.find(params[:id])
    @effect_type.destroy

    respond_to do |format|
      format.html { redirect_to(effect_types_url) }
      format.xml  { head :ok }
    end
  end
end
