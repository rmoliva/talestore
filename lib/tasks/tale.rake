namespace :tale do
  desc 'Create a tale'
  task :create => :environment do
    puts Talestore::Tale.all.inspect

    # Cargar cada uno de los ficheros yaml con los datos de los cuentos
    Dir[File.join(File.dirname(__FILE__), "tales", "*.yml")].each do |file|
      puts "Procesando fichero: #{file}"
      data = YAML::load(File.open(file))

      data.each do |tale|
        puts "TALE: #{tale.inspect}"

        Talestore::Author.transaction do
          # Crear el autor si no existe
          author = Talestore::Author.where(:name => tale["author"]["name"], :surname => tale["author"]["surname"]).first_or_create!(tale["author"])

          # Crear el cuento 
          tale = author.tales.where(:title => tale["tale"]["title"]).first_or_create!(tale["tale"])

          # Asociar el autor al cuento
          tale.authors << author
        end # transaction
      end # each tale 
    end # each config file
  end
end
