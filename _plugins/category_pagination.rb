module Jekyll
  class CategoryPaginator < Generator
    safe true 

    def generate(site)
      site.categories.each {|c| paginate(site, c[0], c[1]) }
    end

    def paginate(site, type, posts)
      count = Pager.calculate_pages(posts, site.config['paginate'].to_i)
      (1..count).each do |page_num|
        pager = Pager.new(site, page_num, posts, count)
        path = "/#{type}"
        path += "/p#{page_num}" if page_num > 1

        cat_page = CategoryPage.new(site, site.source, path, type)
        cat_page.pager = pager
        site.pages << cat_page
      end
    end
  end

  class CategoryPage < Page
    def initialize(site, base, dir, type)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'default.html')
      self.data["category"] = type
    end
  end
end
