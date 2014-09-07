namespace :tale do
  desc 'Create a tale'
  task :create => :environment do
    # Cargar cada uno de los ficheros yaml con los datos de los cuentos
    Dir[File.join(File.dirname(__FILE__), "tales", "*.yml")].each do |file|
      puts "Procesando fichero: #{file}"
      data = YAML::load(File.open(file))

      data.each do |tale|
        puts "TALE: #{tale.inspect}"

        Talestore::Author.transaction do
          authors = tale[:authors].map do |auth|
            # Crear el autor si no existe
            Talestore::Author.where(:name => auth[:name], :surname => auth[:surname]).first_or_create!(auth)
          end

          puts "AUT: #{authors.inspect}"

          # Crear el cuento 
          tale = authors.first.tales.where(:title => tale[:tale][:title]).first_or_create!(tale[:tale])

          # Asociar los autores al cuento
          authors.each do |author|
            tale.authors << author  
          end
        end # transaction
      end # each tale 
    end # each config file
  end

  desc 'Create a tale'
  task :create_manually => :environment do
    id = 108
    text = %Q[]


    tale = Talestore::Tale.find(id)
    tale.update_attributes!(:text => text)
  end
end
