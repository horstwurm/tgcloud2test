class EditionArcticlesController < ApplicationController
  before_action :set_edition_arcticle, only: [:show, :edit, :update, :destroy]

  # GET /edition_arcticles
  # GET /edition_arcticles.json
  def index
    if params[:topic]
      @topic = params[:topic]
    else
      @topic = "editionarticles_info"
    end

    @edition = Edition.find(params[:edition_id])
    
    if params[:dir]
      @ques=[]
      @edition.edition_arcticles.order(:sequence).each do |q|
        h = Hash.new
        h = {:id => q.id, :seq => q.sequence}
        @ques << h
      end

      @myq = EditionArcticle.find(params[:d_id])
      if params[:dir] == "left"

        if @myq and @myq.sequence > 1

          @myq.sequence = @myq.sequence - 1
          @myq.save

          index = -1
          for i in 0..@ques.length-1
            if @myq.id == @ques[i][:id]
              index = i-1
            end
          end
          if index > -1
            @myq2 = EditionArcticle.find(@ques[index][:id])
            if @myq2
              @myq2.sequence = @myq2.sequence + 1
              @myq2.save
            end
          end
        end
      end
    end

    @edition_arcticles = @edition.edition_arcticles
    @editionas = @edition_arcticles.count
  end

  # GET /edition_arcticles/1
  # GET /edition_arcticles/1.json
  def show
  end

  # GET /edition_arcticles/new
  def new
    @edition_arcticle = EditionArcticle.new
    @edition_arcticle.edition_id = params[:edition_id]
    @edition_arcticle.mobject_id = params[:article_id]
    @edition_arcticle.active = false
    @edition_arcticle.status = ""
    @edition_arcticle.sequence = Edition.find(params[:edition_id]).edition_arcticles.count+1
end

  # GET /edition_arcticles/1/edit
  def edit
  end

  # POST /edition_arcticles
  # POST /edition_arcticles.json
  def create
    @edition_arcticle = EditionArcticle.new(edition_arcticle_params)

    respond_to do |format|
      if @edition_arcticle.save
        format.html { redirect_to edition_arcticles_path(:edition_id => @edition_arcticle.edition_id), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @edition_arcticle }
      else
        format.html { render :new }
        format.json { render json: @edition_arcticle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edition_arcticles/1
  # PATCH/PUT /edition_arcticles/1.json
  def update
    respond_to do |format|
      if @edition_arcticle.update(edition_arcticle_params)
        format.html { redirect_to edition_arcticles_path(:edition_id => @edition_arcticle.edition_id), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @edition_arcticle }
      else
        format.html { render :edit }
        format.json { render json: @edition_arcticle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edition_arcticles/1
  # DELETE /edition_arcticles/1.json
  def destroy
    @edition_id = @edition_arcticle.edition_id
    @edition_arcticle.destroy
    respond_to do |format|
      format.html { redirect_to edition_arcticles_path(:edition_id => @edition_id), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition_arcticle
      @edition_arcticle = EditionArcticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edition_arcticle_params
      params.require(:edition_arcticle).permit(:sequence, :active, :mobject_id, :edition_id, :status)
    end
end
