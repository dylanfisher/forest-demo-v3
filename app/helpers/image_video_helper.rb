module ImageVideoHelper
  def lazy_image(media_item, options = {})
    return if media_item.blank?

    skip_lazy = options.delete(:skip_lazy) || false
    size = options.delete(:size) || :large
    data = options.delete(:data) || {}
    alt = options.delete(:alt) || media_item.try(:alternative_text).presence || media_item.try(:caption)
    options.merge!(alt: alt) if alt.present?
    size_mobile = options.delete(:size_mobile) || :medium
    css_style = options.delete(:style).presence || ''
    image_or_placeholder_uri = skip_lazy ? media_item.attachment_url(size) : uri_image_placeholder
    include_background_jump_fix = options.delete(:include_background_jump_fix)

    if media_item.attachment_content_type =~ /svg\+xml/
      size = :original
      size_mobile = :original
    end

    data.merge!(src: media_item.attachment_url(size),
                src_mobile: media_item.attachment_url(size_mobile),
                src_full: media_item.attachment_url(:large),
                caption: md(media_item.try(:caption)))

    point_of_interest_x = options.fetch(:point_of_interest_x, media_item.try(:point_of_interest_x))
    point_of_interest_y = options.fetch(:point_of_interest_y, media_item.try(:point_of_interest_y))

    if options.delete(:background)
      if point_of_interest_x.present? && point_of_interest_y.present?
        css_style << "background-position: #{point_of_interest_x}% #{point_of_interest_y}%;"
      end

      css_style << "background-image: url(#{image_or_placeholder_uri});"

      if include_background_jump_fix && [media_item.width, media_item.height].all?
        ratio = media_item.height.to_f / media_item.width.to_f * 100
        padding_bottom = "padding-bottom: #{ratio}%;"
        css_style << "height: 0; padding-bottom: #{ratio}%;"
      end

      options.merge!('aria-label': alt) if alt.present?
      options.delete(:alt)
      content_tag :div,
                  nil,
                  class: "background-image #{'lazy-image lazyload' unless skip_lazy} #{options.delete(:class)} #{options.delete(:wrapper_class)} content-type--#{media_item.attachment_content_type.parameterize}",
                  style: css_style,
                  role: 'img',
                  data: {
                    bg: data.delete(:src),
                    bg_mobile: data.delete(:src_mobile),
                    **data
                  },
                  **options
    else
      if options[:skip_jump_fix]
        image_tag image_or_placeholder_uri, class: "#{'lazy-image lazyload' unless skip_lazy} #{options.delete(:class)}", data: data, **options
      else
        image_jump_fix media_item, class: options.delete(:wrapper_class) do
          image_tag image_or_placeholder_uri, class: "#{'lazy-image lazyload' unless skip_lazy} #{options.delete(:class)}", data: data, **options
        end
      end
    end
  end

  # def background_image(media_item, options = {})
  #   size = options.delete(:size) || :large
  #   data = options.delete(:data) || {}
  #   alt = options.delete(:alt) || media_item.try(:alternative_text).presence || media_item.try(:caption)
  #   options.merge!(alt: alt) if alt.present?
  #   size_mobile = options.delete(:size_mobile) || :medium
  #   data.merge!(src: media_item.attachment_url(size),
  #               src_mobile: media_item.attachment_url(size_mobile),
  #               src_full: media_item.attachment_url(:large),
  #               caption: md(media_item.try(:caption)))
  #   options.merge!('aria-label': alt) if alt.present?
  #   options.delete(:alt)
  #   css_style = options.delete(:style).presence || ''

  #   if media_item.try(:point_of_interest_x).present? && media_item.try(:point_of_interest_y).present?
  #     point_of_interest_x = options.fetch(:point_of_interest_x, media_item.point_of_interest_x)
  #     point_of_interest_y = options.fetch(:point_of_interest_y, media_item.point_of_interest_y)
  #     css_style << "background-position: #{point_of_interest_x}% #{point_of_interest_y}%;"
  #   end

  #   content_tag :div,
  #               nil,
  #               class: "background-image #{options.delete(:class)} content-type--#{media_item.attachment_content_type.parameterize}",
  #               style: "background-image: url(#{data[:src]}); #{css_style}",
  #               role: 'img',
  #               data: {
  #                 **data
  #               },
  #               **options
  # end

  def lazy_video(media_item, options = {})
    data = options.delete(:data) || {}
    options.merge!(poster: media_item.poster_image.attachment_url(:medium)) if media_item.poster_image.present?
    src = options.delete(:src) || media_item.video_list&.high_res&.url || media_item.attachment_url
    src_mobile = options.delete(:src_mobile) || media_item.video_list&.low_res&.url
    width = options.delete(:width) || media_item.video_list&.width
    height = options.delete(:height) || media_item.video_list&.height
    wrapper_class = options.delete(:wrapper_class)
    autoplay = options.fetch(:autoplay, media_item.try(:autoplay))
    autoplay = autoplay.nil? ? false : autoplay
    playsinline = options.fetch(:playsinline, autoplay)
    controls = options.fetch(:controls, !autoplay)
    ratio = (options.delete(:ratio) || media_item.video_list&.aspect_ratio) || (16.0/9)
    video_loop = options.fetch(:loop, autoplay)
    video_tag_html = capture do
      video_tag '',
                class: "lazy-video #{options.delete(:class)}",
                controls: controls,
                playsinline: autoplay,
                autoplay: autoplay,
                muted: playsinline,
                loop: video_loop,
                data: {
                  src: src,
                  src_mobile: src_mobile,
                  object_fit: 'cover',
                  ratio: ratio,
                  **data },
                **options
    end

    if [width, height].all?
      video_tag_html = capture do
        asset_jump_fix width: width, height: height, class: wrapper_class do
          video_tag_html
        end
      end
    end

    background_poster_image = "background-image: url(#{options[:poster]}); background-position: center center; background-size: cover;" if options[:poster].present?

    content_tag :div,
                nil,
                class: "lazy-video-placeholder #{wrapper_class}",
                style: "height: 0; padding-bottom: #{ratio * 100}%; #{background_poster_image}",
                data: {
                  video_tag_html: video_tag_html }
  end

  def lazy_asset(asset_path, options = {})
    data = options.delete(:data) || {}
    data.merge!(src: asset_path)
    blob = options.delete(:blob)
    width = options.delete(:width)
    height = options.delete(:height)
    limit_height = options.delete(:limit_height)

    if blob.present? && blob.metadata.present?
      width = blob.metadata[:width]
      height = blob.metadata[:height]
    end

    ratio = width.to_f / height.to_f

    if options.delete(:background)
      content_tag :div,
                  (block_given? ? yield : nil),
                  class: "lazy-image lazy-image--background lazyload #{options.delete(:class)}",
                  role: 'img',
                  data: {
                    bg: data.delete(:src),
                    **data
                  },
                  **options
    else
      image_tag_content = capture do
        image_tag uri_image_placeholder, class: "lazy-image lazyload #{options.delete(:class)}", data: data, **options
      end

      if [width, height].all?
        asset_jump_image_content = capture do
          asset_jump_fix width: width, height: height, class: options.delete(:wrapper_class) do
            concat yield if block_given?
            concat image_tag_content
          end
        end
        if limit_height
          content_tag :div, class: options.delete(:outer_wrapper_class), style: "width: #{limit_height.to_f * ratio}px; max-width: 100%;" do
            asset_jump_image_content
          end
        else
          asset_jump_image_content
        end
      else
        image_tag_content
      end
    end
  end

  def uri_image_placeholder
    'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='
  end

  def asset_jump_fix(options = {})
    width = options.delete(:width)
    height = options.delete(:height)
    tag_type = options.delete(:tag) || :div
    content_type = options.delete(:content_type) || 'other'
    css_class = options.delete(:class)

    if [width, height].all?
      ratio = height.to_f / width.to_f * 100
      padding_bottom = "padding-bottom: #{ratio}%;"
    else
      raise 'Width and height must be defined'
    end

    content_tag tag_type, class: "forest-asset-jump-fix #{'forest-asset-jump-fix--' + content_type.parameterize} #{css_class}", style: padding_bottom, **options do
      yield
    end
  end

  # Prevent images from thrashing your page's layout with the image_jump_fix helper.
  # <%= image_jump_fix block.media_item do %>
  #   <%= image_tag block.media_item.attachment_url(:medium) %>
  # <% end %>
  def image_jump_fix(media_item, options = {})
    width = media_item.try(:dimensions).try(:[], :width)
    height = media_item.try(:dimensions).try(:[], :height)
    tag_type = options.delete(:tag) || :div
    css_class = options[:class]

    if [width, height].all?
      ratio = height.to_f / width.to_f
      padding_bottom = "padding-bottom: #{ratio * 100}%;"
    end

    content_tag tag_type, class: "forest-image-jump-fix #{('forest-image-jump-fix--' + media_item.attachment_content_type.parameterize) if media_item.try(:attachment_content_type).present?} #{css_class}", style: padding_bottom do
      yield if block_given?
    end
  end

  # Embed an SVG file inline, allowing it to be styled with CSS.
  def embedded_svg(filename, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    svg['class'] = "#{svg['class']} #{options[:class]}" if options[:class].present?
    svg['id'] = options[:id] if options[:id].present?
    svg['style'] = "#{svg['style']} #{options[:style]}" if options[:style].present?
    svg['width'] = options[:width] if options[:width].present?
    svg['height'] = options[:height] if options[:height].present?
    doc.to_html.html_safe
  end

  def bg_poi(media_item)
    "background-position: #{media_item.point_of_interest_x}% #{media_item.point_of_interest_y}%;"
  end
end
