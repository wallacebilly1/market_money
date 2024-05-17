class ErrorMessage
  attr_reader :message, :status_code

  def initialize(message, status_code)
    @message = message
    @status_code = status_code
  end

  def market_vendor_error_message
    if @message.include?("Market")
      "Validation Failed: Market must exist"
    elsif @message.include?("Vendor")
      "Validation Failed: Vendor must exist"
    end
  end
end