RSpec.configure do |config|

  config.before(:suite) do
    if defined? Rails
      api_docs_folder_path = File.join(Rails.root, '/api_docs/')
    else
      api_docs_folder_path = File.join(File.expand_path('.'), '/api_docs/')
    end

    Dir.mkdir(api_docs_folder_path) unless Dir.exists?(api_docs_folder_path)

    Dir.glob(File.join(api_docs_folder_path, '*')).each do |f|
      File.delete(f)
    end
  end

  config.after(:each, type: :request) do |example|
    if response
      example_group = example.metadata[:example_group]
      example_groups = []

      while example_group
        example_groups << example_group
        example_group = example_group[:example_group]
      end

      action = example_groups[0..-2].map{ |e| e[:description_args].first }.reverse.join(' ')
      example_groups[-1][:description_args].first.match(/(\w+)\sRequests/)
      file_name = ($1 || example_groups[-1][:description_args].first).underscore

      if defined? Rails
        file = File.join(Rails.root, "/api_docs/#{file_name}.md")
      else
        file = File.join(File.expand_path('.'), "/api_docs/#{file_name}.md")
      end

      File.open(file, 'a') do |f|
        # Resource & Action
        f.write "# #{action}\n\n"

        # Request
        request_body = request.body.read
        authorization_header = request.headers['Authorization']
        request_params = request.params.except(*%w(format controller action))

        if request_body.present? || authorization_header.present? || request_params.any?
          f.write "+ Request (#{request.content_type})\n\n"

          # Request Headers
          if authorization_header.present?
            f.write "+ Headers\n\n".indent(4)
            f.write "Authorization: #{authorization_header}\n\n".indent(12)
          end

          # Request Body
          if request_body.present? && request.content_type == 'application/json'
            f.write "+ Body\n\n".indent(4) if authorization_header
            f.write "#{JSON.pretty_generate(JSON.parse(request_body))}\n\n".indent(authorization_header ? 12 : 8)
          end

          # Request Params
          if request_params.any?
            f.write "+ Params\n\n".indent(4) if authorization_header
            f.write "#{request_params}\n\n".indent(authorization_header ? 12 : 8)
          end
        end

        # Response
        f.write "+ Response #{response.status} (#{response.content_type})\n\n"

        # Response Headers
        etag_header = response.headers['ETag']
        if etag_header.present?
          f.write "+ Headers\n\n".indent(4)
          f.write "Etag: #{etag_header}\n\n".indent(12)
        end

        if response.body.present? && response.content_type == 'application/json'
          f.write "+ Body\n\n".indent(4) if etag_header
          f.write "#{JSON.pretty_generate(JSON.parse(response.body))}\n\n".indent(etag_header ? 12 : 8)
        end

        if response.body.present? && response.content_type == 'application/x-yaml'
          f.write "+ Body\n\n".indent(4) if etag_header
          f.write "#{response.body}\n\n".indent(etag_header ? 12 : 8)
        end
      end unless response.status == 403 || response.status == 301
    end
  end
end
