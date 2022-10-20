namespace :db do
  desc "Criar Cidades"
  task create_cities: :environment do
    puts "Start db:create_cities"

    xlsx = Roo::Spreadsheet.open("#{Rails.root}/cidades_sankhya.xlsx")
    last_row = xlsx.last_row
    current_row = 3
    while current_row <= last_row
      array = xlsx.sheet(0).row(current_row)

      City.create!(
       name: array[1].upcase.strip,
       state: array[3].upcase.strip,
       codcid: array[0].to_i,
       coduf: array[2].to_i
      )

      current_row += 1
    end

    puts "End db:create_cities"
  end
end