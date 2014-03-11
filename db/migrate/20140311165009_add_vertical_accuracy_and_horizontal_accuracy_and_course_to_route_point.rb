class AddVerticalAccuracyAndHorizontalAccuracyAndCourseToRoutePoint < ActiveRecord::Migration
  def change
    add_column :route_points, :vertical_accuracy, :float
    add_column :route_points, :horizontal_accuracy, :float
    add_column :route_points, :course, :float
  end
end
