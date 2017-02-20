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
  end

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
        format.html { redirect_to company_path(:id => @signage_loc.owner_id, :topic => "Digital Signage (Standorte)"), notice: 'Signage loc was successfully created.' }
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
        format.html { redirect_to company_path(:id => @signage_loc.owner_id, :topic => "Digital Signage (Standorte)"), notice: 'Signage loc was successfully updated.' }
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
    @owner_id = @signage-loc.owner_id
    @signage_loc.destroy
    respond_to do |format|
      format.html { redirect_to company_path(:id => @owner_id, :topic => "Digital Signage (Inhalt)"), notice: 'Signage loc was successfully destroyed.' }
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
      params.require(:signage_loc).permit(:name, :status, :privateonly, :owner_id, :owner_type, :geo_address, :address1, :address2, :address3, :res_v, :res_h, :avatar)
    end
end
