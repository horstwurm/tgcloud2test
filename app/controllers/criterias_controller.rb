class CriteriasController < ApplicationController
  before_action :set_criteria, only: [:show, :edit, :update, :destroy]

  # GET /criteria
  # GET /criteria.json
  def index
    @criterias = Criteria.all
  end

  # GET /criteria/1
  # GET /criteria/1.json
  def show
  end

  # GET /criteria/new
  def new
    @criteria = Criteria.new
    @criteria.mobject_id = params[:mobject_id]
    @criteria.name = "Bewertungskriterium 1"
    @criteria.description = "..."
    @criteria.rating = 0
  end

  # GET /criteria/1/edit
  def edit
  end

  # POST /criteria
  # POST /criteria.json
  def create
    @criteria = Criteria.new(criteria_params)

    respond_to do |format|
      if @criteria.save
        format.html { redirect_to @criteria, notice: 'Criterium was successfully created.' }
        format.json { render :show, status: :created, location: @criteria }
      else
        format.html { render :new }
        format.json { render json: @criteria.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /criteria/1
  # PATCH/PUT /criteria/1.json
  def update
    respond_to do |format|
      if @criteria.update(criteria_params)
        format.html { redirect_to @criteria, notice: 'Criterium was successfully updated.' }
        format.json { render :show, status: :ok, location: @criteria }
      else
        format.html { render :edit }
        format.json { render json: @criteria.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /criteria/1
  # DELETE /criteria/1.json
  def destroy
    @criteria.destroy
    respond_to do |format|
      format.html { redirect_to criteria_url, notice: 'Criterium was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criteria
      @criteria = Criteria.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def criteria_params
      params.require(:criteria).permit(:mobject_id, :name, :description, :rating)
    end
end
