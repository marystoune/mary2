require 'render_anywhere'
include RenderAnywhere

namespace :qiwicoin do

  TABLE_ID = "#last_txs"
  CHANNEL = "/new_block"
  RM_LAST_TX_CMD = "$(\"#last_txs tr:last\").remove();"
  OPACITY_CMD = "$( \"#last_txs tr:first-child\" ).animate({ opacity: 0.0 }, \"fast\" );$( \"#last_txs tr:first-child\" ).animate({ opacity: 1 }, 2000 );"
  SLEEP_TIME = 2
  STEPS = 25

  desc "Synchronizes the server database with qiwicoin client blockchain"
  task :synchronize_blockchain => :environment do
    steps = STEPS
    while steps != 0

      config = YAML::load(File.open(File.join(Rails.root, "config", "synchronize_blockchain.yml")))[Rails.env]
    
      last_txs_amount = Tx.all.size
      system("cd " + config['dirname'] + "&&" + config['utility'])
    
      current_amount = Tx.all.size
      Tx.all.last(current_amount - last_txs_amount).each do | tx |
      
        html = render 'informations/_last_tx', layout: false, locals: { tx: Tx.last }
        html = html.gsub("\"", "'").gsub("\n", "")
        action = "$('#{TABLE_ID}').prepend(\"#{ html }\");#{RM_LAST_TX_CMD}#{OPACITY_CMD}"      

        faye_helper = FayeHelper.new CHANNEL, action
        faye_helper.broadcast
      end
     
     steps -= 1
     sleep SLEEP_TIME
   end
   
  end

end
