class MeterStandard < ActiveRecord::Base
  belongs_to :user

end

# == Schema Information
#
# Table name: meter_standards
#
#  id         :integer         not null, primary key
#  std_sm_wm  :float           default("1.0"), not null
#  std_big_wm :float           default("12.0"), not null
#  std_sm_yc  :float           default("1.0"), not null
#  std_big_yc :float           default("6.0"), not null
#  std_vst_wm :float           default("2.0"), not null
#  cj_jl      :float           default("50.0"), not null
#  cj_cf      :float           default("-50.0"), not null
#  yd_jl      :float           default("50.0"), not null
#  ydzj_jl    :float           default("50.0"), not null
#  ed_jl      :float           default("100.0"), not null
#  edzj_jl    :float           default("100.0"), not null
#  yd_cf      :float           default("-50.0"), not null
#  ed_cf      :float           default("-50.0"), not null
#  sd_cf      :float           default("-100.0"), not null
#  zg_cf      :float           default("2000.0"), not null
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

