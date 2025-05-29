# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'httparty'

url = "https://tmdb.lewagon.com/movie/top_rated"
response = HTTParty.get(url)
movies = response.parsed_response["results"]

movies.first(10).each do |movie_data|
  Movie.create!(
    title: movie_data["title"],
    overview: movie_data["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500#{movie_data["poster_path"]}",
    rating: movie_data["vote_average"]
  )
end

puts "Creating lists"

list1 = List.create!(name: "Drama")
list2 = List.create!(name: "Comedy")
list3 = List.create!(name: "Sci-Fi")

puts "Creating bookmarks..."
List.all.each do |list|
  2.times do
    movie = Movie.all.sample
    Bookmark.create!(
      comment: "A great match!",
      list: list,
      movie: movie
    )
  end
end

puts "Seed finished"
