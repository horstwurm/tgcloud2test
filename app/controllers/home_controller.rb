class HomeController < ApplicationController

def nutzung
end

def index
    @users = User.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_pk = ""
    @users.each do |i|
      @anz_pk = @anz_pk + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_pk = @anz_pk[0, @anz_pk.length - 1]    

    @companies = Company.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_fk = ""
    @companies.each do |i|
      @anz_fk = @anz_fk + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_fk = @anz_fk[0, @anz_fk.length - 1]    

    @objects = Mobject.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_obj = ""
    @objects.each do |i|
      @anz_obj = @anz_obj + "['" + i.datum.to_s + "', " + i.summe.to_s + "],"
    end
    @anz_obj = @anz_obj[0, @anz_obj.length - 1]    

  if user_signed_in?
    #redirect_to current_user
  end
end

def index1
  if user_signed_in?
    case params[:status] 
      when "einlösen"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "eingelöst"
          @ticket.save
        end
      when "reaktivieren"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "aktiv"
          @ticket.save
        end
    end
    if params[:me]
      @ticket = UserTicket.where('id=?',params[:me]).first
      if @ticket
        if @ticket.owner_type == "Msponsor"
          if @ticket.ticket.msponsor.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.msponsor.company.user.name + " " + @ticket.ticket.msponsor.company.user.lastname + "!"
          end
        end
        if @ticket.owner_type == "Mobject"
          if @ticket.ticket.owner.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.owner.company.user.name + " " + @ticket.ticket.owner.company.user.lastname + "!"
          end
        end
        if @ticket.status == "aktiv"
          @ticket_status = "Ticket gültig"
        else
          @ticket_status = "Ticket ungültig"
          @status_reason = "Ticketstatus muss 'aktiv' sein!, ist aber " + @ticket.status 
        end
      end
    end
  else
    redirect_to home_index7_path, notice: "Kein Benutzer angemeldet!"
  end
end

def index2
    @users = User.all.order(last_sign_in_at: :desc).page(params[:page]).per_page(20)
    @usanz = @users.count
end

def index3
  session[:page] = nil
end

def index4
    @users = User.all.last
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      if user.latitude != nil and user.longitude != nil
        marker.lat user.latitude
        marker.lng user.longitude
        marker.infowindow "<a href=/users/" + user.id.to_s + ">" + user.name + "</a>"
        if user.avatar 
          marker.picture :url => url_for(user.avatar(:small)), :width => 50, :height => 50
        else
          marker.picture :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|", :width => 50, :height => 50
        end
      end
     end
     @hash.push({lat: request.location.latitude, lng: request.location.longitude, infowindow: "img src="+url_for(User.find(1).avatar(:small)) })

@user = current_user
@lat = request.location.latitude
@lng = request.location.longitude 
@text = @lat.to_s + "/" + @lng.to_s
end

def index5
  @test = DonationStat.select("date(created_at) as datum, count(amount) as summe").group("date(created_at)")

  @array = []
  @cat = Category.all
  @cat.each do |c|
    anz = Company.where('category_id=?', c.id).count
    if anz > 0
      hash = Hash.new
      hash = {"label" => c.name, "value" => anz}
      @array << hash
    end
  end
  
  @array.each do |a|
    puts a.to_s
  end
  
end

def index6
  @searches = Search.where('user_id=?', current_user.id).order(:mtype)
end

