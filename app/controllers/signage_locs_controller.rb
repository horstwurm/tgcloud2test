class SignageLocsController < ApplicationController
  before_action :set_signage_loc, only: [:show, :edit, :update, :destroy]

  # GET /signage_locs
  # GET /signage_locs.json
  def index
    #@signage_locs = SignageLoc.all

    @controller_name = controller_name
    
    if params[:page]
      session[:page] = params[:page]
    end
    
    @signage_locs = SignageLoc.all.page(params[:page]).per_page(10)
    @siganz = @signage_locs.count
   counter = 0 
   @locs = "["
   @wins = "["
   @signage_locs.each do |c|

      if c.longitude and c.latitude and c.geo_address and c.name
        @locs = @locs + "["
        @locs = @locs + "'" + c.name.to_s + "', "
        @locs = @locs + c.latitude.to_s + ", "
        @locs = @locs + c.longitude.to_s
        if counter+1 == @siganz
          @locs = @locs + "]"
        else
          @locs = @locs + "],"
        end
  
        @wins = @wins + "["
        @wins = @wins + "'<img src=" + c.avatar(:medium) + "<br><h3>"  + c.name + "<br>" + c.owner.name + "</h3><p>" + c.geo_address + "</p>'"
        if counter+1 == @siganz
          @wins = @wins + "]"
        else
          @wins = @wins + "],"
        end
      end
      counter = counter + 1
    end
    @locs = @locs + "]"
    @wins = @wins + "]"

  end

  # GET /signage_locs/1
  # GET /signage_locs/1.json
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
    
  if @topic == :dskampagnen
    @anz_s = ""
    #@hits = @signage_camp.signage_hits
    #@hits = SignageHit.select("signage_loc_id as loc, date(created_at) as datum, count(id) as summe").where('signage_camp_id=?',@signage_camp.id).group("date(created_at, signage_loc_id)")
    @hits = SignageHit.select("date(created_at) as datum, count(id) as summe").where('signage_loc_id=?',@signage_loc.id).group("date(created_at)").order("date(created_at)")
    @hits.each do |i|
      @anz_s = @anz_s + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_s = @anz_s[0, @anz_s.length - 1] 

    @anz_s2 = ""
    @anz_s2 = @anz_s2 + "['Kampagne', 'Anzahl'],"
    @locs = SignageHit.select("signage_camp_id as camp, count(id) as summe").where("signage_loc_id=?",@signage_loc.id).group("signage_camp_id")
    @locs.each do |i|
      @anz_s2 = @anz_s2 + "['" + SignageCamp.find(i.camp).name + "', " + i.summe.to_s + "],"
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
     @cals = @signage_loc.signage_cals
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
        @array = @array + "title: '" + c.signage_camp.name + "', "
        @array = @array + "start: '" + @calstart + "', "
        @array = @array + "end: '" + @calend + "', "
        @array = @array + "url: '" + company_path(:id => c.signage_camp.owner_id, :topic => "Digital Signage (Kampagnen)") +"'" 
        @array = @array + "}"
        if @cals.count >= counter
          @array = @array + ", "
        end
     end
   end  end

  # GET /signage_locs/new
  def new
    @signage_loc = SignageLoc.new
    if params[:company_id]
      @signage_loc.owner_type = "Company"
      @signage_loc.owner_id = params[:company_id]
    end
    if params[:user_id]
      @signage_loc.owner_type = "User"
      @signage_loc.owner_id = params[:user_id]
    end
  end

  # GET /signage_locs/1/edit
  def edit
  end

  # POST /signage_locs
  # POST /signage_locs.json
  def create
    @signage_loc = SignageLoc.new(signage_loc_params)

    respond_to do |format|
      if @signage_loc.save
        format.html { redirect_to signage_loc_path(:id => @signage_loc.id, :topic => "Details"), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @signage_loc }
      else
        format.html { render :new }
        format.json { render json: @signage_loc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signage_locs/1
  # PATCH/PUT /signage_locs/1.json
  def update
    respond_to do |format|
      if @signage_loc.update(signage_loc_params)
        format.html { redirect_to signage_loc(:id => @signage_loc.id, :topic => "Details"), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @signage_loc }
      else
        format.html { render :edit }
        format.json { render json: @signage_loc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signage_locs/1
  # DELETE /signage_locs/1.json
  def destroy
    @owner_id = @signage_loc.id
    @signage_loc.destroy
    respond_to do |format|
      format.html { redirect_to signage_loc_path(:id => @owner_id, :topic => "Details"), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage_loc
      @signage_loc = SignageLoc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_loc_params
      params.require(:signage_loc).permit(:name, :status, :privateonly, :owner_id, :owner_type, :geo_address, :address1, :address2, :address3, :res_v, :res_h, :price, :avatar)
    end
end
