class CreateMeterStandards < ActiveRecord::Migration
  def change
    create_table :meter_standards do |t|
    
      t.float :std_sm_wm,  null: false, default: 1
    
      t.float :std_big_wm,  null: false, default: 12
    
      t.float :std_sm_yc,  null: false, default:  1
    
      t.float :std_big_yc,  null: false, default:  6
    
      t.float :std_vst_wm,  null: false, default:  2
    
      t.float :cj_jl,  null: false, default: 50 
    
      t.float :cj_cf,  null: false, default:  50
    
      t.float :yd_jl,  null: false, default:  50
    
      t.float :ydzj_jl,  null: false, default:  50
    
      t.float :ed_jl,  null: false, default:  100
    
      t.float :edzj_jl,  null: false, default:  100
    
      t.float :yd_cf,  null: false, default:  50
    
      t.float :ed_cf,  null: false, default:  50
    
      t.float :sd_cf,  null: false, default:  100
    
      t.float :zg_cf,  null: false, default:  2000
    

    

      t.references :user
    

    

      t.timestamps null: false
    end
  end
end
