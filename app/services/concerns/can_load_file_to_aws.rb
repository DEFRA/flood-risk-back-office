# frozen_string_literal: true

module CanLoadFileToAws
  def load_file_to_aws_bucket(options = {})
    result = nil

    3.times do
      result = bucket.load(File.new(file_path, "r"), options)

      break if result.successful?
    end

    raise(result.error) unless result.successful?
  end

  def bucket
    @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
  end
end
