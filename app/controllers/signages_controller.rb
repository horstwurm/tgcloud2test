class SignagesController < ApplicationController
  before_action :set_signage, only: [:show, :edit, :update, :destroy]

  # GET /signages
  # GET /signages.json
  def index
    @camp = SignageCamp.find(params[:camp_id])
    @signages = @camp.signages
    redirect_to company_path(:id => @camp.owner_id, :topic => "Signages")
  end

  # GET /signages/1
  # GET /signages/1.json
  def show
  end

  # GET /signages/new
  def new
    @signage = Signage.new
    @signage.signage_camp_id = params[:camp_id].to_i
  end

  # GET /signages/1/edit
  def edit
  end

  # POST /signages
  # POST /signages.json
  def create
    @signage = Signage.new(signage_params)

    respond_to do |format|
      if @signage.save
        format.html { redirect_to signage_camp_path(:id => @signage.signage_camp_id, :topic => "Details"), notice: 'Signage was successfully created.' }
        format.json { render :show, status: :created, location: @signage }
      else
        format.html { render :new }
        format.json { render json: @signage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /signages/1
  # PATCH/PUT /signages/1.json
  def update
    respond_to do |format|
      if @signage.update(signage_params)
        format.html { redirect_to signage_camp_path(:id => @signage.signage_camp_id, :topic => "Details"), notice: 'Signage was successfully updated.' }
        format.json { render :show, status: :ok, location: @signage }
      else
        format.html { render :edit }
        format.json { render json: @signage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /signages/1
  # DELETE /signages/1.json
  def destroy
    @signage_camp_id = @signage.signage_camp_id
    @signage.destroy
    respond_to do |format|
      format.html { redirect_to signage_camp_path(:id => @signage_camp_id, :topic => "Details"), notice: 'Signage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage
      @signage = Signage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_params
      params.require(:signage).permit(:signage_camp_id, :status, :header, :description, :avatar)
    end
end
