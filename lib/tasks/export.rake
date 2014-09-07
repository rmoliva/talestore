namespace :export do
  desc 'Export tales to yaml format'
  task :yaml => :environment do
    array = Talestore::Tale.all.map do |tale|
      {
        :authors => tale.authors.map do |author| 
          {
            :name => author.name,
            :surname => author.surname,
            :born_year => author.born_year,
            :death_year => author.death_year
          }
        end,
        :tale => {
          :title => tale.title,
          :text => tale.text
        }
      }
    end
    puts array.to_yaml
  end # yaml

  desc 'Export tales to text format'
  task :text => :environment do
    Talestore::Tale.all.map do |tale|
      puts "================================================"
      puts tale.title
      auth = tale.authors.map{|a| "#{a.complete_name} (#{a.born_year} - #{a.death_year})"}
      puts "#{auth.join(', ')}"
      puts ""
      puts tale.text
      puts "================================================"
    end
  end # text
end # export

