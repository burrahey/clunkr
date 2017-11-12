class ResourcesController < ApplicationController

  def index
    @resources = Resource.all
  end

  def show
    @resource = Resource.find_by(id: params[:id])
  end

  def new
    @resource = Resource.new
    @resource_type = ResourceType.new
  end

  def create
    @resource = Resource.new(resource_params)
    if !@resource.resource_type.valid?
      @resource.resource_type = ResourceType.find_by(id: resource_params[:resource_type_id])
    else
      @resource.resource_type.save
      @resource.resource_type_id = @resource.resource_type.id
    end
    if @resource.save
      redirect_to resource_path(@resource)
    else
      flash[:alert] = view_context.pluralize(@resource.errors.count,
      'error')+ " prevented this resource from saving: "
      prep_flash_errors(@resource)
      render 'resources/new'
    end
  end

  def edit
    @resource = Resource.find_by(id: params[:id])
  end

  def update
    @resource = Resource.find_by(id: params[:id])
    @resource.update(resource_params)
    if !@resource.resource_type.valid?
      @resource.resource_type = ResourceType.find_by(id: resource_params[:resource_type_id])
    else
      @resource.resource_type.save
      @resource.resource_type_id = @resource.resource_type.id
    end
    if @resource.save
      redirect_to resource_path(@resource)
    else
      flash[:alert] = view_context.pluralize(@resource.errors.count,
      'error')+ " prevented this resource from saving: "
      prep_flash_errors(@resource)
      render 'resources/edit'
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :source_url, :resource_type_id, :car_id, :resource_type_attributes => [:name])
  end

end
