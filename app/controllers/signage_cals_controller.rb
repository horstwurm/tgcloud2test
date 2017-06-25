class SignageCalsController < ApplicationController
  before_action :set_signage_cal, only: [:show, :edit, :update, :destroy]

  # GET /signage_cals
  # GET /signage_cals.json
  def index
      if params[:confirm_id]
        @cal = SignageCal.find(params[:confirm_id])
        if @cal
          @cal.confirmed = true
          @cal.save
        end
      end
      if params[:noconfirm_id]
        @cal = SignageCal.find(params[:noconfirm_id])
        if @cal
          @cal.confirmed = false
          @cal.save
        end
      end

      counter = 0 
      @array = ""
      @cals = SignageCal.where('signage_loc_id=?', params[:loc_id])
      @loc_id = params[:loc_id]
      @anz = @cals.count
      if @cals
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
          @array = @array + "color: '#ACC550',"
          @array = @array + "textColor: 'white',"
          @array = @array + "icon: '" + icon + "', "
          @array = @array + "title: '" + c.owner.name + "', "
          @array = @array + "start: '" + @calstart + "', "
          @array = @array + "end: '" + @calend + "', "
          @array = @array + "url: '" + company_path(:id => c.owner.id, :topic => "Digital Signage (Inhalt)") +"'" 
          @array = @array + "}"
          if @cals.count >= counter
            @array = @array + ", "
          end
      end
    end
  end

  # GET /signage_cals/1
  # GET /signage_cals/1.json
  def show
  end

  # GET /signage_cals/new
  def new
    @signage_cal = SignageCal.new
    if params[:camp_id]
      @signage_cal.signage_camp_id = params[:camp_id]
      @mode = "camp"
    end
    if params[:loc_id]
      @signage_cal.signage_loc_id = params[:loc_id]
      @mode = "loc"
    end
  end

  # GET /signage_cals/1/edit
  def edit
    if params[:camp_id]
      @mode = "camp"
    end
    if params[:loc_id]
      @mode = "loc"
    end
  end

  # POST /signage_cals
  # POST /signage_cals.json
  def create
    @signage_cal = SignageCal.new(signage_cal_params)

    respond_to do |format|
      if @signage_cal.save
        format.html { redirect_to signage_camp_path(:id => @signage_cal.signage_camp_id, :topic => "Kalender"), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @signage_cal }
      else
        format.html { render :new }
        format.json { render json: @signage_cal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signage_cals/1
  # PATCH/PUT /signage_cals/1.json
  def update
    respond_to do |format|
      if @signage_cal.update(signage_cal_params)
        format.html { redirect_to signage_camp_path(:id => @signage_cal.signage_camp_id, :topic => "Kalender"), notice: (I18n.t :act_update)}
        format.json { render :show, status: :ok, location: @signage_cal }
      else
        format.html { render :edit }
        format.json { render json: @signage_cal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signage_cals/1
  # DELETE /signage_cals/1.json
  def destroy
    @signage_camp_id = @signage_cal.signage_camp_id
    @signage_cal.destroy
    respond_to do |format|
      format.html { redirect_to signage_camp_path(:id => @signage_camp_id, :topic => "Kalender"), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage_cal
      @signage_cal = SignageCal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_cal_params
      params.require(:signage_cal).permit(:signage_loc_id, :signage_camp_id, :confirmed, :date_from, :date_to, :time_from, :time_to)
    end
end
