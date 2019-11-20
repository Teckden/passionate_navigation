class Api::V1::CoursesController < ApplicationController

  # GET /courses.json
  def index
    @courses = Category.find(params[:category_id]).courses
  end

  # GET /courses/1.json
  def show
    @course = Category.find(params[:category_id]).courses.find(params[:id])
  end

  # POST /courses.json
  def create
    @course = Category.find(params[:category_id]).courses.build(course_params)

    if @course.save
      render :show, status: :created
    else
      @errors = @course.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /courses/1.json
  def update
    @course = Category.find(params[:category_id]).courses.find(params[:id])

    if @course.update(course_params)
      render :show, status: :ok
    else
      @errors = @course.errors.full_messages
      render 'api/v1/shared/errors', status: :unprocessable_entity
    end
  end

  # DELETE /courses/1.json
  def destroy
    Category.find(params[:category_id]).courses.find(params[:id]).destroy
  end

  private

  def course_params
    params.require(:course).permit(:author, :name, :state)
  end
end
