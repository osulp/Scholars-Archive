# OVERRIDE: This overrides file_set_ids on RevokeEditFromMembersJob and sets
# the :rows option on the FileSet id query
#
# Base file: https://github.com/samvera/hyrax/blob/v2.9.5/app/jobs/hyrax/revoke_edit_from_members_job.rb
Hyrax::RevokeEditFromMembersJob.class_eval do
  private
  def file_set_ids(work)
    ::FileSet.search_with_conditions({id: work.member_ids}, rows: 10000).map(&:id)
  end
end
