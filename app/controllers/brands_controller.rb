class BrandsController < ApplicationController

  #will be created in a nested cars form

  def index
    @brands = Brand.all
  end

  def show
  end

end
