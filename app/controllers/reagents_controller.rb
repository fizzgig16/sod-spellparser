class ReagentsController < ApplicationController
  # GET /reagents
  # GET /reagents.xml
  def index
    @reagents = Reagent.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reagents }
    end
  end

  # GET /reagents/1
  # GET /reagents/1.xml
  def show
    @reagent = Reagent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reagent }
    end
  end

  # GET /reagents/new
  # GET /reagents/new.xml
  def new
    @reagent = Reagent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reagent }
    end
  end

  # GET /reagents/1/edit
  def edit
    @reagent = Reagent.find(params[:id])
  end

  # POST /reagents
  # POST /reagents.xml
  def create
    @reagent = Reagent.new(params[:reagent])

    respond_to do |format|
      if @reagent.save
        format.html { redirect_to(@reagent, :notice => 'Reagent was successfully created.') }
        format.xml  { render :xml => @reagent, :status => :created, :location => @reagent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reagent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reagents/1
  # PUT /reagents/1.xml
  def update
    @reagent = Reagent.find(params[:id])

    respond_to do |format|
      if @reagent.update_attributes(params[:reagent])
        format.html { redirect_to(@reagent, :notice => 'Reagent was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reagent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reagents/1
  # DELETE /reagents/1.xml
  def destroy
    @reagent = Reagent.find(params[:id])
    @reagent.destroy

    respond_to do |format|
      format.html { redirect_to(reagents_url) }
      format.xml  { head :ok }
    end
  end
end
