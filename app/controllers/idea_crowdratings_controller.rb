class IdeaCrowdratingsController < ApplicationController
  before_action :set_idea_crowdrating, only: [:show, :edit, :update, :destroy]
  after_action :calc_idea_crowdrating, only: [:create, :edit, :update, :destroy]

  # GET /idea_crowdratings
  # GET /idea_crowdratings.json
  def index
    @idea = Idea.find(params[:idea_id])
    #@idea_crowdratings = IdeaCrowdrating.all
  end

  # GET /idea_crowdratings/1
  # GET /idea_crowdratings/1.json
  def show
  end

  # GET /idea_crowdratings/new
  def new
    @idea_crowdrating = IdeaCrowdrating.new
    @idea_crowdrating.idea_id = params[:idea_id]
    @idea_crowdrating.user_id = params[:user_id]
    @idea_crowdrating.rating = 3
    @idea_crowdrating.rating_text = "..."
  end

  # GET /idea_crowdratings/1/edit
  def edit
  end

  # POST /idea_crowdratings
  # POST /idea_crowdratings.json
  def create
    @idea_crowdrating = IdeaCrowdrating.new(idea_crowdrating_params)

    respond_to do |format|
      if @idea_crowdrating.save
        format.html { redirect_to idea_crowdratings_path(:idea_id => @idea_crowdrating.idea_id), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @idea_crowdrating }
      else
        format.html { render :new }
        format.json { render json: @idea_crowdrating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /idea_crowdratings/1
  # PATCH/PUT /idea_crowdratings/1.json
  def update
    respond_to do |format|
      if @idea_crowdrating.update(idea_crowdrating_params)
        format.html { redirect_to idea_crowdratings_path(:idea_id => @idea_crowdrating.idea_id), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @idea_crowdrating }
      else
        format.html { render :edit }
        format.json { render json: @idea_crowdrating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /idea_crowdratings/1
  # DELETE /idea_crowdratings/1.json
  def destroy
    @idea_crowdrating_idea_id = @idea_crowdrating.idea_id
    @idea_crowdrating.destroy
    respond_to do |format|
      format.html { redirect_to idea_crowdratings_path(:idea_id => @idea_crowdrating_idea_id), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea_crowdrating
      @idea_crowdrating = IdeaCrowdrating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_crowdrating_params
      params.require(:idea_crowdrating).permit(:idea_id, :user_id, :rating, :rating_text)
    end
    
    def calc_idea_crowdrating
      rat = @idea_crowdrating.idea.idea_crowdratings.average(:rating)
      if rat > 0
        @idea = Idea.find(@idea_crowdrating.idea)
        if @idea
          @idea.crowdrating = rat
          @idea.save
        end
      end
    end
    
end
