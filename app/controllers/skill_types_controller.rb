class SkillTypesController < ApplicationController
  # GET /skill_types
  # GET /skill_types.xml
  def index
    @skill_types = SkillType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skill_types }
    end
  end

  # GET /skill_types/1
  # GET /skill_types/1.xml
  def show
    @skill_type = SkillType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skill_type }
    end
  end

  # GET /skill_types/new
  # GET /skill_types/new.xml
  def new
    @skill_type = SkillType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skill_type }
    end
  end

  # GET /skill_types/1/edit
  def edit
    @skill_type = SkillType.find(params[:id])
  end

  # POST /skill_types
  # POST /skill_types.xml
  def create
    @skill_type = SkillType.new(params[:skill_type])

    respond_to do |format|
      if @skill_type.save
        format.html { redirect_to(@skill_type, :notice => 'Skill type was successfully created.') }
        format.xml  { render :xml => @skill_type, :status => :created, :location => @skill_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skill_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skill_types/1
  # PUT /skill_types/1.xml
  def update
    @skill_type = SkillType.find(params[:id])

    respond_to do |format|
      if @skill_type.update_attributes(params[:skill_type])
        format.html { redirect_to(@skill_type, :notice => 'Skill type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skill_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skill_types/1
  # DELETE /skill_types/1.xml
  def destroy
    @skill_type = SkillType.find(params[:id])
    @skill_type.destroy

    respond_to do |format|
      format.html { redirect_to(skill_types_url) }
      format.xml  { head :ok }
    end
  end
end
