# frozen_string_literal: true

require "rails_helper"

RSpec.describe "load_admin_areas", type: :rake do
  include_context "rake"

  describe "load_admin_areas" do
    subject(:rake_task) { Rake::Task["load_admin_areas"] }

    it { expect { rake_task.invoke }.not_to raise_error }
  end
end
