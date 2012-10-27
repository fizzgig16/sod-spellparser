class CharClassesController < ApplicationController
  # GET /char_classes
  # GET /char_classes.xml
  def index
    @char_classes = CharClass.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @char_classes }
    end
  end

  # GET /char_classes/1
  # GET /char_classes/1.xml
  def show
    @char_class = CharClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @char_class }
    end
  end

  # GET /char_classes/new
  # GET /char_classes/new.xml
  def new
    @char_class = CharClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @char_class }
    end
  end

  # GET /char_classes/1/edit
  def edit
    @char_class = CharClass.find(params[:id])
  end

  # POST /char_classes
  # POST /char_classes.xml
  def create
    @char_class = CharClass.new(params[:char_class])

    respond_to do |format|
      if @char_class.save
        format.html { redirect_to(@char_class, :notice => 'Char class was successfully created.') }
        format.xml  { render :xml => @char_class, :status => :created, :location => @char_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @char_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /char_classes/1
  # PUT /char_classes/1.xml
  def update
    @char_class = CharClass.find(params[:id])

    respond_to do |format|
      if @char_class.update_attributes(params[:char_class])
        format.html { redirect_to(@char_class, :notice => 'Char class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @char_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /char_classes/1
  # DELETE /char_classes/1.xml
  def destroy
    @char_class = CharClass.find(params[:id])
    @char_class.destroy

    respond_to do |format|
      format.html { redirect_to(char_classes_url) }
      format.xml  { head :ok }
    end
  end
end
