class DataloadersController < ApplicationController
  before_action :set_dataloader, only: [:show, :edit, :update, :destroy]

  # GET /dataloaders
  # GET /dataloaders.json
  def index
    @dataloaders = Dataloader.all
  end

  # GET /dataloaders/1
  # GET /dataloaders/1.json
  def show
  end

  # GET /dataloaders/new
  def new
    @dataloader = Dataloader.new
  end

  # GET /dataloaders/1/edit
  def edit
  end

  # POST /dataloaders
  # POST /dataloaders.json
  def create
    @dataloader = Dataloader.new(dataloader_params)

    respond_to do |format|
      if @dataloader.save
        format.html { redirect_to @dataloader, notice: 'Dataloader was successfully created.' }
        format.json { render :show, status: :created, location: @dataloader }
      else
        format.html { render :new }
        format.json { render json: @dataloader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dataloaders/1
  # PATCH/PUT /dataloaders/1.json
  def update
    respond_to do |format|
      if @dataloader.update(dataloader_params)
        format.html { redirect_to @dataloader, notice: 'Dataloader was successfully updated.' }
        format.json { render :show, status: :ok, location: @dataloader }
      else
        format.html { render :edit }
        format.json { render json: @dataloader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dataloaders/1
  # DELETE /dataloaders/1.json
  def destroy
    @dataloader.destroy
    respond_to do |format|
      format.html { redirect_to dataloaders_url, notice: 'Dataloader was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataloader
      @dataloader = Dataloader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataloader_params
      params.require(:dataloader).permit(:name, :mcategory_id, :document)
    end
end
