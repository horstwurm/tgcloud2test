class HomeController < ApplicationController

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
  if params[:ticket]
    @ticket = UserTicket.find(params[:ticket])
    if @ticket
      @status = "Ticket gültig"
    else
      @status = "Ticket ungültig"
    end
  end
end

def index2
    @users = User.all.order(last_sign_in_at: :desc).page(params[:page]).per_page(20)
    @usanz = @users.count
end

def index3
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
  
def index8
  @mtype = params[:mtype]
  @user_id = params[:user_id]
  @company_id = params[:company_id]
end

def index9
  @array = []
  @array << "Branche"
  @array << "Angebote"
  @array << "Vermietungen"
  @array << "Veranstaltungen"
  @array << "Ausflugsziele"
  @array << "Kleinanzeigen"
  @array << "Crowdfunding"
  @array << "Ticket"
end

end
