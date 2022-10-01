class HooksController < ApplicationController
  # skip_before_action :verify_authenticity_token
  # skip_before_action :authenticate_user!
  
  def order_callback
    
    begin
      puts "parametros: #{params}"
      puts "NOME: #{params["scope_name"]}"
      puts "ID do ESCOPO: #{params["scope_id"]}"
      puts "ID SELLER: #{params["seller_id"]}"
      # data = JSON.parse(params)
      # puts "parse json: #{data}"
      
    rescue Exception => e
      puts "Error on webhook, order_callback: #{e}"
      # Honeybadger.notify("Error on Webhook: #{e.message}")
    end
    
    head :ok
  end

end
