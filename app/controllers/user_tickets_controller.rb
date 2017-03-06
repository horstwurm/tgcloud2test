class UserTicketsController < ApplicationController
  before_action :set_user_ticket, only: [:show, :edit, :update, :destroy]

  # GET /user_tickets
  def index
    @user_tickets = UserTicket.where('user_id=?',current_user.id)
  end

  # GET /user_tickets/1
  def show
  end

  # GET /user_tickets/new
  def new
    @user_ticket = UserTicket.new
    @user_ticket.user_id = params[:user_id]
    @user_ticket.ticket_id = params[:ticket_id]
    @ticket = Ticket.find(params[:ticket_id])
    if @ticket.owner_type == "Mobject"
      @user_ticket.status = "aktiv"
    end
    if @ticket.owner_type == "Msponsor"
      @user_ticket.status = "persönlich"
    end
    @user_ticket.save
    
    @user_ticket = UserTicket.where('user_id=? and ticket_id=?',params[:user_id], params[:ticket_id]).last
    if @user_ticket
        #content = "Ticket_ID:"+ @user_ticket.id.to_s + " für " + @user_ticket.ticket.name + " für " + User.find(@user_ticket.user_id).fullname + " für Event " + @user_ticket.ticket.msponsor.mobject.name + " gesponsort von " + @user_ticket.ticket.msponsor.company.name + " persönliches Ticket"
        content = "http://tkbmarkt.herokuapp.com/home/index1?me="+@user_ticket.id.to_s
        @user_ticket.avatar = @user_ticket.buildQRCode(content)
        @user_ticket.save
    end
    redirect_to user_path(:id => @user_ticket.user_id, :topic => "Tickets"), notice: 'User ticket was successfully created.'    
  end

  # GET /user_tickets/1/edit
  def edit
  end

  # POST /user_tickets
  def create
    @user_ticket = UserTicket.new(user_ticket_params)

    if @user_ticket.save
      redirect_to @user_ticket, notice: 'User ticket was successfully created.'
    else
      render :new
    end
  end

  # PUT /user_tickets/1
  def update
    if @user_ticket.update(user_ticket_params)
      redirect_to @user_ticket, notice: 'User ticket was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_tickets/1
  def destroy
    @ticket_id = @user_ticket.ticket_id
    @user_ticket.destroy
    redirect_to ticketuserview_index_path :ticket_id => @ticket_id, notice: 'User ticket was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_ticket
      @user_ticket = UserTicket.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user_ticket).permit(:user_id, :ticket_id, :avatar, :status)
    end

end
