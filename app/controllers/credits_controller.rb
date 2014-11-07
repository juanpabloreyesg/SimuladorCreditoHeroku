class CreditsController < ApplicationController
  skip_before_filter:verify_authenticity_token


def new
    @credit = owner_user.credits.build
end

def index
  owner_user
  if params[:cedula]
    @cedula = params[:cedula]
    @credits = owner_user.credits.find( :all, :conditions => ["cedula = ?", params[:cedula] ] ).paginate(page: params[:page], per_page: 50)
  else
    @cedula = nil
  end

end

def create
  	@credit = owner_user.credits.build(credit_params)
  	if @credit.save
  		flash[:success] = "Nuevo credito creado"
      @credit.delay(:queue => 'default').generarPlanes
  		redirect_to user_credits_path( params[:user_id] )
  	else
  		render 'new'
  	end
end

private

  def owner_user
  	@owner_user  = User.find( params[:user_id] )
  end

  def credit_line
    @credit_line = Credit_line.find( params[:credit_line_id])
  end


def credit_params
      params.require(:credit).permit(:cedula, :valorCredito, :plazo, :lineaCredito)
end


end
