class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to root_path, notice: I18n.t('controllers.sections.created')
    else
      render :new
    end
  end

  def update
    if @section.update(section_params)
      redirect_to @section, notice: I18n.t('controllers.sections.updated')
    else
      render :edit
    end
  end

  def destroy
    @section.destroy
    redirect_to root_path, notice: I18n.t('controllers.sections.destroyed')
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name)
  end
end
