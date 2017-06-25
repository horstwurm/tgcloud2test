class MratingsController < ApplicationController
  before_action :set_mrating, only: [:show, :edit, :update, :destroy]
  after_action :set_sumrating, only: [:create, :update, :destroy]

  # GET /mratings
  def index
    @mratings = Mrating.all
  end

  # GET /mratings/1
  def show
  end

  # GET /mratings/new
  def new
    @mrating = Mrating.new
    @mrating.mobject_id = params[:mobject_id]
    @mrating.user_id = current_user.id
    @mrating.rating = 3
  end

  # GET /mratings/1/edit
  def edit
  end

  # POST /mratings
  def create
    @mrating = Mrating.new(mrating_params)
    if @mrating.save
      if @mrating.mobject.mtype == "Artikel"
        @topic = "Info"
      else
        @topic = "Bewertungen"
      end
      redirect_to mobject_path(:id => @mrating.mobject_id, :topic => @topic), notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /mratings/1
  def update
    if @mrating.update(mrating_params)
      if @mrating.mobject.mtype == "Artikel"
        @topic = "Info"
      else
        @topic = "Bewertungen"
      end
      redirect_to mobject_path(:id => @mrating.mobject_id, :topic => @topic), notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /mratings/1
  def destroy
    @id = @mrating.mobject_id
    if @mrating.mobject.mtype == "Artikel"
      @topic = "Info"
    else
      @topic = "Bewertungen"
    end
    @mrating.destroy
      redirect_to mobject_path(:id => @id, :topic => @topic), notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mrating
      @mrating = Mrating.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def mrating_params
      params.require(:mrating).permit(:status, :user_id, :mobject_id, :comment, :rating)
    end
    
    def set_sumrating
      @mobject = Mobject.find(@mrating.mobject_id)
      if @mobject
        @mobject.sum_rating = @mobject.avg_rating2()
        @mobject.save
      end
    end
end
