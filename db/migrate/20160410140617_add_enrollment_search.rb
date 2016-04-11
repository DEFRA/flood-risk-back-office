class AddEnrollmentSearch < ActiveRecord::Migration
  def up
    connection.execute <<-SQL
      CREATE INDEX idx_dsc_enrollments_on_ref_number
              ON dsc_enrollments
           USING gin(to_tsvector('simple', reference_number));

      CREATE INDEX idx_dsc_organisations_on_name
                ON dsc_organisations
             USING gin(to_tsvector('simple', name));

      CREATE INDEX idx_dsc_contacts_on_email_address
                ON dsc_contacts
             USING gin(to_tsvector('simple', email_address));

      CREATE INDEX idx_dsc_contacts_on_first_name
                ON dsc_contacts
             USING gin(to_tsvector('simple', first_name));

      CREATE INDEX idx_dsc_contacts_on_last_name
                ON dsc_contacts
              USING gin(to_tsvector('simple', last_name));

      CREATE INDEX idx_dsc_addresses_on_postcode
                ON dsc_addresses
             USING gin(to_tsvector('simple', postcode));
    SQL
  end

  def down
    connection.execute <<-SQL
      DROP INDEX idx_dsc_enrollments_on_ref_number;
      DROP INDEX idx_dsc_organisations_on_name;
      DROP INDEX idx_dsc_contacts_on_email_address;
      DROP INDEX idx_dsc_contacts_on_first_name;
      DROP INDEX idx_dsc_contacts_on_last_name;
      DROP INDEX idx_dsc_addresses_on_postcode;
    SQL
  end

  def change
    add_column :dsc_enrollments, :reference_number, :string, limit: 12

    add_index :dsc_enrollments, [:reference_number], unique: true

    # Drop the legacy view, if it exists
    execute "DROP VIEW IF EXISTS dsc_enrollment_searches_view"

    create_view :dsc_enrollment_searches
  end
end
