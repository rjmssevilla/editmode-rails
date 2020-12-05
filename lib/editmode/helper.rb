module Editmode
  module Helper
    # Render non-editable content
    def e(identifier, *args)
      field, options = parse_arguments(args)
      begin
        chunk = Editmode::ChunkValue.new(identifier, options.merge({raw: true}))

        if chunk.chunk_type == 'collection_item'
          chunk_type = chunk.field_chunk(field)["chunk_type"]
          content = render_content(chunk_type, chunk.field(field), options[:class], field)
        else
          content = render_content(chunk.chunk_type, chunk.content, options[:class])
        end

        content
      rescue => er
        puts er
      end
    end

    def render_content(chunk_type, content, css_class=nil, field=nil)
      return image_tag(content, class: css_class) if chunk_type == 'image'
      return content if field.present?

      content
    end

    def render_custom_field_raw(label, options={})
      e(@custom_field_chunk["identifier"], label, options.merge({response: @custom_field_chunk}))
    end
    alias_method :f, :render_custom_field_raw

    def parse_arguments(args)
      field = nil
      options = {}
      if args[0].class.name == 'String'
        field = args[0]
        options =  args[1] || {}
      elsif args[0].class.name == 'Hash'
        options =  args[0] || {}
      end
      return field, options
    end
  end
end
