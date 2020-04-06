# frozen_string_literal: true

module ReverseGeocode
  module Data
    class Page < Jekyll::Page
      # Create an endpoint page.
      #
      # @param [Jekyll::Site] site
      # @param [String] base
      # @param [Hash] zip_code
      def initialize(site, base, zip_code)
        @dir  = "v1"
        @base = base
        @name = "#{zip_code['zip']}.json"
        @site = site

        process(@name)
        read_yaml(File.join(base, "_layouts"), "location.html")
        data["zip_code"] = zip_code
      end
    end

    class Generator < Jekyll::Generator
      FILENAME = "zipcodes.json"

      # Generate endpoints for each zip code.
      #
      # @param [Jekyll::Site] site
      def generate(site)
        file      = File.open(File.join(site.config["data_dir"], FILENAME)).read
        zip_codes = JSON.parse(file)
        zip_codes.each do |zip_code|
          site.pages << Page.new(site, site.source, zip_code)
        end
      end
    end
  end
end
