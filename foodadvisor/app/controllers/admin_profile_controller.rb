class AdminProfileController < ApplicationController
  layout 'with_sidebar'
  
  def show
    @clienti = Cliente.all
  end
end
