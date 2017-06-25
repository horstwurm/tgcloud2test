module UsersHelper

def qrcodeimg(mobject, size)

  mtype = mobject.class.table_name
  mid = mobject.id
  
  content = "http://tkbmarkt.herokuapp.com"+url_for(mobject)

  @qr = Qrcode.where('mobject_type=? and mobject_id=?', mobject.class.table_name, mobject.id).first

  if !@qr
    qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
    qr_img = qr.to_img
    qr_img.resize(200, 200).save("app_qrcode.png")
    @qr = Qrcode.new
    @qr.mobject_type= mtype
    @qr.mobject_id = mid
    @qr.avatar = File.open("app_qrcode.png")
    @qr.save
  end

  hash = Hash.new
  hash = {"qr_text" => content, "qr_code" => image_tag(@qr.avatar(:small)) }
  return hash

end

def small_carousel(company, size)

    html = ""
    html = html +  '<div class="owl-show2">'
    mobjects = company.mobjects
    mobjects.each do |m|

      #m.mdetails.each do |s|
        #if s.avatar_file_name
          html = html + "<div align=center>"+ (showFirstImage2(:medium, m, m.mdetails)) + "<h4>" + m.mtype + ": " + m.name + "</h4><p>" + "</p></div>"
        #end
        
      #end
      
      m.mratings.last(1).each do |r|
        if r.user.avatar_file_name
          html = html + "<div align=center>"+ (showImage2(:medium, r.user, true)) + "<h4>" + r.comment + "</h4><p>" + r.user.name + " " + r.user.lastname + "</p></div>"
        end
      end
    end
    
    html = html +  "</div>"
    return html.html_safe
end

def carousel(signages, size, text)
    html = ""
    html = html +  '<div class="owl-show">'
    signages.each do |s|
      if s.avatar_file_name == nil
        html = html + "<div>" + image_tag(image_def("Signage", "", ""), :size => size, class:"card-img-top img-responsive" ) + "</div>"
      else
        html = html + "<div align=center>"+ (image_tag s.avatar(:native), class:"img-rounded img-rounded") + "<h2>" + s.header + "</h2>" + s.description + "</div>"
      end
    end
    html = html +  "</div>"
    return html.html_safe
end

def carousel2(mobject, size)
    html = ""
    if mobject.mdetails == nil
      html = html + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" )
    else
      if mobject.mdetails.count == 0
        html = html + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" )
      else
        html = html +  '<div class="owl-show">'
        mobject.mdetails.each do |p|
          
          html = html + "<div class='row'>"

            html = html + "<div class='col-xs=12'>"
              if p.avatar_file_name == nil
                html = html + "<div>" + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
              else
                html = html + "<div>"+ (image_tag p.avatar(size), class:"img-rounded") + "</div>"
              end
            html = html + "</div>"
              
            html = html + "<div class='col-xs=12'>"
              if p.name 
                html = html + "<b>"+p.name + "</b><br>"
              end
              if p.description
                html = html + p.description + "<br>"
              end
            html = html + "</div>"

            html = html + "<div class='col-xs=12'>"
              if p.document_file_name
                html = html + link_to(p.document.url, target: "_blank") do 
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-cloud-download")
                end
              end
            html = html + "</div>"

          html = html + "</div>"
              
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def sigcar(mobject)
    html = ""
    if mobject.signages == nil
    else
      if mobject.signages.count == 0
      else
        html = html +  '<div class="owl-show">'
        mobject.signages.each do |p|
          if p.avatar_file_name == nil
          else
            html = html + "<div>"+ (image_tag p.avatar(:medium), class:"img-rounded") + "</div>"
          end
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def align_text(txt)
    len = 30
    if txt == nil
        text = ""
    else
        if txt.length >= len
          text = txt[0,len]
        else
          text = txt
        end
    end
    return text + "..."
end

