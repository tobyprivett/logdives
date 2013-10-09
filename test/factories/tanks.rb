# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :tank do |f|
  f.dive_id 1
  f.start_pressure 1
  f.end_pressure 1
  f.pressure_unit :metric
end

Factory.define :trimix_tank_18_35_imperial, :parent => :tank do |f|
  f.mix_type 'Trimix'
  f.volume 108
  f.volume_unit :imperial
  f.o2 18
  f.he 35
  f.pressure_unit :imperial
end

Factory.define :deco_tank_metric, :parent => :tank do |f|
  f.volume 6
  f.volume_unit :metric
  f.mix_type 'Nitrox'
  f.o2 80
  f.pressure_unit :metric
end