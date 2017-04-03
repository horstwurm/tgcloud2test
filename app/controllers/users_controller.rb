class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def webmaster
    if @user.webmaster == true
      @user.webmaster = false
    else
      @user.webmaster = true
    end
    @user.save
    redirect_to @user, notice: 'Webmaster '  
  end
  
  def ticketstatus
    if params[:userticket_id]
      @ut = UserTicket.find(params[:userticket_id])
      case params[:status]
        when "zurückgeben"
          @ut.status = "zurückgegeben"
        when "aktivieren"
          @ut.status = "aktiv"
        when "einlösen"
          @ut.status = "eingelöst"
      end
      @ut.save
    end
    redirect_to user_path(:id => @ut.user_id, :topic => "Tickets"), notice: 'Ticketstatus successfully updated '  
  end
  
  def index
    @controller_name = controller_name
    if params[:page] != nil
      session[:page] = params[:page]
    end
    @filter = params[:filter_id]
    @users = User.search(params[:filter_id],params[:search]).order(created_at: :desc).page(params[:page]).per_page(10)
    @usanz = @users.count
     counter = 0 
     @locs = "["
     @wins = "["
     @users.each do |u|

        if u.longitude and u.latitude and u.geo_address
       
          @locs = @locs + "["
          @locs = @locs + "'" + u.fullname + "', "
          @locs = @locs + u.latitude.to_s + ", "
          @locs = @locs + u.longitude.to_s
          if counter+1 == @usanz
            @locs = @locs + "]"
          else
            @locs = @locs + "],"
          end
  
          @wins = @wins + "["
          @wins = @wins + "'<img src=" + u.avatar(:small) + "<br><h3>" + u.fullname + "</h3><p>" + u.geo_address + "</p>'"
          if counter+1 == @usanz
            @wins = @wins + "]"
          else
            @wins = @wins + "],"
          end

        end

        counter = counter + 1
      end
      @locs = @locs + "]"
      @wins = @wins + "]"
     
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
     
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    
    if params[:header] != nil and params[:body] != nil
      UserMailer.send_message(params[:id], params[:header], params[:body]).deliver_now
    end
    
     if params[:trx_status_ok_id]
       @trx = Transaction.find(params[:trx_status_ok_id])
       if @trx
         @trx.status = "freigegeben"
         @trx.save
       end
     end
     if params[:trx_status_ausgefuehrt_id]
       @trx = Transaction.find(params[:trx_status_ausgefuehrt_id])
       if @trx
         @trx.status = "ausgeführt"
         @trx.save
       end
     end

     if params[:topic]
       @topic = params[:topic]
     else 
       @topic = "Info"
     end 

    if params[:topic] == "Kalendereintraege"
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
      end
      
      if params[:confirm_id]
        @appoint = Appointment.find(params[:confirm_id])
        if @appoint
          @appoint.confirmed = true
          @appoint.save
        end
      end
      if params[:noconfirm_id]
        @appoint = Appointment.find(params[:noconfirm_id])
        if @appoint
          @appoint.confirmed = false
          @appoint.save
        end
      end
      if false
      @start = Date.commercial(session[:year],session[:cw],1)
      @appointments = Appointment.search(@user.id, session[:cw], session[:year]).order(app_date: :asc)
      @appanz = @appointments.count
      @subject = params[:subject]
      end

      counter = 0 
      @array = ""
      @cals = Appointment.where('user_id1=? and active=?', @user.id, true)
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
      @calstart = c.app_date.strftime("%Y-%m-%d")+"T"+time_from+":00"
      @calend = c.app_date.strftime("%Y-%m-%d")+"T"+time_to+":00"
      
      counter = counter + 1
      @array = @array + "{"
      if c.user_id1 == c.user_id2
        @array = @array + "color: '#E0E0E0',"
      else
        if c.confirmed
          @array = @array + "color: '#ACC550',"
        else
          @array = @array + "color: '#61A6A7',"
        end
      end
      @array = @array + "textColor: 'white',"
      user = User.find(c.user_id2)
      case c.channel
        when "Geschäftsstelle"
           icon = '<i class="glyphicon glyphicon-briefcase"></i>'
        when "Treffpunkt"
           icon = '<i class="glyphicon glyphicon-map-marker"></i>'
        when "Wohnort Berater"
           icon = '<i class="glyphicon glyphicon-home"></i>'
        when "Wohnort Kunde"
           icon = '<i class="glyphicon glyphicon-home"></i>'
        when "Telefon"
           icon = '<i class="glyphicon glyphicon-phone-alt"></i>'
        when "VideoChat"
           icon = '<i class="glyphicon glyphicon-facetime-video"></i>'
        else
           icon = '<i class="glyphicon glyphicon-question-sign"></i>'
      end
      @array = @array + "icon: '" + icon + "', "
      if user
        @array = @array + "title: '" + user.name + " " + user.lastname + "', "
      else
        @array = @array + "title: 'unknown', "
      end
      @array = @array + "start: '" + @calstart + "', "
      @array = @array + "end: '" + @calend + "', "
      @array = @array + "url: '" + user_path(:id => c.user_id2, :topic => "Info") +"'" 
      @array = @array + "}"
      if @cals.count >= counter
        @array = @array + ", "
      end
      
   end
      
      
      
    end

    if @topic == "Favoriten"
     counter = 0 
     @locs = "["
     @wins = "["
     @favourits = Favourit.where('user_id=? and object_name=?', @user.id, "User") 
     @favourits.each do |f|
        u = UserPosition.where('user_id=?',f.object_id).last
        if u
          if u.longitude and u.latitude and u.geo_address
            @locs = @locs + "["
            @locs = @locs + "'" + u.user.fullname + "', "
            @locs = @locs + u.latitude.to_s + ", "
            @locs = @locs + u.longitude.to_s
            if counter+1 == @favourits.count
              @locs = @locs + "]"
            else
              @locs = @locs + "],"
            end
    
            @wins = @wins + "["
            @wins = @wins + "'<img src=" + u.user.avatar(:medium) + "<br><h3>" + u.user.fullname + "</h3><p>" + u.user.geo_address + "</p>'"
            if counter+1 == @favourits.count
              @wins = @wins + "]"
            else
              @wins = @wins + "],"
            end
          end
          counter = counter + 1
        end
      end
      @locs = @locs + "]"
      @wins = @wins + "]"
    end

    if @topic == "Info"
     counter = 0 
     @locs = "["
     @wins = "["
     @up = @user.user_positions.limit(20).order(created_at: :desc)
     @count = @up.count
     @up.each do |u|
        if u.longitude and u.latitude and u.geo_address
          @locs = @locs + "["
          @locs = @locs + "'" + u.user.fullname + "', "
          @locs = @locs + u.latitude.to_s + ", "
          @locs = @locs + u.longitude.to_s
          if counter+1 == @up.count
            @locs = @locs + "]"
          else
            @locs = @locs + "],"
          end
  
          @wins = @wins + "["
          @wins = @wins + "'<h3>" + u.created_at.strftime("%d.%m.%Y") + "</h3><p>" + u.geo_address + "</p>'"
          if counter+1 == @up.count
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

      @array_s = ""
      @array_s = @user.build_stats(@array_s, Appointment.where('user_id1=? or user_id2=?',@user.id,@user.id), "Kalendereintraege" )
      @array_s = @user.build_stats(@array_s, @user.companies, "Institutionen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Angebote'), "Angebote" )
      @array_s = @user.build_stats(@array_s, @user.madvisors, "Ansprechpartner" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Kleinanzeigen'), "Kleinanzeigen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Stellenanzeigen'), "Stellenanzeigen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Vermietungen'), "Vermietungen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Veranstaltungen'), "Veranstaltungen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Ausschreibungen'), "Ausschreibungen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Ausflugsziele'), "Ausflugsziele" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Artikel'), "Artikel" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Publikationen'), "Publikationen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Umfragen'), "Umfragen" )
      @array_s = @user.build_stats(@array_s, @user.mobjects.where('mtype=?','Crowdfunding'), "Crowdfunding" )
      @array_s = @user.build_stats(@array_s, @user.mstats, "Crowdfunding Beitraege" )            if false
      @array_s = @user.build_stats(@array_s, @user.user_tickets, "Tickets" ) 
      @array_s = @user.build_stats(@array_s, @user.mratings, "Bewertungen" )
      @array_s = @user.build_stats(@array_s, @user.favourits, "Favoriten" )
      @array_s = @user.build_stats(@array_s, @user.customers, "Kundenstatus" )
      @array_s = @user.build_stats(@array_s, @user.transactions.where('ttype=?', "Payment"),"Transaktionen")
      @array_s = @user.build_stats(@array_s, Email.where('m_to=? or m_from=?', @user.id, @user.id), "Nachrichten" )
      @array_s = @user.build_stats(@array_s, @user.searches, "Abfragen" )
      @array_s = @array_s[0, @array_s.length - 1]
  end

  # GET /users/new
  def new
    # @user = User.new
    # @user.superuser = false
    # if params[:mode] = "signin"
    #   @user.userid = params[:user_id]
    #   @user.active = true
    # end
  end

  # GET /users/1/edit
  def edit
    #@user.status = "changed"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        
        # send eMail
        puts "ATTENTION ATTENTION here we go...."
        UserMailer.signup_confirmation(@user, "newKMU Sign In Confirmation").deliver_now
        
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:calendar, :time_from, :time_to, :status, :dateofbirth, :email, :active, :anonymous, :webmaster, :userid, :lastname, :name, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :org, :title, :costrate, :costinfo1, :avatar )
    end
    
end
