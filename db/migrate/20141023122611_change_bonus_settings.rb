class ChangeBonusSettings < ActiveRecord::Migration
  def self.up
    BonusSetting.where("id <> 1").destroy_all
    default_settings = [
      { begin: 1001,  end: 201_001,   amount: 50  }
    ]
    
    default_settings.each do |setting|
      BonusSetting.create(setting)
    end
  end

  def self.down
    BonusSetting.where("id <> 1").destroy_all
    default_settings = [
      { begin: 1001,  end: 2000,   amount: 700  },
      { begin: 2001,  end: 3000,   amount: 600  },
      { begin: 3001,  end: 4000,   amount: 500  },
      { begin: 4001,  end: 5000,   amount: 400  },
      { begin: 5001,  end: 10000,  amount: 300  },
      { begin: 10001, end: 20000,  amount: 100  },
      { begin: 20001, end: 50000,  amount: 50   },
      { begin: 50001, end: 100000, amount: 20   }
    ]
    
    default_settings.each do |setting|
      BonusSetting.create(setting)
    end

  end
end
