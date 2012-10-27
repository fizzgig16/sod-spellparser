class MapSpellToCharClassesController < ApplicationController
  # GET /map_spell_to_char_classes
  # GET /map_spell_to_char_classes.xml
  def index
    @map_spell_to_char_classes = MapSpellToCharClass.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @map_spell_to_char_classes }
    end
  end

  # GET /map_spell_to_char_classes/1
  # GET /map_spell_to_char_classes/1.xml
  def show
    @map_spell_to_char_class = MapSpellToCharClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @map_spell_to_char_class }
    end
  end

  # GET /map_spell_to_char_classes/new
  # GET /map_spell_to_char_classes/new.xml
  def new
    @map_spell_to_char_class = MapSpellToCharClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @map_spell_to_char_class }
    end
  end

  # GET /map_spell_to_char_classes/1/edit
  def edit
    @map_spell_to_char_class = MapSpellToCharClass.find(params[:id])
  end

  # POST /map_spell_to_char_classes
  # POST /map_spell_to_char_classes.xml
  def create
    @map_spell_to_char_class = MapSpellToCharClass.new(params[:map_spell_to_char_class])

    respond_to do |format|
      if @map_spell_to_char_class.save
        format.html { redirect_to(@map_spell_to_char_class, :notice => 'Map spell to char class was successfully created.') }
        format.xml  { render :xml => @map_spell_to_char_class, :status => :created, :location => @map_spell_to_char_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @map_spell_to_char_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /map_spell_to_char_classes/1
  # PUT /map_spell_to_char_classes/1.xml
  def update
    @map_spell_to_char_class = MapSpellToCharClass.find(params[:id])

    respond_to do |format|
      if @map_spell_to_char_class.update_attributes(params[:map_spell_to_char_class])
        format.html { redirect_to(@map_spell_to_char_class, :notice => 'Map spell to char class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map_spell_to_char_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /map_spell_to_char_classes/1
  # DELETE /map_spell_to_char_classes/1.xml
  def destroy
    @map_spell_to_char_class = MapSpellToCharClass.find(params[:id])
    @map_spell_to_char_class.destroy

    respond_to do |format|
      format.html { redirect_to(map_spell_to_char_classes_url) }
      format.xml  { head :ok }
    end
  end
end
