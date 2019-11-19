class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exception)
    @errors = [exception.message]
    render 'api/v1/shared/errors', status: :not_found
  end
end
