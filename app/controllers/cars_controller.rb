class CarsController < ApplicationController

  before_action :require_login
  skip_before_action :require_login, only: [:index, :show]

  helper_method :params

  #I should make a different home page

  def index
    if field_has_content(params[:brand_id])
      @cars = Brand.find_by(id: params[:brand_id]).cars
    elsif
      params[:year]
      @cars = Car.where(year: params[:year])
    else
      @cars = Car.all
    end
  end

  def just_added
    @cars = Car.just_added
    render 'cars/index'
  end

  def show
    @car = Car.find_by(id: params[:id])
  end

  def new
    if field_has_content(params[:brand_id])
      @car = Car.new(brand_id: params[:brand_id])
      @car.car_types.build
    else
      @car = Car.new
      @car.build_brand
      @car.car_types.build
    end
  end

  def create
    @car = Car.new(car_params)
    if !@car.brand.valid?
      #done due to issues with blank input overwriting brand_id, thus a newly created brand would know about the car but not vice versa
      @car.brand = Brand.find_by(id: car_params[:brand_id])
    else
      @car.brand.save
      @car.brand_id = @car.brand.id
    end
    #weeds out any invalid car types
    @car.remove_blank_car_type_ids
    if @car.save
      success_message(@car, "create")
      redirect_to car_path(@car)
    else
      flash_errors_and_heading(@car)
      render 'cars/new'
    end
  end


  def edit
    @car = Car.find_by(id: params[:id])
  end

  def update
    @car = Car.find_by(id: params[:id])
    @car.assign_attributes(car_params)
    if !@car.brand.valid?
      #done due to issues with blank input overwriting brand_id, thus a newly created brand would know about the car but not vice versa
      if field_has_content(car_params[:brand_id])
        @car.brand = Brand.find_by(id: car_params[:brand_id])
      end
    else
      @car.brand.save
      @car.brand_id = @car.brand.id
    end
    #weeds out any invalid car types
    @car.remove_blank_car_type_ids
    if @car.save
      success_message(@car, "update")
      redirect_to car_path(@car)
    else
      flash_errors_and_heading(@car)
      render 'cars/edit'
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    success_message(@car, "destroy")
    redirect_to cars_path
  end

  private

  def car_params
    params.require(:car).permit(:brand_id, :name, :year, :photo_url, :car_type_ids => [], car_types_attributes: [:name], :brand_attributes => [:name, :logo])
  end

end
