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
            if auth.kind_of?(Fixnum)
              Talestore::Author.find(auth)
            else
              # Crear el autor si no existe
              Talestore::Author.where(:name => auth[:name], :surname => auth[:surname]).first_or_create!(auth)
            end
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
    id = 147
    text = %Q[Hay muchísimas mujeres que piensan que con tal de no llegar hasta el fin con un amante, pueden permitirse, sin ofensa para su esposo, un cierto comercio de galantería, y a menudo esta forma de ver las cosas tiene consecuencias más peligrosas que si la caída hubiese sido completa. Lo que le ocurrió a la Marquesa de Guissac, mujer de elevada posición de Nimes, en el Languedoc, es una prueba evidente de lo que aquí proponemos como máxima.

Alocada, aturdida, alegre, rebosante de ingenio y de simpatía, la señora de Guissac creyó que ciertas cartas de amor, escritas y recibidas por ella y por el barón de Aumelach, no tendrían consecuencia alguna, siempre que no fueran conocidas; y que si, por desgracia, llegaban a ser descubiertas, pudiendo probar su inocencia a su marido, no perdería en modo alguno su favor. Se equivocó... El señor de Guissac, desmedidamente celoso, sospecha el intercambio, interroga a una doncella, se apodera de una carta, al principio no encuentra en ella nada que justifique sus temores, pero sí mucho más de lo que necesita para alimentar sus sospechas, toma una pistola y un vaso de limonada e irrumpe como un poseso en la habitación de su mujer...

-Señora, he sido traicionado -ruge enfurecido-; leed: él me lo aclara, ya no hay tiempo para juzgar, os concedo la elección de vuestra muerte.

La Marquesa se defiende, jura a su marido que está equivocado, que puede ser, es verdad, culpable de una imprudencia, pero que no lo es, sin lugar a duda, de crimen alguno.

-¡Ya no me convenceréis, pérfida! -responde el marido furioso-, ¡ya no me convenceréis! Elegid rápidamente o al instante este arma os privará de la luz del día.

La desdichada señora de Guissac, aterrorizada, se decide por el veneno; toma la copa y lo bebe.

-¡Deteneos! -le dice su esposo cuando ya ha bebido parte-, no pereceréis sola; odiado por vos, traicionado por vos, ¿qué querríais que hiciera yo en el mundo? -y tras decir esto bebe lo que queda en el cáliz.
-¡Oh, señor! -exclama la señora de Guissac-. En terrible trance en que nos habéis colocado a ambos, no me neguéis un confesor ni tampoco el poder abrazar por última vez a mi padre y a mi madre.

Envían a buscar en seguida a las personas que esta desdichada mujer reclama, se arroja a los brazos de los que le dieron la vida y de nuevo protesta que no es culpable de nada. Pero, ¿qué reproches se le pueden hacer a un marido que se cree traicionado y que castiga a su mujer de tal forma que él mismo se sacrifica? Sólo queda la desesperación y el llanto brota de todos por igual. Mientras tanto llega el confesor...

-En este atroz instante de mi vida -dice la Marquesa- deseo, para consuelo de mis padres y para el honor de mi memoria, hacer una confesión pública -y empieza a acusarse en voz alta de todo aquello que su conciencia le reprocha desde que nació.

El marido, que está atento y que no oye citar al barón de Aumelach, convencido de que en semejante ocasión su mujer no se atrevería a fingir, se levanta rebosante de alegría.

-¡Oh, mis queridos padres! -exclama abrazando al mismo tiempo a su suegro y a su suegra-, consolaos y que vuestra hija me perdone el miedo que le he hecho pasar, tantas preocupaciones me produjo que es lícito que le devuelva unas cuantas. No hubo nunca ningún veneno en lo que hemos tomado, que esté tranquila; calmémonos todos y que por lo menos aprenda que una mujer verdaderamente honrada no sólo no debe cometer el mal, sino que tampoco debe levantar sospechas de que lo comete.

La Marquesa tuvo que hacer esfuerzos sobrehumanos para recobrarse de su estado; se había sentido envenenada hasta tal punto que el vuelo de su imaginación le había ya hecho padecer todas las angustias de muerte semejante. Se pone en pie temblorosa, abraza a su marido; la alegría reemplaza al dolor y la joven esposa, bien escarmentada por esta terrible escena, promete que en el futuro sabrá evitar hasta la más pequeña apariencia de infidelidad. Mantuvo su palabra y vivió más de treinta años con su marido sin que éste tuviera nunca que hacerle el más mínimo reproche.
]


    tale = Talestore::Tale.find(id)
    tale.update_attributes!(:text => text)
  end
end
