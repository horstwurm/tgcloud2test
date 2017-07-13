class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  $branchen_codes = []

  # GET /companies
  def index

    @controller_name = controller_name
    
    if params[:page]
      session[:page] = params[:page]
    end
    
    @companies = Company.search(params[:filter_id], params[:search]).order(created_at: :desc).page(params[:page]).per_page(10)
    @companz = @companies.count
   counter = 0 
   @locs = []
   @wins = []
   @companies.each do |c|
      if c.longitude and c.latitude and c.geo_address
        @locs << [c.name, c.latitude, c.longitude.to_s]
        @wins << ["<img src=" + c.avatar(:small) + "<br><h3>" + c.name + "</h3><p>" + c.geo_address + "</p>"]
      end
    end

  end

  # GET /companies/1
  def show
     if params[:topic]
       @topic = params[:topic]
     else 
       @topic = "institutionen_info"
     end 
    
    if params[:camp_id]
      @campaign = SignageCamp.find(params[:camp_id])
    end

    @stats = [["Aktivtäten","Anzahl"]]
    @stats << ["Projekte/Tasks", @company.mobjects.where('mtype=?','projekte').count ]
    @stats << ["Werbekampagnen", @company.mobjects.where('mtype=?','kampagnen').count ]
    @stats << ["Werbestandorte", @company.mobjects.where('mtype=?','standorte').count ]
    @stats << ["Publikationen", @company.mobjects.where('mtype=?','publikationren').count ]
    @stats << ["Umfragen", @company.mobjects.where('mtype=?','umfragen').count ]
    @stats << ["Innovationswettbewerbe", @company.mobjects.where('mtype=?','innovationswettbewerbe').count ]
    @stats << ["Veranstaltungen", @company.mobjects.where('mtype=?','veranstaltungen').count ]
    @stats << ["Partnerlinks", @company.partner_links.count ]

    if false
    @array_s = ""
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','angebote'), "angebote" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','kleinanzeigen'), "Kleinanzeigen" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','vermietungen'), "Vermietungen" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','veranstaltungen'), "Veranstaltungen" )
    @array_s = @company.build_stats(@array_s, @company.msponsors, "sponsorenengagements" ) 
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','ausschreibungen'), "ausschreibungen" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','ausflugsziele'), "ausflugsziele" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','stellenanzeigen'), "stellenanzeigen" )
    @array_s = @company.build_stats(@array_s, @company.mobjects.where('mtype=?','crowdfunding'), "crowdfunding" )
    @array_s = @company.build_stats(@array_s, @company.mstats, "crowdfunding Beitraege" )            if false
    @array_s = @company.build_stats(@array_s, @company.customers, "kundenstatus" )
    @array_s = @company.build_stats(@array_s, @company.transactions.where('ttype=?', "payment"), "transaktionen" )
    @array_s = @company.build_stats(@array_s, Email.where('m_to=? or m_from=?', @company.user.id, @company.user.id), "nachrichten" )
    #@array_s = @company.build_stats(@array_s, @company.user.searches, "abfragen" )
    @array_s = @array_s[0, @array_s.length - 1]
    end
    
  end

  # GET /companies/new
  def new
      @company = Company.new
      @company.user_id = params[:user_id]
      @company.active = true
      @company.social = false
      @company.status = "OK"
      @company.partner = false
  end

  # GET /companies/1/edit
  def edit
    #@company.status = "changed"
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to user_path(:id => @company.user_id, :topic => "institutionen_info"), notice: (I18n.t :act_create)
      # redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @us = @company.user_id
    @company.destroy
    redirect_to user_path(:id => @us, :topic => "personen_institutionen"),  notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
    
    def company_params
      params.require(:company).permit(:partner, :status, :active, :name, :homepage, :mcategory_id, :social, :stichworte, :user_id, :description, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at)
    end

end
