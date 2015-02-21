require_relative './config/environment.rb'

class PDFParser
  attr_accessor :reader, :raw_extracted_pages, :raw_extracted_buildings

  def initialize(filename)
    @reader = PDF::Reader.new(filename)
    @raw_extracted_pages = []
    @raw_extracted_buildings = []
    extract_pages_to_text
    extract_buildings
  end

  # Parses PDF into an array of pages containing arrays of each line of the PDF.

  def extract_pages_to_text
    reader.pages.each do |page|
      raw_extracted_pages << page.text.split("\n")
    end
  end

  # Splits each building entry into an array with address details
  # Removes junk (the generic headings on each page of the PDF and empty arrays from blank lines)
  def extract_buildings
    raw_extracted_pages.each do |page|
      page.each do |line|
        building_info = line.split(" ")
        if building_info.empty? == false && building_info[0] != "ZIP" && building_info[0].start_with?("Brooklyn") == false && building_info[0].start_with?("Source") == false
          raw_extracted_buildings << building_info
        end
      end
    end
  end

end

info = PDFParser.new("./data/2013BrooklynBldgs.pdf")
binding.pry

# info.raw_extracted_buildings[0] will return the first building and so on.
