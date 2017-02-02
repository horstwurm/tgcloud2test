module UsersHelper
  
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
    
    if false
    if items.table_name == "users"
    html_string = html_string + "<a href=/users/" + item.id.to_s + "> " + item.name + " " + item.lastname + "</a>"
    end
    if items.table_name == "companies"
    html_string = html_string + "<a href=/companies/" + item.id.to_s + "> " + item.name + "</a>"
    end
    if items.table_name == "mobjects"
    html_string = html_string + "<a href=/mobjects/" + item.id.to_s + "> " + item.name + "</a>"
    end
    end
  
    if item and show
      
      html_string = html_string + '<div class="col-xs-12 col-sm-12 col-md-6 col-lg-4 col-xl-4">'
        html_string = html_string + '<div class="thumbnail thumbnail-list">'
        
          html_string = html_string + '<div class="panel-body panel-listhead">'

            case items.table_name
                when "users"
                  html_string = html_string + item.name + " " + item.lastname
                    #item.name + content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-info-sign")
                  #end  
                  #"<a href=/users/" + item.id.to_s + "> " + item.name + " " + item.lastname + "</a>"
                when "companies", "mobjects", "searches", "mdetails"
                  html_string = html_string + item.name
                when "customers"
                  @comp = Company.find(item.partner_id)
                  html_string = html_string + @comp.name
                when "madvisors", "participants"
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
                when "mratings"
                  html_string = html_string + item.user.name + " " + item.user.lastname
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
                  when "users", "companies"
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
                  when "mratings"
                    html_string = html_string + showImage2(:medium, item.user, true)
                  when "mobjects"
                    html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
                  when "mratings"
                    html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                  when "mstats"
                    if par == "CF"
                      html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                    end
                    if par == "Owner"
                      html_string = html_string + showImage2(:medium, item.owner, true)
                    end
                  when "madvisors", "participants"
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
                          content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.mtype), style:"font-size:8em") 
                          #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                        end
                      else
                        case item.search_domain
                          when "Privatpersonen"
                            html_string = html_string + link_to(users_path(:filter_id => item.id)) do
                              content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "Tickets"
                              #content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              html_string = html_string + image_tag(image_def("Privatpersonen", item.mtype, item.msubtype))
                          when "Institutionen"
                            html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                              content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.search_domain), style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                          when "Objekte"
                            html_string = html_string + link_to(mobjects_path(:filter_id => item.id)) do
                              content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(item.mtype), style:"font-size:8em") 
                              #image_tag(image_def(item.search_domain, item.mtype, item.msubtype))
                            end
                        end
                      end
                  when "transactions"
                    html_string = html_string + showImage2(:medium, @ac_ver.customer.owner, true)
                end

              html_string = html_string + '</div>'
            html_string = html_string + '</div>'

            html_string = html_string + '<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">'
              html_string = html_string + '<div class="panel-header panel-media"><list>'
                case items.table_name
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
                when "users"
                  if item.id == current_user.id or current_user.superuser
                    access=true
                  end 
                when "favourits", "searches", "mratings"
                  if item.user_id == current_user.id
                    access=true
                  end 
                when "mobjects", "partners", "mstats", "transactions"
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
  return html_string.html_safe
end

def showFirstImage2(size, item, details)
      #case size
      #  when :small
      #      si = "50x50"
      #  when :thumb
      #      si = "100x100"
      #  when :medium
      #      si = "250x250"
      #  when :big
      #      si = "500x500"
      #end
    html_string = link_to item do
      if details.count > 0
        pic = details.first
        if pic.avatar_file_name
          image_tag pic.avatar(size), class:"img-rounded"
        else
          image_tag(image_def("Objekte", item.mtype, item.msubtype), :size => size, class:"card-img-top img-responsive" )
        end
      else
        image_tag(image_def("Objekte", item.mtype, item.msubtype), :size => size, class:"card-img-top img-responsive" )
      end
    end
    return html_string.html_safe
end

