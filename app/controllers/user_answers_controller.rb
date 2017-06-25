class UserAnswersController < ApplicationController
  before_action :set_user_answer, only: [:show, :edit, :update, :destroy]

  # GET /user_answers
  # GET /user_answers.json
  def index
    @questionaire = Mobject.find(params[:mobject_id])
    @questions = @questionaire.questions
    #@user_answers = UserAnswer.all
  end
  
  # GET /user_answers/1
  # GET /user_answers/1.json
  def show
  end

  # GET /user_answers/new
  def new
    @user_answer = UserAnswer.new
    @user_answer.user_id = current_user.id
    @user_answer.answer_id = params[:answer_id]
  end

  # GET /user_answers/1/edit
  def edit
  end

  # POST /user_answers
  # POST /user_answers.json
  def create
    @user_answer = UserAnswer.new(user_answer_params)

    respond_to do |format|
      if @user_answer.save
        format.html { redirect_to user_answers_path(:mobject_id => @user_answer.answer.question.mobject.id), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @user_answer }
      else
        format.html { render :new }
        format.json { render json: @user_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_answers/1
  # PATCH/PUT /user_answers/1.json
  def update
    respond_to do |format|
      if @user_answer.update(user_answer_params)
        format.html { redirect_to user_answers_path(:mobject_id => @user_answer.answer.question.mobject.id), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @user_answer }
      else
        format.html { render :edit }
        format.json { render json: @user_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_answers/1
  # DELETE /user_answers/1.json
  def destroy
    @user_answer.destroy
    respond_to do |format|
      format.html { redirect_to user_answers_url, notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_answer
      @user_answer = UserAnswer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_answer_params
      params.require(:user_answer).permit(:answer_id, :user_id, :num, :description, :checker, :status)
    end
end
