class HooksController < ApplicationController
  # skip_before_action :verify_authenticity_token
  # skip_before_action :authenticate_user!
  
  def order_callback
    
    # begin
    puts "parametros: #{params}"
    if params["scope_name"] == "order"
      Order.get_order!(params["scope_id"])
    end
      
    # rescue Exception => e
    #   puts "Error on webhook, order_callback: #{e.message}, parameters: #{params}"
    #   # Honeybadger.notify("Error on Webhook: #{e.message}")
    # end
    
    head :ok
  end

end
