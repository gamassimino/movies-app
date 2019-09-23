desc "Pronto - CI commentor with rubocop"
namespace :pronto do

  task commentor: :environment do
    require "pronto/rubocop"

    formatter = Pronto::Formatter::GitlabFormatter.new
    Pronto.run('origin/develop', '.', formatter)
  end
end
