class ShowcalController < ApplicationController

  def index
    
    if false
      if params[:page]
        session[:page] = params[:page]
      end
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
      @mobjects = Mobject.search(session[:cw], session[:year], params[:filter_id], params[:mtype], params[:msubtype], params[:search]).order(created_at: :desc).page(params[:page]).per_page(100)
      @mobanz = @mobjects.count
      @mtype = params[:mtype]
      @msubtype = params[:msubtype]
  
      session[:mtype] = params[:mtype]
      session[:msubtype] = params[:msubtype]

     if params[showcal_index_path]
       @test = params[showcal_index_path][:domain]
     else
       @test = "veranstaltungen"
     end
     
   end
   
   @domain = params[:dom]
   counter = 0 
   @array = ""
   case @domain
    when "Geburtstage"
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
                @array = @array + "url : '" + user_path(:id => @user.id, :topic => "personen_info") +"'" 
                @array = @array + "}"
                if current_user.favourits.count >= counter
                  @array = @array + ", "
                end  
              end
            end
        end
        
    when "Veranstaltungen", "crowdfunding", "aktionen", "ausschreibungen", "stellenanzeigen"
      if params[:filter_id]
        @mobjects = Mobject.search(nil, nil, params[:filter_id], nil, nil, nil)
      else
        if @domain == "Aktionen"
          @mobjects = Mobject.where('mtype=? and msubtype=?', "angebote", "aktion")
          #@mobjects = Mobject.search(session[:cw], session[:year], params[:filter_id], "Angebote", "Aktion", params[:search]).order(created_at: :desc).page(params[:page]).per_page(100)
        else
          @mobjects = Mobject.where('mtype=?', @domain)
          #@mobjects = Mobject.search(session[:cw], session[:year], params[:filter_id], @test, nil, params[:search]).order(created_at: :desc).page(params[:page]).per_page(100)
        end
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

    if @domain == "geburtstage"
       counter = 0 
       @locs = "["
       @wins = "["
       @users.each do |m|

         if m.object_name == "User" 
           @user = User.find(m.object_id)
           if @user and @user.latitude and @user.longitude and @user.geo_address
              @locs = @locs + "["
              @locs = @locs + "'" + @user.fullname + "', "
              @locs = @locs + @user.latitude.to_s + ", "
              @locs = @locs + @user.longitude.to_s
              if counter+1 == @users.count
                @locs = @locs + "]"
              else
                @locs = @locs + "],"
              end
              @wins = @wins + "["
              if @user.avatar
                @wins = @wins + "'<img src=" + @user.avatar(:small) + "><br><h3>" + @user.fullname + "</h3><p>" + @user.geo_address + "<br>"+ @user.dateofbirth.strftime("%d.%m.%Y") +"</p>'"
              end
              if counter+1 == @users.count
                @wins = @wins + "]"
              else
                @wins = @wins + "],"
              end
              counter = counter + 1
           end
           
         end
       end
       @locs = @locs + "]"
       @wins = @wins + "]"

    else
      
       counter = 0 
       @locs = "["
       @wins = "["
       @mobjects.each do |m|
         if m.latitude and m.longitude and m.geo_address
            @locs = @locs + "["
            if m.owner_type == "User"
              @locs = @locs + "'" + m.owner.fullname + "', "
            else
              @locs = @locs + "'" + m.owner.name + "', "
            end
            @locs = @locs + m.latitude.to_s + ", "
            @locs = @locs + m.longitude.to_s
            if counter+1 == @mobjects.count
              @locs = @locs + "]"
            else
              @locs = @locs + "],"
            end
      
            @wins = @wins + "["
            if m.mdetails.count > 0
              @wins = @wins + "'<img src=" + m.mdetails.first.avatar(:small) + "><br><h3>" + m.name + "</h3><p>" + m.geo_address + "<br>"+ m.date_from.strftime("%d.%m.%Y") + " - " + m.date_from.strftime("%d.%m.%Y") +"</p>'"
            else
              @wins = @wins + "'<img src=" + m.owner.avatar(:small) + "><br><h3>" + m.name + "</h3><p>" + m.geo_address + "<br>"+ m.date_from.strftime("%d.%m.%Y") + " - " + m.date_from.strftime("%d.%m.%Y") +"</p>'"
            end
            if counter+1 == @mobjects.count
              @wins = @wins + "]"
            else
              @wins = @wins + "],"
            end
            counter = counter + 1
         end
       end
       @locs = @locs + "]"
       @wins = @wins + "]"

    end

end

end
