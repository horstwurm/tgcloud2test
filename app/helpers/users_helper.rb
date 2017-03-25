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
      m.mdetails.each do |s|
        if s.avatar_file_name
          html = html + "<div align=center>"+ (image_tag s.avatar(:medium), class:"img-rounded") + "<h4>" + m.mtype + ": " + m.name + "</h4><p>" + s.description + "</p></div>"
        end
      end
      
      m.mratings.last(1).each do |r|
        if r.user.avatar_file_name
          html = html + "<div align=center>"+ (image_tag r.user.avatar(:medium), class:"img-rounded") + "<h4>" + r.comment + "</h4><p>" + r.user.name + " " + r.user.lastname + "</p></div>"
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

    #case size
    #    when :small
    #        si = "50x50"
    #    when :thumb
    #        si = "100x100"
    #    when :medium
    #        si = "250x250"
    #    when :big
    #        si = "500x500"
    #end
    html = ""
    if mobject.mdetails == nil
      html = html + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" )
    else
      if mobject.mdetails.count == 0
        html = html + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" )
      else
        html = html +  '<div class="owl-show">'
        mobject.mdetails.each do |p|
          if p.avatar_file_name == nil
            html = html + "<div>" + image_tag(image_def("Objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
          else
            html = html + "<div>"+ (image_tag p.avatar(size), class:"img-rounded") + "</div>"
          end
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
                when "edition_arcticles"
                  html_string = html_string + item.mobject.name
                when "editions"
                  html_string = html_string + item.name
                when "comments"
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
                  html_string = html_string + "Abfrage"
                when "customers"
                  @comp = Company.find(item.partner_id)
                  html_string = html_string + @comp.name
                when "madvisors", "participants", "mratings"
                  if par == "User"
                    html_string = html_string + item.user.name + " " + item.user.lastname
                  end
                  if par == "Object"
                    html_string = html_string + item.mobject.name
                  end
                when "msponsors"
                  if par == "Company"
                    html_string = html_string + item.company.name
                  end
                  if par == "Object"
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
                  if par == "CF"
                        html_string = html_string + item.mobject.name 
                  end
                  if par == "Owner"
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
                  when "edition_arcticles"
                    html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                  when "editions"
                    html_string = html_string + showImage2(:medium, item, true)
                  when "tickets"
                    html_string = html_string + showFirstImage2(:medium, item, item.owner.mdetails)
                  when "signage_camps"
                    html_string = html_string + showFirstImage2(:medium, item, item.signages)
                  when "comments"
                    html_string = html_string + showImage2(:medium, item.user, true)
                  when "users", "companies", "signages", "signage_locs", "articles"
                    html_string = html_string + showImage2(:medium, item, true)
                  when "mdetails"
                    html_string = html_string + showImage2(:medium, item, false)
                  when "msponsors"
                    if par == "Company"
                      html_string = html_string + showImage2(:medium, item.company, true)
                    end
                    if par == "Object"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                  when "mobjects"
                    html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
                  when "mstats"
                    if par == "CF"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                    if par == "Owner"
                      html_string = html_string + showImage2(:medium, item.owner, true)
                    end
                  when "madvisors", "participants", "mratings"
                    if par == "Object"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                    if par == "User"
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
                          when "Privatpersonen"
                            html_string = html_string + link_to(users_path(:filter_id => item.id)) do
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "Tickets"
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              html_string = html_string + image_tag(image_def("Privatpersonen", item.mtype, item.msubtype))
                          when "Institutionen"
                            html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              content_tag(:i, nil, class:"glyphicon glyphicon-question-sign", style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "Objekte"
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
                      if item.msubtype == "Belohnungen"
                        html_string = html_string + '<i class="glyphicon glyphicon-gift"></i> '
                        html_string = html_string + item.reward + '<br>'
                      end
                      if item.msubtype == "Zinsen"
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
                        when "Veranstaltungen" 
                          if item.eventpart
                            html_string = html_string + '<i class="glyphicon glyphicon-info-sign"></i> '+"Anmeldung erforderlich<br>"
                          else
                            html_string = html_string + '<i class="glyphicon glyphicon-info-sign"></i> '+"keine Anmeldung erforderlich<br>"
                          end
                          @angemeldet = nil
                          if user_signed_in?
                            @angemeldet = current_user.participants.where('mobject_id=?', item.id).first
                            if @angemeldet
                              html_string = html_string + '<i class="glyphicon glyphicon-pencil"></i> '+"angemeldet<br>"
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

                        when "Publikationen"
                            item.editions.order(release_date: :desc).each do |e|
                              html_string = html_string + link_to(edition_path(:id => e.id, :topic => "Artikel")) do
                                content_tag(:div, showImage2(:small, e, false)) + content_tag(:div, e.name)
                                #html_string = html_string + e.name + "<br>"
                              end
                            end

                        when "Ausschreibungen", "Kleinanzeigen", "Stellenanzeigen", "Crowdfunding"
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
                          if item.mtype == "Crowdfunding"
                            if item.sum_amount and item.sum_amount > 0 and item.amount and item.amount > 0
                              html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '+ sprintf("%05.2f CHF", item.sum_amount) + " / " + sprintf("%05.2f CHF", item.amount) + "<br>"
                              html_string = html_string + '<div class="progress">'
                              html_string = html_string + '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="' + item.sum_amount.to_s + '" aria-valuemin="0" aria-valuemax="' + item.amount.to_s + '" style="width:' + (item.sum_amount/item.amount*100).to_s + '%">'
                              html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                              html_string = html_string + '</div>'
                              html_string = html_string + '</div>'
                            end
                          end

                        when "Angebote"
                          if item.msubtype == "Standard"
                            if item.price_reg
                              html_string = html_string + '<i class="glyphicon glyphicon-euro"></i> '
                              html_string = html_string +  sprintf("%05.2f CHF",item.price_reg) 
                            end
                          end
                          if item.msubtype == "Aktion"
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
                when "edition_arcticles"
                  if (item.edition.mobject.owner_type == "User" and item.edition.mobject.owner_id == current_user.id) or (item.edition.mobject.owner_type == "Company" and item.edition.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "editions"
    	            html_string = html_string + link_to(edition_arcticles_path(:edition_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-book")
                  end
                  if (item.mobject.owner_type == "User" and item.mobject.owner_id == current_user.id) or (item.mobject.owner_type == "Company" and item.mobject.owner.user_id == current_user.id)
                    access = true
                  end
                when "tickets"
                  if item.owner_type == "Mobject"
                    if (item.owner.owner_id == current_user.id) or (item.owner.owner_type == "Company" and item.owner.user_id == current_user.id)
                      access = true
                    end
                    if item.user_tickets.count < item.contingent
        	            html_string = html_string + link_to(new_user_ticket_path(:ticket_id => item.id, :user_id => current_user.id)) do 
                        content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-shopping-cart")
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
                    if item.mtype == "Veranstaltungen" 
                      if item.eventpart
                        if @angemeldet
            	            html_string = html_string + link_to(mobjects_path(:del_part_id => item.id, :topic => item.mtype)) do 
                            content_tag(:i, nil, class:"btn btn-danger glyphicon glyphicon-pencil")
                          end
                        else
            	            html_string = html_string + link_to(mobjects_path(:set_part_id => item.id, :topic => item.mtype)) do 
                            content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                          end
                        end
                      end
                    end
                    if item.mtype == "Artikel" and par #Artikelauswahl für Edition
                      html_string = html_string + link_to(new_edition_arcticle_path(:edition_id => par, :article_id => item.id)) do
                        content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-pencil")
                      end
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
                  if par == "User"
      	            html_string = html_string + link_to(user_path(:id => item.user_id, :topic => "Kalendereintraege")) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-calendar")
                    end
      	            html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.user_id)) do 
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-envelope")
                    end
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
          image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive")
          #image_tag(image_def("Objekte", item.mtype, item.msubtype), :size => "50x50", class:"card-img-top img-responsive" )
        end
      else
        image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive")
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
          html_string = image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive")
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
        html_string = image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive")
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

def navigate(object,item)
    
    # html_string = "<navigate><div class='col-xs-12'><div class='panel-body'>"
    # html_string = "<navigate>"
    #html_string = "<div class='panel-body'>"
    html_string = ""
    case object
      when "Privatpersonen"
        html_string = html_string + build_nav("Privatpersonen",item,"Info",item)
        html_string = html_string + build_nav("Privatpersonen",item,"Kalendereintraege",Appointment.where('user_id1=? or user_id2=?',item,item).count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Angebote",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Standard").count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Aktionen",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Aktion").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Angebote, Services und Aktionen",item.mobjects.where('mtype=?',"Angebote").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Ansprechpartner",item.madvisors.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Institutionen",item.companies.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Stellenanzeigen",item.mobjects.where('mtype=?',"Stellenanzeigen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Kleinanzeigen",item.mobjects.where('mtype=?',"Kleinanzeigen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Vermietungen",item.mobjects.where('mtype=?',"Vermietungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Veranstaltungen",item.mobjects.where('mtype=?',"Veranstaltungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Veranstaltungen (angemeldet)",item.participants.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Tickets",item.user_tickets.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Ausflugsziele",item.mobjects.where('mtype=?',"Ausflugsziele").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Ausschreibungen",item.mobjects.where('mtype=?',"Ausschreibungen").count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Spenden)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Spenden").count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Belohnungen)",item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Belohnungen").count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Zinsen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Zinsen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding Initiativen", item.mobjects.where('mtype=? ',"Crowdfunding").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Beitraege)", item.mstats.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Bewertungen", item.mratings.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Favoriten",item.favourits.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Publikationen", item.mobjects.where('mtype=?',"Publikationen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Artikel", item.mobjects.where('mtype=?',"Artikel").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Kundenbeziehungen", item.customers.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Transaktionen", item.transactions.where('ttype=?', "Payment").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"eMail", Email.where('m_to=? or m_from=?', item.id, item.id).count > 0)
        #html_string = html_string + build_nav("Privatpersonen",item,"Berechtigungen", item.credentials.count > 0)

      when "Institutionen"
        html_string = html_string + build_nav("Institutionen",item,"Info",item)
        #html_string = html_string + build_nav("Institutionen",item,"Angebote",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Standard").count > 0)
        #html_string = html_string + build_nav("Institutionen",item,"Aktionen",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Aktion").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Angebote, Services und Aktionen",item.mobjects.where('mtype=? ',"Angebote").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Stellenanzeigen",item.mobjects.where('mtype=?',"Stellenanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Kleinanzeigen",item.mobjects.where('mtype=?',"Kleinanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Vermietungen",item.mobjects.where('mtype=?',"Vermietungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Veranstaltungen",item.mobjects.where('mtype=?',"Veranstaltungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Sponsorenengagements",item.msponsors.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Ausflugsziele",item.mobjects.where('mtype=?',"Ausflugsziele").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Ausschreibungen",item.mobjects.where('mtype=?',"Ausschreibungen").count > 0)
        #html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Spenden)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Spenden").count > 0)
        #html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Belohnungen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Belohnungen").count > 0)
        #html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Zinsen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Zinsen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding Initiativen", item.mobjects.where('mtype=?',"Crowdfunding").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Beitraege)", item.mstats.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Digital Signage (Kampagnen)", item.signage_camps.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Digital Signage (Standorte)", item.signage_locs.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Publikationen", item.mobjects.where('mtype=?',"Publikationen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Kundenbeziehungen", item.customers.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Transaktionen",item.transactions.where('ttype=?', "Payment").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"eMail", Email.where('m_to=? or m_from=?', item.user.id, item.user.id).count > 0)
        if item.partner
          html_string = html_string + build_nav("Institutionen",item,"Links (Partner)", item.partner_links.count > 0)
        end

      when "Objekte"
        html_string = html_string + build_nav("Objekte",item,"Info",item)

        if user_signed_in?
          if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
          html_string = html_string + build_nav("Objekte",item,"Details",item.mdetails.where('mtype=?',"Details").count > 0)
          end
        end 
        
        if item.mtype == "Angebote" or item.mtype == "Stellenanzeigen"
          html_string = html_string + build_nav("Objekte",item,"Ansprechpartner",item.madvisors.count > 0)
        end
        if item.mtype == "Veranstaltungen"
          html_string = html_string + build_nav("Objekte",item,"Eintrittskarten",item.tickets.count > 0)
          html_string = html_string + build_nav("Objekte",item,"Sponsorenengagements",item.msponsors.count > 0)
          html_string = html_string + build_nav("Objekte",item,"Teilnehmer (Veranstaltungen)",item.participants.count > 0)
        end
        if item.mtype == "Vermietungen"
          html_string = html_string + build_nav("Objekte",item,"Kalender (Vermietungen)",item.mcalendars.count > 0)
        end
        if item.mtype == "Ausschreibungen"
          html_string = html_string + build_nav("Objekte",item,"Ausschreibungsangebote",item.mdetails.where('mtype=?',"Ausschreibungsangebote").count > 0)
        end
        if item.mtype == "Artikel"
          #html_string = html_string + build_nav("Objekte",item,"Blog",item.comments.count > 0)
        end
        if item.mtype == "Publikationen"
          html_string = html_string + build_nav("Objekte",item,"Ausgaben",item.editions.count > 0)
        end
        if item.mtype == "Crowdfunding"
          html_string = html_string + build_nav("Objekte",item,"CF Statistik",item.mstats.count > 0)
          html_string = html_string + build_nav("Objekte",item,"CF Transaktionen",item.mstats.count > 0)
        end
        if item.mtype != "Artikel"
          html_string = html_string + build_nav("Objekte",item,"Bewertungen",item.mratings.count > 0)
        end

      when "Kampagnen"
        html_string = html_string + build_nav("Kampagnen",item, "Info",item)
        html_string = html_string + build_nav("Kampagnen",item,"Details",item.signages.count > 0)
        html_string = html_string + build_nav("Kampagnen",item,"Standorte",item.signage_cals.count > 0)
        html_string = html_string + build_nav("Kampagnen",item,"Kalender",item.signage_cals.count > 0)

      when "Standorte"
        html_string = html_string + build_nav("Standorte",item, "Info",item)
        html_string = html_string + build_nav("Standorte",item,"Kampagnen",item.signage_cals.count > 0)
        html_string = html_string + build_nav("Standorte",item,"Kalender",item.signage_cals.count > 0)
    end
    
    #html_string = html_string + "</div></div></navigate>"
    # html_string = html_string + "</navigate>"
    #html_string = html_string + "</div>"
    return html_string.html_safe
    
end

def build_nav(object, item, topic, condition)
  
  html_string=""
  if (!user_signed_in? and $activeapps.include?(object+topic)) or (user_signed_in? and getUserCreds.include?(object+topic)) or (user_signed_in? and current_user.superuser)

    if condition
      btn = "active"
    else
      btn = "inactive"
    end
    
    case object
      when "Privatpersonen"
        html_string = link_to(user_path(:id => item.id, :topic => topic), title: getIcon(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic)["icon"])
          #content_tag(:span, content_tag(:i, topic), class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic))
        end
      when "Institutionen"
        html_string = link_to(company_path(:id => item.id, :topic => topic), title: getIcon(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic)["icon"])
        end
      when "Objekte"
        html_string = link_to(mobject_path(:id => item.id, :topic => topic), title: getIcon(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic)["icon"])
        end
      when "Kampagnen"
        html_string = link_to(signage_camp_path(:id => item.id, :topic => topic), title: getIcon(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic)["icon"])
        end
      when "Standorte"
        html_string = link_to(signage_loc_path(:id => item.id, :topic => topic), title: getIcon(topic)["icontext"], 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip' ) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic)["icon"])
        end
    end
  end
  
  return html_string.html_safe
end

def action_buttons2(object, item, topic)
    html_string = "<div class='col-xs-12'><div class='panel-body'>"
    
    case object 
      when "TicketChoice"
        html_string = html_string + link_to(user_path(:id => item, :topic => "Tickets")) do
          content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
        end
        
      when "Mcategory"
        html_string = html_string + link_to(home_index9_path) do
          content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
        end
        html_string = html_string + link_to(new_mcategory_path(:ctype => item)) do
          content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
        end
        
      when "Privatpersonen"
        html_string = html_string + link_to(users_path :page => session[:page]) do
          content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
        end
        
        case topic
            when "Kalendereintraege"
              if false
              html_string = html_string + link_to(user_path(:user_id => item.id, :dir => "<", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
              end
              html_string = html_string + link_to(user_path(:user_id => item.id, :dir => ">", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-right")
              end
              end
        end
        
        if user_signed_in?
          if $activeapps.include?("PrivatpersonenFavoriten")
            html_string = html_string + link_to(new_favourit_path :object_name => "User", :object_id => item.id, :user_id => current_user.id) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-heart")
            end
          end
          if current_user.id == item.id or current_user.superuser
              html_string = html_string + link_to(edit_user_path(item)) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-wrench")
            end
            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do
                content_tag(:i, nil, class: "btn btn-danger pull-right glyphicon glyphicon-trash")
            end
          end
          html_string = html_string + link_to(new_webmaster_path :object_name => "User", :object_id => item.id, :user_id => current_user.id) do
            content_tag(:i, nil, class: "btn btn-warning pull-right glyphicon glyphicon-eye-open")
          end
          if $activeapps.include?("PrivatpersonenTransaktionen")
            html_string = html_string + link_to(listaccount_index_path :user_id => current_user.id, :user_id_ver => item.id, :company_id_ver => nil, :ref => "Vergütung an "+item.name + " " + item.lastname, :object_name => "User", :object_id => item.id, :amount => nil) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-euro")
            end
          end
          if $activeapps.include?("PrivatpersonenPositionen (Privatpersonen)")
            html_string = html_string + link_to(new_user_position_path(:user_id => current_user.id)) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-map-marker")
            end
          end
          if current_user.superuser
            html_string = html_string + link_to(credentials_path(:user_id => item.id)) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-lock")
            end
          end

          case topic
            when "Kalendereintraege"
              #html_string = html_string + link_to(user_path(:user_id => item.id, :dir => "<", :topic => topic)) do
              #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
              #end
              #html_string = html_string + link_to(user_path(:user_id => item.id, :dir => ">", :topic => topic)) do
              #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-right")
              #end
              html_string = html_string + link_to(new_appointment_path :user_id1 => item.id, :user_id2 => current_user.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Angebote", "Aktionen", "Angebote, Services und Aktionen"
              html_string = html_string + link_to(home_index8_path :user_id => current_user.id, :mtype => "Angebote") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Crowdfunding (Spenden)", "Crowdfunding (Belohnungen)", "Crowdfunding (Zinsen)", "Crowdfunding Initiativen"
              html_string = html_string + link_to(home_index8_path :user_id => current_user.id, :mtype => "Crowdfunding") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Kleinanzeigen", "Stellenanzeigen"
              html_string = html_string + link_to(home_index8_path :user_id => current_user.id, :mtype => topic) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Institutionen"
              html_string = html_string + link_to(new_company_path :user_id => current_user.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Vermietungen", "Veranstaltungen", "Ausflugsziele", "Ausschreibungen", "Publikationen", "Artikel"
              html_string = html_string + link_to(new_mobject_path :user_id => current_user.id, :mtype => topic, :msubtype => nil) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Kundenbeziehungn"
              html_string = html_string + link_to(new_customer_path :user_id => item.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "eMail"
              html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.id)) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Tickets"
              html_string = html_string + link_to(ticketuserview_index2_path(:user_id => item.id)) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
          end
          
        end

      when "Institutionen"
        html_string = html_string + link_to(companies_path :page => session[:page]) do
          content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-list")
        end
        if user_signed_in?
          if $activeapps.include?("InstitutionenFavoriten")
            html_string = html_string + link_to(new_favourit_path :object_name => "Company", :object_id => item.id, :user_id => current_user.id) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-heart")
            end
          end
          if current_user.id == item.user_id or current_user.superuser
            if item.partner
              #html_string = html_string + link_to(customer_advisor_index2_path :partner_id => item.id) do
                #content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-user")
              #end
            end
            html_string = html_string + link_to(edit_company_path(item)) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-wrench")
            end
            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do
              content_tag(:i, nil, class: "btn btn-danger pull-right glyphicon glyphicon-trash")
            end
          end
          html_string = html_string + link_to(new_webmaster_path :object_name => "Company", :object_id => item.id, :user_id => current_user.id) do
            content_tag(:i, nil, class: "btn btn-warning pull-right glyphicon glyphicon-eye-open")
          end
          if $activeapps.include?("InstitutionenTransaktionen")
            html_string = html_string + link_to(listaccount_index_path :user_id => current_user.id, :user_id_ver => nil, :company_id_ver => item.id, :ref => "Vergütung an "+item.name, :object_name => "Company", :object_id => item.id, :amount => nil) do
              content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-euro")
            end
          end
          case topic
            when "Angebote", "Aktionen", "Angebote, Services und Aktionen"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => "Angebote") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Crowdfunding (Spenden)", "Crowdfunding (Belohnungen)", "Crowdfunding (Zinsen)", "Crowdfunding Initiativen"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => "Crowdfunding") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Kleinanzeigen", "Stellenanzeigen"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => topic) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Vermietungen", "Veranstaltungen", "Ausflugsziele", "Ausschreibungen", "Publikationen"
              html_string = html_string + link_to(new_mobject_path :company_id => item.id, :mtype => topic, :msubtype => nil) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Kundenbeziehungen"
              html_string = html_string + link_to(customers_path :company_id => item.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Links (Partner)"
              html_string = html_string + link_to(new_partner_link_path :company_id => item.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Digital Signage (Kampagnen)"
              html_string = html_string + link_to(new_signage_camp_path :company_id => item.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Digital Signage (Standorte)"
              html_string = html_string + link_to(new_signage_loc_path :company_id => item.id) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
          end
        end
        
      when "Objekte"
         html_string = html_string + link_to(mobjects_path :mtype => item.mtype, :msubtype => item.msubtype, :page => session[:page]) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         case topic
            when "Info"
               if user_signed_in?
                 if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
           	        html_string = html_string + link_to(edit_mobject_path(item)) do
                       content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-wrench")
                     end
                     # Möglichkeit Service anzubieten
                     #if item.sum_amount >= item.amount
               	     #    html_string = html_string + link_to(home_index10_path(item)) do
                     #      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-lock")
                     #   end
                     #end
           	        html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do
                       content_tag(:i, nil, class:"btn btn-danger pull-right glyphicon glyphicon-trash")
                     end
                 end
                 html_string = html_string + link_to(new_webmaster_path :object_name => "Mobject", :object_id => item.id, :user_id => current_user.id) do
                   content_tag(:i, nil, class:"btn btn-warning pull-right glyphicon glyphicon-eye-open")
                 end
               end
            when "Details"
                if user_signed_in?
                  #html_string = html_string + item.owner_id.to_s + item.owner_type 
                 if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                    html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "Details")) do
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                    end
                 end
                end
            when "Ausschreibungsangebote"
                if user_signed_in?
                 if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                    html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "Ausschreibungsangebote")) do
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                    end
                 end
                end
            when "Eintrittskarten"
                if user_signed_in?
                 if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                    html_string = html_string + link_to(new_ticket_path(:mobject_id => item.id)) do
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                    end
                 end
                end
            when "Ausgaben"
                if user_signed_in?
                 if (item.owner_type == "User" and item.owner_id == current_user.id) or (item.owner_type == "Company" and item.owner.user_id == current_user.id)
                    html_string = html_string + link_to(new_edition_path(:mobject_id => item.id)) do
                      content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                    end
                 end
                end
            when "Sponsorenengagements"
              if user_signed_in?
                html_string = html_string + link_to(new_msponsor_path(:mobject_id => item.id)) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                end
              end
            when "Blog"
              if user_signed_in?
      	        html_string = html_string + link_to(new_comment_path :mobject_id => item.id, :user_id => current_user.id) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                end
              end
            when "Bewertungen"
              if user_signed_in?
      	        html_string = html_string + link_to(new_mrating_path :mobject_id => item.id, :user_id => current_user.id) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                end
              end
            when "Ansprechpartner"
              if user_signed_in?
                if (item.owner_type == "User" and item.owner_id == current_user.id)
                  html_string = html_string + link_to(madvisors_path :mobject_id => item.id) do
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                  end
                end
              end
            when "Kalender (Vermietungen)"
              if false
              html_string = html_string + link_to(mobject_path(:mobject_id => item.id, :dir => "<", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
              end
              html_string = html_string + link_to(mobject_path(:mobject_id => item.id, :dir => ">", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-right")
              end
              end
              if user_signed_in?
                html_string = html_string + link_to(new_mcalendar_path(:user_id => current_user.id, :mobject_id => item.id)) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                end
              end
            when "CF Statistik"
            when "CF Transaktionen"
              #if item.sum_amount < item.amount
                html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "User")) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-user")
                end
                html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "Company")) do
                  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-copyright-mark")
                end
              #end
            when "Standort"
         end

      when "Kampagnen"
         html_string = html_string + link_to(company_path(:id => item.owner_id, :topic => "Digital Signage (Kampagnen)")) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         html_string = html_string + link_to(home_index11_path(:camp_id => item.id)) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-film")
         end
         case topic
            when "Info"
            when "Details"
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_path(:camp_id => item.id)) do
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                  end
                end
              end
            when "Kalender"
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_cal_path(:camp_id => item.id)) do
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                  end
                end
              end
            when "Standorte"
         end

      when "Standorte"
         html_string = html_string + link_to(company_path(:id => item.owner_id, :topic => "Digital Signage (Standorte)")) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         html_string = html_string + link_to(home_index11_path(:loc_id => item.id)) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-film")
         end
         case topic
            when "Info"
            when "Kalender"
              if user_signed_in?
                if current_user.id == item.owner.user_id 
                  html_string = html_string + link_to(new_signage_cal_path(:loc_id => item.id)) do
                    content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
                  end
                end
              end
            when "Standorte"
         end

      when "Editionen"
         html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "Ausgaben")) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end

      when "Edition"
         html_string = html_string + link_to(edition_path(:id => item.id, :topic => "Info")) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end

      when "ArtikelEdition"
         html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "Ausgaben")) do
          content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-list")
         end
         #html_string = html_string + link_to(home_index11_path(:loc_id => item.id)) do
          #content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-book")
         #end
         if user_signed_in?
          if (item.mobject.owner_type == "User" and current_user.id == item.mobject.owner.id) or (item.mobject.owner_type == "Company" and current_user.id == item.mobject.owner.user_id) 
            #html_string = html_string + link_to(new_edition_arcticle_path(:edition_id => item.id)) do
            #  content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
            #end
            html_string = html_string + link_to(mobjects_path(:mtype => "Artikel", :edition_id => item.id)) do
              content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-plus")
            end
          end
        end
    end
    html_string = html_string + "</div></div>"
    return html_string.html_safe
end

def build_stats(array, records, label)
  if records != nil
    anz = records.count
    if anz > 0
      hash = Hash.new
      hash = {"label" => label, "value" => anz}
      array << hash
      return array
    end
  end
  return array
end

def getIcon(iconstring)
    icon = nil
    icontext = nil
    case iconstring

      when "Angebote, Services und Aktionen"
        icon = "shopping-cart"
        icontext = "Produkte, Services & Aktionen"
      when "Crowdfunding Initiativen"
        icon = "grain"
        icontext = "Crowdfunding Initiativen"
      when "Berechtigungen"
        icon = "lock"
        icontext = "Berechtigungen"
      when "Ausgaben"
        icon = "duplicate"
        icontext = "Ausgaben/Editionen zur Publikation"
      when "Blog"
        icon = "comment"
        icontext = "Teilen Sie uns Ihre Meinung mit - nutzen Sie den Blog"
      when "Artikel"
        icon = "text-background"
        icontext = "Artikel"
      when "Publikationen"
        icon = "book"
        icontext = "Publikationen"
      when "Eintrittskarten"
        icon = "qrcode"
        icontext = "Eintrittskarten & Tickets"
      when "Digital Signage Standorte"
        icon = "blackboard"
        icontext = "Crowdfunding Initiativen"
      when "Werbeflächen"
        icon = "blackboard"
        icontext = "Crowdfunding Initiativen"
      when "Kampagnen"
        icon = "bullhorn"
        icontext = "Werbekampagnen"
      when "Digital Signage (Kampagnen)"
        icon = "bullhorn"
        icontext = "Werbekampagnen"
      when "Digital Signage (Standorte)"
        icon = "blackboard"
        icontext = "Werbeflächen"
      when "Digital Signage (Show)"
        icon = "film"
        icontext = "Werbekampagne anzeigen"
      when "News"
        icon = "alert"
        icontext = "Benachrichtigungen"
      when "AngeboteStandard"
        icon = "info-sign"
        icontext = "Angebote, Produkte & Services"
      when "AngeboteAktionen"
        icon = "exclamation-sign"
        icontext = "befristete Sonderaktionen"
      when "StellenanzeigenSuchen"
        icon = "search"
        icontext = "Stellenanzeigen Suchen"
      when "StellenanzeigenAnbieten"
        icon = "filter"
        icontext = "Stellenanzeige Angebote"
      when "KleinanzeigenSuchen"
        icon = "search"
        icontext = "Kleinanzeigen Suchen"
      when "KleinanzeigenAnbieten"
        icon = "filter"
        icontext = "Kleinanzeigen Angebote"
      when "CrowdfundingSpenden"
        icon = "gift"
        icontext = "Spendeninitiativen"
      when "CrowdfundingBelohnungen"
        icon = "qrcode"
        icontext = "Crowdfunding"
      when "CrowdfundingZinsen"
        icon = "signal"
        icontext = "Crowdlending"
      when "KalenderGeburtstage"
        icon = "user"
        icontext = "Geburtstagskalender"
      when "KalenderAktionen"
        icon = "shopping-cart"
        icontext = "Aktionskalender"
      when "KalenderAusschreibungen"
        icon = "pencil"
        icontext = "Aussschreibungskalender"
      when "KalenderVeranstaltungen"
        icon = "glass"
        icontext = "Veranstaltungskalender"
      when "KalenderStellenanzeigen"
        icon = "briefcase"
        icontext = "befristete Stellenanzeigen"
      when "KalenderCrowdfunding"
        icon = "grain"
        icontext = "Crowdfunding Kalender"
      when "Kalender"
        icon = "calendar"
        icontext = "Kalender"
      when "Standorte"
        icon = "blackboard"
        icontext = "Werbeflächen"
      when "Info"
        icon = "info-sign"
        icontext = "Allgemeine Informationen"
      when "Kalendereintraege"
        icon = "calendar"
        icontext = "Kalender"
      when "Ansprechpartner"
        icon = "user"
        icontext = "Verantwortungen"
      when "Stellenanzeigen"
        icon = "briefcase"
        icontext = "Stellenanzeigen"
      when "Kleinanzeigen"
        icon = "pushpin"
        icontext = "Kleinanzeigen"
      when "Tickets"
        icon = "barcode"
        icontext = "Tickets & Gutscheine"
      when "Crowdfunding (Beitraege)"
        icon = "gift"
        icontext = "Crowdfunding Beiträge"
      when "Bewertungen"
        icon = "star"
        icontext = "Bewertungen"
      when "Favoriten"
        icon = "heart"
        icontext = "Persönliche Favoriten"
      when "Kundenbeziehungen"
        icon = "check"
        icontext = "Kundenbeziehungen"
      when "Kontobeziehungen"
        icon = "list"
        icontext = "Kontobeziehungen"
      when "Transaktionen"
        icon = "euro"
        icontext = "Geldtransaktionen"
      when "eMail"
        icon = "envelope"
        icontext = "Korrespondenz & Nachrichten"
      when "Positionen (Privatpersonen)"
        icon = "map-marker"
        icontext = "meine Ortungspositionen"
      when "Positionen (Favoriten)"
        icon = "map-marker"
        icontext = "Ortungspositionen meiner Favoriten"
      when "Aktivitaeten"
        icon = "dashboard"
        icontext = "Aktivitätenübersicht"
      when "Sponsorenengagements"
        icon = "heart"
        icontext = "Sponsorenengagements"
      when "Links (Partner)"
        icon = "globe"
        icontext = "Spezielle Partnerlinks"
      when "Details"
        icon = "search"
        icontext = "Geben Sie weitere Informationen an"
      when "Ausschreibungsangebote"
        icon = "book"
        icontext = "Angebote der Ausschreibung"
      when "Kalender (Vermietungen)"
        icon = "calendar"
        icontext = "Belegungskalender"
      when "Teilnehmer (Veranstaltungen)"
        icon = "subscript"
        icontext = "Teilnehmer der Veranstaltung"
      when "CF Statistik"
        icon = "dashboard"
        icontext = "Crowdfunding Statistik"
      when "CF Transaktionen"
        icon = "euro"
        icontext = "Crowdfunding Geldtransaktionen"
      when "Einstellungen"
        icon = "cog"
        icontext = "Einstellungen"
      when "meine Abfragen"
        icon = "question-sign"
        icontext = "meine Abfragen"
      when "Privatpersonen"
        icon = "user"
        icontext = "Privatpersonen"
      when "Institutionen"
        icon = "copyright-mark"
        icontext = "Firmen, Gewerbe, Vereine & Institutionen"
      when "Suchen"
        icon = "search"
        icontext = "Suchen"
      when "Anbieten"
        icon = "filter"
        icontext = "Anbieten"
      when "Angebote"
        icon = "shopping-cart"
        icontext = "Angebote und Services"
      when "Aktionen"
        icon = "shopping-cart"
        icontext = "Befristete Sonderaktionen"
      when "Standard"
        icon = "info-sign"
        icontext = "Angebote und Services"
      when "Aktion"
        icon = "exclamation-sign"
        icontext = "Befristete Sonderaktionen"
      when "Vermietungen"
        icon = "retweet"
        icontext = "Vermietungen"
      when "Ausschreibungen"
        icon = "pencil"
        icontext = "Ausschreibungen"
      when "Stellenanzeigen"
        icon = "briefcase"
        icontext = "Stellenanzeigen"
      when "Stellenanzeigen (Suchen)"
        icon = "briefcase"
        icontext = "Stellenanzeigen Suchen"
      when "Stellenanzeigen (Anbieten)"
        icon = "briefcase"
        icontext = "Stellenanzeigen Anbieten"
      when "Veranstaltungen"
        icon = "glass"
        icontext = "Veranstaltungen"
      when "Veranstaltungen (angemeldet)"
        icon = "subscript"
        icontext = "Veranstaltungsanmeldungen"
      when "Ausflugsziele"
        icon = "camera"
        icontext = "Ausflugsziele, Sehenswürdigkeiten"
      when "Kleinanzeigen"
        icon = "pushpin"
        icontext = "Kleinanzeigen"
      when "Kleinanzeigen (Suchen)"
        icon = "pushpin"
        icontext = "Kleinanzeigen Suchen"
      when "Kleinanzeigen (Anbieten)"
        icon = "pushpin"
        icontext = "Kleinanzeigen Anbieten"
      when "Crowdfunding"
        icon = "grain"
        icontext = "Crowdfunding Initiativen"
      when "Spenden"
        icon = "gift"
        icontext = "Spendeninitiativen"
      when "Belohnungen"
        icon = "qrcode"
        icontext = "Reward Initiativen"
      when "Zinsen"
        icon = "signal"
        icontext = "Crowdlending"
      when "Crowdfunding (Spenden)"
        icon = "grain"
        icontext = "Spendeninitiativen"
      when "Crowdfunding (Belohnungen)"
        icon = "grain"
        icontext = "Reward Initiativen"
      when "Crowdfunding (Zinsen)"
        icon = "grain"
        icontext = "Crowdlending"
      when "Kalender (Aktionen)"
        icon = "calendar"
        icontext = "Aktionskalender"
      when "Kalender (Veranstaltungen)"
        icon = "calendar"
        icontext = "Veranstaltungskalender"
      when "Kalender (Ausschreibungen)"
        icon = "calendar"
        icontext = "Aussschreibungskalender"
      when "Neues Angebot"
        icon = "shopping-cart"
      when "Neue Aktion"
        icon = "shopping-cart"
      when "Neue Kleinanzeige (Anbieten)"
        icon = "align-justify"
      when "Neue Kleinanzeige (Suchen)"
        icon = "align-justify"
      when "Neue Stellenanzeige (Anbieten)"
        icon = "briefcase"
      when "Neue Stellenanzeige (Suchen)"
        icon = "briefcase"
      when "Neue Crowdfunding-Initiative (Spenden)"
        icon = "grain"
      when "Neue Crowdfunding-Initiative (Belohnungen)"
        icon = "grain"
      when "Neue Crowdfunding-Initiative (Zinsen)"
        icon = "grain"
      else
        icon = "question-mark"
    end
    if !icon
      icon = "question-mark"
    end
    if !icontext
      icontext = "kein Hinweistext verfügbar"
    end
    ret = Hash.new
    ret = {"icon" => icon, "icontext" => icontext}
    
    return ret
end

def build_kachel_color(domain, name, path_param, user_id, company_id)
    case domain
    
     when "Einstellungen"
        path = credentials_path(:user_id => current_user.id)
        pic = image_def(domain, domain, nil)

      when "meine Abfragen"
        path = home_index6_path
        pic = image_def(domain, domain, nil)

      when "Privatpersonen"
        path = users_path(:mtype => nil, :msubtype => nil)
        pic = image_def(domain, domain, nil)

      when "Institutionen"
        path = companies_path(:mtype => nil, :msubtype => nil)
        pic = image_def(domain, domain, nil)

      when "Angebote"
        path = mobjects_path(:mtype => "Angebote", :msubtype => "Standard")
        pic = image_def("Object", "Angebote", "Standard")

      when "Aktionen"
        path = mobjects_path(:mtype => "Angebote", :msubtype => "Aktion")
        pic = image_def("Object", "Angebote", "Aktion")

      when "Vermietungen"
        path = mobjects_path(:mtype => "Vermietungen", :msubtype => nil)
        pic = image_def("Object", "Vermietungen", nil)

      when "Publikationen"
        path = mobjects_path(:mtype => "Publikationen", :msubtype => nil)
        pic = image_def("Object", "Publikationen", nil)

      when "Ausschreibungen"
        path = mobjects_path(:mtype => "Ausschreibungen", :msubtype => nil)
        pic = image_def("Object", "Ausschreibungen", nil)

      when "Stellenanzeigen (Suchen)"
        path = mobjects_path(:mtype => "Stellenanzeigen", :msubtype => "Suchen")
        pic = image_def("Object", "Stellenanzeigen", "Suchen")

      when "Stellenanzeigen (Anbieten)"
        path = mobjects_path(:mtype => "Stellenanzeigen", :msubtype => "Anbieten")
        pic = image_def("Object", "Stellenanzeigen", "Anbieten")

      when "Veranstaltungen"
        path = mobjects_path(:mtype => "Veranstaltungen", :msubtype => nil)
        pic = image_def("Object", "Veranstaltungen", nil)

      when "Veranstaltungen (angemeldet)"
        path = mobjects_path(:mtype => "Veranstaltungen", :msubtype => nil)
        pic = image_def("Object", "Veranstaltungen", nil)

      when "Teilnehmer (Veranstaltungen)"
        path = mobjects_path(:mtype => "Veranstaltungen", :msubtype => nil)
        pic = image_def("Object", "Veranstaltungen", nil)

      when "Ausflugsziele"
        path = mobjects_path(:mtype => "Ausflugsziele", :msubtype => nil)
        pic = image_def("Object", "Ausflugsziele", nil)

      when "Kleinanzeigen (Suchen)"
        path = mobjects_path(:mtype => "Kleinanzeigen", :msubtype => "Suchen")
        pic = image_def("Object", "Kleinanzeigen", "Suchen")

      when "Kleinanzeigen (Anbieten)"
        path = mobjects_path(:mtype => "Kleinanzeigen", :msubtype => "Anbieten")
        pic = image_def("Object", "Kleinanzeigen", "Anbieten")

      when "Crowdfunding (Spenden)"
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Spenden")
        pic = image_def("Object", "Crowdfunding", "Spenden")

      when "Crowdfunding (Belohnungen)"
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Belohnungen")
        pic = image_def("Object", "Crowdfunding", "Belohnungen")

      when "Crowdfunding (Zinsen)"
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Zinsen")
        pic = image_def("Object", "Crowdfunding", "Zinsen")

      when "Kalender (Aktionen)"
        path = showcal_index_path(:mtype => "Angebote", :msubtype => "Aktion")
        pic = "calendar.jpg"

      when "Kalender (Veranstaltungen)"
        path = showcal_index_path(:mtype => "Veranstaltungen", :msubtype => nil)
        pic = "calendar.jpg"

      when "Kalender (Ausschreibungen)"
        path = showcal_index_path(:mtype => "Ausschreibungen", :msubtype => nil)
        pic = "calendar.jpg"

      when "Neues Angebot"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Angebote", :msubtype => "Standard")
        pic = "angebot.jpg"

      when "Neue Aktion"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Angebote", :msubtype => "Aktion")
        pic = "aktion.jpg"

      when "Neue Kleinanzeige (Anbieten)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Kleinanzeigen", :msubtype => "Anbieten")
        pic = "kleinanzeige.jpg"

      when "Neue Kleinanzeige (Suchen)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Kleinanzeigen", :msubtype => "Suchen")
        pic = "kleinanzeige.jpg"

      when "Neue Stellenanzeige (Anbieten)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Stellenanzeigen", :msubtype => "Anbieten")
        pic = "stellenanzeige.jpg"

      when "Neue Stellenanzeige (Suchen)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Stellenanzeigen", :msubtype => "Suchen")
        pic = "stellenanzeige.jpg"

      when "Neue Crowdfunding-Initiative (Spenden)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id,  :mtype => "Crowdfunding", :msubtype => "Spenden")
        pic = "spende.jpg"

      when "Neue Crowdfunding-Initiative (Belohnungen)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Crowdfunding", :msubtype => "Belohnungen")
        pic = "belohnung.jpg"

      when "Neue Crowdfunding-Initiative (Zinsen)"
        path = new_mobject_path(:user_id => user_id, :company_id => company_id, :mtype => "Crowdfunding", :msubtype => "Zinsen")
        pic = "kredit.jpg"

    end
    
    icon = getIcon(domain)["icon"]
    if path_param
      path = path_param
    end
    
    html_string = ""
    html_string = html_string + link_to(path) do
      content_tag(:div, nil, class:"col-xs-12 col-sm-12 col-md-6 col-lg-4") do
        content_tag(:div, nil, class:"panel-body panel-nav") do
          temp = content_tag(:div, nil, class:"col-xs-3 col-sm-3 col-md-3 col-lg-3") do
            icon_size = "4"
            content_tag(:i, nil, class:"glyphicon glyphicon-" + icon, style:"font-size:" + icon_size + "em") 
          end
          temp = temp + content_tag(:div, nil, class:"col-xs-7 col-sm-7 col-md-7 col-lg-7") do
            content_tag(:home_nav, domain)
          end
          temp = temp + content_tag(:div, nil, class:"col-xs-2 col-sm-2 col-md-2 col-lg-2") do
            content_tag(:i, nil, class:"glyphicon glyphicon-chevron-right pull-right")
          end
        end
      end
    end

    return html_string.html_safe
    
