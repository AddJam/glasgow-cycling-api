# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

p "Seeding pictures"
pictures_file = File.open("#{Rails.root}/db/pictures.csv").read
pictures_file.gsub!(/\r\n?/, "\n")
pictures_file.each_line do |picture|
	picture.gsub!("\n", "")
	p "County file line with pic #{picture}"
  picture_parts = picture.split(',')

  file_name = picture_parts[0]
  lat = picture_parts[1]
  long = picture_parts[2]
  photographer = picture_parts[3]
  source_url = picture_parts[4]

  file = File.open("#{Rails.root}/db/pictures/#{file_name}")

  pic = Picture.create({
    lat: lat,
    long: long,
    credit_label: photographer,
    credit_url: source_url,
    url: source_url,
    image: file
  })
  file.close
end
