Category.create!([
  { name: '服装箱包' },
  { name: '个护化妆' },
  { name: '母婴玩具' },
  { name: '食品保健' },
  { name: '家居日常' },
  { name: '科技电子' }
]) if Category.all.blank?
Region.create!([
  { name: '香港' },
  { name: '台湾' },
  { name: '日本' },
  { name: '韩国' },
  { name: '马来西亚' },
  { name: '美国' },
  { name: '英国' },
  { name: '瑞典' },
  { name: '荷兰' },
  { name: '意大利' },
  { name: '丹麦' }
]) if Region.all.blank?
Preference.create!([
  { name: 'commission_rate', value: '0.05'},
  { name: 'deposit_ratio', value: '0.7'}
])