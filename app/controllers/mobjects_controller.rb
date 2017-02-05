class MobjectsController < ApplicationController
  before_action :set_mobject, only: [:show, :edit, :update, :destroy]

  # GET /mobjects
  def index

    @controller_name = controller_name
    
    if params[:set_part_id]
      @anmeldung = current_user.participants.where('mobject_id=?', params[:set_part_id]).first
      if !@anmeldung
        @participant = Participant.new
        @participant.user_id = current_user.id
        @participant.mobject_id = params[:set_part_id]
        @participant.save
      end
    end
    if params[:del_part_id]
      @anmeldung = current_user.participants.where('mobject_id=?', params[:del_part_id]).first
      if @anmeldung
        @anmeldung.destroy
      end
    end
    
    if params[:mtype]
      session[:mtype] = params[:mtype]
      case params[:mtype]
        when "Kleinanzeigen", "Stellenanzeigen", "Crowdfunding", "Angebote"
          if params[:msubtype]
            session[:msubtype] = params[:msubtype]
          end
        else
            session[:msubtype] = nil
      end
    end
    
    @mobjects = Mobject.search(nil, nil, params[:filter_id], session[:mtype], session[:msubtype], params[:search]).order(created_at: :desc).page(params[:page]).per_page(10)
    @mobanz = @mobjects.count
    @mtype = session[:mtype]
    @msubtype = session[:msubtype]
    @param = params[:filter_id]
    @search = params[:search]

     counter = 0 
     @locs = "["
     @wins = "["
     @mobjects.each do |u|

        if u.longitude and u.latitude and u.geo_address
       
          @locs = @locs + "["
          @locs = @locs + "'" + u.name + "', "
          @locs = @locs + u.latitude.to_s + ", "
          @locs = @locs + u.longitude.to_s
          if counter+1 == @mobanz
            @locs = @locs + "]"
          else
            @locs = @locs + "],"
          end
  
          @wins = @wins + "["
          if u.mdetails.count > 0
            if u.mdetails.first.avatar_file_name 
              img = url_for(u.mdetails.first.avatar(:small))
            else
              img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
            end
          else
            img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
          end
          @wins = @wins + "'<img src=" + img + " <br><h3>" + u.name + "</h3><p>" + u.geo_address + "</p>'"
          if counter+1 == @mobanz
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

  # GET /mobjects/1
  def show
    if params[:confirm_id]
      calEntry = Mcalendar.find(params[:confirm_id])
      if calEntry
        calEntry.confirmed = true
        calEntry.save
      end
    end
    if params[:noconfirm_id]
      calEntry = Mcalendar.find(params[:noconfirm_id])
      if calEntry
        calEntry.confirmed = false
        calEntry.save
      end
    end
    if !params[:topic]
      @topic = "Info"
    else
      @topic = params[:topic]
    end
    if false
    if !session[:cw]
      session[:cw] = Date.today.cweek.to_i
    end
    if !session[:year]
      session[:year] = Date.today.cwyear.to_i
    end
    if params[:dir]
      case params[:dir]
        when ">"
          if session[:cw] == 52
            session[:cw] = 1
            session[:year] = session[:year].to_i + 1
          else
            session[:cw] = session[:cw].to_i + 1
          end
        when "<"
          if session[:cw] == 1
            session[:cw] = 52
            session[:year] = session[:year].to_i - 1
          else
            session[:cw] = session[:cw].to_i - 1
          end
      end
    end
    @start = Date.commercial(session[:year],session[:cw],1)
    @calendars = Mcalendar.search(@mobject.id, session[:cw], session[:year]).order(date_from: :asc)
    @calanz = @calendars.count
    end
    
    @mobjects_anz = Mstat.select("date(created_at) as datum, count(amount) as summe").where('mobject_id = ?', @mobject.id).group("date(created_at)")
    @mobjects_bet = Mstat.select("date(created_at) as datum, sum(amount) as summe").where('mobject_id = ?', @mobject.id).group("date(created_at)")

    @anz_s = ""
    @mobjects_anz.each do |i|
      @anz_s = @anz_s + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_s = @anz_s[0, @anz_s.length - 1]    

    @bet_s = ""
    @mobjects_bet.each do |i|
      @bet_s = @bet_s + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @bet_s = @bet_s[0, @bet_s.length - 1]
    
   counter = 0 
   @array = ""
   @cals = @mobject.mcalendars
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
      @array = @array + "title: '" + c.user.name + " " + c.user.lastname + "', "
      @array = @array + "start: '" + @calstart + "', "
      @array = @array + "end: '" + @calend + "', "
      @array = @array + "url: '" + user_path(:id => c.user.id, :topic => "Info") +"'" 
      @array = @array + "}"
      if @cals.count >= counter
        @array = @array + ", "
      end
      
   end
    
  end

  # GET /mobjects/new
  def new
    @mobject = Mobject.new
    @mobject.status = "OK"
    @mobject.eventpart = false
    @mobject.mtype = params[:mtype]
    @mobject.msubtype = params[:msubtype]
    @mobject.mcategory_id = params[:msubtype]
    @mobject.active = true
    @mobject.social = false
    @mobject.name = @mobject.mtype
    @mobject.description = "Beschreibung..."
    @mobject.homepage = "www.xyz.ch"
    @mobject.price_reg = 0
    @mobject.price_new = 0
    @mobject.date_from = Date.today
    @mobject.date_to = Date.today+30
    @mobject.time_from = 7
    @mobject.time_to = 18
    @mobject.amount = 10000.00
    @mobject.price = 100.00
    @mobject.reward = "Belohnung..."
    @mobject.interest_rate = 5
    @mobject.due_date = Date.today + 365
    @mobject.sum_amount = 0
    @mobject.sum_rating = 0

    if params[:user_id]
      @mobject.owner_id = params[:user_id]
      @mobject.owner_type = "User"
    end
    if params[:company_id]
      @mobject.owner_id = params[:company_id]
      @mobject.owner_type = "Company"
    end
    @mobject.address1 = @mobject.owner.address1
    @mobject.address2 = @mobject.owner.address2
    @mobject.address3 = @mobject.owner.address3
    @mobject.geo_address = @mobject.owner.geo_address
    @mobject.longitude = @mobject.owner.longitude
    @mobject.latitude = @mobject.owner.latitude

    case params[:mtype]
      when "Angebote"
        case params[:msubtype]
          when "Standard"
          when "Aktion"
        end
      when "Veranstaltungen"
      when "Ausscheibungen"
      when "Ausflugsziele"
      when "Crowdfunding"
        case params[:msubtype]
          when "Spenden"
          when "Belohnungen"
          when "Zinsen"
        end
      when "Kleinanzeigen"
      when "Stellenanzeigen"
      when "Vermietungen"
    end
  end

  # GET /mobjects/1/edit
  def edit
  end

  # POST /mobjects
  def create
    @mobject = Mobject.new(mobject_params)

    if @mobject.save
      redirect_to @mobject, notice: 'Mobject was successfully created.'
    else
      render :new
    end
  end

  # PUT /mobjects/1
  def update
    if @mobject.update(mobject_params)
      redirect_to @mobject, notice: 'Mobject was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /mobjects/1
  def destroy
    @ownerid = @mobject.owner_id
    @ownertype = @mobject.owner_type
    @mtype = @mobject.mtype
    @msubtype = @mobject.msubtype
    @mobject.destroy
    if @ownertype == "User"
      redirect_to user_path(:id => @ownerid), notice: 'Mobject was successfully destroyed.'
    else
      redirect_to company_path(:id => @ownerid), notice: 'Mobject was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobject
      @mobject = Mobject.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def mobject_params
      params.require(:mobject).permit(:eventpart, :owner_id, :owner_type, :mtype, :msubtype, :mcategory_id, :company_id, :user_id, :status, :name, :description, :reward, :interest_rate, :due_date, :date_from, :date_to, :time_from, :time_to, :days, :amount, :price, :tasks, :skills, :offers, :social, :price_reg, :price_new, :active, :keywords, :homepage, :address1, :address2, :address3, :latitude, :longitude, :geo_address)
    end

end
