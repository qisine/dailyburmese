require File.join(__dir__, 'utilities.rb')

module Jekyll
  class Paginator < Generator
    safe true 

    def generate(site)
      #require 'debugger'; debugger
      site.categories.each do |c|
        paginate(site, c[0], c[1].sort_by {|p| -p.date.to_f}, "/archives/#{c[0]}", CategoryPage) 
      end

      site.tags.each do |t|
        t[1].group_by { |p| p.categories.first }.each_pair do |cat, posts|
          paginate(site, t[0], posts.sort_by {|p| -p.date.to_f}, "/tags/#{cat}/#{t[0]}", TagPage) 
        end
      end

      kwds = Hash.new { |h,k| h[k] = [] }
      site.posts.select {|p| p.categories.first == "unicode" && p.data["keywords"]}.each do |p|
        p.data["kwd_hash"] ||= Hash.new { |h,k| h[k] = [] }
        p.data["keywords"].split(",").each do |kwd|
          kwds[kwd.strip] << p
          p.data["kwd_hash"][kwd.strip] << "/keywords/#{Utilities::dasherize(kwd.strip)}"
        end
      end

      kwds.each_pair do |kwd, posts| 
        paginate(site, kwd, posts.sort_by {|p| -p.date.to_f}, "/keywords/#{Utilities::dasherize(kwd)}", KeywordPage) 
      end
    end

    def paginate(site, type, posts, prefix, page_cls)
      count = Pager.calculate_pages(posts, site.config['paginate'].to_i)
      (1..count).each do |page_num|
        pager = Pager.new(site, page_num, posts, count)
        path = prefix
        path += "/p#{page_num}" if page_num > 1

        cat_page = page_cls.new(site, site.source, path, type)
        cat_page.pager = pager
        site.pages << cat_page
      end

    end
  end

  class BasePage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
    end
  end

  class CategoryPage < BasePage
    def initialize(site, base, dir, type)
      super(site, base, dir)

      self.read_yaml(base, 'archives/category_index.html')
      self.data["category"] = type
    end
  end

  class TagPage < BasePage
    def initialize(site, base, dir, type)
      super(site, base, dir)

      self.read_yaml(base, 'archives/tag_index.html')
      self.data["tag"] = type
    end
  end

  class KeywordPage < BasePage
    def initialize(site, base, dir, type)
      super(site, base, dir)

      self.read_yaml(base, 'archives/tag_index.html')
      self.data["kw"] = type
    end
  end
end
