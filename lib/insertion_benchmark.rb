class InsertionBenchmark
  def insert_points
    route = Route.new
    route.mode = "bike"
    route.user_id = 1
    points = [{
      lat: 55.4,
      long: 22.3,
      altitude: 1.24,
      kph: 60,
      time: Time.now.to_i,
      vertical_accuracy: 30,
      horizontal_accuracy: 30,
      course: 100.2,
      }] * 1000
    points.each do |point|
      route_point = RoutePoint.create do |rp|
        rp.lat = point[:lat]
        rp.long = point[:long]
        rp.altitude = point[:altitude]
        rp.kph = point[:speed] if point[:speed]
        rp.kph = point[:kph] if point[:kph]
        rp.time = Time.at(point[:time].to_i)
        rp.vertical_accuracy = point[:vertical_accuracy]
        rp.horizontal_accuracy = point[:horizontal_accuracy]
        rp.course = point[:course]
        rp.street_name = point[:street_name] if point[:street_name].present?
        rp.route = route
      end
      route.points << route_point
    end
    route.save
  end

  def perform_benchmark
    puts "ActiveRecord with transaction:"
    puts base = Benchmark.measure { insert_points }

    puts "ActiveRecord with transaction:"
    puts bench = Benchmark.measure { ActiveRecord::Base.transaction { insert_points } }
    puts sprintf("  %2.2f base", base.real)
    puts sprintf("  %2.2f bench", bench.real)
    puts sprintf("  %2.2fx faster than base", base.real / bench.real)
  end
end
