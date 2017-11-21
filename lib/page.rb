class Page
  include ERB::Util

  WIKIGAME_SHORTCODES = %w{invhasall invhasone invhasnone invpickup invdrop settoken gettoken test}
  URL_REMAPS = {
    'http://www.scatmania.org/wp-content/paul_zippy.jpg' => '/images/paul_zippy.jpg'
  }

  attr_reader :id, :tag, :time, :body, :owner, :user, :read_acl, :write_acl, :comment_acl

  def self.all
    @@all_pages ||= DB.execute('SELECT * FROM wikka_pages').map{|row| Page.new(row)}
  end

  def self.find_by_tag(tag)
    all.select{|page| page.tag == tag}[0]
  end

  def self.missing_pages
    @@missing_pages || []
  end

  def self.find_all_containing_word(word)
    all.select{|page| page.body =~ /(\W|^)#{word}(\W|$)/}
  end

  def initialize(row)
    @id, @tag, @time, @body, @owner, @user, @read_acl, @write_acl, @comment_acl = row
  end

  def comments
    @comments ||= Comment.find_all_by_page_tag(@tag)
  end

  def formatted
    result = h(@body)
    # Add warning if using unsupported shortcodes
    URL_REMAPS.each do |from, to|
      result.gsub!(from, to)
    end
    result = %{<div class="wikigame-shortcodes">This page used WikiGameToolkit shortcodes, which are not supported in this version of the site.</div>#{result}} if WIKIGAME_SHORTCODES.any?{|code| result =~ /\{\{#{code}\}\}/i}
    # Pre-process by fixing windows line endings
    result.gsub!(/\r\n/, "\n")
    # Downcasify all shortcodes to protect them from being turned into links
    result.gsub!(/\{\{.*\}\}/){|shortcode| shortcode.downcase}
    # Strip duplicate page titles
    result.gsub!(/^[^\n]*=+ *#{@tag} *=+[^\n]*/, '')
    # Strip leading/trailing newlines
    result.gsub!(/^\n+/, '')
    result.gsub!(/\n+$/, '')
    # Process wiki code
    result.gsub!(/\n+----+\n+/, '<hr />')
    result.gsub!(/''(.+?)''/, '<strong class="highlight">\1</strong>')
    result.gsub!(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    result.gsub!(/\/\/(.+?)\/\//, '<em>\1</em>')
    result.gsub!(/##(.+?)##/, '<pre>\1</pre>')
    result.gsub!(/%%(.+?)%%/, '<pre>\1</pre>')
    result.gsub!(/\+\+(.+?)\+\+/, '<strike>\1</strike>')
    result.gsub!(/__(.+?)__/, '<u>\1</u>')
    result.gsub!(/@@(.+?)@@/, '<center>\1</center>')
    result.gsub!(/#%(.+?)#%/, '<div class="button">\1</div>')
    result.gsub!(/={6} *(.+?) *={6}\n*/, '<h1>\1</h1>')
    result.gsub!(/={5} *(.+?) *={5}\n*/, '<h2>\1</h2>')
    result.gsub!(/={4} *(.+?) *={4}\n*/, '<h3>\1</h3>')
    result.gsub!(/={3} *(.+?) *={3}\n*/, '<h4>\1</h4>')
    result.gsub!(/={2} *(.+?) *={2}\n*/, '<h5>\1</h5>')
    result.gsub!(/(~- *([^\n]*))(\n *~-([^\n]*))*/) do |list|
      items = list.gsub('~-', '<li>').gsub("\n", '</li>')
      "<ul>#{items}</ul>"
    end
    result.gsub!(/\[\[.+?\]\]|([A-Z][a-z0-9]+)([A-Z][a-z0-9]*)+/) do |link|
      link = link.gsub(/[\[\[\]\]]/, '').split(' ', 2)
      classes = []
      unless Page.find_by_tag(link[0])
        # broken link; attempt obvious fixes
        if Page.find_by_tag(link[0].capitalize)
          # fixed it!
          link[1] ||= link[0]
          link[0] = link[0].capitalize
          classes << 'auto-fixed'
        else
          # nope; still broken - let's try something else
          if alt_page = Page.all.select{|page| page.tag.downcase == link[0].downcase}[0]
            # phew! that worked
            link[1] ||= link[0]
            link[0] = alt_page.tag
            classes << 'auto-fixed'
          else
            # still nothing? damn: let's give up!
            (@@missing_pages ||= []) << link[0]
            classes << 'broken'
          end
        end
      end
      if link[0] =~ /^https?:/
        url = link[0]
        classes << 'external'
      else
        url = "/#{link[0]}"
        classes << 'internal'
      end
      %{<a href="#{url}" class="#{classes.join(' ')}">#{link[1] || link[0]}</a>}
    end
    result.gsub!(/\n/, "<br />\n")
    result.gsub!(/(<br \/>\n){2,}</, "<br />\n<")
    result.gsub!(/\{\{(.+?)( +(.+?)=&quot;(.+?)&quot;)*\}\}/) do |shortcode|
      code, params = shortcode[2...-2].split(/\s/, 2)
      params = (params || '').scan(/ *(.+?)=&quot;(.+?)&quot;/) || []
      params = Hash.new.tap{ |h| params.each{ |k,v| h[k] = v } }
      if code == 'image'
        image = %{<img src="#{params['url']}" alt="#{params['alt']}" class="#{params['class']}" />}
        image = %{<a href="/#{params['link']}">#{image}</a>} if(params['link'])
        image
      elsif code == 'category'
        page_tags = Page.find_all_containing_word(@tag).map(&:tag)
        lis = page_tags.map{|t| %{<li><a href="/#{t}">#{t}</a></li>} }.join('')
        %{<ul>#{lis}</ul>}
      elsif WIKIGAME_SHORTCODES.include?(code)
        # drop
      else
        "<div>UNKNOWN SHORTCODE: #{code} (#{h(params.inspect)})</div>"
      end
    end
    # Add comments
    if comments.length > 0
      comments_html = comments.map{|comment| %{<blockquote class="comment"><div class="body">#{comment.comment}</div><cite><a href="/#{comment.user}">#{comment.user}</a></cite></blockquote>} }
      result = %{#{result}<div class="comments">#{comments_html.join("\n")}</div>}
    end
    result
  end
end
