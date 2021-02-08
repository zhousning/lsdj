
class MeterRead < ActiveRecord::Base

  belongs_to :user





end

# == Schema Information
#
# Table name: meter_reads
#
#  id             :integer         not null, primary key
#  std_sm_wm      :float           default("0.0"), not null
#  std_big_wm     :float           default("0.0"), not null
#  std_vst_wm     :float           default("0.0"), not null
#  std_sm_yc      :float           default("0.0"), not null
#  std_big_yc     :float           default("0.0"), not null
#  act_sm_read    :integer         default("0"), not null
#  mst_sm_read    :integer         default("0"), not null
#  act_big_read   :integer         default("0"), not null
#  mst_big_read   :integer         default("0"), not null
#  act_vst_read   :integer         default("0"), not null
#  mst_vst_read   :integer         default("0"), not null
#  act_smyc_read  :integer         default("0"), not null
#  mst_smyc_read  :integer         default("0"), not null
#  act_bigyc_read :integer         default("0"), not null
#  mst_bigyc_read :integer         default("0"), not null
#  rcv_count      :float           default("0.0"), not null
#  wtr_count      :float           default("0.0"), not null
#  smp_fc_count   :integer         default("0"), not null
#  smp_count      :integer         default("0"), not null
#  name           :string          default(""), not null
#  cal_date       :string          default(""), not null
#  total          :float           default("0.0"), not null
#  act_mt_count   :float           default("0.0"), not null
#  mst_mt_count   :float           default("0.0"), not null
#  cj_rate        :float           default("0.0"), not null
#  acrt_rate      :float           default("0.0"), not null
#  rcy_rate       :float           default("0.0"), not null
#  acrt_mny       :float           default("0.0"), not null
#  rcy_mny        :float           default("0.0"), not null
#  salary         :float           default("0.0"), not null
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

