# Create some initial locations:
# NOTE: names are mainly for administtative purposes as characters will see every location as "unknown location"

return unless Location.count < 10

(1..19).each do
  Location.create(name: Faker::Address.city, locationtype_id: 1, locationclass_id: 1)
end