def index7
 if params[home_index7_path]
   @test = params[home_index7_path][:domain]
 else
   @test = "Veranstaltungen"
 end 
 counter = 0 
 @array = ""
 case @test
  when "Geburtstage Favoriten"
     @users = current_user.favourits
     @anz = @users.count
     @users.each do |u|
          if u.object_name == "User" 
            @user = User.find(u.object_id)
            if @user and @user.dateofbirth

              @caldate = Date.today.year.to_s + "-" + @user.dateofbirth.strftime("%m-%d")
              
              counter = counter + 1
              @array = @array + "{"
              @array = @array + "color : '#ACC550',"
              @array = @array + "textColor : 'white',"
              @array = @array + "title : '" + @user.name + " " + @user.lastname + "', "
              @array = @array + "start : '" + @caldate + "', "
              @array = @array + "url : '" + user_path(:id => @user.id, :topic => "personen_nfo") +"'" 
              @array = @array + "}"
              if current_user.favourits.count >= counter
                @array = @array + ", "
              end  
            end
          end
      end
      
  when "Veranstaltungen", "Crowdfunding", "Aktionen", "Ausschreibungen", "Stellenanzeigen"
    if @test == "Aktionen"
      @mobjects = Mobject.where('mtype=? and msubtype=?', "Angebote", "Aktion")
    else
      @mobjects = Mobject.where('mtype=?', @test)
    end
    @anz = @mobjects.count
    @mobjects.each do |u|
          if u.date_from
            counter = counter + 1
            @array = @array + "{"
            @array = @array + "color : '#ACC550',"
            @array = @array + "textColor : 'white',"
            @array = @array + "title : '" + u.name + "', "
            @array = @array + "start : '" + u.date_from.to_s + "', "
            if u.date_to
              @array = @array + "end : '" + u.date_to.to_s + "', "
            end
            @array = @array + "url : '" + mobject_path(:id => u.id, :topic => "objekte_info") +"'" 
            @array = @array + "}"
            if @mobjects.count >= counter
              @array = @array + ", "
            end  
          end
      end
  end
end
  
def index8
  @mtype = params[:mtype]
  @user_id = params[:user_id]
  @company_id = params[:company_id]
end

def index9
  @categories = Mcategory.select("ctype").distinct
end