def showImage2(size, item, linkit)
  
   #html_string = "<a href=/users/" + item.id.to_s + "> test </a>"
   #return html_string.html_safe
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
    if linkit
      html_string = link_to(item) do
        if item.avatar_file_name
            image_tag item.avatar(size), class:"card-img-top img-responsive"
        else
          case item.class.name
            when "User"
              image_tag(image_def("Privatpersonen", nil, nil), :size => size, class:"card-img-top img-responsive" )
            when "Company"
              image_tag(image_def("Institutionen", nil, nil), :size => size, class:"card-img-top img-responsive" )
            else
              image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive" )
          end
        end
      end
    else
      if item.avatar_file_name
          html_string = image_tag item.avatar(size), class:"card-img-top img-responsive"
      else
        case item.class.name
          when "User"
            html_string = image_tag(image_def("Privatpersonen", nil, nil), :size => size, class:"card-img-top img-responsive" )
          when "Company"
            html_string = image_tag(image_def("Institutionen", nil, nil), :size => size, class:"card-img-top img-responsive" )
          else
            html_string = image_tag("no_pic.jpg", :size => size, class:"card-img-top img-responsive" )
        end
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
        html_string = html_string + build_nav("Privatpersonen",item,"Angebote",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Standard").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Aktionen",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Aktion").count > 0)
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
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Spenden)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Spenden").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Belohnungen)",item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Belohnungen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Zinsen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Zinsen").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Crowdfunding (Beitraege)", item.mstats.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Bewertungen", item.mratings.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Favoriten",item.favourits.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Kundenbeziehungen", item.customers.count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"Transaktionen", item.transactions.where('ttype=?', "Payment").count > 0)
        html_string = html_string + build_nav("Privatpersonen",item,"eMail", Email.where('m_to=? or m_from=?', item.id, item.id).count > 0)

      when "Institutionen"
        html_string = html_string + build_nav("Institutionen",item,"Info",item)
        html_string = html_string + build_nav("Institutionen",item,"Angebote",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Standard").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Aktionen",item.mobjects.where('mtype=? and msubtype=?',"Angebote", "Aktion").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Stellenanzeigen",item.mobjects.where('mtype=?',"Stellenanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Kleinanzeigen",item.mobjects.where('mtype=?',"Kleinanzeigen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Vermietungen",item.mobjects.where('mtype=?',"Vermietungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Veranstaltungen",item.mobjects.where('mtype=?',"Veranstaltungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Sponsorenengagements",item.msponsors.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Ausflugsziele",item.mobjects.where('mtype=?',"Ausflugsziele").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Ausschreibungen",item.mobjects.where('mtype=?',"Ausschreibungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Spenden)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Spenden").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Belohnungen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Belohnungen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Zinsen)", item.mobjects.where('mtype=? and msubtype=?',"Crowdfunding", "Zinsen").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Crowdfunding (Beitraege)", item.mstats.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Kundenbeziehungen", item.customers.count > 0)
        html_string = html_string + build_nav("Institutionen",item,"Transaktionen",item.transactions.where('ttype=?', "Payment").count > 0)
        html_string = html_string + build_nav("Institutionen",item,"eMail", Email.where('m_to=? or m_from=?', item.user.id, item.user.id).count > 0)
        if item.partner
          html_string = html_string + build_nav("Institutionen",item,"Links (Partner)", item.partner_links.count > 0)
        end

      when "Objekte"
        html_string = html_string + build_nav("Objekte",item,"Info",item)
        html_string = html_string + build_nav("Objekte",item,"Details",item.mdetails.where('mtype=?',"Details").count > 0)
        if item.mtype == "Veranstaltungen"
          html_string = html_string + build_nav("Objekte",item,"Sponsorenengagements",item.msponsors.count > 0)
        end
        if item.mtype == "Angebote" or item.mtype == "Stellenanzeigen"
          html_string = html_string + build_nav("Objekte",item,"Ansprechpartner",item.madvisors.count > 0)
        end
        if item.mtype == "Veranstaltungen"
          html_string = html_string + build_nav("Objekte",item,"Teilnehmer (Veranstaltungen)",item.participants.count > 0)
        end
        if item.mtype == "Vermietungen"
          html_string = html_string + build_nav("Objekte",item,"Kalender (Vermietungen)",item.mcalendars.count > 0)
        end
        if item.mtype == "Ausschreibungen"
          html_string = html_string + build_nav("Objekte",item,"Ausschreibungsangebote",item.mdetails.where('mtype=?',"Ausschreibungsangebote").count > 0)
        end
        if item.mtype == "Crowdfunding"
          html_string = html_string + build_nav("Objekte",item,"CF Statistik",item.mstats.count > 0)
          html_string = html_string + build_nav("Objekte",item,"CF Transaktionen",item.mstats.count > 0)
        end
        html_string = html_string + build_nav("Objekte",item,"Bewertungen",item.mratings.count > 0)

    end
    
    #html_string = html_string + "</div></div></navigate>"
    # html_string = html_string + "</navigate>"
    #html_string = html_string + "</div>"
    return html_string.html_safe
    
