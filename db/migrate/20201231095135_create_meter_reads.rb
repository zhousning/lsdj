class CreateMeterReads < ActiveRecord::Migration
  def change
    create_table :meter_reads do |t|
    
      t.float :std_sm_wm,  null: false, default: Setting.systems.default_num 
    
      t.float :std_big_wm,  null: false, default: Setting.systems.default_num 
    
      t.float :std_vst_wm,  null: false, default: Setting.systems.default_num 

      t.float :std_sm_yc,  null: false, default: Setting.systems.default_num 
    
      t.float :std_big_yc,  null: false, default: Setting.systems.default_num 
    
      t.integer :act_sm_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :mst_sm_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :act_big_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :mst_big_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :act_vst_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :mst_vst_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :act_smyc_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :mst_smyc_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :act_bigyc_read,  null: false, default: Setting.systems.default_num 
    
      t.integer :mst_bigyc_read,  null: false, default: Setting.systems.default_num 
    
      t.float :rcv_count,  null: false, default: Setting.systems.default_num 
    
      t.float :wtr_count,  null: false, default: Setting.systems.default_num 

      t.integer :smp_fc_count,  null: false, default: Setting.systems.default_num 
    
      t.integer :smp_count,  null: false, default: Setting.systems.default_num 
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :cal_date,  null: false, default: Setting.systems.default_str
    
      t.float :total,  null: false, default: Setting.systems.default_num 

      t.float :act_mt_count,  null: false, default: Setting.systems.default_num 

      t.float :mst_mt_count,  null: false, default: Setting.systems.default_num 
    
      t.float :cj_rate,  null: false, default: Setting.systems.default_num 

      t.float :acrt_rate,  null: false, default: Setting.systems.default_num 

      t.float :rcy_rate,  null: false, default: Setting.systems.default_num 

      t.float :acrt_mny,  null: false, default: Setting.systems.default_num 

      t.float :rcy_mny,  null: false, default: Setting.systems.default_num 

      t.timestamps null: false
    end
  end
end
