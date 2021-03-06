
  class RideShare::Driver
    attr_reader :id, :name, :vin

    def initialize(driver_data)
      @id = driver_data[:id]
      @name = driver_data[:name]
      @vin = driver_data[:vin]
    end

    def trips
      trips =  RideShare::Trip.all_drivers(id)
      return ((trips.length > 0) ? trips : nil)
    end

    def rating
      return nil if !(trips)
      ratings = trips.map{ |t| t.rating.to_f }
      return (ratings.reduce(:+) / ratings.length).round(1)
    end

    def self.all
      driver_array = []
      CSV.open("support/drivers.csv", 'r').each do |driver|
        new_driver = RideShare::Driver.new({
          :id => driver[0],
          :name => driver[1],
          :vin => driver[2]
          })
          driver_array << new_driver
      end
      driver_array.shift
      return driver_array
    end

    def self.find(id)
      raise InvalidIdError.new "This is not a valid ID. ID Given: #{id}" if !(id.match(/^\d+$/))
      drivers = RideShare::Driver.all
      return drivers.find { |d| d.id == id }
    end

  end
