class CreateUsers < ActiveRecord::Migration[4.2]
  def self.up
    db_adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
    is_postgres_adapter = db_adapter.in? %w[postgres postgis]

    # create_extension('citext') if is_postgres_adapter

    create_table(:users) do |t|
      ## Database authenticatable
      if is_postgres_adapter
        t.citext :email, null: false, default: "", limit: 255
      else
        # account for the dummy rspec app using sqlite3
        t.string :email, null: false, default: "", limit: 255
      end

      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      if is_postgres_adapter
        t.citext :reset_password_token
      else
        # account for the dummy rspec app using sqlite3
        t.string :reset_password_token
      end

      t.datetime :reset_password_sent_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at

      if is_postgres_adapter
        t.inet   :current_sign_in_ip
        t.inet   :last_sign_in_ip
      else
        # account for the dummy rspec app using sqlite3
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip
      end

      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      t.integer    :invitations_count, default: 0
      t.index      :invitations_count
      t.index      :invitation_token, unique: true # for invitable
      t.index      :invited_by_id

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.text :disabled_comment
      t.timestamp :disabled_at
      t.datetime :locked_at

      t.string :role_names

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