end

def build_hauptmenue

    html_string = ""

    if user_signed_in?  
      init_apps
      creds = getUserCreds
    else
      creds = init_apps
    end

    if creds.include?("Hauptmenue"+"News") and user_signed_in?
        domain = "News"
        path = home_index10_path
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Privatpersonen")
        domain = "Privatpersonen"
        path = users_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Institutionen")
        domain = "Institutionen"
        path = companies_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Angebote")
        hasharray = []
        if creds.include?("Hauptmenue"+"AngeboteStandard")
          path = mobjects_path(:mtype => "Angebote", :msubtype => "Standard")
          hash = Hash.new
          hash = {"path" => path, "text" => "Standard", "icon" => "Standard" }
          hasharray << hash
        end
        if creds.include?("Hauptmenue"+"AngeboteAktionen")
          path = mobjects_path(:mtype => "Angebote", :msubtype => "Aktion")
          hash = Hash.new
          hash = {"path" => path, "text" => "Aktion", "icon" => "Aktion" }
          hasharray << hash
        end
        domain = "Angebote"
        domain_text = domain
        #html_string = html_string + hasharray.to_s
        html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    if creds.include?("Hauptmenue"+"Vermietungen")
        domain = "Vermietungen"
        path = mobjects_path(:mtype => "Vermietungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Ausschreibungen")
        domain = "Ausschreibungen"
        path = mobjects_path(:mtype => "Ausschreibungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Publikationen")
        domain = "Publikationen"
        path = mobjects_path(:mtype => "Publikationen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Artikel")
        domain = "Artikel"
        path = mobjects_path(:mtype => "Artikel", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Stellenanzeigen")
        hasharray = []
        domain = "Stellenanzeigen"
        domain_text = domain
        if creds.include?("Hauptmenue"+"StellenanzeigenSuchen")
          path = mobjects_path(:mtype => "Stellenanzeigen", :msubtype => "Suchen")
          hash = Hash.new
          hash = {"path" => path, "text" => "Suchen", "icon" => "Suchen" }
          hasharray << hash
        end
        if creds.include?("Hauptmenue"+"StellenanzeigenAnbieten")
          path = mobjects_path(:mtype => "Stellenanzeigen", :msubtype => "Anbieten")
          hash = Hash.new
          hash = {"path" => path, "text" => "Anbieten", "icon" => "Anbieten" }
          hasharray << hash
        end
        html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    if creds.include?("Hauptmenue"+"Veranstaltungen")
        domain = "Veranstaltungen"
        path = mobjects_path(:mtype => "Veranstaltungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Ausflugsziele")
        domain = "Ausflugsziele"
        path = mobjects_path(:mtype => "Ausflugsziele", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    if creds.include?("Hauptmenue"+"Kleinanzeigen")
        hasharray = []
        domain = "Kleinanzeigen"
        domain_text = domain
      if creds.include?("Hauptmenue"+"KleinanzeigenSuchen")
        path = mobjects_path(:mtype => "Kleinanzeigen", :msubtype => "Suchen")
        hash = Hash.new
        hash = {"path" => path, "text" => "Suchen", "icon" => "Suchen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"KleinanzeigenAnbieten")
        path = mobjects_path(:mtype => "Kleinanzeigen", :msubtype => "Anbieten")
        hash = Hash.new
        hash = {"path" => path, "text" => "Anbieten", "icon" => "Anbieten" }
        hasharray << hash
      end
      html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end

    if creds.include?("Hauptmenue"+"Crowdfunding")
        hasharray = []
        domain = "Crowdfunding"
        domain_text = domain
      if creds.include?("Hauptmenue"+"CrowdfundingSpenden")
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Spenden")
        hash = Hash.new
        hash = {"path" => path, "text" => "Spenden", "icon" => "Spenden" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"CrowdfundingBelohnungen")
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Belohnungen")
        hash = Hash.new
        hash = {"path" => path, "text" => "Belohnungen", "icon" => "Belohnungen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"CrowdfundingZinsen")
        path = mobjects_path(:mtype => "Crowdfunding", :msubtype => "Zinsen")
        hash = Hash.new
        hash = {"path" => path, "text" => "Zinsen", "icon" => "Zinsen" }
        hasharray << hash
      end
      html_string = html_string + complex_menue(domain, domain_text, hasharray)
    end
    
    if creds.include?("Hauptmenue"+"Digital Signage (Standorte)")
        domain = "Werbeflächen"
        path = signage_locs_path
        html_string = html_string + simple_menue(domain, path)
    end
    
    if creds.include?("Hauptmenue"+"Kalender")
      hasharray = []
      domain = "Kalender"
      domain_text = domain
      if creds.include?("Hauptmenue"+"KalenderGeburtstage")
        if user_signed_in?
          path = showcal_index_path + "?dom=Geburtstage"
          hash = Hash.new
          hash = {"path" => path, "text" => "Geburtstage Favoriten", "icon" => "Privatpersonen" }
          hasharray << hash
        end
      end
      if creds.include?("Hauptmenue"+"KalenderAktionen")
        path = showcal_index_path + "?dom=Aktionen"
        hash = Hash.new
        hash = {"path" => path, "text" => "Aktionen", "icon" => "Aktionen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"KalenderAusschreibungen")
        path = showcal_index_path + "?dom=Ausschreibungen"
        hash = Hash.new
        hash = {"path" => path, "text" => "Ausschreibungen", "icon" => "Ausschreibungen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"KalenderVeranstaltungen")
        path = showcal_index_path + "?dom=Veranstaltungen"
        hash = Hash.new
        hash = {"path" => path, "text" => "Veranstaltungen", "icon" => "Veranstaltungen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"KalenderStellenanzeigen")
        path = showcal_index_path + "?dom=Stellenanzeigen"
        hash = Hash.new
        hash = {"path" => path, "text" => "Stellenanzeigen", "icon" => "Stellenanzeigen" }
        hasharray << hash
      end
      if creds.include?("Hauptmenue"+"KalenderCrowdfunding")
        path = showcal_index_path + "?dom=Crowdfunding"
        hash = Hash.new
        hash = {"path" => path, "text" => "Crowdfunding", "icon" => "Crowdfunding" }
        hasharray << hash
      end
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
          content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(domain)["icon"], style:"font-size:" + icon_size + "em") 
        end
        temp = temp + content_tag(:div, nil, class:"col-xs-7 col-sm-7 col-md-7 col-lg-7") do
          content_tag(:home_nav, domain)
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
  html_string = "<" + domain + ">"
  html_string = html_string + content_tag(:div, nil, class:"col-xs-12 col-sm-12 col-md-6 col-lg-4") do
    content_tag(:div, nil, class:"panel-body panel-nav") do
      
      temp = content_tag(:div, nil, class:"col-xs-3 col-sm-3 col-md-3 col-lg-3") do
        icon_size = "4"
        content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(domain)["icon"], style:"font-size:" + icon_size + "em") 
      end
      temp = temp + content_tag(:div, nil, class:"col-xs-9 col-sm-9 col-md-9 col-lg-9") do
        temp2 = content_tag(:home_nav, domain_text) + "<br><br>".html_safe
        temp2 = temp2 + content_tag(:home_nav_small, build_sub_menu(domain, domain_text, hasharray))
      end
    end
  end
  html_string = html_string + "</" + domain + ">"
  return html_string.html_safe
end

def build_sub_menu(domain, domain_text, hasharray)
  html_string = "<" + domain + "_options" + ">"
  for i in 0..hasharray.length-1
        html_string = html_string + "<a href="+hasharray[i]["path"] + ">"
        html_string = html_string + "<i class='glyphicon glyphicon-"+getIcon(hasharray[i]["icon"])["icon"]+"' style='font-size:2em'> </i> "
        html_string = html_string + hasharray[i]["text"]
        html_string = html_string + "</a><br><br>"
  end
  html_string = html_string + "</" + domain + "_options" + ">"
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
          cpath = credentials_path(:id => @credential.id, :user_id => user.id)
        end
      end
    end

    if !forget

      html_string = html_string + link_to(cpath) do
        content_tag(:div, nil, class:"col-xs-4 col-sm-4 col-md-3 col-lg-2") do 
          content_tag(:div, nil, class:"thumbnail " + thumbnail_state, align:"center") do
            content_tag(:span, nil) do
              icon_size = "4"
              content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(a.right)["icon"], style:"font-size:" + icon_size + "em") + content_tag(:small_cal, "<br>".html_safe+a.right)
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
      when "Privatpersonen"
        pic = "user.jpg"
      when "Institutionen"
        pic = "company.jpg"
        
      when "Objekte"
        case mtype
          when "Angebote"
            if msubtype == "Standard"
              pic = "angebot.jpg"
            else
              pic = "aktion.jpg"
            end

          when "Artikel"
            pic = "artikel.jpg"

          when "Vermietungen"
            pic = "vermietung.jpg"

          when "Publikationen"
            pic = "publication.jpg"

          when "Ausschreibungen"
            pic = "ausschreibung.jpg"

          when "Ausflugsziele"
            pic = "ausflug.jpg"

          when "Veranstaltungen"
            pic = "veranstaltung.jpg"
          when "Anmeldungen"
            pic = "veranstaltung.jpg"

          when "Stellenanzeigen"
            if msubtype == "Suchen"
              pic = "stellenanzeige.jpg"
            else
              pic = "stellenanzeige.jpg"
            end

          when "Kleinanzeigen"
            if msubtype == "Suchen"
              pic = "kleinanzeige.jpg"
            else
              pic = "kleinanzeige.jpg"
            end

          when "Crowdfunding"
            case msubtype
              when "Spenden"
                pic = "spende.jpg"
              when "Belohnungen"
                pic = "belohnung.jpg"
              when "Zinsen"
                pic = "kredit.jpg"
            end

          when "Kalender (Aktionen)"
            pic = "calendar.jpg"
          when "Kalender (Veranstaltungen)"
            pic = "calendar.jpg"
          when "Kalender (Ausschreibungen)"
            pic = "calendar.jpg"
    
          when "Neues Angebot"
            pic = "angebot.jpg"
          when "Neue Aktion"
            pic = "aktion.jpg"
    
          when "Neue Kleinanzeige (Anbieten)"
            pic = "kleinanzeige.jpg"
          when "Neue Kleinanzeige (Suchen)"
            pic = "kleinanzeige.jpg"
    
          when "Neue Stellenanzeige (Anbieten)"
            pic = "stellenanzeige.jpg"
          when "Neue Stellenanzeige (Suchen)"
            pic = "stellenanzeige.jpg"
    
          when "Neue Crowdfunding-Initiative (Spenden)"
            pic = "spende.jpg"
          when "Neue Crowdfunding-Initiative (Belohnungen)"
            pic = "belohnung.jpg"
          when "Neue Crowdfunding-Initiative (Zinsen)"
            pic = "kredit.jpg"
          else
            pic = "no_pic.jpg"
        end
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
    hash = {"domain" => "Hauptmenue", "right" => "News", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Privatpersonen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Institutionen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Angebote", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Angebote", "right" => "AngeboteStandard", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Angebote", "right" => "AngeboteAktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Vermietungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Ausschreibungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Stellenanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Stellenanzeigen", "right" => "StellenanzeigenAnbieten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Stellenanzeigen", "right" => "StellenanzeigenSuchen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Veranstaltungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Ausflugsziele", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Kleinanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Publikationen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Artikel", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kleinanzeigen", "right" => "KleinanzeigenAnbieten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kleinanzeigen", "right" => "KleinanzeigenSuchen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Crowdfunding", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingSpenden", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingBelohnungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingZinsen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Digital Signage (Standorte)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Kalender", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderGeburtstage", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderAktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderCrowdfunding", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderStellenanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderVeranstaltungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderAusschreibungen", "access" => false}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Info", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kalendereintraege", "access" => false}
    @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Privatpersonen", "right" => "Angebote", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Privatpersonen", "right" => "Aktionen", "access" => false}
    # @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Angebote, Services und Aktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ansprechpartner", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Institutionen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Stellenanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kleinanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Vermietungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Veranstaltungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Veranstaltungen (angemeldet)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Tickets", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ausflugsziele", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ausschreibungen", "access" => false}
    @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Spenden)", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Belohnungen)", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Zinsen)", "access" => false}
    # @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding Initiativen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Beitraege)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Bewertungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Favoriten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Publikationen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Artikel", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kundenbeziehungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kontobeziehungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Transaktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "eMail", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Positionen (Privatpersonen)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Positionen (Favoriten)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Aktivitaeten", "access" => false}
    @array << hash
    #hash = Hash.new
    #hash = {"domain" => "Privatpersonen", "right" => "Berechtigungen", "access" => false}
    #@array << hash
    
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Info", "access" => true}
    @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Institutionen", "right" => "Angebote", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Institutionen", "right" => "Aktionen", "access" => false}
    # @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Angebote, Services und Aktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Stellenanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kleinanzeigen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Vermietungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Veranstaltungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Sponsorenengagements", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Ausflugsziele", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Ausschreibungen", "access" => false}
    @array << hash
    hash = Hash.new
    # hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Spenden)", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Belohnungen)", "access" => false}
    # @array << hash
    # hash = Hash.new
    # hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Zinsen)", "access" => false}
    # @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding Initiativen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Beitraege)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Publikationen", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kundenbeziehungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kontobeziehungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Transaktionen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "eMail", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Favoriten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Links (Partner)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Aktivitaeten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Digital Signage (Kampagnen)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Digital Signage (Standorte)", "access" => false}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Info", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Details", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Eintrittskarten", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Sponsorenengagements", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Ansprechpartner", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Kalender (Vermietungen)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Teilnehmer (Veranstaltungen)", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Ausschreibungsangebote", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Bewertungen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Blog", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Ausgaben", "access" => true}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "CF Statistik", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "CF Transaktionen", "access" => false}
    @array << hash
    
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => "Info", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => "Details", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => "Kalender", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Kampagnen", "right" => "Standorte", "access" => false}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => "Info", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => "Kampagnen", "access" => false}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Standorte", "right" => "Kalender", "access" => false}
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
            when "Zitat"
              html_string = html_string + "<artikel_quote>" + '"' + d.description + '"' + "</artikel_quote><br>"
            when "Link"
              html_string = html_string + "<artikel_link>"
              html_string = html_string + link_to(url_with_protocol(d.description), target: "_blank") do
                content_tag(:div, d.description)
              end
              html_string = html_string + "</artikel_link>"

            when "Abstimmung"
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
              
            when "Text"
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
          when "Bewertung"
              #html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header><br>"
              html_string = html_string + "<div class='row'>"
                html_string = html_string + "<div class='panel-group' id='accordionB"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<div class='panel panel-blog'>"
                  
                    html_string = html_string + "<h4 class='panel panel-blog'>"
                      html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionB"+article.id.to_s+"' href='#collapseTwoB"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                        html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header> "
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

          when "Blog"
              #html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header><br>"
              html_string = html_string + "<div class='row'>"
                html_string = html_string + "<div class='panel-group' id='accordionG"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<div class='panel panel-blog'>"
                  
                    html_string = html_string + "<h4 class='panel panel-blog'>"
                      html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionG"+article.id.to_s+"' href='#collapseTwoG"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                        html_string = html_string + "<artikel_subheader>"+ d.name + "</artikel_header> "
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

end    