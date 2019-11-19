class Api::V1::VerticalsController < ApplicationController

  # GET /verticals.json
  def index
    @verticals = Vertical.all
  end

  # GET /verticals/1.json
  def show
    @vertical = Vertical.find(params[:id])
  end

  # POST /verticals.json
  def create
    @vertical = Vertical.new(vertical_params)

    if @vertical.save
      render :show, status: :created
    else
      @errors = @vertical.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /verticals/1.json
  def update
    @vertical = Vertical.find(params[:id])

    if @vertical.update(vertical_params)
      render :show
    else
      @errors = @vertical.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # DELETE /verticals/1.json
  def destroy
    Vertical.find(params[:id]).destroy
  end

  private

  def vertical_params
    params.require(:vertical).permit(:name)
  end
end
