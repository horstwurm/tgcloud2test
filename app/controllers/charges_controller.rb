class ChargesController < ApplicationController
  before_action :set_charge, only: [:show, :edit, :update, :destroy]

  # GET /charges
  # GET /charges.json
  def index
    @charges = Charge.all
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
  end

  # GET /charges/new
  def new
    @charge = Charge.new
    if params[:user_id]
      @charge.owner_id = params[:user_id]
      @charge.owner_type = "User"
    end
    if params[:company_id]
      @charge.owner_id = params[:company_id]
      @charge.owner_type = "Company"
    end
    @charge.topic = params[:topic]
    @charge.amount = params[:fee]
    @charge.plan = params[:plan]
    if !@charge.amount
      @charge.amount = 500
    end
  end

  # GET /charges/1/edit
  def edit
  end

  # POST /charges
  # POST /charges.json
  def create

   @charge = Charge.new(charge_params)
    
   customer = StripeTool.create_customer(email: params[:stripeEmail], 
                                          stripe_token: params[:stripeToken])

   charge = StripeTool.create_charge(customer_id: customer.id, 
                                      amount: (@charge.amount*100).to_i,
                                      description: @charge.topic)

    @charge.stripe_id = customer.id
    

    respond_to do |format|
      if @charge.save
        if @charge.owner_type == "User"
          format.html { redirect_to user_path(:id => @charge.owner_id, :topic => "personen_charges"), notice: (I18n.t :thxpayment) }
        end
        if @charge.owner_type == "Company"
          format.html { redirect_to company_path(:id => @charge.owner_id, :topic => "institutionen_charges"), notice: 'Charge was successfully created.' }
        end
        format.json { render :show, status: :created, location: @charge }
      else
        format.html { render :new }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to user_path(:id => @charge.owner_id, :topic => "personen_charges"), notice: (:I18n.t :nopayment)
    
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
    respond_to do |format|
      if @charge.update(charge_params)
        if @charge.owner_type == "User"
          format.html { redirect_to user_path(:id => @charge.owner_id, :topic => "personen_charges"), notice: 'Charge was successfully created.' }
        end
        if @charge.owner_type == "Company"
          format.html { redirect_to company_path(:id => @charge.owner_id, :topic => "institutionen_charges"), notice: 'Charge was successfully created.' }
        end
        format.json { render :show, status: :ok, location: @charge }
      else
        format.html { render :edit }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy
    respond_to do |format|
      format.html { redirect_to charges_url, notice: 'Charge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_charge
      @charge = Charge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def charge_params
      params.require(:charge).permit(:owner_id, :owner_type, :stripe_id, :topic, :amount, :plan)
    end
end
