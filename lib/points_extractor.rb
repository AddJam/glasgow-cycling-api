class PointsExtractor
  attr_accessor :locations, :types

  def initialize
    @locations = []
    @types = {
      rack: 'racks',
      shop: 'shops'
    }
  end

  def extract_all_types
    Rails.cache.fetch('racks-shops-data', expires_in: 1.day) do
      @types.each_key do |key|
        @locations += extract_locations(key.to_s, @types[key])
      end
      p "#{locations.count} locations"
      @locations
    end
  end

  def extract_locations(type, file_name)
    file_location = "db/points-of-interest/#{file_name}.geojson"

    file = open(file_location)
    json = file.read
    data = JSON.parse(json)

    p "#{data['features'].count} features of type #{type}"

    type_locations = []
    features = data['features']
    features.each do |feature|
      geometry = feature['geometry']
      if 'Polygon' == geometry['type']
        location = geometry['coordinates'][0][0]
      else
        location = geometry['coordinates'][0..1]
      end

      properties = feature['properties']

      type_locations << {
        lat: location[1],
        long: location[0],
        name: properties['name'],
        type: type
      }
    end

    return type_locations
  end
end
