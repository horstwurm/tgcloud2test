class CritsController < ApplicationController
  before_action :set_crit, only: [:show, :edit, :update, :destroy]

  # GET /crits
  # GET /crits.json
  def index
    @crits = Crit.all
  end

  # GET /crits/1
  # GET /crits/1.json
  def show
  end

  # GET /crits/new
  def new
    @crit = Crit.new
    @crit.mobject_id = params[:mobject_id]
    @crit.name = "Kriterium 1"
    @crit.description = "..."
  end

  # GET /crits/1/edit
  def edit
  end

  # POST /crits
  # POST /crits.json
  def create
    @crit = Crit.new(crit_params)

    respond_to do |format|
      if @crit.save
        format.html { redirect_to mobject_path(:id => @crit.mobject_id, :topic => :bewertungskriterien), notice: (I18n.t :act_create)}
        format.json { render :show, status: :created, location: @crit }
      else
        format.html { render :new }
        format.json { render json: @crit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crits/1
  # PATCH/PUT /crits/1.json
  def update
    respond_to do |format|
      if @crit.update(crit_params)
        format.html { redirect_to mobject_path(:id => @crit.mobject_id, :topic => :bewertungskriterien), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @crit }
      else
        format.html { render :edit }
        format.json { render json: @crit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crits/1
  # DELETE /crits/1.json
  def destroy
    @crit_mobject_id = @crit.mobject_id
    @crit.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @crit_mobject_id, :topic => :bewertungskriterien), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crit
      @crit = Crit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crit_params
      params.require(:crit).permit(:mobject_id, :name, :description, :rating)
    end
end