def index10
  if user_signed_in?
    
    if params[:day]
      @n = params[:day].to_i
    else
      @n=1
    end
    
    # follow Tickets
    @usertickets = UserTicket.where('user_id=? and (status=? or status=?) and created_at>=?', current_user.id, "übergeben", "persönlich", @n.day.ago).order(created_at: :desc)

    # follow Favoriten
    @favourits = current_user.favourits.where('created_at>=?',@n.day.ago).order(created_at: :desc)

    # follow Termine
    @appointments = Appointment.where('user_id1=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Transaktionen
    @transactions = current_user.transactions.where('created_at>=?', @n.day.ago ).order(created_at: :desc)
    
    @customers = current_user.customers.order(created_at: :desc)

    # follow eMails
    @emails  = Email.where('m_to=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Objects from Favouriten
    @mobjects = current_user.mobjects.order(created_at: :desc)

    # follow Searches
    @searches = current_user.searches.order(created_at: :desc)
    
  end    
end

def index11
  if params[:kam_id]
    @campaign = Mobject.find(params[:kam_id])
    @company = @campaign.owner
    @signages = @campaign.mdetails
    @location = nil
  end
  if params[:loc_id]
    @location = Mobject.find(params[:loc_id])
    @company = @location.owner
    @campaigns = SignageCal.where('mstandort=?',params[:loc_id])
    @signages = nil
  end
  
end

def index12
end

def index13
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
end

def index14
  random = Random.new(Time.new.to_i)
  ra1 = rand(100)+1
  
  @anz_obj = []
  for i in 0..ra1
    temp = Hash.new
    temp = {"Nummer"+ i.to_s => i}
    @anz_obj << temp
  end
end

def dashboard_data
    respond_to do |format|
      format.json 
        msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]
        render :json => msg.to_json
    end
end

def dashboard2_data
    respond_to do |format|
      format.json 
        msg = []
        msg << {:kategorie => "User", :anzahl => User.all.count}
        msg << {:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count}
        @cats = Mobject.select("mtype").distinct
        @cats.each do |c|
          count = Mobject.where('mtype=?', c.mtype).count
          if count > 0
            msg << {:kategorie => c.mtype, :anzahl => count}
          end
        end
        render :json => msg.to_json
    end
end

def dashboard_projectdata

  @mobject = Mobject.find(params[:pid])
  @prolist = [@mobject.id]
  @mobject.wo_iterate(@mobject.id, true, @prolist)
  @projects = Mobject.where("mtype=? and id in (?)", "projekte", @prolist)
  msg = []
  @projects.each do |p|
    @kosten = p.timetracks.where('costortime=?',"kosten").sum(:amount)
    @aufwand = p.timetracks.where('costortime=?',"aufwand").sum(:amount)
    if @kosten
      msg << {:id => p.id, :kategorie => "kosten", :summe => @kosten}
    end
    if @aufwand
      msg << {:id => p.id, :kategorie => "aufwand", :summe => @aufwand}
    end 
  end
  respond_to do |format|
    format.json
      render :json => msg.to_json
  end
end

def dashboard
end

def index15
  @question = Question.find(params[:question_id])
  
  if @question.mcategory.name == "text" or @question.mcategory.name == "numerisch" 
    if @question.answers.count == 0
      @a = Answer.new
      @a.question_id = @question.id
      @a.name = "Bitte angeben"
      @a.save
    end  
  end
  
  if params[:user_answer_id]
    @ua = UserAnswer.find(params[:user_answer_id])
    @a = @ua.answer
    
    if @question.mcategory.name == "single"
      @question.answers.each do |qa|
        @uai = UserAnswer.where('user_id=? and answer_id=?', current_user.id, qa.id).first
        if @uai and @uai.checker
          @uai.checker = false
          @uai.save
        end
      end
    end
    if @ua
      if @question.mcategory.name == "multiple"
        if @ua.checker
          @ua.checker = false
        else
          @ua.checker = true
        end
      else
        @ua.checker =true
      end
      @ua.save
    end
  end
end


def index16
  @question = Question.find(params[:question_id])
end

def index17
  if params[:mailgunflag]
    $usemailgun = true
  else
    $usemailgun = false
  end
  #UserMailer.welcome_email(User.last).deliver_now
  redirect_to home_index3_path
end

def index18
  
  @array = []
  #@array << ['alle', "TKB", "TKB"]
  @projects = Mobject.all
  @projects.each do |p|
    #h = Hash.new
    #h = {"alle Projekte"}
    if p.parent and p.parent > 0
      @par = Mobject.find(p.parent).name
    else
      @par = "TKB"
    end
    #@array << [p.name, @par, p.name]
    @array << [ ("<a href=/mobjects/" + p.id.to_s + ">" + p.name + "</a>"), @par, p.name]
  end
  #@array = []
  #@array << ["root", "ich", "root"]
end

def import
    path=File.join(Rails.root, "/app/assets/images/mig2017.xlsx")
    workbook = Creek::Book.new path
    @worksheets = workbook.sheets
end

def Umfragen_data

    @question = Question.find(params[:question_id])
  
    @array = []
    @question.answers.each do |qa|
      
      anz = qa.user_answers.where('checker=?',true).count
      
      hash = Hash.new
      hash = {:kategorie => qa.name, :anzahl => anz.to_s}
      @array << hash
      
    end

    #msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]

    respond_to do |format|
      format.json 
        render :json => @array.to_json
    end

end

def dashboard_project
end

def readsensordata
  if params[:sensor]
    @sensor = Mobject.find(params[:sensor])
    @iots = @sensor.sensors.order(:created_at)
  else
    @iots = Sensor.all.order(:created_at)
  end
  respond_to do |format|
    format.json 
      msg = []
      #msg << {:datum => "Datum", :wert => "Wert"}
      @iots.each do |i|
          msg << {:datum => i.created_at.strftime("%H:%m"), :wert => i.value}
      end
      render :json => msg.to_json
  end
end

def writesensordata
  if params[:sensor] and params[:value]
    @sensor = Sensor.new
    @sensor.mobject_id = params[:sensor]
    @sensor.value = params[:value]
    @sensor.save
  end
  @sensors = Mobject.find(params[:sensor]).sensors
  msg = []
  if @sensors and @sensors.count > 0 
    msg << {:type => "Anzahl", :anzahl => @sensors.count}
  else
    msg << {:type => "Anzahl", :anzahl => 0}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

end