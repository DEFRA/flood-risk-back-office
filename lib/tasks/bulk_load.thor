# This is a development tool for creating multiple Enrollments
require "thor"
require "factory_girl"

module Flood
  # rubocop:disable Metrics/ClassLength
  class BulkLoad < Thor

    desc "clear", "Clear DB of major model data"

    def clear
      init

      [
        FloodRiskEngine::Address,
        FloodRiskEngine::Organisation,
        FloodRiskEngine::EnrollmentExemption,
        FloodRiskEngine::Enrollment,
        EnrollmentExport
      ].each do |m|
        ActiveRecord::Base.connection.execute("TRUNCATE #{m.table_name} CASCADE")
      end
    end

    desc "list", "List all available factories"

    def list
      init

      puts "\nLoad paths:\n#############\n\t#{FactoryGirl.definition_file_paths.join("\n\t")}"

      puts "\nFactory names:\n#############\n\t#{FactoryGirl.factories.collect(&:name).sort.join("\n\t")}"
    end

    desc "import", "Generate and import Enrollments"

    method_option(
      :number,
      aliases: "-n",
      type: :numeric,
      default: 50,
      desc: "Number of Enrollments to generate"
    )

    method_option(
      :factory,
      aliases: "-f",
      default: [:approved_individual],
      type: :array,
      desc: "Factories to use to generate Enrollments"
    )

    method_option(
      :pending,
      aliases: "-p",
      type: :boolean,
      default: false,
      desc: "Load <n> Pending Enrollments for each major OrganisationType"
    )

    method_option(
      :approved,
      aliases: "-a",
      type: :boolean,
      default: false,
      desc: "Load <n> Approved Enrollments for each major OrganisationType"
    )

    method_option(
      :rejected,
      aliases: "-r",
      type: :boolean,
      default: false,
      desc: "Load <n> Rejected Enrollments for each major OrganisationType"
    )

    method_option(
      :incomplete,
      aliases: "-i",
      type: :boolean,
      default: false,
      desc: "Include sample of INCOMPLTE Enrollments"
    )

    method_option(
      :use_transaction,
      aliases: "-t",
      type: :boolean,
      default: false,
      desc: "Use ActiveRecord::Base.transaction - faster but all data lost in event of interruption"
    )

    def import
      init

      raise "Not available in Production" if Rails.env.production?

      # 10000 ~ 15 mins
      begin
        FloodRiskEngine::Enrollment.paper_trail_off!
        # FloodRiskEngine::Address.paper_trail_off!

        if options["use_transaction"]
          puts("\nRunning within single transaction - Ctrl-C will roll back all loaded Enrollments")
          ActiveRecord::Base.transaction do
            run
          end
        else
          run
        end

        puts("\nLast Enrollment generated:")
        puts "ID: #{FloodRiskEngine::Enrollment.last.id}"
        puts "RefNumber [#{FloodRiskEngine::Enrollment.last.ref_number}]"

        conn = ActiveRecord::Base.connection
        vacuum_after_insert(conn)
        reindex_after_insert(conn)
      ensure
        FloodRiskEngine::Enrollment.paper_trail_on!
      end
    end

    # rubocop:disable Metrics/BlockLength
    no_commands do
      # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      def build_factory_list
        factories = []

        factories += FactoryGirl.factories.collect(&:name).grep(/approved_/) if options[:approved]
        factories += FactoryGirl.factories.collect(&:name).grep(/rejected_/) if options[:rejected]
        factories += FactoryGirl.factories.collect(&:name).grep(/submitted_/) if options[:pending]

        if options[:incomplete]
          factories += FactoryGirl.factories.collect(&:name).grep(/page/).tap { |a| a.delete :page_confirmation }
        end

        factories
      end
      # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

      def init
        # assume run from Rails.root
        puts "Loading Rails environment"
        require File.expand_path("config/environment.rb")

        FactoryGirl.reload
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def run
        number = options["number"].to_i

        threads = options["max_threads"].to_i

        factories = if options[:approved] || options[:rejected] || options[:pending] || options[:incomplete]
                      build_factory_list
                    else
                      options["factory"]
                    end

        puts "Starting load of #{number} enrollments per factory(s) #{factories.inspect}"

        t1 = Time.zone.now

        if threads.zero?
          1.upto(number) do |n|
            print "." if (n % 10).zero?
            factories.each { |f| FactoryGirl.create(f) }
          end
        else
          puts "Running using #{threads} threads"

          cycles = (number / threads).to_i

          # the remainder
          1.upto(number - (cycles * threads)).each { factories.each { |f| FactoryGirl.create(f) } }

          1.upto(cycles).map do
            1.upto(threads).map do
              Thread.new do
                factories.each { |f| FactoryGirl.create(f) }
                ActiveRecord::Base.connection.close
              end
            end.each(&:join)
          end
        end

        t2 = Time.zone.now

        puts("\nBulk load of [#{options['number'] * factories.size}] Enrollments took [#{t2 - t1}] seconds")
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Runs VACUUM against each table, which reclaims storage occupied by dead tuples.
      # Note it caters for when connected to a postgres database or a sqlite (for example if
      # testing the command using the dummy app in this gem).
      # If postgres then it uses the ANALYZE argument to update statistics, which are used
      # by the planner to determine the most efficient way to execute a query.
      # rubocop:disable Lint/ShadowedArgument
      def modify_after_insert(conn, postgres_cmd, default_cmd)
        conn = ActiveRecord::Base.connection
        cmd = if conn.instance_values["config"][:adapter].in? %w[postgresql postgres postgis]
                postgres_cmd
              else
                default_cmd
              end

        %i[enrollments organisations contacts addresses].each do |t|
          conn.execute "#{cmd} flood_risk_engine_#{t};"
        end
      end
      # rubocop:enable Lint/ShadowedArgument

      def vacuum_after_insert(conn)
        modify_after_insert conn, "VACUUM (ANALYZE)", "VACUUM"
      end

      def reindex_after_insert(conn)
        modify_after_insert conn, "REINDEX TABLE", "REINDEX"
      end

    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/ClassLength
end
