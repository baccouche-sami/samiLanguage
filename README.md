# SamiLanguage (Projet INTECH)

=> BACCOUCHE SAMI

=> Travail Réalisé: Interpreter
    - Lexer (done) + Tests unitaires
    - Parser (done) + Tests unitaires
    - Interpreter (done) + Tests unitaires

=> le langage source: sami

=> le langage d'implémentation : ruby

=> Interpreter Sami (Language Sami) est un langage interprété, ce qui signifie que mon interpréteur traduira le code source de Sami (fichiers avec extension (.sami)) en code machine pendant l’exécution du programme. Mon interpréteur est implémenté en utilisant ruby et mon choix de la language ruby est inspiré par l'utilisation de ruby pour créer le langage Liquid de Shopify.

Les parties de notre interpréteur sont Lexer,Parser et Interpreter :

    Lexer : la mission du mon lexer est de convertir une chaîne de caractères en des groupements sensibles généralement appelés 'tokens', Imaginez que je déclare une variable appelée      my_var. lexer lira ces caractères et produira un token Token::VARIABLE.

    Parser : La tâche principale de mon parser est de transformer une séquence plate de tokens en une structure de données qui peut représenter les relations existant entre eux. Une autre fonction importante de mon parser est de nous dire quand nous avons foiré en signalant des erreurs de syntaxe.

    Interpreter: Mon interpreter est trés simple puisque il fonctionne directement avec la structure de données produite par mon parser. L’interprète analysera cette structure pièce par pièce et l’exécutera au fur et à mesure.

==> Conclusion: Dans mon language Sami, la conversion en code machine va se faire parce que l’interpréteur lui-même va être un programme Ruby (et donc être interprété par l’interpréteur de Ruby pendant que nous l’exécutons !).





## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add SamiLanguage

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install SamiLanguage

## Usage

TO Execute Program 1 : bundle exec sami exemples/testme1.sami
TO Execute Program 2 : bundle exec sami exemples/testme2.sami


TO RUN ALL TESTS : bundle exec rspec

TO RUN LEXER TESTS : bundle exec rspec spec/lexer_spec.rb
TO RUN PARSER TESTS : bundle exec rspec spec/parser_spec.rb
TO RUN INTERPRETER TESTS : bundle exec rspec spec/interpreter_spec.rb



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/SamiLanguage. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/SamiLanguage/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SamiLanguage project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/SamiLanguage/blob/master/CODE_OF_CONDUCT.md).
