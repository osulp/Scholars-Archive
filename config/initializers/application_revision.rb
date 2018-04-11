revision = ''
revision_file_path = File.join(Rails.root, '..', 'revisions.log')
begin
  lines = File.open(revision_file_path).to_a.map{ |line| line.chomp }
  last_revision = lines.last.split(' ')[3].gsub(')','')
  last_branch = lines.last.split(' ')[1]
  revision = "Deployed #{last_branch}@#{last_revision}"
  puts "Deploy revision #{revision} parsed from #{revision_file_path} file."
rescue
  puts "ERROR: Wasn't able to parse #{revision_file_path} file."
end

ENV['SCHOLARSARCHIVE_DEPLOYED_REVISION'] = revision
