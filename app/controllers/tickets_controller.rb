class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  def index
    if params[:msponsor_id]
      @msponsor = Msponsor.find(params[:msponsor_id])
      @tickets = Ticket.where('owner_type=? and owner_id=?', "Msponsor", params[:msponsor_id]).limit(5)
    end
    if params[:mobject_id]
      @tickets = Ticket.where('owner_type=? and owner_id=?', "Mobject", params[:mobject_id]).limit(10)
    end
    if @tickets
      @ticanz = @tickets.count
    else
      @ticanz = 0
    end
    
    if params[:ticket_id]
      @searches = Search.where('ticket_id=?', params[:ticket_id])
      @searches.each do |s|
        @users = User.where(s.sql_string)
        @users.each do |u|
          userticket = UserTicket.new
          userticket.user_id = u.id
          userticket.ticket_id = params[:ticket_id]
          userticket.status = "überreicht"
          userticket.save
        end
      end
    end
  end

  # GET /tickets/1
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    if params[:msponsor_id]
      @ticket.owner_id = params[:msponsor_id]
      @ticket.owner_type = "Msponsor"
    end
    if params[:mobject_id]
      @ticket.owner_id = params[:mobject_id]
      @ticket.owner_type = "Mobject"
    end
    @ticket.active = true
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)
    if @ticket.save
      if @ticket.owner_type == "Msponsor"
        redirect_to tickets_path :msponsor_id => @ticket.owner_id, notice: (I18n.t :act_create)
      end
      if @ticket.owner_type == "Mobject"
        redirect_to mobject_path(:id => @ticket.owner_id, :topic => "objekte_eintrittskarten"), notice: (I18n.t :act_create)
      end
    else
      render :new
    end
  end

  # PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      if @ticket.owner_type == "Msponsor"
        redirect_to tickets_path :msponsor_id => @ticket.owner_id, notice: (I18n.t :act_update)
      end
      if @ticket.owner_type == "Mobject"
        redirect_to mobject_path(:id => @ticket.owner_id, :topic => "objekte_eintrittskarten"), notice: (I18n.t :act_update)
      end
    else
      render :edit
    end
  end

  # DELETE /tickets/1
  def destroy
    if @ticket.owner_type == "Msponsor"
      @msponsor_id = @ticket.owner_id
    end
    if @ticket.owner_type == "Mobject"
      @mobject_id = @ticket.owner_id
    end
    @ticket.destroy
    if @msponsor_id
      redirect_to tickets_path :msponsor_id => @msponsor_id, notice: (I18n.t :act_delete)
    end
    if @mobject_id
      redirect_to mobject_path(:id => @mobject_id, :topic => "objekte_eintrittskarten"), notice: (I18n.t :act_delete)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:owner_id, :owner_type, :mcategory_id, :name, :description, :amount, :contingent, :active)
    end
end
