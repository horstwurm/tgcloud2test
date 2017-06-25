class EditionsController < ApplicationController
  before_action :set_edition, only: [:show, :edit, :update, :destroy]

  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
    #@edition = Edition.find(params[:edition_id])
  end

  # GET /editions/new
  def new
    @edition = Edition.new
    @edition.mobject_id = params[:mobject_id]
    @edition.active = false
  end

  # GET /editions/1/edit
  def edit
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.new(edition_params)

    respond_to do |format|
      if @edition.save
        format.html { redirect_to mobject_path(:id => @edition.mobject_id, :topic => "Ausgaben"), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @edition }
      else
        format.html { render :new }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /editions/1
  # PATCH/PUT /editions/1.json
  def update
    respond_to do |format|
      if @edition.update(edition_params)
        format.html { redirect_to mobject_path(:id => @edition.mobject_id, :topic => "Ausgaben"), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @edition }
      else
        format.html { render :edit }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    @mobject_id = @edition.mobject_id
    @edition.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @mobject_id, :topic => "Ausgaben"), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition
      @edition = Edition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edition_params
      params.require(:edition).permit(:avatar, :active, :mobject_id, :release_date, :name, :description, :status)
    end
end
