# frozen_string_literal: true

require "defra_ruby/aws"

module CanLoadFileToAws
  def load_file_to_aws_bucket(options = {})
    response = nil

    3.times do
      response = bucket.load(File.new(file_path, "r"), options)

      break if response.successful?
    end

    raise(response.error) unless response.successful?

    response.result
  end

  def bucket
    @_bucket ||= DefraRuby::Aws.get_bucket(bucket_name)
  end
end
