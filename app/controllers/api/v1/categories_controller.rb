class Api::V1::CategoriesController < ApplicationController

  # GET /categories.json
  def index
    @categories = Vertical.find(params[:vertical_id]).categories
  end

  # GET /categories/1.json
  def show
    @category = Vertical.find(params[:vertical_id]).categories.find(params[:id])
  end

  # POST /categories.json
  def create
    @category = Vertical.find(params[:vertical_id]).categories.build(category_params)

    if @category.save
      render :show, status: :created
    else
      @errors = @category.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1.json
  def update
    @category = Vertical.find(params[:vertical_id]).categories.find(params[:id])

    if @category.update(category_params)
      render :show
    else
      @errors = @category.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # DELETE /categories/1.json
  def destroy
    Vertical.find(params[:vertical_id]).categories.find(params[:id]).destroy
  end

  private

  def category_params
    params.require(:category).permit(:name, :state)
  end
end