def build_medialist2(items, cname, par)

  priceAnz = 0
  html_string = "<br>"
      html_string = html_string + '<div class="row">'
  items.each do |item|
    
    show = true
    if cname == "nopartners"
      if par[:user_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "User", par[:user_id], item.id).first
      end
      if par[:company_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "Company", par[:company_id], item.id).first
      end
      if @customer
        show = false
      end
    end
    
    if item and show
      
      html_string = html_string + '<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 col-xl-4">'
        html_string = html_string + '<div class="thumbnail thumbnail-list">'
        
          html_string = html_string + '<div class="panel-body panel-listhead">'

            case items.table_name
                when "prices"
                  html_string = html_string + item.sequence.to_s + (I18n.t :nterpreis)
                when "crits"
                  html_string = html_string + item.name
                when "ideas"
                  priceAnz = priceAnz + 1
                  if priceAnz <= item.mobject.prices.count
                    html_string = html_string + '<fire><i class="glyphicon glyphicon-fire"></fire></i> '
                  end
                  html_string = html_string + item.header
                when "questions"
                  html_string = html_string + item.name
                when "edition_arcticles"
                  html_string = html_string + item.mobject.name
                when "editions"
                  html_string = html_string + item.name
                when "comments", "idea_crowdratings"
                  html_string = html_string + item.user.name + " " + item.user.lastname + " am " + item.created_at.strftime("%d.%m.%Y um %k:%M Uhr")
                when "tickets"
                  html_string = html_string + " " + item.name.to_s
                when "signages"
                  html_string = html_string + " " + item.header
                when "signage_locs"
                  html_string = html_string + item.name
                when "users"
                  html_string = html_string + item.name + " " + item.lastname
                when "companies", "mobjects", "mdetails", "signage_camps"
                  html_string = html_string + item.name
                when "searches"
                  html_string = html_string + (I18n.t :abfrage)
                when "customers"
                  @comp = Company.find(item.partner_id)
                  html_string = html_string + @comp.name
                when "madvisors", "participants", "mratings"
                  if par == "user"
                    html_string = html_string + item.user.name + " " + item.user.lastname
                  end
                  if par == "object"
                    html_string = html_string + item.mobject.name
                  end
                when "msponsors"
                  if par == "company"
                    html_string = html_string + item.company.name
                  end
                  if par == "object"
                    html_string = html_string + item.mobject.name
                  end
                when "favourits"
                  @item = Object.const_get(item.object_name).find(item.object_id)
                  if Object.const_get(item.object_name).to_s == "User"
                      html_string = html_string + @item.name + " " + @item.lastname 
                  end
                  if Object.const_get(item.object_name).to_s == "Company"
                      html_string = html_string + @item.name 
                  end
                when "transactions"
                  @ac_ver = Account.find(item.account_ver)
                  @customer = @ac_ver.customer
                  if @ac_ver.customer.owner_type == "User"
                      html_string = html_string + @customer.owner.name + " " + @customer.owner.lastname 
                  end
                  if @ac_ver.customer.owner_type == "Company"
                      html_string = html_string + @customer.owner.name 
                  end
                when "mstats"
                  if par == "cf"
                        html_string = html_string + item.mobject.name 
                  end
                  if par == "owner"
                    if item.owner_type == "User"
                        html_string = html_string + item.owner.name + " " + item.owner.lastname 
                    end
                    if item.owner_type == "Company"
                        html_string = html_string + item.owner.name 
                    end
                  end
            end

          html_string = html_string + '</div>'

          html_string = html_string + '<div class="row">'
            html_string = html_string + '<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">'
              html_string = html_string + '<div class="panel-header">'

                case items.table_name
                  when "prices"
                      html_string = html_string + showImage2(:medium, item, true)
                  when "crits"
                      if par
                        html_string = html_string + ""
                      else
                        html_string = html_string + "<rating>" + item.rating.to_s + "</rating>" 
                      end
                  when "ideas"
                    if par == "user"
                      html_string = html_string + showImage2(:medium, item.user, true)
                    end
                    if par == "idee"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                  when "edition_arcticles"
                    html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                  when "editions"
                    html_string = html_string + showImage2(:medium, item, true)
                  when "tickets"
                    html_string = html_string + showFirstImage2(:medium, item, item.owner.mdetails)
                  when "signage_camps"
                    html_string = html_string + showFirstImage2(:medium, item, item.signages)
                  when "comments", "idea_crowdratings"
                    html_string = html_string + showImage2(:medium, item.user, true)
                  when "users", "companies", "signages", "signage_locs", "articles"
                    html_string = html_string + showImage2(:medium, item, true)
                  when "mdetails"
                    html_string = html_string + showImage2(:medium, item, false)
                  when "msponsors"
                    if par == "company"
                      html_string = html_string + showImage2(:medium, item.company, true)
                    end
                    if par == "object"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                  when "mobjects"
                    html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
                  when "mstats"
                    if par == "cf"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                    if par == "owner"
                      html_string = html_string + showImage2(:medium, item.owner, true)
                    end
                  when "madvisors", "participants", "mratings"
                    if par == "object"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                    if par == "user"
                      html_string = html_string + showImage2(:medium, item.user, true)
                    end
                  when "favourits"
                    @item = Object.const_get(item.object_name).find(item.object_id)
                    if @item
                      html_string = html_string + showImage2(:medium, @item, true)
                    end
                  when "customers"
                      if @comp
                        html_string = html_string + showImage2(:medium, @comp, true)
                      end
                  when "searches"
                      if par != nil and par != ""
                        html_string = html_string + link_to(showcal_index_path(:filter_id => item.id, :dom => par)) do
                          content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.mtype)["icon"], style:"font-size:8em") 
                          #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                        end
                      else
                        html_string = html_string + "<soft_padding>"
                        case item.search_domain
                          when "privatpersonen"
                            html_string = html_string + link_to(users_path(:filter_id => item.id)) do
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "tickets"
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              html_string = html_string + image_tag(image_def("Privatpersonen", item.mtype, item.msubtype))
                          when "institutionen"
                            html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "objekte"
                            html_string = html_string + link_to(mobjects_path(:filter_id => item.id)) do
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.mtype), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                        end
                        html_string = html_string + "</soft_padding>"
                      end
                  when "transactions"
                    html_string = html_string + showImage2(:medium, @ac_ver.customer.owner, true)
                end

              html_string = html_string + '</div>'
            html_string = html_string + '</div>'

            html_string = html_string + '<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">'
              html_string = html_string + '<div class="panel-header panel-media"><list>'
                case items.table_name
                    when "idea_crowdratings"
                      if item.rating and item.rating > 0
                        item.rating.round.times do
                          html_string = html_string + '<i class="glyphicon glyphicon-star"></i> '
                        end
                        html_string = html_string + ' (' + sprintf("%.1f",item.rating) + ')<br>'
                      end
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + "<b>" + item.rating_text + "</b><br>"

                    when "prices"
                      html_string = html_string + '<i class="glyphicon glyphicon-gift"></i> '
                      html_string = html_string + item.name + "<br>"
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + "<b>" + item.description + "</b><br>"
                    when "crits"
                      if item.rating and item.rating > 0
                        html_string = html_string + '<div class="progress">'
                        html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + item.rating.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + item.rating.to_s + '%">'
                        html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                        html_string = html_string + '</div>'
                        html_string = html_string + '</div>'
                      end
                      if par #Idea_id
                        @idearating = IdeaRating.where('user_id=? and idea_id=? and crit_id=?', current_user.id, par, item.id).first
                        if !@idearating
                          @idearating = IdeaRating.new
                          @idearating.idea_id = par
                          @idearating.crit_id = item.id
                          @idearating.user_id = current_user.id
                          @idearating.rating = 0
                          @idearating.rating_text = "..."
                          @idearating.save
                        end
                        if @idearating and @idearating.rating > 0
                          html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                          html_string = html_string + '<div class="progress">'
                          html_string = html_string + '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar2" aria-valuenow="' + @idearating.rating.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + @idearating.rating.to_s + '%">'
                          html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                          html_string = html_string + '</div>'
                          html_string = html_string + '</div>'
                        end
                      end
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + "<b>" + item.description + "</b><br>"

                    when "ideas"
                      if item.crowdrating and item.crowdrating > 0
                        html_string = html_string + '<i class="glyphicon glyphicon-star"></i> '
                        html_string = html_string + "<rating>" 
                        item.crowdrating.round.times do
                          html_string = html_string + '<i class="glyphicon glyphicon-star"></i> '
                        end
                        html_string = html_string + "</rating>" 
                        html_string = html_string + sprintf("(%3.1f)",item.crowdrating) + "<br>" 
                      end
                      if item.rating
                        html_string = html_string + '<i class="glyphicon glyphicon-education"></i> '
                        html_string = html_string + "<rating>" + sprintf("%3.1f",item.rating) + "</rating><br>" 
                      end
                      
                      html_string = html_string + '<i class="glyphicon glyphicon-user"></i> '
                      html_string = html_string + item.user.name + " " + item.user.lastname + "<br>"
                      html_string = html_string + "<b>" + item.description + "</b><br>"
                      # html_string = html_string + showImage2(:small, item, false)
                      if item.avatar_file_name
                        #html_string = html_string + "Weitere Informationen: "
                        html_string = html_string + link_to(item.avatar.url, target: "_blank") do 
                          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-picture")
                        end
                      end
                      if item.document_file_name
                        #html_string = html_string + "Weitere Informationen: "
                        html_string = html_string + link_to(item.document.url, target: "_blank") do 
                          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-book")
                        end
                      end

                    when "edition_arcticles"
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + item.mobject.owner.name + " " + item.mobject.owner.lastname
                    when "editions"
                      html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                      if item.release_date 
                        html_string = html_string +  item.release_date.strftime("%d.%m.%Y") + '<br>'
                      end 
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + item.description
                    when "comments"
                      html_string = html_string + "<blog>'" + item.description + "'</blog>"
                    when "questions"
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + item.mcategory.name + '<br><br>'
                      
                      if item.mcategory.name == "single" or item.mcategory.name == "multiple" 

          	            html_string = html_string + link_to(new_answer_path(:question_id => item.id)) do 
                          content_tag(:i, nil, class:"btn btn-primary btn-xs glyphicon glyphicon-plus")
                        end
                        html_string = html_string + (I18n.t :antwortoptionen) + '<br><br>'
                        item.answers.each do |a|
  
                          html_string = html_string + "<div class='row'>"
                          html_string = html_string + '<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">'
                          case item.mcategory.name
                            when "text"
                              html_string = html_string + a.name
                            when "numerisch"
                              html_string = html_string + a.name 
                            when "multiple"
                              html_string = html_string + a.name 
                            when "single"
                              html_string = html_string + a.name 
                            end
                            html_string = html_string + "</div>"
                            html_string = html_string + '<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">'
              	            html_string = html_string + link_to(a, method: :delete, data: { confirm: 'Are you sure?' }) do 
                              content_tag(:i, nil, class:"btn btn-danger btn-xs glyphicon glyphicon-trash pull-right")
                            end
              	            html_string = html_string + link_to(edit_answer_path(:id => a)) do 
                              content_tag(:i, nil, class:"btn btn-primary btn-xs glyphicon glyphicon-wrench pull-right")
                            end
                            html_string = html_string + "</div>"
                            html_string = html_string + "</div>"
                          
                        end

                      end
                      
                    when "articles"
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + item.mcategory.name + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-exclamation-sign"></i> '
                      html_string = html_string + item.status.to_s + '<br>'
                    when "tickets"
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + item.mcategory.name + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                      html_string = html_string + item.amount.to_s+ '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-exclamation-sign"></i> '
                      html_string = html_string + item.contingent.to_s + ' verfügbar <br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-warning-sign"></i> '
                      html_string = html_string + item.user_tickets.count.to_s + ' verkauft <br>'
                    when "signage_locs"
                      html_string = html_string + "<h3>" + item.owner.name + '</h3><br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-home"></i> '
                      if item.address1 and item.address1.length > 0 
                        html_string = html_string + item.address1 + '<br>' 
                      end
                      if item.address2 and item.address2.length > 0 
                        html_string = html_string + item.address2 + '<br>' 
                      end
                      if item.address3 and item.address3.length > 0 
                        html_string = html_string + item.address3 + '<br>' 
                      end
                     when "signages", "signage_camps"
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + item.description + '<br>'
                    when "mdetails"
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string + item.description + '<br>'
                    when "users"
                      html_string = html_string + '<i class="glyphicon glyphicon-home"></i> '
                      if item.address1 and item.address1.length > 0 
                        html_string = html_string + item.address1 + '<br>' 
                      end
                      if item.address2 and item.address2.length > 0 
                        html_string = html_string + item.address2 + '<br>' 
                      end
                      if item.address3 and item.address3.length > 0 
                        html_string = html_string + item.address3 + '<br>' 
                      end
                      html_string = html_string + '<i class="glyphicon glyphicon-phone-alt"></i> '
                      if item.phone1 and item.phone1.length > 0 
                        html_string = html_string + item.phone1 + '<br>' 
                      end
                      if item.phone2 and item.phone2.length > 0 
                        html_string = html_string + item.phone2 + '<br>' 
                      end
                      html_string = html_string + '<br><i class="glyphicon glyphicon-envelope"></i> '
                      html_string = html_string +  item.email
                    when "companies"
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + item.mcategory.name + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-home"></i> '
                      if item.address1 and item.address1.length > 0 
                        html_string = html_string + item.address1 + '<br>' 
                      end
                      if item.address2 and item.address2.length > 0 
                        html_string = html_string + item.address2 + '<br>' 
                      end
                      if item.address3 and item.address3.length > 0 
                        html_string = html_string + item.address3 + '<br>' 
                      end
                      html_string = html_string + '<i class="glyphicon glyphicon-phone-alt"></i> '
                      if item.phone1 and item.phone1.length > 0 
                        html_string = html_string + item.phone1 + '<br>' 
                      end
                      if item.phone2 and item.phone2.length > 0 
                        html_string = html_string + item.phone2 + '<br>' 
                      end
                      html_string = html_string + '<br><i class="glyphicon glyphicon-envelope"></i> '
                      html_string = html_string + item.user.email
                    when "customers"
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + @comp.mcategory.name + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-home"></i> '
                      html_string = html_string + @comp.geo_address + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-envelope"></i> '
                      html_string = html_string + @comp.user.email + '<br>'

                    when "mobjects"
                      if item.sum_rating and item.sum_rating > 0
                        item.sum_rating.round.times do
                          html_string = html_string + '<i class="glyphicon glyphicon-star"></i> '
                        end
                        html_string = html_string + ' (' + sprintf("%.1f",item.sum_rating) + ')<br>'
                      end
                      
                      html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                      html_string = html_string + item.mcategory.name + '<br>'
                      if item.msubtype == "belohnungen"
                        html_string = html_string + '<i class="glyphicon glyphicon-gift"></i> '
                        html_string = html_string + item.reward + '<br>'
                      end
                      if item.msubtype == "zinsen"
                        html_string = html_string + '<i class="glyphicon glyphicon-signal"></i> '
                        html_string = html_string + sprintf("%3.1f %",item.interest_rate)  + '<br>'
                      end

                      if item.owner_type == "Company"
                          html_string = html_string + '<i class="glyphicon glyphicon-copyright-mark"></i> '
                          html_string = html_string + item.owner.name + "<br>"
                      end
                      if item.owner_type == "User"
                          html_string = html_string + '<i class="glyphicon glyphicon-user"></i> '
                          html_string = html_string + item.owner.name + " "+ item.owner.lastname + "<br>"
                      end

                      case item.mtype
                        when "veranstaltungen" 
                          if item.eventpart
                            html_string = html_string + '<i class="glyphicon glyphicon-info-sign"></i> '+(I18n.t :anmeldungerforderlich) + "<br>"
                          else
                            html_string = html_string + '<i class="glyphicon glyphicon-info-sign"></i> ' + (I18n.t :keineanmeldungerforderlich) + "<br>"
                          end
                          @angemeldet = nil
                          if user_signed_in?
                            @angemeldet = current_user.participants.where('mobject_id=?', item.id).first
                            if @angemeldet
                              html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '+(I18n.t :angemeldet)+ "<br>"
                            end
                          end
                          html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                          html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                          soll = (item.date_to.to_date - item.date_from.to_date).to_i
                          ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                          if soll > 0 and ist > 0
                            html_string = html_string + '<div class="progress">'
                            html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                            html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                            html_string = html_string + '</div>'
                            html_string = html_string + '</div>'
                          end

                        when "publikationen"
                            item.editions.order(release_date: :desc).each do |e|
                              html_string = html_string + link_to(edition_path(:id => e.id, :topic => :artikel)) do
                                content_tag(:div, showImage2(:small, e, false)) + content_tag(:div, e.name)
                                #html_string = html_string + e.name + "<br>"
                              end
                            end

                        when "projekte"
                          if !item.date_from
                            item.date_from = Date.today
                          end
                          if !item.date_to
                            item.date_to = Date.today
                          end
                          if !item.risk
                            item.risk = "tief"
                          end
                          if !item.quality
                            item.quality = "hoch"
                          end

                          html_string = html_string + "<br>"
                          html_string = html_string + "<div class='row'>"
                            html_string = html_string + "<div class='col-xs-4'>"
                              html_string = html_string + (I18n.t :termin) +"<br>" + item.date_to.strftime("%d.%m.%Y")
                            html_string = html_string + "</div>"
                            html_string = html_string + "<div class='col-xs-8'>"
                              soll = (item.date_to.to_date - item.date_from.to_date).to_i
                              ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                              if soll > 0 and ist > 0
                                html_string = html_string + '<div class="progress">'
                                html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                                html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                                html_string = html_string + '</div>'
                                html_string = html_string + '</div>'
                              end
                            html_string = html_string + "</div>"
                          html_string = html_string + "</div>"

                          if !item.sum_pkosten_plan
                            item.sum_pkosten_plan = 0.0
                          end
                          if !item.sum_paufwand_plan
                            item.sum_paufwand_plan = 0.0
                          end

                          html_string = html_string + "<div class='row'>"
                            html_string = html_string + "<div class='col-xs-4'>"
                              html_string = html_string + (I18n.t :kosten) +"<br>"+ sprintf("%5.2f "+(I18n.t :waehrung),item.sum_pkosten_plan)
                            html_string = html_string + "</div>"
                            html_string = html_string + "<div class='col-xs-8'>"
                              if item.sum_pkosten_plan and item.sum_pkosten_ist
                                html_string = html_string + '<div class="progress">'
                                html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_pkosten_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_pkosten_plan.to_s + '" style="width:' + (item.sum_pkosten_ist*100/item.sum_pkosten_plan).to_s + '%">'
                                html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                                html_string = html_string + '</div>'
                                html_string = html_string + '</div>'
                              end
                            html_string = html_string + "</div>"
                          html_string = html_string + "</div>"

                          html_string = html_string + "<div class='row'>"
                            html_string = html_string + "<div class='col-xs-4'>"
                              html_string = html_string + (I18n.t :aufwand) + "<br>"+sprintf("%5.1f "+(I18n.t :personentage),item.sum_paufwand_plan)
                            html_string = html_string + "</div>"
                            html_string = html_string + "<div class='col-xs-8'>"
                              if item.sum_paufwand_plan and item.sum_paufwand_ist
                                html_string = html_string + '<div class="progress">'
                                html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_paufwand_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_paufwand_plan.to_s + '" style="width:' + (item.sum_paufwand_ist*100/item.sum_paufwand_plan).to_s + '%">'
                                html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                                html_string = html_string + '</div>'
                                html_string = html_string + '</div>'
                              end
                            html_string = html_string + "</div>"
                          html_string = html_string + "</div>"

                          html_string = html_string + "<div class='row'>"
                            html_string = html_string + "<div class='col-xs-4'>"
                            html_string = html_string + "</div>"
                            html_string = html_string + "<div class='col-xs-8'>"
                              html_string = html_string + "<div class='col-xs-6' align='center' >"
                                html_string = html_string + "Qualität"
                              html_string = html_string + "</div>"
                              html_string = html_string + "<div class='col-xs-6' align='center' >"
                                html_string = html_string + "Risiko"
                              html_string = html_string + "</div>"
                            html_string = html_string + "</div>"
                          html_string = html_string + "</div>"

                          html_string = html_string + "<div class='row'>"
                            html_string = html_string + "<div class='col-xs-4'>"
                            html_string = html_string + "</div>"
                            html_string = html_string + "<div class='col-xs-8'>"
                              html_string = html_string + "<div class='col-xs-6' align='center' style='font-size:4em'>"
                                html_string = html_string + "<div class='quality"+ item.quality + "'>"
                                  html_string = html_string + '<i class="glyphicon glyphicon-stop"></i>'
                                html_string = html_string + "</div>"
                              html_string = html_string + "</div>"
                              html_string = html_string + "<div class='col-xs-6' align='center' style='font-size:4em'>"
                                html_string = html_string + "<div class='risk"+ item.risk + "'>"
                                  html_string = html_string + '<i class="glyphicon glyphicon-stop"></i>'
                                html_string = html_string + "</div>"
                              html_string = html_string + "</div>"
                            html_string = html_string + "</div>"
                          html_string = html_string + "</div>"

                        when "ausschreibungen", "kleinanzeigen", "stellenanzeigen", "crowdfunding", "innovationswettbewerbe"
                          html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                          html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                          soll = (item.date_to.to_date - item.date_from.to_date).to_i
                          ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                          if soll > 0 and ist > 0
                            html_string = html_string + '<div class="progress">'
                            html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                            html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                            html_string = html_string + '</div>'
                            html_string = html_string + '</div>'
                          end
                          if item.mtype == "crowdfunding"
                            if item.sum_amount and item.sum_amount > 0 and item.amount and item.amount > 0
                              html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '+ sprintf("%05.2f CHF", item.sum_amount) + " / " + sprintf("%05.2f CHF", item.amount) + "<br>"
                              html_string = html_string + '<div class="progress">'
                              html_string = html_string + '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="' + item.sum_amount.to_s + '" aria-valuemin="0" aria-valuemax="' + item.amount.to_s + '" style="width:' + (item.sum_amount/item.amount*100).to_s + '%">'
                              html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                              html_string = html_string + '</div>'
                              html_string = html_string + '</div>'
                            end
                          end

                        when "angebote"
                          if item.msubtype == "standard"
                            if item.price_reg
                              html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                              html_string = html_string +  sprintf("%05.2f CHF",item.price_reg) 
                            end
                          end
                          if item.msubtype == "aktion"
                            if item.price_new
                              html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                              html_string = html_string +  sprintf("%05.2f CHF",item.price_new) 
                            end
                            if item.price_reg
                              html_string = html_string + " statt " + sprintf("%05.2f CHF",item.price_reg) + '<br>'
                            end

                            html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                            html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                            soll = (item.date_to.to_date - item.date_from.to_date).to_i
                            ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                            if soll > 0 and ist > 0
                              html_string = html_string + '<div class="progress">'
                              html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                              html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                              html_string = html_string + '</div>'
                              html_string = html_string + '</div>'
                            end

                          end
                      end

                      when "madvisors"
                          html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                          html_string = html_string + item.grade + "<br>"
                          if item.mobject.mtype == "projekte"
                            html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                            if !item.rate
                              item.rate = 0
                            end
                            html_string = html_string + sprintf("%5.2f",item.rate) + "<br>"
                          end
                      when "participants"
                          html_string = html_string + '<i class="glyphicon glyphicon-time"></i> '
                          html_string = html_string + item.created_at.strftime("%d.%m.%Y") 
                      when "mstats"
                        if item.owner_type == "Company"
                            html_string = html_string + '<i class="glyphicon glyphicon-copyright-mark"></i> '
                            html_string = html_string + item.owner.name + "<br>"
                        end
                        if item.owner_type == "User"
                            html_string = html_string + '<i class="glyphicon glyphicon-user"></i> '
                            html_string = html_string + item.owner.name + " "+ item.owner.lastname + "<br>"
                        end
                        html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                        html_string = html_string + sprintf("%05.2f CHF",item.amount) + '<br>'
                        html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                        html_string = html_string +  item.created_at.strftime("%d.%m.%Y") + '<br>'

                    when "msponsors"
                        if items.table_name == "msponsors"
                          case item.slevel
                            when "1"
                              html_string = html_string + image_tag("Sponsor_gold.jpg", :size => "100x100", class:"img-rounded")
              				      when "2"
                              html_string = html_string + image_tag("Sponsor_silver.jpg", :size => "100x100", class:"img-rounded")
              				      when "3"
                              html_string = html_string + image_tag("Sponsor_bronze.jpg", :size => "100x100", class:"img-rounded")
                          end
                        end
                        
                    when "favourits"
                      html_string = html_string + @item.geo_address + '<br>'
    
                    when "searches"
                      html_string = html_string + "<anzeigetext>" + item.name + "</anzeigetext><br>"
                      if item.search_domain == "Object"
                        html_string = html_string + '<i class="glyphicon glyphicon-folder-open"></i> '
                        html_string = html_string + item.mtype + "<br>" 
                        html_string = html_string + item.msubtype.to_s + '<br>'
                      end
                      html_string = html_string + '<i class="glyphicon glyphicon-question-sign"></i> '
                      html_string = html_string + 'Anzahl ' + item.counter.to_s + '<br>'
                      
                    when "transactions"
                      html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                      html_string = html_string + sprintf("%05.2f CHF",item.amount) + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string +  item.ref + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-calendar"></i> '
                      html_string = html_string +  item.trx_date.strftime("%d.%m.%Y") + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-inbox"></i> '
                      html_string = html_string +  item.status + '<br>'

                    when "mratings"
                      item.rating.times do
                        html_string = html_string + '<i class="glyphicon glyphicon-star"></i>'
                      end
                      html_string = html_string + "<br>"
                      html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '
                      html_string = html_string +  item.comment + '<br>'
                      html_string = html_string + '<i class="glyphicon glyphicon-time"></i> '
                      html_string = html_string + item.created_at.strftime("%d.%m.%Y") 

                end
              html_string = html_string + '</list></div>'
            html_string = html_string + '</div>'
          html_string = html_string + '</div>'

          html_string = html_string + '<div class="panel panel-listfoot">'

            if (Date.today - item.created_at.to_date).to_i < 5
                html_string = html_string + (image_tag 'neu.png', :size => '30x30', class:'img-rounded')
            end 
            #html_string = html_string + item.created_at.strftime("%d.%m.%Y")

            #check credentials
            access = false
            if user_signed_in?
              case cname
                when "prices"
                  if (item.mobject.owner_type == "User" and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company" and item.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "crits"
                  if par
                    array = []
                    item.mobject.madvisors.each do |m|
                      array << m.user_id
                    end
                    if array.include?(current_user.id)
                      access = true
                    end
                  else
                    if (item.mobject.owner_type == "User" and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company" and item.mobject.owner.user_id == current_user.id)
                      access = true
                    end
                  end
                when "ideas"
      	          html_string = html_string + link_to(idea_crowdratings_path(:idea_id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-star")
                    end
                  array = []
                  item.mobject.madvisors.each do |m|
                    array << m.user_id
                  end
                  if array.include?(current_user.id)
      	            html_string = html_string + link_to(idea_ratings_path(:idea_id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-education")
                    end
                  end
                  if (item.user_id == current_user.id)
                    access = true
                  end
                when "idea_crowdratings"
                  if (item.user_id == current_user.id)
                    access = true
                  end
                when "questions"
                  if (item.mobject.owner_type == "User" and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company" and item.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "edition_arcticles"
                  if (item.edition.mobject.owner_type == "User" and item.edition.mobject.owner_id == current_user.id) or (item.edition.mobject.owner_type == "Company" and item.edition.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "editions"
    	            html_string = html_string + link_to(edition_arcticles_path(:edition_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-text-background")
                  end
                  if (item.mobject.owner_type == "User" and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company" and item.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "tickets"
                  if item.owner_type == "Mobject"
                    if (item.owner.owner_id == current_user.id) or (item.owner.owner_type == "Company" and item.owner.user_id == current_user.id)
                      access = true
                    end
                    if item.user_tickets and item.contingent
                      if item.user_tickets.count < item.contingent
          	            html_string = html_string + link_to(new_user_ticket_path(:ticket_id => item.id, :user_id => current_user.id)) do 
                          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-shopping-cart")
                        end
                      end
                    end
                  end
                when "signages" 
                  if item.signage_camp.owner.user_id == current_user.id
                    access=true
                  end 
                when "users"
                  if item.id == current_user.id or current_user.superuser
                    access=true
                  end 
                when "favourits", "searches", "mratings", "comments"
                  if item.user_id == current_user.id
                    access=true
                  end 
                when "mobjects", "partners", "mstats", "transactions", "signage_camps", "signage_locs"
                  if cname == "signage_locs"
      	            html_string = html_string + link_to(home_index11_path(:loc_id => item.id)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-blackboard")
                    end
                  end
                  if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                    access = true
                  end
                  if cname == "mobjects"
                    if user_signed_in?
                      # if item.mtype == "projekte" and item.madvisors.where('role=? and user_id=?',item.mtype, current_user.id).count > 0
                      #   html_string = html_string + link_to(timetracks_path(:mobject_id => item.id)) do 
                      #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                      #   end
                      # end
                    end
                    if item.mtype == "veranstaltungen" 
                      if item.eventpart
                        if @angemeldet
            	            html_string = html_string + link_to(mobjects_path(:del_part_id => item.id, :topic => :veranstaltung)) do 
                            content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-pencil")
                          end
                        else
            	            html_string = html_string + link_to(mobjects_path(:set_part_id => item.id, :topic => :veranstaltung)) do 
                            content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                          end
                        end
                      end
                    end
                    if item.mtype == "artikel"
                      if par #Artikelauswahl für Edition
                        html_string = html_string + link_to(new_edition_arcticle_path(:edition_id => par, :article_id => item.id)) do
                          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                        end
                      end
                    end
                    if item.mtype == "umfragen"
                      html_string = html_string + link_to(user_answers_path(:mobject_id => item.id, :user_id => current_user.id)) do
                        content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                      end
                      #html_string = html_string + link_to(home_index17_path(:mobject_id => item.id)) do
                      #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-stats")
                      #end
                    end
                  end
                  
                when "nopartners"
                  access = true
                when "madvisors"
                  if item.user_id == current_user.id or current_user.superuser
                    access = true
                  end
                when "mdetails"
                  if item.document_file_name
      	            html_string = html_string + link_to(item.document.url, target: "_blank") do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-cloud-download")
                    end
                  end
                  if (item.mobject.owner_type == "User"and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company"and item.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "msponsors"
                  if item.company.user_id == current_user.id
                    access = true
                  end
                 
               end
            end

            #html_string = html_string + link_to(item, :topic => "Info") do 
            #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-info-sign")
            #end
 
            if access
              case cname 
                when "prices"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_price_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "crits"
                  if par 
      	            html_string = html_string + link_to(edit_idea_rating_path(:id => @idearating.id)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                    end
                  else
      	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                      content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                    end
      	            html_string = html_string + link_to(edit_crit_path(:id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                    end
                  end
                when "ideas"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_idea_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "idea_crowdratings"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_idea_crowdrating_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "edition_arcticles"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_edition_arcticle_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "editions"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_edition_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
    	            #html_string = html_string + link_to(edition_arcticles_path(:edition_id => item)) do 
                  #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-book")
                  #end
                when "comments"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_comment_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "tickets"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_ticket_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "signages"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_signage_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "signage_camps"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_signage_camp_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
    	           # html_string = html_string + link_to(signage_locs_path(:camp_id => item.id)) do 
                #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-map-marker")
                #   end
    	           # html_string = html_string + link_to(company_path(:id => item.owner_id, :camp_id => item.id, :topic => "Signages")) do 
                #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-picture")
                #   end
    	           # html_string = html_string + link_to(home_index11_path(:camp_id => item.id)) do 
                #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-film")
                #   end
                when "signage_locs"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_signage_loc_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "favourits"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
                when "madvisors"
                  # if par == "User"
      	           # html_string = html_string + link_to(user_path(:id => item.user_id, :topic => "Kalendereintraege")) do 
                  #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-calendar")
                  #   end
      	           # html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.user_id)) do 
                  #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-envelope")
                  #   end
                  # end
    	            html_string = html_string + link_to(edit_madvisor_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
                when "partners"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_customer_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
    	            html_string = html_string + link_to(accounts_path(:customer_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
                  end
                when "mstats"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_mstat_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
    	            html_string = html_string + link_to(accounts_path(:customer_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-euro")
                  end
                when "nopartners"
                  if par[:user_id]
      	            html_string = html_string + link_to(new_customer_path(:user_id => par[:user_id], :partner_id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                    end
                  end
                  if par[:company_id]
      	            html_string = html_string + link_to(new_customer_path(:company_id => par[:company_id], :partner_id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                    end
                  end
                when "searches"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_search_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "msponsors"
    	            html_string = html_string + link_to(tickets_path :msponsor_id => item.id) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-barcode")
                  end
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_msponsor_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "mdetails"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_mdetail_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                when "questions"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => :fragen, :dir => "left", :q_id => item.id)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
                  end
    	            html_string = html_string + link_to(edit_question_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                  if item.mcategory.name == "Multiple" or item.mcategory.name == "Single"  
                    html_string = html_string + link_to(home_index16_path(:question_id => item.id)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-stats")
                    end
                  end

                when "mratings"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_mrating_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                 when "transactions"
                  if item.status == "erfasst"
                    #if @customer.owner_type == "User"
                    #  html_string = html_string + link_to(user_path(:id => @customer.owner_id, :trx_status_ok_id => t.id, :topic => "Transaktionen")) do
                    #    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-ok")
                    #  end
                    #end
                    #if @customer.owner_type == "Company"
                    #  html_string = html_string + link_to(company_path(:id => @customer.owner_id, :trx_status_ok_id => t.id, :topic => "Transaktionen")) do
                    #    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-ok")
                    #  end
                    #end
      	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                      content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                    end
      	            html_string = html_string + link_to(edit_transaction_path(:id => item)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                    end
                  end
                  if item.status == "freigegeben"
                    #if @customer.owner_type == "User"
                    #  html_string = html_string + link_to(user_path(:id => @customer.owner_id, :trx_status_ausgefuehrt_id => t.id, :topic => "Transaktionen")) do
                    #    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-ok")
                    #  end
                    #end
                    #if @customer.owner_type == "Company"
                    #  html_string = html_string + link_to(company_path(:id => @customer.owner_id, :trx_status_ausgefuehrt_id => t.id, :topic => "Transaktionen")) do
                    #    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-ok")
                    #  end
                    #end
                  end
                 when "mobjects"
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_mobject_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                  end
                   #if item.mtype == "artikel"
                   #    html_string = html_string + link_to(user_path(:id => item.owner_id, :topic => "Artikel", :article_id => item.id)) do
                   #     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-copy")
                   #  end
                   #end

              end
          end

          html_string = html_string + '</div>'

        html_string = html_string + '</div>'
      html_string = html_string + '</div>'

    end
  end
  html_string = html_string + '</div>'
  return html_string.html_safe
end

def showFirstImage2(size, item, details)
    html_string = link_to item do
      if details.count > 0
        pic = details.first
        if pic.avatar_file_name
          image_tag pic.avatar(size), class:"img-rounded img-responsive"
        else
          image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive")
          #image_tag(image_def("Objekte", item.mtype, item.msubtype), :size => "50x50", class:"card-img-top img-responsive" )
        end
      else
        image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive")
        #image_tag(image_def("Objekte", item.mtype, item.msubtype), :size => "50x50", class:"card-img-top img-responsive" )
      end
    end
    return html_string.html_safe
end

def showImage2(size, item, linkit)
    if linkit
      html_string = link_to(item) do
        if item.avatar_file_name
            #image_tag(item.avatar(size), class:"card-img-top img-responsive")
            image_tag(item.avatar(size), class:"img-responsive")
        else
          html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive")
          # case item.class.name
          #   when "User"
          #     image_tag(image_def("Privatpersonen", nil, nil), :size => "50x50", class:"card-img-top img-responsive" )
          #   when "Company"
          #     image_tag(image_def("Institutionen", nil, nil), :size => "50x50", class:"card-img-top img-responsive" )
          #   else
          #     image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive" )
          # end
        end
      end
    else
      if item.avatar_file_name
          html_string = image_tag(item.avatar(size), class:"card-img-top img-responsive")
      else
        html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive")
        # case item.class.name
        #   when "User"
        #     html_string = image_tag(image_def("Privatpersonen", nil, nil), :size => "50x50", class:"card-img-top img-responsive" )
        #   when "Company"
        #     html_string = image_tag(image_def("Institutionen", nil, nil), :size => "50x50", class:"card-img-top img-responsive" )
        #   else
        #     html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive" )
        # end
      end
    end
    return html_string.html_safe
end

def header(header, format)
    if format
      html_string = "<div class='col-xs-12'><div class='panel-heading header'><li_header>" + header + "</li_header></div></div>"
    else
      html_string = "<div class='panel-heading header'><li_header>" + header + "</li_header></div>"
    end
    return html_string.html_safe
end

def header3(object_type, object, topic, format)
  if format
    html_string = "<div class='col-xs-12'><div class='panel-heading header'><li_header>" + (I18n.t topic) + "</li_header></div></div>"
  else
    html_string = "<div class='panel-heading header'><li_header>" + (I18n.t topic) + "</li_header></div>"
  end
  
  html_string = html_string + action_buttons2(object_type, object, topic)

  return html_string.html_safe
end

def navigate(object,item)
    
    html_string = ""
    case object
      when :personen
        html_string = html_string + build_nav("Privatpersonen",item,:info,item)
        html_string = html_string + build_nav("Privatpersonen",item,:kalendereintraege, Appointment.where('user_id1=? or user_id2=?',item,item).count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:angebote,item.mobjects.where('mtype=?',"angebote").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:ansprechpartner,item.madvisors.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:institutionen,item.companies.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:stellenanzeigen,item.mobjects.where('mtype=?',"stellenanzeigen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:kleinanzeigen,item.mobjects.where('mtype=?',"kleinanzeigen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:vermietungen,item.mobjects.where('mtype=?',"vermietungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:veranstaltungen,item.mobjects.where('mtype=?',"veranstaltungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:anmeldungen,item.participants.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:tickets,item.user_tickets.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:ausflugsziele,item.mobjects.where('mtype=?',"ausflugsziele").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:ausschreibungen,item.mobjects.where('mtype=?',"ausschreibungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:innovationswettbewerbe,item.mobjects.where('mtype=?',"innovationswettbewerbe").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:ideen,item.ideas.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:crowdfunding, item.mobjects.where('mtype=? ',"crowdfunding").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:crowdfundingbeitraege, item.mstats.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:bewertungen, item.mratings.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:favoriten,item.favourits.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:publikationen, item.mobjects.where('mtype=?',"publikationen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:artikel, item.mobjects.where('mtype=?',"artikel").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:umfragen, item.mobjects.where('mtype=?',"umfragen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:projekte, item.mobjects.where('mtype=? and parent=?',"projekte",0).count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:zeiterfassung, item.timetracks.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:ressourcenplanung, item.plannings.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:gruppen, item.mobjects.where('mtype=?',"gruppen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:kundenbeziehungen, item.customers.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:transaktionen, item.transactions.where('ttype=?', "payment").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:emails, Email.where('m_to=? or m_from=?', item.id, item.id).count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,:zugriffsberechtigungen, item.credentials.count > 0)

      when :institutionen
        html_string = html_string + build_nav("Institutionen",item,:info,item)
        html_string = html_string + build_nav("Institutionen",item,:angebote,item.mobjects.where('mtype=? ',"angebote").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:stellenanzeigen,item.mobjects.where('mtype=?',"stellenanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:kleinanzeigen,item.mobjects.where('mtype=?',"kleinanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:vermietungen,item.mobjects.where('mtype=?',"vermietungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:veranstaltungen,item.mobjects.where('mtype=?',"veranstaltungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:sponsorenengagements,item.msponsors.count > 0)
        html_string = html_string + build_nav("Institutionen",item,:ausflugsziele,item.mobjects.where('mtype=?',"ausflugsziele").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:ausschreibungen,item.mobjects.where('mtype=?',"ausschreibungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:innovationswettbewerbe,item.mobjects.where('mtype=?',"innovationswettbewerbe").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:crowdfunding, item.mobjects.where('mtype=?',"crowdfunding").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:crowdfundingbeitraege, item.mstats.count > 0)
        html_string = html_string + build_nav("Institutionen",item,:dskampagnen, item.signage_camps.count > 0)
        html_string = html_string + build_nav("Institutionen",item,:dsstandorte, item.signage_locs.count > 0)
        html_string = html_string + build_nav("Institutionen",item,:publikationen, item.mobjects.where('mtype=?',"publikationen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:umfragen, item.mobjects.where('mtype=?',"umfragen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:projekte, item.mobjects.where('mtype=? and parent=?',"projekte",0).count > 0)
        html_string = html_string + build_nav("Institutionen",item,:kundenbeziehungen, item.customers.count > 0)
        html_string = html_string + build_nav("Institutionen",item,:transaktionen,item.transactions.where('ttype=?', "payment").count > 0)
        html_string = html_string + build_nav("Institutionen",item,:emails, Email.where('m_to=? or m_from=?', item.user.id, item.user.id).count > 0)
        if item.partner
          html_string = html_string + build_nav("Institutionen",item,:partnerlinks, item.partner_links.count > 0)
        end

      when :objekte
        html_string = html_string + build_nav("Objekte",item,:info,item)
        if user_signed_in?
          if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
          html_string = html_string + build_nav("Objekte",item,:details,item.mdetails.where('mtype=?',"details").count > 0)
          end
        end 
        
        if item.mtype == "angebote" or item.mtype == "stellenanzeigen"
          html_string = html_string + build_nav("Objekte",item,:ansprechpartner,item.madvisors.count > 0)
        end
        if item.mtype == "veranstaltungen"
          html_string = html_string + build_nav("Objekte",item,:eintrittskarten,item.tickets.count > 0)
          html_string = html_string + build_nav("Objekte",item,:sponsorenengagements,item.msponsors.count > 0)
          html_string = html_string + build_nav("Objekte",item,:teilnehmer,item.participants.count > 0)
        end
        if item.mtype == "vermietungen"
          html_string = html_string + build_nav("Objekte",item,:kalender_vermietungen,item.mcalendars.count > 0)
        end
        if item.mtype == "ausschreibungen"
          html_string = html_string + build_nav("Objekte",item,:ausschreibungsangebote,item.mdetails.where('mtype=?',"ausschreibungsangebote").count > 0)
        end
        if item.mtype == "artikel"
          #html_string = html_string + build_nav("Objekte",item,:blog,item.comments.count > 0)
        end
        if item.mtype == "innovationswettbewerbe"
          html_string = html_string + build_nav("Objekte",item,:preise, item.prices.count > 0)
          html_string = html_string + build_nav("Objekte",item,:bewertungskriterien, item.crits.count > 0)
          html_string = html_string + build_nav("Objekte",item,:jury, item.madvisors.count > 0)
          html_string = html_string + build_nav("Objekte",item,:ideen,item.ideas.count > 0)
        end
        if item.mtype == "umfragen"
          if user_signed_in?
            if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
              html_string = html_string + build_nav("Objekte",item,:fragen,item.questions.count > 0)
              html_string = html_string + build_nav("Objekte",item,:umfrageteilnehmer,User.count > 0)
            end
          end
        end
        if item.mtype == "publikationen"
          html_string = html_string + build_nav("Objekte",item,:ausgaben,item.editions.count > 0)
        end
        if item.mtype == "gruppen"
          html_string = html_string + build_nav("Objekte",item,:gruppenmitglieder, item.madvisors.where('role=?',item.mtype).count > 0)
          # html_string = html_string + build_nav("Objekte",item,:zeiterfassung, item.madvisors.where('role=?',item.mtype).count > 0)
          html_string = html_string + build_nav("Objekte",item,:ressourcenplanung, item.madvisors.where('role=?',item.mtype).count > 0)
        end
        if item.mtype == "projekte"
          if user_signed_in?
            if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
              html_string = html_string + build_nav("Objekte",item,:substruktur, Mobject.where('parent=?',item.id).count > 0)
              html_string = html_string + build_nav("Objekte",item,:projektberechtigungen, item.madvisors.where('role=?',item.mtype).count > 0)
            end
          end
          html_string = html_string + build_nav("Objekte",item,:auftragscontrolling, item.timetracks.count > 0)
          html_string = html_string + build_nav("Objekte",item,:projektdashboard, item.timetracks.count > 0)
        end
        if item.mtype == "crowdfunding"
          html_string = html_string + build_nav("Objekte",item, :cfstatistik,item.mstats.count > 0)
          html_string = html_string + build_nav("Objekte",item, :cftransaktionen,item.mstats.count > 0)
        end
        if item.mtype != "artikel" and item.mtype != "projekte" and item.mtype != "gruppen"
          html_string = html_string + build_nav("Objekte",item, :bewertungen ,item.mratings.count > 0)
        end

      when :dskampagnen
        html_string = html_string + build_nav("Kampagnen",item, :info,item)
        html_string = html_string + build_nav("Kampagnen",item,:details,item.signages.count > 0)
        html_string = html_string + build_nav("Kampagnen",item,:dsstandorte,item.signage_cals.count > 0)
        html_string = html_string + build_nav("Kampagnen",item,:dskalender,item.signage_cals.count > 0)

      when :dsstandorte
        html_string = html_string + build_nav("Standorte",item, :info,item)
        html_string = html_string + build_nav("Standorte",item,:dskampagnen,item.signage_cals.count > 0)
        html_string = html_string + build_nav("Standorte",item,:dskalender,item.signage_cals.count > 0)
    end
    
    return html_string.html_safe
    
end

def build_nav(object, item, topic, condition)
  
  html_string=""
  if (!user_signed_in? and $activeapps.include?(object+topic.to_s)) or (user_signed_in? and getUserCreds.include?(object+topic.to_s)) or (user_signed_in? and current_user.superuser)

    if condition
      btn = "active"
    else
      btn = "inactive"
    end
    
    case object
      when "Privatpersonen"
        html_string = link_to(user_path(:id => item.id, :topic => topic), title: getIcon2(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon2(topic)["icon"])
          #content_tag(:span, content_tag(:i, topic), class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic))
        end
      when "Institutionen"
        html_string = link_to(company_path(:id => item.id, :topic => topic), title: getIcon2(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon2(topic)["icon"])
        end
      when "Objekte"
        html_string = link_to(mobject_path(:id => item.id, :topic => topic), title: getIcon2(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon2(topic)["icon"])
        end
      when "Kampagnen"
        html_string = link_to(signage_camp_path(:id => item.id, :topic => topic), title: getIcon2(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon2(topic)["icon"])
        end
      when "Standorte"
        html_string = link_to(signage_loc_path(:id => item.id, :topic => topic), title: getIcon2(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon2(topic)["icon"])
        end
    end
  end
  
  return html_string.html_safe
end

def action_buttons2(object_type, item, topic)

  html_string = ""

  case object_type 
    when :kategorie
      html_string = html_string + link_to(home_index9_path) do
        content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
      end
      html_string = html_string + link_to(new_mcategory_path(:ctype => item)) do
        content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
      end

    when :personen
      case topic
        when :info
          html_string = html_string + link_to(users_path(:page => session[:page]), title: (I18n.t :personen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
            content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
          end
          if user_signed_in?
            if current_user.id == item.id or current_user.superuser
                html_string = html_string + link_to(edit_user_path(item), title: (I18n.t :bearbeiten), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-wrench")
              end
              html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher)}, title: (I18n.t :accountloeschen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' )  do
                  content_tag(:i, nil, class: "btn btn-danger pull-right glyphicon glyphicon-trash")
              end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id) , title: (I18n.t :missbrauchmelden), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
              content_tag(:i, nil, class: "btn btn-warning pull-right glyphicon glyphicon-eye-open")
            end
            if $activeapps.include?("PrivatpersonenTransaktionen") or current_user.superuser
              html_string = html_string + link_to(listaccount_index_path(:user_id => current_user.id, :user_id_ver => item.id, :company_id_ver => nil, :ref => (I18n.t :verguetungan)+item.name + " " + item.lastname, :object_name => "User", :object_id => item.id, :amount => nil)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
              end
            end
            if $activeapps.include?("PrivatpersonenPositionen (Privatpersonen)") or current_user.superuser
              html_string = html_string + link_to(new_user_position_path(:user_id => current_user.id)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
              end
            end
            if $activeapps.include?("PrivatpersonenFavoriten") or current_user.superuser
              html_string = html_string + link_to(new_favourit_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
              end
            end
          end
          
        when :kalendereintraege
          html_string = html_string + link_to(new_appointment_path(:user_id1 => item.id, :user_id2 => current_user.id))  do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
          
        when :kleinanzeigen, :stellenanzeigen, :angebote, :crowdfunding
          html_string = html_string + link_to(home_index8_path(:user_id => current_user.id, :mtype => topic)) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
          
        when :institutionen
          html_string = html_string + link_to(new_company_path(:user_id => current_user.id)) do
            content_tag(:i, content_tag(:b,(I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end

        when :vermietungen, :veranstaltungen, :ausflugsziele, :ausschreibungen, :publikationen, :artikel, :umfragen, :projekte, :gruppen, :innovationswettbewerbe
          html_string = html_string + link_to(new_mobject_path(:user_id => current_user.id, :mtype => topic, :msubtype => nil)) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end

        when :emails
          html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.id)) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end

        when :tickets
          html_string = html_string + link_to(ticketuserview_index2_path(:user_id => item.id)) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
      end

    when :institutionen
      case topic
        when :info
          html_string = html_string + link_to(companies_path(:page => session[:page]), title: (I18n.t :institutionen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
            content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
          end
          if user_signed_in?
            if $activeapps.include?("InstitutionenFavoriten")
              html_string = html_string + link_to(new_favourit_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
              end
            end
            if current_user.id == item.user_id or current_user.superuser
              html_string = html_string + link_to(edit_company_path(item), title: (I18n.t :bearbeiten), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-wrench")
              end
              html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) }, title: (I18n.t :accountloeschen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                content_tag(:i, nil, class: "btn btn-danger pull-right glyphicon glyphicon-trash")
              end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id), title: (I18n.t :missbrauchmelden), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
              content_tag(:i, nil, class: "btn btn-warning pull-right glyphicon glyphicon-eye-open")
            end
            if $activeapps.include?("InstitutionenTransaktionen")
              html_string = html_string + link_to(listaccount_index_path :user_id => current_user.id, :user_id_ver => nil, :company_id_ver => item.id, :ref => (I18n.t :verguetungan)+item.name, :object_name => "Company", :object_id => item.id, :amount => nil) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-primary glyphicon glyphicon-plus")
              end
            end
          end

        when :angebote, :crowdfunding, :kleinanzeigen, :stellenanzeigen
          html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => topic) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end

        when :vermietungen, :veranstaltungen, :ausflugsziele, :ausschreibungen, :publikationen, :umfragen, :projekte, :innovationswettbewerbe
          html_string = html_string + link_to(new_mobject_path :company_id => item.id, :mtype => topic, :msubtype => nil) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
          
        when :partnerlinks
          html_string = html_string + link_to(new_partner_link_path :company_id => item.id) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
          
        when :dskampagnen
          html_string = html_string + link_to(new_signage_camp_path :company_id => item.id) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end

        when :dsstandorte
          html_string = html_string + link_to(new_signage_loc_path :company_id => item.id) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
          end
      end
        
    when :objekte
       case topic
          when :info
             html_string = html_string + link_to(mobjects_path(:mtype => item.mtype, :msubtype => item.msubtype, :page => session[:page], :parent => session[:parent]), title: (I18n.t :objekte)+item.mtype, 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
              content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
             end
             if session[:edition_id]
               html_string = html_string + link_to(edition_path(:id => session[:edition_id], :topic => "Info"), title: (I18n.t :zurueckzurausgabe), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-book")
               end
             end 
             if item.parent and item.parent > 0 
                html_string = html_string + link_to(mobject_path(:id => item.parent, :mtype => "projekte", :msubtype => nil, :topic => "Substruktur"), title: (I18n.t :hierachiezurueck), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
                  content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-level-up")
                end
             end 
             if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
         	        html_string = html_string + link_to(edit_mobject_path(item), title: (I18n.t :bearbeiten), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                     content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                   end
         	        html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) }, title: item.mtype + " löschen", 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                     content_tag(:i, nil, class:"btn btn-danger pull-right glyphicon glyphicon-trash")
                   end
               end
               html_string = html_string + link_to(new_webmaster_path(:object_name => "Mobject", :object_id => item.id, :user_id => current_user.id), title: (I18n.t :missbrauchmelden), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
                 content_tag(:i, nil, class:"btn btn-warning pull-right glyphicon glyphicon-eye-open")
               end
             end

          when :details
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "details")) do
                    content_tag(:i, content_tag(:f,(I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end
              
          when :ideen
              if user_signed_in?
                html_string = html_string + link_to(new_idea_path(:mobject_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, content_tag(:f,(I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                end
              end

          when :preise
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_price_path(:mobject_id => item.id)) do
                    content_tag(:i, content_tag(:f,(I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end

          when :bewertungskriterien
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_crit_path(:mobject_id => item.id)) do
                    content_tag(:i, content_tag(:f," Neu"), class:"btn btn-special glyphicon glyphicon-plus")
                  end
                end
              end

          when :projektberechtigungen, :gruppenmitglieder, :jury
             if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(madvisors_path :user_id => item.owner_id, :mobject_id => item.id, :role => item.mtype) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end

          when :substruktur
             if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  if item.owner_type == "User"
                    html_string = html_string + link_to(new_mobject_path :user_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
                    end
                  end
                  if item.owner_type == "Company"
                    html_string = html_string + link_to(new_mobject_path :company_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class: "btn btn-special glyphicon glyphicon-plus")
                    end
                  end
               end
              end

          when :ausschreibungsangebote
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "ausschreibungsangebote")) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-primary glyphicon glyphicon-plus")
                  end
               end
              end

          when :eintrittskarten
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_ticket_path(:mobject_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end

          when :fragen
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_question_path(:mobject_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end
              
          when :ausgaben
              if user_signed_in?
               if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                  html_string = html_string + link_to(new_edition_path(:mobject_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
               end
              end

          when :sponsorenengagements
            if user_signed_in?
              html_string = html_string + link_to(new_msponsor_path(:mobject_id => item.id)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
              end
            end
            
          when :blog
            if user_signed_in?
    	        html_string = html_string + link_to(new_comment_path :mobject_id => item.id, :user_id => current_user.id) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
              end
            end
            
          when :bewertungen
            if user_signed_in?
    	        html_string = html_string + link_to(new_mrating_path :mobject_id => item.id, :user_id => current_user.id) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
              end
            end
            
          when :ansprechpartner
            if user_signed_in?
              if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                html_string = html_string + link_to(madvisors_path :mobject_id => item.id) do
                  content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                end
              end
            end
            
          when :kalender_vermietungen
            if user_signed_in?
              html_string = html_string + link_to(new_mcalendar_path(:user_id => current_user.id, :mobject_id => item.id)) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
              end
            end
            
          when :cfstatistik
          when :cftransaktionen
            #if item.sum_amount < item.amount
              html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "User")) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-user")
              end
              html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "Company")) do
                content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-copyright-mark")
              end
            #end

          when :dsstandorte
      end

    when :dskampagnen
         html_string = html_string + link_to(company_path(:id => item.owner_id, :topic => :dskampagnen), title: (I18n.t :dskampagnen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         html_string = html_string + link_to(home_index11_path(:camp_id => item.id), title: (I18n.t :kampagnenshow), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-film")
         end
         case topic
            when :info
            when :details
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_path(:camp_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
                end
              end
            when :kampagnen
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_cal_path(:camp_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
                end
              end
         end

      when :dsstandorte
         html_string = html_string + link_to(company_path(:id => item.owner_id, :topic => :dsstandorte), title: (I18n.t :dsstandorte), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         html_string = html_string + link_to(home_index11_path(:loc_id => item.id), title: (I18n.t :dsshow), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-film")
         end
         case topic
            when :info
            when :kalender
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_cal_path(:loc_id => item.id)) do
                    content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
                  end
                end
              end
         end

      when :editionen
         html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => :editionen), title: (I18n.t :editionen), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end

      when :edition
         html_string = html_string + link_to(edition_path(:id => item.id, :topic => :edition), title: (I18n.t :edition), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end

      when :ideenbewertung
         html_string = html_string + link_to(mobject_path(:id => item.mobject.id, :topic => :ideenbewertung), title: (I18n.t :ideenbewertung), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end

      when :crowdideenbewertung
         html_string = html_string + link_to(mobject_path(:id => item.mobject.id, :topic => :crowdideenbewertung), title: (I18n.t :crowdideenbewertung), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         if user_signed_in?
          html_string = html_string + link_to(new_idea_crowdrating_path(:idea_id => item.id, :user_id => current_user.id)) do
            content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
          end
        end

      when :artikeledition
         html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => :artikeledition), title: (I18n.t :zurueckzurausgabe), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         if user_signed_in?
          if (item.mobject.owner_type == "User" and current_user.id == item.mobject.owner.id) or (item.mobject.owner_type == "Company" and current_user.id == item.mobject.owner.user_id) 
            html_string = html_string + link_to(mobjects_path(:mtype => "artikel", :edition_id => item.id)) do
              content_tag(:i, content_tag(:b, (I18n.t :hinzufuegen)), class:"btn btn-special glyphicon glyphicon-plus")
            end
          end
         end

  end
  # html_string = html_string + "</div></div>"
  return html_string.html_safe
end

def getIcon2(symbol)
  icon = "question_mark"
  case symbol
    when :news
      icon = "alert"
    when :personen, :geburtstage, :ansprechpartner, :anmeldungen, :gruppenmitglieder, :umfrageteilnehmer, :veranstaltungsteilnehmer, :kalendergeburtstage
      icon = "user"
    when :institutionen
      icon = "copyright-mark"
    when :vermietungen
      icon = "retweet"
    when :ausschreibungen, :kalenderausschreibungen
      icon = "pencil"
    when :publikationen, :kalenderpublikationen, :ausgaben
      icon = "book"
    when :artikel
      icon = "text-background"
    when :umfragen, :fragen, :meineabfragen
      icon = "question-sign"
    when :projekte
      icon = "tasks"
    when :innovationswettbewerbe
      icon = "cog"
    when :veranstaltungen, :kalenderveranstaltungen
      icon = "glass"
    when :ausflugsziele
      icon = "camera"
    when :werbeflaechen
      icon = "blackboard"
    when :angebote
      icon = "shopping-cart"
    when :angebotestandard, :info
      icon = "info-sign"
    when :angeboteaktion, :aktionen, :kalenderaktionen
      icon = "exclamation-sign"
    when :stellenanzeigen, :kalenderstellenanzeigen
      icon = "briefcase"
    when :kleinanzeigen
      icon = "pushpin"
    when :stellenanzeigensuchen, :kleinanzeigensuchen, :details
      icon = "search"
    when :stellenanzeigenanbieten, :kleinanzeigenanbieten
      icon = "filter"
    when :crowdfunding, :kalendercrowdfunding
      icon = "grain"
    when :crowdfundingspenden
      icon = "gift"
    when :crowdfundingbelohnungen, :tickets
      icon = "qrcode"
    when :crowdfundingzinsen
      icon = "signal"
    when :kalender, :kalendereintraege
      icon = "calendar"
    when :ideen, :einstellungen
      icon = "cog"
    when :crowdfundingbeitraege, :transaktionen, :cftransaktionen
      icon = "euro"
    when :bewertungen
      icon = "star"
    when :favoriten, :sponsorenengagements
      icon = "heart"
    when :zeiterfassung
      icon = "time"
    when :ressourcenplanung
      icon = "screenshot"
    when :gruppen
      icon = "th"
    when :kundenbeziehungen
      icon = "check"
    when :emails
      icon = "envelope"
    when :zugriffsberechtigungen, :projektberechtigungen
      icon = "lock"
    when :dskampagnen
      icon = "bullhorn"
    when :dsstandorte
      icon = "blackboard"
    when :jury
      icon = "education"
    when :preise
      icon = "gift"
    when :bewertungskriterien
      icon = "pencil"
    when :projektdashboard, :aktivitaeten, :cfstatistik
      icon = "dashboard"
    when :auftragscontrolling
      icon = "eye-open"
    when :substruktur
      icon = "cog"
    when :fragen
      icon = "question-sign"
    when :ausgaben
      icon = "dublicate"
    when :blog
      icon = "comment"
    when :tickets, :eintrittskarten
      icon = "barcode"
    when :show
      icon = "film"
    when :kontobeziehungen
      icon = "film"
    when :mappositionen, :mappositionenfavoriten, :standorte
      icon = "map-marker"
    when :partnerlinks
      icon = "globe"
    when :ausschreibungsangebote
      icon = "book"
    when :berechtigungen
      icon = "lock"
  end
  ret = Hash.new
  ret = {"icon" => icon, "icontext" => (I18n.t symbol)}
  
  return ret
end

def build_hauptmenue

    html_string = ""

    if user_signed_in?  
      init_apps
      creds = getUserCreds
    else
      creds = init_apps
    end

    domain = :news
    if creds.include?("Hauptmenue"+domain.to_s) and user_signed_in?
        path = home_index10_path
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :personen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = users_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :institutionen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = companies_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :vermietungen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "vermietungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :ausschreibungen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "ausschreibungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :publikationen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "publikationen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :artikel
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "artikel", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :umfragen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "umfragen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :projekte
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "projekte", :msubtype => "Root", :parent => 0)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :innovationswettbewerbe
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "innovationswettbewerbe")
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :veranstaltungen
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "veranstaltungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = :ausflugsziele
    if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "ausflugsziele", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"++domain.to_s)
        path = signage_locs_path
        html_string = html_string + simple_menue(domain, path)
    end
    
    domain = :angebote
    if creds.include?("Hauptmenue"+domain.to_s)
        hasharray = []
        domain = :angebotestandard
        if creds.include?("Hauptmenue"+domain.to_s)
          path = mobjects_path(:mtype => "angebote", :msubtype => "standard")
          hash = Hash.new
          hash = {"path" => path, "text" => (I18n.t :standard), "icon" => :standard }
          hasharray << hash
        end
        domain = :angeboteaktion
        if creds.include?("Hauptmenue"+domain.to_s)
          path = mobjects_path(:mtype => "angebote", :msubtype => "aktion")
          hash = Hash.new
          hash = {"path" => path, "text" => (I18n.t :aktion), "icon" => :aktion }
          hasharray << hash
        end
        domain = :angebote
        domain_text = I18n.t :angebote
        #html_string = html_string + hasharray.to_s
        html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    domain = :stellenanzeigen
    if creds.include?("Hauptmenue"+domain.to_s)
        hasharray = []
        domain = :stellenanzeigensuchen
        if creds.include?("Hauptmenue"+domain.to_s)
          path = mobjects_path(:mtype => "stellenanzeigen", :msubtype => "suchen")
          hash = Hash.new
          hash = {"path" => path, "text" => (I18n.t :suchen), "icon" => :suchen }
          hasharray << hash
        end
        domain = :stellenanzeigenanbieten
        if creds.include?("Hauptmenue"+domain.to_s)
          path = mobjects_path(:mtype => "stellenanzeigen", :msubtype => "anbieten")
          hash = Hash.new
          hash = {"path" => path, "text" => (I18n.t :anbieten), "icon" => :anbieten }
          hasharray << hash
        end
        domain = :stellenanzeigen
        domain_text = I18n.t :stellenanzeigen
        html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    domain = :kleinanzeigen
    if creds.include?("Hauptmenue"+domain.to_s)
        hasharray = []
        domain = :stellenanzeigensuchen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "kleinanzeigen", :msubtype => "suchen")
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :suchen), "icon" => :suchen }
        hasharray << hash
      end
      domain = :stellenanzeigenanbieten
      if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "kleinanzeigen", :msubtype => "anbieten")
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :anbieten), "icon" => :anbieten }
        hasharray << hash
      end
        domain = :kleinanzeigen
        domain_text = I18n.t :kleinanzeigen
      html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    domain = :crowdfunding
    if creds.include?("Hauptmenue"+domain.to_s)
        hasharray = []
        domain = :crowdfundingspenden
      if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "crowdfunding", :msubtype => "spenden")
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :spenden), "icon" => :spenden }
        hasharray << hash
      end
        domain = :crowdfundingbelohnungen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "crowdfunding", :msubtype => "belohnungen")
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :belohnungen), "icon" => :belohnungen }
        hasharray << hash
      end
        domain = :crowdfundingzinsen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = mobjects_path(:mtype => "crowdfunding", :msubtype => "zinsen")
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :zinsen), "icon" => :zinsen }
        hasharray << hash
      end
      domain = :crowdfunding
      domain_text = I18n.t :crowdfunding
      html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    domain = :kalender
    if creds.include?("Hauptmenue"+domain.to_s)
      hasharray = []
      domain = :kalendergeburtstage
      if creds.include?("Hauptmenue"+domain.to_s)
        if user_signed_in?
          path = showcal_index_path + "?dom=geburtstage"
          hash = Hash.new
          hash = {"path" => path, "text" => (I18n.t :geburtstage), "icon" => :geburtstage }
          hasharray << hash
        end
      end
      domain = :kalenderaktionen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = showcal_index_path + "?dom=aktionen"
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :aktionen), "icon" => :aktionen }
        hasharray << hash
      end
      domain = :kalenderausschreibungen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = showcal_index_path + "?dom=ausschreibungen"
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :ausschreibungen), "icon" => :ausschreibungen }
        hasharray << hash
      end
      domain = :kalenderveranstaltungen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = showcal_index_path + "?dom=veranstaltungen"
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :veranstaltungen), "icon" => :veranstaltungen }
        hasharray << hash
      end
      domain = :kalenderstellenanzeigen
      if creds.include?("Hauptmenue"+domain.to_s)
        path = showcal_index_path + "?dom=stellenanzeigen"
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :stellenanzeigen), "icon" => :stellenanzeigen }
        hasharray << hash
      end
      domain = :kalendercrowdfunding
      if creds.include?("Hauptmenue"+domain.to_s)
        path = showcal_index_path + "?dom=crowdfunding"
        hash = Hash.new
        hash = {"path" => path, "text" => (I18n.t :crowdfunding), "icon" => :crowdfunding }
        hasharray << hash
      end
      domain = :kalender
      domain_text = I18n.t :kalender
      html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end
    
    return html_string.html_safe
    
end

def simple_menue (domain, path)
  html_string = ""
  html_string = html_string + link_to(path) do
    content_tag(:div, nil, class:"col-xs-12 col-sm-12 col-md-6 col-lg-4") do
      content_tag(:div, nil, class:"panel-body panel-nav") do
        temp = content_tag(:div, nil, class:"col-xs-3 col-sm-3 col-md-3 col-lg-3") do
          icon_size = "4"
          content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon2(domain)["icon"], style:"font-size:" + icon_size + "em") 
        end
        temp = temp + content_tag(:div, nil, class:"col-xs-7 col-sm-7 col-md-7 col-lg-7") do
          content_tag(:home_nav, (I18n.t domain))
        end
        #temp = temp + content_tag(:div, nil, class:"col-xs-2 col-sm-2 col-md-2 col-lg-2") do
        #  content_tag(:i, nil, class:"glyphicon glyphicon-chevron-right pull-right")
        #end
      end
    end
  end
  return html_string.html_safe
end

def complex_menue (domain, domain_text, hasharray)
  html_string = "<" + domain.to_s + ">"
  html_string = html_string + content_tag(:div, nil, class:"col-xs-12 col-sm-12 col-md-6 col-lg-4") do
    content_tag(:div, nil, class:"panel-body panel-nav") do
      
      temp = content_tag(:div, nil, class:"col-xs-3 col-sm-3 col-md-3 col-lg-3") do
        icon_size = "4"
        content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon2(domain)["icon"], style:"font-size:" + icon_size + "em") 
      end
      temp = temp + content_tag(:div, nil, class:"col-xs-9 col-sm-9 col-md-9 col-lg-9") do
        temp2 = content_tag(:home_nav, domain_text) + "<br><br>".html_safe
        temp2 = temp2 + content_tag(:home_nav_small, build_sub_menu(domain, domain_text, hasharray))
      end
    end
  end
  html_string = html_string + "</" + domain.to_s + ">"
  return html_string.html_safe
end

def build_sub_menu(domain, domain_text, hasharray)
  html_string = "<" + domain.to_s + "_options" + ">"
  for i in 0..hasharray.length-1
        html_string = html_string + "<a href="+hasharray[i]["path"] + ">"
        html_string = html_string + "<i class='glyphicon glyphicon-"+getIcon2(hasharray[i]["icon"])["icon"]+"' style='font-size:2em'> </i> "
        html_string = html_string + hasharray[i]["text"]
        html_string = html_string + "</a><br><br>"
  end
  html_string = html_string + "</" + domain.to_s + "_options" + ">"
  return html_string.html_safe
end

def build_kachel_access(topic, mode, user)

  html_string = ""
  appparams = Appparam.where('domain=?',topic)
  appparams.each do |a|
  
    if mode == "System"
      if a.access
          thumbnail_state = 'thumbnail-active'
        else
          thumbnail_state = 'thumbnail-inactive'
      end
      cpath = appparams_path(:id => a.id)
    end

    if mode == "User"
      forget = false
      @credential = user.credentials.where('appparam_id=?',a.id).first
      if @credential
        if !a.access
          #@credential.access = false
          #@credential.save
          @credential.destroy
          forget=true
        end
      else
        if a.access
          @cred = Credential.new
          @cred.appparam_id = a.id
          @cred.user_id = user.id
          @cred.access = a.access
          @cred.save
        else
          forget=true
        end
      end
      if !forget
        @credential = user.credentials.where('appparam_id=?',a.id).first
        if @credential
          if @credential.access
              thumbnail_state = 'thumbnail-active'
            else
              thumbnail_state = 'thumbnail-inactive'
          end
          cpath = user_path(:id => @credential.user_id, :credential_id => @credential.id, :topic => "zugriffsberechtigungen")
        end
      end
    end

    if !forget

      html_string = html_string + link_to(cpath) do
        content_tag(:div, nil, class:"col-xs-4 col-sm-4 col-md-3 col-lg-2") do 
          content_tag(:div, nil, class:"thumbnail " + thumbnail_state, align:"center") do
            content_tag(:span, nil) do
              icon_size = "4"
              content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon2(a.right.to_sym)["icon"], style:"font-size:" + icon_size + "em") + content_tag(:small_cal, "<br>".html_safe + (I18n.t a.right))
            end
          end
        end
      end

    end

  end    
  return html_string.html_safe
end

def image_def (domain, mtype, msubtype)
    case domain
      when $app_name
        pic = "connect.jpg"
      when "privatpersonen"
        pic = "user.jpg"
      when "institutionen"
        pic = "company.jpg"
      when "objekte"
        pic = "angebot.jpg"
      else
        pic = "no_pic.jpg"
    end
end

def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
end

def avg_rating2(mobject)
    rat = Mrating.where("mobject_id=?", mobject).average(:rating)
    if rat != nil
        return rat.round
    else
        return 0
    end
end

def AktionDatum2(datum, mobject)
    if datum >= mobject.date_from and datum <= mobject.date_to
        return true
    else
        return false
    end
end

def init_apps

  apps = Appparam.all
  if !apps or apps.count==0
  
    @array = []

    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :news, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :personen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :institutionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :angebote, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :angebote, "right" => :angebotestandard, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :angebote, "right" => :angeboteaktion, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :vermietungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :ausschreibungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :stellenanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :stellenanzeigen, "right" => :stellenanzeigenanbieten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :stellenanzeigen, "right" => :stellenanzeigensuchen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :veranstaltungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :ausflugsziele, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :kleinanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :publikationen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :artikel, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :innovationswettbewerbe, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :umfragen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :projekte, "access" => true, "icon" => "projekte"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kleinanzeigen, "right" => :kleinanzeigenanbieten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kleinanzeigen", "right" => :kleinanzeigensuchen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :crowdfunding, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :crowdfunding, "right" => :crowdfundingspenden, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :crowdfunding, "right" => :crowdfundingbelohnungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :crowdfunding, "right" => :crowdfundingzinsen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :dsstandorte, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => :kalender, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalendergeburtstage, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalenderpublikationen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalenderaktionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalendercrowdfunding, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalenderstellenanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalenderveranstaltungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => :kalender, "right" => :kalenderausschreibungen, "access" => false, "icon" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :info, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :kalendereintraege, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :angebote, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :ansprechpartner, "access" => true, "icon" => "personen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :institutionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :stellenanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :kleinanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :vermietungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :veranstaltungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :anmeldungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :tickets, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :ausflugsziele, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :ausschreibungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :innovationswettbewerbe, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :ideen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :crowdfunding, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :crowdfundingbeitraege, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :bewertungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :favoriten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :gruppen, "access" => true, "icon" => "th"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :publikationen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :artikel, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :umfragen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :projekte, "access" => true, "icon" => "projekte"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :zeiterfassung, "access" => true, "icon" => "zeiterfassung"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :ressourcenplanung, "access" => true, "icon" => "ressourcenplanung"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :kundenbeziehungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :kontobeziehungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :transaktionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :emails, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :mappositionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :mappositionenfavoriten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => :aktivitaeten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :info, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :angebote, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :stellenanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :kleinanzeigen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :vermietungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :veranstaltungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :sponsorenengagements, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :ausflugsziele, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :ausschreibungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :innovationswettbewerbe, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :crowdfunding, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :crowdfundingbeitraege, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :publikationen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :umfragen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :projekte, "access" => true, "icon" => "projekte"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :kundenbeziehungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :kontobeziehungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :transaktionen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :emails, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :favoriten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :partnerlinks, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :aktivitaeten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :dskampagnen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => :dsstandorte, "access" => false, "icon" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :info, "access" => true, "icon" => "info"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :details, "access" => true, "icon" => "details"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :eintrittskarten, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :sponsorenengagements, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :ansprechpartner, "access" => true, "icon" => "personen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :projektberechtigungen, "access" => true, "icon" => "berechtigungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :auftragscontrolling, "access" => true, "icon" => "auftragscontrolling"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :projektdashboard, "access" => true, "icon" => "projektdashboard"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :kalender, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :veranstaltungsteilnehmer, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :ausschreibungsangebote, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :bewertungen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :blog, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :fragen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :umfrageteilnehmer, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :jury, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :preise, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :ideen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :bewertungskriterien, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :gruppenmitglieder, "access" => true, "icon" => "personen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :substruktur, "access" => true, "icon" => "task"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :ausgaben, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :cfstatistik, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => :cftransaktionen, "access" => false, "icon" => "news"}
    @array << hash
    
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => :info, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => :details, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => :kalender, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => :standorte, "access" => false, "icon" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => :info, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => :dskampagnen, "access" => false, "icon" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => :kalender, "access" => false, "icon" => "news"}
    @array << hash

    for i in 0..@array.length-1
      c = Appparam.new
      c.domain = @array[i]["domain"]
      if @array[i]["parent_domain"]
        c.parent_domain = @array[i]["parent_domain"]
      else
        c.parent_domain = "Root"
      end
      c.right = @array[i]["right"]
      #c.icon = @array[i]["icon"]
      c.access = @array[i]["access"]
      c.save
    end
    apps = Appparam.all
  end

  $activeapps = []
  apps.each do |a|
    $activeapps << a.domain+a.right if a.access
  end
  
  return $activeapps

end

def init_credentials
  @appparams = Appparam.all
  @appparams.each do |a|
    if a.access
      c = Credential.new
      c.user_id = current_user.id
      c.appparam_id = a.id
      c.access = a.access
      c.save
    end
  end
end

def getUserCreds
  credapps = []
  if current_user.superuser
    appparams = Appparam.all
    appparams.each do |a|
      credapps << a.domain+a.right
    end
  else  
    creds = current_user.credentials
    if !creds or creds.count==0
      init_credentials
    end
    creds.each do |c|
      if $activeapps.include?(c.appparam.domain+c.appparam.right)
        credapps << c.appparam.domain+c.appparam.right if c.access
      end
    end
  end
  return credapps
end

def buildQRCode(content)
  qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
  qr_img = qr.to_img
  qr_img.resize(200, 200).save("ticketqrcode.png")
  img = File.open("ticketqrcode.png")
end

def build_edition(edition)
  html_string = "<div class=panel-body>"
  
    html_string = html_string + "<div class='row'>"
      html_string = html_string + "<div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 xl-3'>"
        html_string = html_string + showImage2(:medium, edition, false)
      html_string = html_string + "</div>"
      
      html_string = html_string + "<div class='col-xs-9 col-sm-9 col-md-9 col-lg-9 xl-9'>"

        html_string = html_string + "<div class='row'>"
          html_string = html_string + link_to(edition.mobject.owner) do
            showImage2(:small, edition.mobject.owner, false)
          end
          html_string = html_string + "<br>"
          if edition.mobject.owner_type == "User"
            html_string = html_string + edition.mobject.owner.name + " " + edition.mobject.owner.lastname
          end
          if edition.mobject.owner_type == "Company"
            html_string = html_string + edition.mobject.owner.name
          end
        html_string = html_string + "</div>"
        html_string = html_string + "<br><br>"
          
        html_string = html_string + "<div class='row'>"
          html_string = html_string + "<inhalt>Inhalt</inhalt>"
          html_string = html_string + "<br><br>"
          edition.edition_arcticles.order(:sequence).each do |a|
            html_string = html_string + "<h4 class='panel panel-publish'>"
            html_string = html_string + link_to(mobject_path(:id => a.mobject.id, :topic => "Info", :edition_id => edition.id)) do
              content_tag(:div, a.mobject.name) + content_tag(:artikel_autor, a.mobject.owner.name + " " + a.mobject.owner.lastname)
            end
            html_string = html_string + "</h4>"
          end
        html_string = html_string + "</div>"

      html_string = html_string + "</div>"
    html_string = html_string + "</div>"
    
  html_string = html_string + "</div>"
  return html_string.html_safe
end

def build_article(article)
#html_string = "<div class=panel-body>"
  html_string = ""
  html_string = html_string + "<div class='row'>"

    article.mdetails.order(:sequence).each do |d|

      if d.textoptions != "Blog" and d.textoptions != "Bewertung"
      
      html_string = html_string + "<div class='col-xs-12 col-sm-6 col-md-6 col-lg-4 xl-4'>"
        html_string = html_string + "<div class='row'>"
          if d.avatar_file_name
            html_string = html_string + "<div class='col-xs-6 col-sm-6 col-md-6 col-lg-6'>"
              html_string = html_string + showImage2(:medium, d, false)
            html_string = html_string + "</div>"
            html_string = html_string + "<div class='col-xs-6 col-sm-6 col-md-6 col-lg-6'>"
              html_string = html_string + "<artikel_subheader>" + d.name + "</artikel_subheader><br><br>"
            html_string = html_string + "</div>"
            
          else
            html_string = html_string + "<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12'>"
              html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_subheader><br><br>"
            html_string = html_string + "</div>"
          end
          html_string = html_string + "<br>"
          
          case d.textoptions
            when "zitat"
              html_string = html_string + "<artikel_quote>" + '"' + d.description + '"' + "</artikel_quote><br>"
            when "Link"
              html_string = html_string + "<artikel_link>"
              html_string = html_string + link_to(url_with_protocol(d.description), target: "_blank") do
                content_tag(:div, d.description)
              end
              html_string = html_string + "</artikel_link>"

            when "abstimmung"
                html_string = html_string + "<div class='panel panel-blog'>"
                  
                  if user_signed_in?
                    @url = url_for(action: action_name, controller: controller_name)
                    html_string = html_string + link_to(new_mlike_path :mobject_id => article.id, :user_id => current_user.id, :like => true, :return_url => @url) do
                      #content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                      content_tag(:span, content_tag(:b, "Ja")+content_tag(:span, article.mlikes.where('likeit=?',true).count.to_s, class:"badge"), class:"btn btn-primary glyphicon glyphicon-thumbs-up")
                    end
                    html_string = html_string + link_to(new_mlike_path :mobject_id => article.id, :user_id => current_user.id, :like => false, :return_url => @url) do
                      #content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                      content_tag(:span, content_tag(:b, "Nein")+content_tag(:span, article.mlikes.where('likeit=?',false).count.to_s, class:"badge"), class:"btn btn-primary glyphicon glyphicon-thumbs-down")
                    end
                  else
                      html_string = html_string + content_tag(:i, nil, class:"glyphicon glyphicon-thumbs-up") + content_tag(:span, article.mlikes.where('likeit=?',true).count.to_s, class:"badge")
                      html_string = html_string + content_tag(:i, nil, class:"glyphicon glyphicon-thumbs-down") + content_tag(:span, article.mlikes.where('likeit=?',false).count.to_s, class:"badge")
                  end
                html_string = html_string + "</div>"
              
            when "text"
              html_string = html_string + "<artikel_content>" + d.description + "</artikel_content><br>"
          end
          
          if d.document_file_name
            html_string = html_string + "<br>Download Link "
            html_string = html_string + link_to(d.document.url, target: "_blank") do
              content_tag(:i, nil, class:'btn btn-primary btn-xs glyphicon glyphicon-cloud-download')
            end
          end
          
        html_string = html_string + "</div><br>"
      html_string = html_string + "</div>"
    end
    end
    
    article.mdetails.order(:sequence).each do |d|
      
      html_string = html_string + "<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 xl-12'>"
        case d.textoptions
          when "bewertung"
              #html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header><br>"
              html_string = html_string + "<div class='row'>"
                html_string = html_string + "<div class='panel-group' id='accordionB"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<div class='panel panel-blog'>"
                  
                    html_string = html_string + "<h4 class='panel panel-blog'>"
                      html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionB"+article.id.to_s+"' href='#collapseTwoB"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                        html_string = html_string + "<artikel_subheader><i class='glyphicon glyphicon-chevron-down'> </i>"+ d.name + "</artikel_header> "
                        #html_string = html_string + link_to(mobject_path :mobject_id => article.id, :topic => "Bewertungen") do
                        if user_signed_in?
                          html_string = html_string + link_to(new_mrating_path(:mobject_id => article.id, :user_id => current_user.id)) do
                            content_tag(:i, content_tag(:i," bewerten"), class:"btn btn-primary glyphicon glyphicon-star")
                          end
                        end
                      html_string = html_string + "</a>"
                    html_string = html_string + "</h4>"
                    html_string = html_string + "<div id='collapseTwoB"+article.id.to_s+"' class='panel-collapse collapse' role='tabpanel' aria-labelledby='headingOne'>"
                      html_string = html_string + build_medialist2(article.mratings.order(created_at: :desc), "mratings", "User")
                    html_string = html_string + "</div>"
                      
                  html_string = html_string + "</div>"
                html_string = html_string + "</div>"
              html_string = html_string + "</div>"

          when "blog"
              #html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header><br>"
              html_string = html_string + "<div class='row'>"
                html_string = html_string + "<div class='panel-group' id='accordionG"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<div class='panel panel-blog'>"
                  
                    html_string = html_string + "<h4 class='panel panel-blog'>"
                      html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionG"+article.id.to_s+"' href='#collapseTwoG"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                        html_string = html_string + "<artikel_subheader><i class='glyphicon glyphicon-chevron-down'> </i>" + d.name + "</artikel_header> "
                        #html_string = html_string + link_to(mobject_path :mobject_id => article.id, :topic => "Blog") do
                        if user_signed_in?
                          html_string = html_string + link_to(new_comment_path(:mobject_id => article.id, :user_id => current_user.id)) do
                            content_tag(:i, content_tag(:i," kommentieren"), class:"btn btn-primary glyphicon glyphicon-comment")
                          end
                        end
                      html_string = html_string + "</a>"
                    html_string = html_string + "</h4>"
                    html_string = html_string + "<div id='collapseTwoG"+article.id.to_s+"' class='panel-collapse collapse' role='tabpanel' aria-labelledby='headingOne'>"
                      html_string = html_string + build_medialist2(article.comments.order(created_at: :desc), "comments", "User")
                    html_string = html_string + "</div>"
                      
                  html_string = html_string + "</div>"
                html_string = html_string + "</div>"
              html_string = html_string + "</div>"

        end
      html_string = html_string + "</div>"        
    end

  html_string = html_string + "</div>"
#html_string = html_string + "</div>"
return html_string.html_safe
end 


def build_questionaire(questionaire)
  html_string = "<div class=panel-body>"
  
    html_string = html_string + "<div class='row'>"
      html_string = html_string + "<div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 xl-3'>"
        html_string = html_string + showFirstImage2(:medium, questionaire, questionaire.mdetails)
      html_string = html_string + "</div>"
      
      html_string = html_string + "<div class='col-xs-9 col-sm-9 col-md-9 col-lg-9 xl-9'>"

        html_string = html_string + "<div class='row'>"
          html_string = html_string + link_to(questionaire.owner) do
            showImage2(:small, questionaire.owner, false)
          end
          html_string = html_string + "<br>"
          if questionaire.owner_type == "User"
            html_string = html_string + questionaire.owner.name + " " + questionaire.owner.lastname
          end
          if questionaire.owner_type == "Company"
            html_string = html_string + questionaire.owner.name
          end
        html_string = html_string + "</div>"
        html_string = html_string + "<br><br>"
          
        html_string = html_string + "<div class='row'>"
          html_string = html_string + "<inhalt>Inhalt</inhalt>"
          html_string = html_string + "<br><br>"
        html_string = html_string + "</div>"
        questionaire.questions.order(:sequence).each do |q|
          html_string = html_string + "<div class='row'>"

            #html_string = html_string + "<div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 xl-3'>"
            # if current_user.user_answers.answers.where('question_id=?',q.id).count > 0
            #   html_string = html_string + '<i class="glyphicon glyphicon-check"></i>'              
            # else
            #   html_string = html_string + '<i class="glyphicon glyphicon-edit"></i>'
            # end
            #html_string = html_string + "</div>"
            #html_string = html_string + "<div class='col-xs-9 col-sm-9 col-md-9 col-lg-9 xl-9'>"
              html_string = html_string + link_to(home_index15_path(:question_id => q.id)) do
                content_tag(:div, q.name)
              end
            #html_string = html_string + "</div>"

          html_string = html_string + "</div>"
        end

      html_string = html_string + "</div>"
    html_string = html_string + "</div>"
    
  html_string = html_string + "</div>"
  return html_string.html_safe
end

def current_period(p, item)
  case p
  when "Jahr"
      if Date.today.strftime("%m").to_i == item
          return true
      end
  when "Monat"
      if Date.today.strftime("%W").to_i == item
          return true
      end
  when "Woche"
      if Date.today == item
          return true
      end
  end
  return false
end

def exportWriter (mobject, istsoll, istsollkum, istsollau, iso)
  filename = "public/workorder_" + DateTime.now.to_s + ".xls"
  workbook = WriteExcel.new(filename)
        
  # Add worksheet(s)
  worksheet  = workbook.add_worksheet

  # header format
  f_header0 = workbook.add_format
  f_header0.set_bold
  # f_header0.set_color('blue')
  f_header0.set_size(20)
  # format.set_align('right')

  f_header1 = workbook.add_format
  f_header1.set_color('white')
  #f_header1.set_bg_color('black')
  f_header1.set_bg_color(57)

  f_param = workbook.add_format
  f_param.set_bold
  f_param.set_color('red')

  # col sizes
  worksheet.set_column(0,20,20)
  
  row = 0
  col = 0
  worksheet.write(row, col, "Auftragscontrolling " + DateTime.now.strftime("%d.%m.%y-%H:%M"), f_header0)
  row = row + 2
  worksheet.write(row, col, "Parameter:", f_header1)
  row = row + 1
  worksheet.write(row, col, "Periode:")
  worksheet.write(row, col+1, @c_mode, f_param)
  row = row + 1
  worksheet.write(row, col, "Fokus:")
  worksheet.write(row, col+1, @c_scope, f_param)
  row = row + 1
  worksheet.write(row, col, "Projekt/Auftrag:")
  worksheet.write(row, col+1, mobject.name, f_param)
  row = row + 1
  worksheet.write(row, col, "Substrukturen inkludieren:")
  if @include_sub
    wosub = "Ja"
  else
    wosub = "Nein"
  end
  worksheet.write(row, col+1, wosub, f_param)
  row=row+2

  worksheet.write(row, 0, "Zeitraum", f_header1)
  worksheet.write(row+1, 0, "IST")
  worksheet.write(row+2, 0, "SOLL")
  worksheet.write(row+3, 0, "Delta")
  for i in 1..istsoll.length-1
    worksheet.write(row, i, istsoll[i][0],f_header1)
    worksheet.write(row+1, i, istsoll[i][1])
    worksheet.write(row+2, i, istsoll[i][2])
    if istsoll[i][2]-istsoll[i][1] < 0
      worksheet.write(row+3, i, istsoll[i][2]-istsoll[i][1], f_param)
    else
      worksheet.write(row+3, i, istsoll[i][2]-istsoll[i][1])
    end 
  end
  
  row=row+6
  worksheet.write(row, 0, "kumuliert", f_header1)
  worksheet.write(row+1, 0, "IST")
  worksheet.write(row+2, 0, "SOLL")
  worksheet.write(row+3, 0, "Delta")
  for i in 1..istsollkum.length-1
    worksheet.write(row, i, istsollkum[i][0],f_header1)
    worksheet.write(row+1, i, istsollkum[i][1])
    worksheet.write(row+2, i, istsollkum[i][2])
    if istsollkum[i][2]-istsollkum[i][1] < 0
      worksheet.write(row+3, i, istsollkum[i][2]-istsollkum[i][1], f_param)
    else
      worksheet.write(row+3, i, istsollkum[i][2]-istsollkum[i][1])
    end 
  end

  row=row+6
  for k in 0..iso.length-1

    maiso = iso[k]
    @user = User.find(maiso[i][0])
    if @user
      @name = @user.name + " " + @user.lastname
    else
      @name = "unbekannt"
    end
    
    worksheet.write(row, 0, @name, f_header1)
    worksheet.write(row+1, 0, "IST")
    worksheet.write(row+2, 0, "SOLL")
    worksheet.write(row+3, 0, "Delta")

    for i in 1..maiso.length-1
      worksheet.write(row, i, maiso[i][1],f_header1)
      worksheet.write(row+1, i, maiso[i][2])
      worksheet.write(row+2, i, maiso[i][3])
      if maiso[i][3] - maiso[i][2] < 0
        worksheet.write(row+3, i, maiso[i][3] - maiso[i][2], f_param)
      else
        worksheet.write(row+3, i, maiso[i][3] - maiso[i][2])
      end 
    end

    row = row + 4

  end

  workbook.close
  return filename

end

def wo_iterate(wo, include_sub, wolist)
  if include_sub
    subs = Mobject.where("parent=?", wo)
    subs.each do |s|
      wolist << s.id
      wo_iterate(s.id, include_sub, wolist)
    end
  end
end

end    