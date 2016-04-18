class UserVersion < PaperTrail::Version
  self.sequence_name = :user_versions_id_seq
end
