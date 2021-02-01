# == Schema Information
#
# Table name: meter_reads
#
#  id             :integer         not null, primary key
#
#  std_sm_wm      :float           default("0.0"), not null
#  std_big_wm     :float           default("0.0"), not null
#  std_vst_wm     :float           default("0.0"), not null
#  
#  act_sm_read    :float           default("0.0"), not null
#  mst_sm_read    :float           default("0.0"), not null
#
#  act_big_read   :float           default("0.0"), not null
#  mst_big_read   :float           default("0.0"), not null
#
#  act_vst_read   :float           default("0.0"), not null
#  mst_vst_read   :float           default("0.0"), not null
#
#  act_smyc_read  :float           default("0.0"), not null
#  mst_smyc_read  :float           default("0.0"), not null
#
#  act_bigyc_read :float           default("0.0"), not null
#  mst_bigyc_read :float           default("0.0"), not null
#
#  rcv_count      :float           default("0.0"), not null
#  wtr_count      :float           default("0.0"), not null
#
#  name           :string          default(""), not null
#  cal_date       :string          default(""), not null
#
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#


class MeterRead < ActiveRecord::Base






end
