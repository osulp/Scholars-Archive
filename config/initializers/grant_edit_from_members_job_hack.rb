# OVERRIDE: This overrides file_set_ids on GrantEditFromMembersJob and sets
# the :rows option on the FileSet id query
#
# Base file: https://github.com/samvera/hyrax/blob/v2.9.5/app/jobs/hyrax/grant_edit_from_members_job.rb
Hyrax::GrantEditToMembersJob.class_eval do
  private
  def file_set_ids(work)
    ::FileSet.search_with_conditions({id: work.member_ids}, rows: 10000).map(&:id)
  end
end