end

def build_nav(object, item, topic, condition)
  
  html_string=""
  if $activeapps.include?(object+topic)

    if condition
      btn = "active"
    else
      btn = "inactive"
    end
    
    case object
      when "Privatpersonen"
        html_string = link_to(user_path(:id => item.id, :topic => topic)) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic))
        end
      when "Institutionen"
        html_string = link_to(company_path(:id => item.id, :topic => topic)) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic))
        end
      when "Objekte"
        html_string = link_to(mobject_path(:id => item.id, :topic => topic)) do
          content_tag(:i, nil, class:"btn btn-"+btn+" glyphicon glyphicon-" + getIcon(topic))
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
              html_string = html_string + link_to(user_path(:user_id => item.id, :dir => "<", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
              end
              html_string = html_string + link_to(user_path(:user_id => item.id, :dir => ">", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-right")
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
            when "Angebote", "Aktionen"
              html_string = html_string + link_to(home_index8_path :user_id => current_user.id, :mtype => "Angebote") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Crowdfunding (Spenden)", "Crowdfunding (Belohnungen)", "Crowdfunding (Zinsen)"
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
            when "Vermietungen", "Veranstaltungen", "Ausflugsziele", "Ausschreibungen"
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
            when "Angebote", "Aktionen"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => "Angebote") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Crowdfunding (Spenden)", "Crowdfunding (Belohnungen)", "Crowdfunding (Zinsen)"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => "Crowdfunding") do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Kleinanzeigen", "Stellenanzeigen"
              html_string = html_string + link_to(home_index8_path :company_id => item.id, :mtype => topic) do
                content_tag(:i, nil, class: "btn btn-primary glyphicon glyphicon-plus")
              end
            when "Vermietungen", "Veranstaltungen", "Ausflugsziele", "Ausschreibungen"
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
            when "Sponsorenengagements"
              if user_signed_in?
                html_string = html_string + link_to(new_msponsor_path(:mobject_id => item.id)) do
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
              html_string = html_string + link_to(mobject_path(:mobject_id => item.id, :dir => "<", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-left")
              end
              html_string = html_string + link_to(mobject_path(:mobject_id => item.id, :dir => ">", :topic => topic)) do
                content_tag(:i, nil, class:"btn btn-primary glyphicon glyphicon-chevron-right")
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
    case iconstring

      when "AngeboteStandard"
        icon = "info-sign"
      when "AngeboteAktionen"
        icon = "exclamation-sign"
      when "StellenanzeigenSuchen"
        icon = "search"
      when "StellenanzeigenAnbieten"
        icon = "filter"
      when "KleinanzeigenSuchen"
        icon = "search"
      when "KleinanzeigenAnbieten"
        icon = "filter"
      when "CrowdfundingSpenden"
        icon = "gift"
      when "CrowdfundingBelohnungen"
        icon = "qrcode"
      when "CrowdfundingZinsen"
        icon = "signal"
      when "KalenderGeburtstage"
        icon = "user"
      when "KalenderAktionen"
        icon = "shopping-cart"
      when "KalenderAusschreibungen"
        icon = "pencil"
      when "KalenderVeranstaltungen"
        icon = "glass"
      when "KalenderStellenanzeigen"
        icon = "briefcase"
      when "KalenderCrowdfunding"
        icon = "grain"

      when "Kalender"
        icon = "calendar"
      when "Info"
        icon = "info-sign"
      when "Kalendereintraege"
        icon = "calendar"
      when "Ansprechpartner"
        icon = "user"
      when "Stellenanzeigen"
        icon = "briefcase"
      when "Kleinanzeigen"
        icon = "pushpin"
      when "Tickets"
        icon = "barcode"
      when "Crowdfunding (Beitraege)"
        icon = "gift"
      when "Bewertungen"
        icon = "star"
      when "Favoriten"
        icon = "heart"
      when "Kundenbeziehungen"
        icon = "check"
      when "Kontobeziehungen"
        icon = "list"
      when "Transaktionen"
        icon = "euro"
      when "eMail"
        icon = "list"
      when "Positionen (Privatpersonen)"
        icon = "map-marker"
      when "Positionen (Favoriten)"
        icon = "map-marker"
      when "Aktivitaeten"
        icon = "dashboard"
      when "Sponsorenengagements"
        icon = "heart"
      when "Links (Partner)"
        icon = "globe"
      when "Details"
        icon = "search"
      when "Ausschreibungsangebote"
        icon = "book"
      when "Kalender (Vermietungen)"
        icon = "calendar"
      when "Teilnehmer (Veranstaltungen)"
        icon = "user"
      when "CF Statistik"
        icon = "dashboard"
      when "CF Transaktionen"
        icon = "euro"

      when "Einstellungen"
        icon = "cog"
      when "meine Abfragen"
        icon = "question-sign"

      when "Privatpersonen"
        icon = "user"
      when "Institutionen"
        icon = "copyright-mark"

      when "Suchen"
        icon = "search"
      when "Anbieten"
        icon = "filter"

      when "Angebote"
        icon = "shopping-cart"
      when "Aktionen"
        icon = "shopping-cart"
      when "Standard"
        icon = "info-sign"
      when "Aktion"
        icon = "exclamation-sign"
      when "Vermietungen"
        icon = "retweet"
      when "Ausschreibungen"
        icon = "pencil"
      when "Stellenanzeigen"
        icon = "briefcase"
      when "Stellenanzeigen (Suchen)"
        icon = "briefcase"
      when "Stellenanzeigen (Anbieten)"
        icon = "briefcase"
      when "Veranstaltungen"
        icon = "glass"
      when "Veranstaltungen (angemeldet)"
        icon = "glass"
      when "Ausflugsziele"
        icon = "map-marker"
      when "Kleinanzeigen"
        icon = "pushpin"
      when "Kleinanzeigen (Suchen)"
        icon = "pushpin"
      when "Kleinanzeigen (Anbieten)"
        icon = "pushpin"
      when "Crowdfunding"
        icon = "grain"
      when "Spenden"
        icon = "gift"
      when "Belohnungen"
        icon = "qrcode"
      when "Zinsen"
        icon = "signal"
      when "Crowdfunding (Spenden)"
        icon = "grain"
      when "Crowdfunding (Belohnungen)"
        icon = "grain"
      when "Crowdfunding (Zinsen)"
        icon = "grain"
      when "Kalender (Aktionen)"
        icon = "calendar"
      when "Kalender (Veranstaltungen)"
        icon = "calendar"
      when "Kalender (Ausschreibungen)"
        icon = "calendar"

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
    
    icon = getIcon(domain)
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

    #html_string=html_string+creds.to_s

    # if creds.include?("Hauptmenue"+"meine Abfragen")
    #   domain = "meine Abfragen"
    #   path = home_index6_path
    #   html_string = html_string + simple_menue(domain, path)
    # end

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
          content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(domain), style:"font-size:" + icon_size + "em") 
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
        content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(domain), style:"font-size:" + icon_size + "em") 
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
        html_string = html_string + "<i class='glyphicon glyphicon-"+getIcon(hasharray[i]["icon"])+"' style='font-size:2em'> </i> "
        html_string = html_string + hasharray[i]["text"]
        html_string = html_string + "</a><br><br>"
  end
  html_string = html_string + "</" + domain + "_options" + ">"
  return html_string.html_safe
end

def build_kachel_access(topic, mode)

  if mode == "System"
    credentials = Appparam.where('domain=?',topic)
  end
  if mode == "User"
    credentials = current_user.credentials.where('domain=?',topic)
  end

  html_string = ""
  credentials.each do |c|
    
    if mode == "System"
      cpath = appparams_path(:id => c.id)
    end
    skip = false
    if mode == "User"
      if !$activeapps.include?(topic+c.right)
        skip = true
      end
      cpath = credentials_path(:id => c.id)
    end
    
    if !skip
      if c.access == nil or c.access == true
        thumbnail_state = 'thumbnail-active'
      else
        thumbnail_state = 'thumbnail-inactive'
      end

        html_string = html_string + link_to(cpath) do
          content_tag(:div, nil, class:"col-xs-4 col-sm-4 col-md-3 col-lg-2") do 
            content_tag(:div, nil, class:"thumbnail " + thumbnail_state, align:"center") do
              content_tag(:span, nil) do
                icon_size = "4"
                content_tag(:i, nil, class:"glyphicon glyphicon-" + getIcon(c.right), style:"font-size:" + icon_size + "em") + content_tag(:small_cal, "<br>".html_safe+c.right)
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
      when "mein xConnect"
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

          when "Vermietungen"
            pic = "vermietung.jpg"

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
    hash = {"domain" => "Hauptmenue", "right" => "meine Abfragen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Privatpersonen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Institutionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Angebote"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Angebote", "right" => "AngeboteStandard"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Angebote", "right" => "AngeboteAktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Vermietungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Ausschreibungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Stellenanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Stellenanzeigen", "right" => "StellenanzeigenAnbieten"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Stellenanzeigen", "right" => "StellenanzeigenSuchen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Veranstaltungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Ausflugsziele"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Kleinanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kleinanzeigen", "right" => "KleinanzeigenAnbieten"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kleinanzeigen", "right" => "KleinanzeigenSuchen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Crowdfunding"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingSpenden"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingBelohnungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Crowdfunding", "right" => "CrowdfundingZinsen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "right" => "Kalender"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderGeburtstage"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderAktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderCrowdfunding"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderStellenanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderVeranstaltungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Hauptmenue", "parent_domain" => "Kalender", "right" => "KalenderAusschreibungen"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Info"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kalendereintraege"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Angebote"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Aktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ansprechpartner"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Institutionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Stellenanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kleinanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Vermietungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Veranstaltungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Veranstaltungen (angemeldet)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Tickets"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ausflugsziele"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Ausschreibungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Spenden)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Belohnungen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Zinsen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Crowdfunding (Beitraege)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Bewertungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Favoriten"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kundenbeziehungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Kontobeziehungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Transaktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "eMail"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Positionen (Privatpersonen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Positionen (Favoriten)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Privatpersonen", "right" => "Aktivitaeten"}
    @array << hash
    
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Info"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Angebote"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Aktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Stellenanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kleinanzeigen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Vermietungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Veranstaltungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Sponsorenengagements"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Ausflugsziele"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Ausschreibungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Spenden)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Belohnungen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Zinsen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Crowdfunding (Beitraege)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kundenbeziehungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Kontobeziehungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Transaktionen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "eMail"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Links (Partner)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Institutionen", "right" => "Aktivitaeten"}
    @array << hash
    
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Info"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Details"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Sponsorenengagements"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Ansprechpartner"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Kalender (Vermietungen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Teilnehmer (Veranstaltungen)"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Ausschreibungsangebote"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "Bewertungen"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "CF Statistik"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "Objekte", "right" => "CF Transaktionen"}
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
      c.access = true
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
    c = Credential.new
    c.user_id = current_user.id
    c.appparam_id = a.id
    c.access = a.access
    c.save
  end
end

def getUserCreds
  credapps = []
  creds = current_user.credentials
  if !creds or creds.count==0
    init_credentials
  end
  creds.each do |c|
    if $activeapps.include?(c.appparam.domain+c.appparam.right)
      credapps << c.appparam.domain+c.appparam.right if c.access
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

end    