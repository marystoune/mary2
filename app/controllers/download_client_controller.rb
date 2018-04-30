class DownloadClientController < ApplicationController
  
  POSSIBLE_CLIENTS = ["windows", "linux", "mac"]

  def download
    if POSSIBLE_CLIENTS.include? params[:file_name]
      send_file "#{Rails.root}/public/#{params[:file_name]}.zip", type: 'application/zip', disposition: 'inline'
    else
      render text: "" and return
    end 
  end
end
