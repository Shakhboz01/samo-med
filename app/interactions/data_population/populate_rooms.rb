module DataPopulation
  class PopulateRooms < ActiveInteraction::Base
    def execute
      rooms = JSON.parse(File.read('app/assets/javascripts/rooms.json'))

      rooms.each do |room|
        Room.create(
          name: room['XONA_NOMI_RAQAMI'],
          capacity: room['NECHI_KISHILIK']
        )
      end
    end
  end
end
