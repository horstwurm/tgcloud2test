class SignageCampsController < ApplicationController
  before_action :set_signage_camp, only: [:show, :edit, :update, :destroy]

  # GET /signage_camps
  # GET /signage_camps.json
  def index
    @signage_camps = SignageCamp.all
  end

  # GET /signage_camps/1
  # GET /signage_camps/1.json
  def show

    if !params[:topic]
      @topic = "Info"
    else
      @topic = params[:topic]
    end

    if params[:confirm_id]
      calEntry = SignageCal.find(params[:confirm_id])
      if calEntry
        calEntry.confirmed = true
        calEntry.save
      end
    end
    if params[:noconfirm_id]
      calEntry = SignageCal.find(params[:noconfirm_id])
      if calEntry
        calEntry.confirmed = false
        calEntry.save
      end
    end
    
  if @topic == "Standorte"
    @anz_s = ""
    #@hits = @signage_camp.signage_hits
    @hits = SignageHit.select("signage_loc_id as loc, date(created_at) as datum, count(id) as summe").where('signage_camp_id=?',@signage_camp.id).group("date(created_at, signage_loc_id)")
    @hits = SignageHit.select("date(created_at) as datum, count(id) as summe").where('signage_camp_id=?',@signage_camp.id).group("date(created_at)").order("date(created_at)")
    @hits.each do |i|
      @anz_s = @anz_s + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_s = @anz_s[0, @anz_s.length - 1] 

    @anz_s2 = ""
    @anz_s2 = @anz_s2 + "['Standort 1', 'Anzahl'],"
    @locs = SignageHit.select("signage_loc_id as loc, count(id) as summe").where("signage_camp_id=?",@signage_camp.id).group("signage_loc_id")
    @locs.each do |i|
      @anz_s2 = @anz_s2 + "['" + SignageLoc.find(i.loc).name + "', " + i.summe.to_s + "],"
    end
    @anz_s2 = @anz_s2[0, @anz_s2.length - 1] 

    if false
    @anz_s2 = ""
    @anz_s2 = @anz_s2 + "['Datum', 'Standort 1', 'Standort 2', 'Standort 3'],"
    @anz_s2 = @anz_s2 + "['2004',  1000,      400, 340],"
    @anz_s2 = @anz_s2 +  "['2005',  1170,      460, 200],"
    @anz_s2 = @anz_s2 +  "['2006',  660,       1120, 345],"
    @anz_s2 = @anz_s2 + "['2007',  1030,      540, 780]"
    end
  
  end

   if @topic == "Kalender"
     counter = 0 
     @array = ""
     @cals = @signage_camp.signage_cals
     @anz = @cals.count
     @cals.each do |c|
  
        time_from = c.time_from.to_s
        if c.time_from.to_s.length == 1
          time_from = "0"+c.time_from.to_s
        end
        time_to = c.time_to.to_s
        if c.time_to.to_s.length == 1
          time_to = "0"+c.time_to.to_s
        end
        @calstart = c.date_from.strftime("%Y-%m-%d")+"T"+time_from+":00"
        @calend = c.date_to.strftime("%Y-%m-%d")+"T"+time_to+":00"
        
        counter = counter + 1
        @array = @array + "{"
        if c.confirmed
          @array = @array + "color: '#ACC550',"
        else
          @array = @array + "color: '#61A6A7',"
        end
        @array = @array + "textColor: 'white',"
        @array = @array + "title: '" + c.signage_loc.name + "', "
        @array = @array + "start: '" + @calstart + "', "
        @array = @array + "end: '" + @calend + "', "
        @array = @array + "url: '" + company_path(:id => c.signage_loc.owner_id, :topic => "Digital Signage (Standorte)") +"'" 
        @array = @array + "}"
        if @cals.count >= counter
          @array = @array + ", "
        end
     end
   end
   
  end

  # GET /signage_camps/new
  def new
    @signage_camp = SignageCamp.new
    if params[:company_id]
      @signage_camp.owner_type = "Company"
      @signage_camp.owner_id = params[:company_id]
    end
    if params[:user_id]
      @signage_camp.owner_type = "User"
      @signage_camp.owner_id = params[:user_id]
    end
  end

  # GET /signage_camps/1/edit
  def edit
  end

  # POST /signage_camps
  # POST /signage_camps.json
  def create
    @signage_camp = SignageCamp.new(signage_camp_params)

    respond_to do |format|
      if @signage_camp.save
        format.html { redirect_to company_path(:id => @signage_camp.owner_id, :topic => "Digital Signage (Kampagnen)"), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @signage_camp }
      else
        format.html { render :new }
        format.json { render json: @signage_camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signage_camps/1
  # PATCH/PUT /signage_camps/1.json
  def update
    respond_to do |format|
      if @signage_camp.update(signage_camp_params)
        format.html { redirect_to company_path(:id => @signage_camp.owner_id, :topic => "Digital Signage (Kampagnen)"), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @signage_camp }
      else
        format.html { render :edit }
        format.json { render json: @signage_camp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signage_camps/1
  # DELETE /signage_camps/1.json
  def destroy
    @id = @signage_camp.owner_id
    @signage_camp.destroy
    respond_to do |format|
      format.html { redirect_to company_path(:id => @id, :topic => "Digital Signage (Kampagnen)"), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage_camp
      @signage_camp = SignageCamp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_camp_params
      params.require(:signage_camp).permit(:name, :description, :owner_id, :owner_type)
    end
end
