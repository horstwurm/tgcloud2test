class SignageHitsController < ApplicationController
  before_action :set_signage_hit, only: [:show, :edit, :update, :destroy]

  # GET /signage_hits
  # GET /signage_hits.json
  def index
    @signage_hits = SignageHit.all
  end

  # GET /signage_hits/1
  # GET /signage_hits/1.json
  def show
  end

  # GET /signage_hits/new
  def new
    @signage_hit = SignageHit.new
  end

  # GET /signage_hits/1/edit
  def edit
  end

  # POST /signage_hits
  # POST /signage_hits.json
  def create
    @signage_hit = SignageHit.new(signage_hit_params)

    respond_to do |format|
      if @signage_hit.save
        format.html { redirect_to @signage_hit, notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @signage_hit }
      else
        format.html { render :new }
        format.json { render json: @signage_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signage_hits/1
  # PATCH/PUT /signage_hits/1.json
  def update
    respond_to do |format|
      if @signage_hit.update(signage_hit_params)
        format.html { redirect_to @signage_hit, notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @signage_hit }
      else
        format.html { render :edit }
        format.json { render json: @signage_hit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signage_hits/1
  # DELETE /signage_hits/1.json
  def destroy
    @signage_hit.destroy
    respond_to do |format|
      format.html { redirect_to signage_hits_url, notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage_hit
      @signage_hit = SignageHit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_hit_params
      params.require(:signage_hit).permit(:signage_camp_id, :signage_loc_id, :datetime_from)
    end
end
