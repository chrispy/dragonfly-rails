puts "Loading Filesystem"
module Dragonfly
  module DataStorage
    class FileDataStore
      include ::Kaltha::StoringScope
      def path
        ::Rails.configuration.kaltha.assets_path
      end
      def relative_path_for(filename)
        generated_path = generate_path(filename)
        puts "Generated Path: #{generated_path}"
        generated_path
      end
    end
  end
end