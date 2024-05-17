class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveModel::ValidationError, with: :invalid_record_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_parameters_response

  private
  def not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404)
    ).serialize_json, status: 404
  end

  def invalid_record_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 400)
    ).serialize_json, status: 400
  end

  def invalid_parameters_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 422)
    ).serialize_json, status: 422
  end
end