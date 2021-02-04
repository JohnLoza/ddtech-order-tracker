require 'active_support/concern'

module Searchable
  extend ActiveSupport::Concern

  class_methods do

    # search for keywords in certain fields
    # available options, keywords = String, fields = Array and joins = Hash
    def search(options={})
      # not search anything if there are no keywords or fields to search for
      return all unless options[:keywords].present?
      raise ArgumentError, "No fields to search were given" unless options[:fields].present?
      raise ArgumentError, "fields option must be an Array" unless options[:fields].kind_of? Array

      if options[:joins].present? and (!options[:joins].kind_of? Hash and !options[:joins].kind_of? Symbol)
        raise ArgumentError, "joins options must be a Hash or a Symbol"
      end

      query = Array.new

      options[:keywords] = Utils.format_search_keywords(options[:keywords])
      operator = options[:keywords].at(Utils::REGEXP_SPLITTER) ? :REGEXP : :LIKE

      options[:fields].each do |field|
        query << "#{field} #{operator} :keywords"
      end

      query = query.join(' OR ')

      if options[:joins].present?
        joins(options[:joins]).where(query, keywords: options[:keywords])
      else
        where(query, keywords: options[:keywords])
      end
    end

  end
end
