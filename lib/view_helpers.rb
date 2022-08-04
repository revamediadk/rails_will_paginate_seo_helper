module RailsWillPaginateSeoHelper
  module ViewHelpers
    def will_paginate_seo_links(collection, first_word_translations = 'First', page_word_translations = 'Page')
      return unless collection.respond_to?(:current_page)

      @collection = collection
      @first_word_translations = first_word_translations
      @page_word_translations = page_word_translations
      build_tags
    end

    private

    def build_tags
      return (previous_link_tag << next_link_tag).html_safe if next_link_tag && previous_link_tag
      return previous_link_tag.html_safe if previous_link_tag

      next_link_tag.html_safe if next_link_tag
    end

    def previous_link_tag
      previous_page = @collection.previous_page
      original_url = request.original_url
      if previous_page
        prev_page_url = if previous_page == 1
                          original_url.gsub(/(&|\?)page\=\d{1,}/, '')
                        else
                          original_url.gsub(/page\=\d{1,}/, "page=#{previous_page}")
                        end
        if previous_page >= 2 # if page 3 or more add the base url link
          return content_tag(:a, @first_word_translations, href: original_url.gsub(/(&|\?)page\=\d{1,}/, ''), class: "first-page") + content_tag(:a, "#{@page_word_translations} #{previous_page}", href: prev_page_url, class: "previous-page")
        end

        content_tag(:a, "#{@page_word_translations} #{previous_page}", href: prev_page_url, class: "previous-page")
      end
    end

    def next_link_tag
      next_page = @collection.next_page
      return nil if next_page.nil?

      original_url = request.original_url

      match = original_url.match(/(&|\?)page\=\d{1,}/)

      if match          # has :page url-parameter
        next_page_url = original_url.gsub(/page\=\d{1,}/, "page=#{next_page}")
      else              # no :page url-parameter page
        sign_match = original_url.match(/\?/)
        next_page_url = if sign_match # url has parameter attached
                          original_url.concat("&page=#{next_page}")
                        else            # url has no parameter attached
                          original_url.concat("?page=#{next_page}")
                        end
      end

      content_tag(:a, "#{@page_word_translations} #{next_page}", href: next_page_url, class: "next-page") if next_page_url
    end
  end
end
