class MlikesController < ApplicationController
  before_action :set_mlike, only: [:show, :edit, :update, :destroy]

  # GET /mlikes
  # GET /mlikes.json
  def index
    @mlikes = Mlike.all
  end

  # GET /mlikes/1
  # GET /mlikes/1.json
  def show
  end

  # GET /mlikes/new
  def new
    @mlike = Mlike.new
    @mlike.mobject_id = params[:mobject_id]
    @mlike.user_id = params[:user_id]
    @mlike.like = params[:like]
    @mlike.save
    redirect_to mobject_path(:id => @mlike.mobject_id, :topic => "Info"), notice: 'Mlike was successfully created.'
end

  # GET /mlikes/1/edit
  def edit
  end

  # POST /mlikes
  # POST /mlikes.json
  def create
    @mlike = Mlike.new(mlike_params)

    respond_to do |format|
      if @mlike.save
        format.html { redirect_to mobject_path(:id => @mlike.mobject_id, :topic => "Info"), notice: 'Mlike was successfully created.' }
        format.json { render :show, status: :created, location: @mlike }
      else
        format.html { render :new }
        format.json { render json: @mlike.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mlikes/1
  # PATCH/PUT /mlikes/1.json
  def update
    respond_to do |format|
      if @mlike.update(mlike_params)
        format.html { redirect_to mobject_path(:id => @mlike.mobject_id, :topic => "Info"), notice: 'Mlike was successfully updated.' }
        format.json { render :show, status: :ok, location: @mlike }
      else
        format.html { render :edit }
        format.json { render json: @mlike.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mlikes/1
  # DELETE /mlikes/1.json
  def destroy
    @mobject_id = @mlike.mobject_id
    @mlike.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @mobject_id, :topic => "Info"), notice: 'Mlike was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mlike
      @mlike = Mlike.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mlike_params
      params.require(:mlike).permit(:user_id, :mobject_id, :like)
    end
end
